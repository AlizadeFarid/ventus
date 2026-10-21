// Supabase Edge Function: generate-itinerary
//
// A thin, stateless proxy to Google Gemini that turns a trip's context (its
// stops, dates and travellers) into a structured day-by-day itinerary. The
// Gemini API key never leaves the server (set as the GEMINI_API_KEY secret).
// The function does NOT touch the database — it just returns activities; the
// Flutter app persists them through its own local-first itinerary repository,
// keeping the offline copy authoritative.
//
// Deploy:  supabase functions deploy generate-itinerary
// Secret:  supabase secrets set GEMINI_API_KEY=...   (optionally GEMINI_MODEL)

const GEMINI_API_KEY = Deno.env.get("GEMINI_API_KEY") ?? "";
// Gemini 2.x Flash — fast + free-tier friendly. Overridable via secret.
const GEMINI_MODEL = Deno.env.get("GEMINI_MODEL") ?? "gemini-2.5-flash";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

/// The activity kinds the app understands (must match Dart's ActivityKind enum).
const KINDS = ["flight", "stay", "food", "sight", "transport", "activity"];

interface TripContext {
  title?: string;
  country?: string;
  stops?: { name: string; country?: string }[];
  startDate?: string;
  endDate?: string;
  nights?: number;
  dayCount?: number;
  travelerType?: string;
  adults?: number;
  children?: number;
}

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

function languageName(code: string): string {
  const names: Record<string, string> = {
    az: "Azerbaijani",
    tr: "Turkish",
    en: "English",
    ru: "Russian",
  };
  return names[code.slice(0, 2).toLowerCase()] ?? code;
}

function buildPrompt(trip: TripContext, language: string): string {
  const dayCount = Math.max(1, trip.dayCount ?? (trip.nights ?? 0) + 1);
  const route = (trip.stops ?? [])
    .map((s) => (s.country ? `${s.name} (${s.country})` : s.name))
    .join(", ");
  const travellers =
    `${trip.adults ?? 2} adult(s)` +
    (trip.children ? `, ${trip.children} child(ren)` : "") +
    (trip.travelerType ? `, travelling as a ${trip.travelerType}` : "");

  return [
    `You are an expert travel planner. Build a realistic, well-paced day-by-day`,
    `itinerary for this trip.`,
    ``,
    `Destination / route: ${route || trip.country || trip.title || "the trip"}.`,
    `Trip length: ${dayCount} day(s)${trip.startDate ? `, starting ${trip.startDate}` : ""}.`,
    `Travellers: ${travellers}.`,
    ``,
    `Rules:`,
    `- Cover days 1..${dayCount}; "day" is a 1-based integer in that range.`,
    `- 3 to 5 activities per day, in a sensible chronological order.`,
    `- "startMinutes" is minutes from midnight (0..1439), or null if no fixed time.`,
    `  Keep times realistic and non-overlapping within a day.`,
    `- "kind" must be exactly one of: ${KINDS.join(", ")}.`,
    `- "title" is short (max ~6 words). See the naming rules at the end.`,
    `- "place" is the venue's real, map-searchable name exactly as it appears on`,
    `  OpenStreetMap / Google Maps — the official local or English name, never a`,
    `  translation (e.g. "Wat Pho", "Sagrada Familia", "Chatuchak Weekend Market").`,
    `  Add the city when the name alone is ambiguous (e.g. "Old Town, Prague").`,
    `  The app geocodes this field to pin the activity on a map, so a made-up or`,
    `  translated name is worse than null. Use null only when the activity has no`,
    `  specific place (a free afternoon, a rest block).`,
    `- If multiple stops, allocate days across them and use "transport"/"flight"`,
    `  activities when moving between cities.`,
    trip.children
      ? `- Include family-friendly choices suitable for children.`
      : ``,
    `- Naming ("title"). Write titles in ${languageName(language)}, with one`,
    `  exception for proper names:`,
    `  * Generic activities MUST be in ${languageName(language)} — never leave`,
    `    them in English. Examples for Azerbaijani: Breakfast = "Səhər yeməyi",`,
    `    Lunch = "Günorta yeməyi", Dinner = "Şam yeməyi", Coffee break = "Qəhvə`,
    `    fasiləsi", Hotel check-in = "Otelə yerləşmə", Check-out = "Oteldən`,
    `    çıxış", Airport transfer = "Hava limanına transfer", Free time =`,
    `    "Sərbəst vaxt", Walk = "Gəzinti", Shopping = "Alış-veriş", Train to`,
    `    Milan = "Milana qatar". Do the same for Turkish and any other language.`,
    `  * Proper names of landmarks, museums, parks, venues, restaurants, streets`,
    `    and neighbourhoods are NOT translated word by word. Keep the widely`,
    `    known original/international name: "Louvre Museum", "Colosseum", "Eiffel`,
    `    Tower", "Piazza Navona", "Jardin des Tuileries".`,
    `  * A visit's title is just that name. Do not glue translated words onto a`,
    `    proper name ("Tuileries Garden stroll" is wrong; use "Jardin des`,
    `    Tuileries" or "Tuileries bağında gəzinti" only if the name is kept intact).`,
    `  * "place" always stays in its own map name (see above), never translated.`,
    `Return ONLY the structured JSON described by the schema.`,
  ].filter(Boolean).join("\n");
}

const responseSchema = {
  type: "OBJECT",
  properties: {
    activities: {
      type: "ARRAY",
      items: {
        type: "OBJECT",
        properties: {
          day: { type: "INTEGER" },
          startMinutes: { type: "INTEGER", nullable: true },
          title: { type: "STRING" },
          place: { type: "STRING", nullable: true },
          kind: { type: "STRING", enum: KINDS },
        },
        required: ["day", "title", "kind"],
      },
    },
  },
  required: ["activities"],
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  if (req.method !== "POST") {
    return json({ error: "Method not allowed" }, 405);
  }
  if (!GEMINI_API_KEY) {
    return json({ error: "GEMINI_API_KEY is not configured" }, 500);
  }

  let payload: { trip?: TripContext; language?: string };
  try {
    payload = await req.json();
  } catch {
    return json({ error: "Invalid JSON body" }, 400);
  }

  const trip = payload.trip ?? {};
  const language = (payload.language ?? "en").slice(0, 5);

  const url =
    `https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODEL}:generateContent?key=${GEMINI_API_KEY}`;

  const geminiBody = {
    contents: [{ role: "user", parts: [{ text: buildPrompt(trip, language) }] }],
    generationConfig: {
      temperature: 0.7,
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
  if (!text) {
    return json({ error: "Gemini returned no content" }, 502);
  }

  let parsed: { activities?: unknown };
  try {
    parsed = JSON.parse(text);
  } catch {
    return json({ error: "Gemini returned malformed JSON" }, 502);
  }

  // Sanitise: keep only well-formed activities with a known kind and clamp the
  // day into 1..dayCount so a stray value can't break the timeline.
  const dayCount = Math.max(1, trip.dayCount ?? (trip.nights ?? 0) + 1);
  const raw = Array.isArray(parsed.activities) ? parsed.activities : [];
  const activities = raw
    .map((a: Record<string, unknown>) => {
      const day = Math.min(dayCount, Math.max(1, Number(a.day) || 1));
      const title = typeof a.title === "string" ? a.title.trim() : "";
      const kind = KINDS.includes(a.kind as string)
        ? (a.kind as string)
        : "activity";
      const place = typeof a.place === "string" && a.place.trim()
        ? a.place.trim()
        : null;
      const sm = a.startMinutes;
      const startMinutes = typeof sm === "number" && sm >= 0 && sm <= 1439
        ? Math.round(sm)
        : null;
      return { day, startMinutes, title, place, kind };
    })
    .filter((a) => a.title.length > 0);

  return json({ activities });
});
