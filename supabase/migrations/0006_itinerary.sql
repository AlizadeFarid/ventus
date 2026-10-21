-- Day-by-day itinerary: per-trip activities, owned per-user.
-- Idempotent: safe to run again. Run after 0001_trips.sql (and ideally 0005,
-- since itinerary lives alongside trip stops). Backs the Itinerary feature
-- (lib/features/trips: ItineraryItem domain + Drift ItineraryItems + the
-- Trip Hub's filled timeline and the full Itinerary screen).

create table if not exists public.itinerary_items (
  id            text primary key,
  trip_id       text not null references public.trips (id) on delete cascade,
  user_id       uuid not null references auth.users (id) on delete cascade,
  day           integer not null default 1,
  start_minutes integer,            -- minutes from midnight; null = no set time
  title         text not null,
  place         text,
  kind          text not null default 'activity',
  position      integer not null default 0,
  created_at    timestamptz not null default now()
);

create index if not exists itinerary_items_trip_id_idx
  on public.itinerary_items (trip_id);
create index if not exists itinerary_items_user_id_idx
  on public.itinerary_items (user_id);

-- Row-level security: a user may only see and change their own activities.
alter table public.itinerary_items enable row level security;

drop policy if exists "Itinerary items are viewable by their owner" on public.itinerary_items;
create policy "Itinerary items are viewable by their owner"
  on public.itinerary_items for select
  using (auth.uid() = user_id);

drop policy if exists "Users can insert their own itinerary items" on public.itinerary_items;
create policy "Users can insert their own itinerary items"
  on public.itinerary_items for insert
  with check (auth.uid() = user_id);

drop policy if exists "Users can update their own itinerary items" on public.itinerary_items;
create policy "Users can update their own itinerary items"
  on public.itinerary_items for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users can delete their own itinerary items" on public.itinerary_items;
create policy "Users can delete their own itinerary items"
  on public.itinerary_items for delete
  using (auth.uid() = user_id);
