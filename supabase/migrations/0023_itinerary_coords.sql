-- Map v2: add geographic coordinates to itinerary activities so a trip's
-- day-by-day plan (not just its city stops) can be drawn on the map.
-- Coordinates are resolved client-side from the activity's free-text `place`
-- via the free Photon/OSM geocoder (see lib/features/places), biased towards
-- the trip's stop coordinates. Idempotent: safe to re-run.
-- Run after 0006_itinerary.sql.

-- Nullable on purpose: an activity whose place is missing or that Photon
-- couldn't resolve simply has no pin (the Map tab lists it as unlocated).
alter table public.itinerary_items add column if not exists lat double precision;
alter table public.itinerary_items add column if not exists lon double precision;
