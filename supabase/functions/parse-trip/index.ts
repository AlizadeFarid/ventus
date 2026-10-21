// Supabase Edge Function: parse-trip
//
// Turns a free-text trip description ("a relaxed long weekend in Rome with my
// wife next month") into a structured draft the Create Trip flow can pre-fill:
// stops, optional dates, and travellers. Stateless — it returns a draft only;
// the app applies it to its in-progress trip state. Shares the Gemini key
// (GEMINI_API_KEY) with generate-itinerary.
//
// Deploy:  supabase functions deploy parse-trip --use-api

const GEMINI_API_KEY = Deno.env.get("GEMINI_API_KEY") ?? "";
const GEMINI_MODEL = Deno.env.get("GEMINI_MODEL") ?? "gemini-2.5-flash";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

/// Must match Dart's TravelerType enum.
const TRAVELER_TYPES = ["solo", "couple", "family", "friends"];

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

function buildPrompt(description: string, language: string, today: string): string {
  return [
    `You extract a structured trip plan from a free-text description.`,
    `Today's date is ${today} (use it to resolve relative dates like`,
    `"next weekend" or "in July" into absolute YYYY-MM-DD values).`,
    ``,
    `Description: """${description}"""`,
    ``,
    `Rules:`,
    `- "stops": the cities/places to visit, in travel order. Each has a "name"`,
    `  and its "country". At least one stop. Use well-known English place names.`,
    `- "startDate"/"endDate": YYYY-MM-DD ONLY when the text actually states or`,
    `  clearly implies them ("26 November", "next Friday", "in July 10-15").`,
    `  NEVER invent or guess dates. If only a start is given with a duration,`,
    `  set startDate and leave endDate null. Otherwise null.`,
    `- "nights": integer number of nights when the text states a duration ("5 days"`,
    `  = 4 nights, "a week" = 7 nights, "long weekend" = 3), else null. Independent`,
    `  of whether dates are given.`,
    `- "travelerType": one of ${TRAVELER_TYPES.join(", ")} if implied, else null.`,
    `- "adults"/"children": integer counts ONLY when stated or implied ("me and my`,
    `  wife" = 2 adults, "alone" = 1, "with 2 kids" = children 2), else null.`,
    `- "budgetAmount": the total trip budget as a number when a budget is stated,`,
    `  else null. "budgetCurrency": its ISO 4217 code (USD, EUR, AZN, TRY, GBP...)`,
    `  inferred from the symbol or word, else null.`,
    `- "title": a short trip name (max ~4 words) in language "${language}", or null.`,
    `Return ONLY the structured JSON described by the schema.`,
  ].join("\n");
}

const responseSchema = {
  type: "OBJECT",
  properties: {
    title: { type: "STRING", nullable: true },
    stops: {
      type: "ARRAY",
      items: {
        type: "OBJECT",
        properties: {
          name: { type: "STRING" },
          country: { type: "STRING" },
        },
        required: ["name"],
      },
    },
    startDate: { type: "STRING", nullable: true },
    endDate: { type: "STRING", nullable: true },
    travelerType: { type: "STRING", enum: TRAVELER_TYPES, nullable: true },
    adults: { type: "INTEGER", nullable: true },
    children: { type: "INTEGER", nullable: true },
    nights: { type: "INTEGER", nullable: true },
    budgetAmount: { type: "NUMBER", nullable: true },
    budgetCurrency: { type: "STRING", nullable: true },
  },
  required: ["stops"],
};

const ISO_DATE = /^\d{4}-\d{2}-\d{2}$/;

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  if (req.method !== "POST") return json({ error: "Method not allowed" }, 405);
  if (!GEMINI_API_KEY) {
    return json({ error: "GEMINI_API_KEY is not configured" }, 500);
  }

  let payload: { description?: string; language?: string; today?: string };
  try {
    payload = await req.json();
  } catch {
    return json({ error: "Invalid JSON body" }, 400);
  }

  const description = (payload.description ?? "").trim();
  if (!description) return json({ error: "Empty description" }, 400);
  const language = (payload.language ?? "en").slice(0, 5);
  const today = ISO_DATE.test(payload.today ?? "")
    ? payload.today as string
    : new Date().toISOString().split("T")[0];

  const url =
    `https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODEL}:generateContent?key=${GEMINI_API_KEY}`;

  const geminiBody = {
    contents: [
      { role: "user", parts: [{ text: buildPrompt(description, language, today) }] },
    ],
    generationConfig: {
      temperature: 0.3,
      responseMimeType: "application/json",
      responseSchema,
    },
  };

  let res: Response;
  try {
    res = await fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(geminiBody),
    });
  } catch (e) {
    return json({ error: `Gemini request failed: ${e}` }, 502);
  }
  if (!res.ok) {
    const detail = await res.text();
    return json({ error: `Gemini error ${res.status}`, detail }, 502);
  }

  const data = await res.json();
  const text: string | undefined =
    data?.candidates?.[0]?.content?.parts?.[0]?.text;
  if (!text) return json({ error: "Gemini returned no content" }, 502);

  let parsed: Record<string, unknown>;
  try {
    parsed = JSON.parse(text);
  } catch {
    return json({ error: "Gemini returned malformed JSON" }, 502);
  }

  // Sanitise into a predictable shape the app can trust.
  const rawStops = Array.isArray(parsed.stops) ? parsed.stops : [];
  const stops = rawStops
    .map((s: Record<string, unknown>) => ({
      name: typeof s.name === "string" ? s.name.trim() : "",
      country: typeof s.country === "string" ? s.country.trim() : "",
    }))
    .filter((s) => s.name.length > 0);

  if (stops.length === 0) {
    return json({ error: "No stops could be parsed" }, 422);
  }

  const cleanDate = (v: unknown) =>
    typeof v === "string" && ISO_DATE.test(v) ? v : null;
  const travelerType = TRAVELER_TYPES.includes(parsed.travelerType as string)
    ? (parsed.travelerType as string)
    : null;
  const clampInt = (v: unknown, min: number, fallback: number | null) => {
    if (v === null || v === undefined) return fallback;
    const n = Number(v);
    return Number.isFinite(n) ? Math.max(min, Math.round(n)) : fallback;
  };
  const budgetAmount = Number(parsed.budgetAmount);
  const currency = typeof parsed.budgetCurrency === "string"
    ? parsed.budgetCurrency.trim().toUpperCase()
    : "";

  return json({
    title: typeof parsed.title === "string" && parsed.title.trim()
      ? parsed.title.trim()
      : null,
    stops,
    startDate: cleanDate(parsed.startDate),
    endDate: cleanDate(parsed.endDate),
    travelerType,
    adults: clampInt(parsed.adults, 1, null),
    children: clampInt(parsed.children, 0, null),
    nights: clampInt(parsed.nights, 1, null),
    budgetAmount: Number.isFinite(budgetAmount) && budgetAmount > 0
      ? budgetAmount
      : null,
    budgetCurrency: /^[A-Z]{3}$/.test(currency) ? currency : null,
  });
});
