-- Map module: add geographic coordinates to trip stops so the route can be
-- drawn on a map. Coordinates come from the free Photon/OSM autocomplete used in
-- the Create Trip flow (see lib/features/places). Idempotent: safe to re-run.
-- Run after 0005_trip_stops_and_fields.sql.

-- Nullable on purpose: stops created before this migration (and any custom
-- free-text stops Photon couldn't resolve) simply have no point on the map.
alter table public.trip_stops add column if not exists lat double precision;
alter table public.trip_stops add column if not exists lon double precision;
