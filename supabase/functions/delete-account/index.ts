// Supabase Edge Function: delete-account
//
// Permanently deletes the calling user's account. A client cannot delete its
// own auth user directly, so the app calls this function with its session JWT;
// the function verifies the token, then uses the service-role key to remove the
// user. Application rows that reference auth.users(id) with ON DELETE CASCADE
// are cleared automatically; anything else should be cascaded in the schema.
//
// Required secrets (SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are injected by
// the platform automatically):
//   - none beyond the defaults
//
// Deploy:  supabase functions deploy delete-account --use-api

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "";
const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  if (req.method !== "POST") return json({ error: "Method not allowed" }, 405);
  if (!SUPABASE_URL || !SERVICE_ROLE_KEY) {
    return json({ error: "Service is not configured" }, 500);
  }

  // The caller's session JWT identifies which account to delete.
  const authHeader = req.headers.get("Authorization") ?? "";
  const jwt = authHeader.replace(/^Bearer\s+/i, "").trim();
  if (!jwt) return json({ error: "Missing authorization" }, 401);

  // Service-role client: can read the user from the token and delete it.
  const admin = createClient(SUPABASE_URL, SERVICE_ROLE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false },
  });

  const { data: userData, error: userError } = await admin.auth.getUser(jwt);
  if (userError || !userData?.user) {
    return json({ error: "Invalid or expired session" }, 401);
  }
  const userId = userData.user.id;

  const { error: deleteError } = await admin.auth.admin.deleteUser(userId);
  if (deleteError) {
    return json({ error: `Could not delete account: ${deleteError.message}` }, 500);
  }

  return json({ ok: true });
});
