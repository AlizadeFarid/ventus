-- Create Trip flow: multi-stop routes + traveler details, and the move to a
-- Storage object *path* for trip covers (see lib/core/storage/app_storage.dart).
-- Idempotent: safe to run again. Run after 0001_trips.sql (and 0003 once trip
-- cover upload is built, since covers live in the `trip-covers` bucket).

-- ── trips: rename cover column + add traveler fields ───────────────────────
-- Rename cover_image_url → cover_image_path only if the old column still exists.
do $$
begin
  if exists (
    select 1 from information_schema.columns
    where table_schema = 'public' and table_name = 'trips'
      and column_name = 'cover_image_url'
  ) then
    alter table public.trips rename column cover_image_url to cover_image_path;
  end if;
end $$;

alter table public.trips add column if not exists cover_image_path text;
alter table public.trips add column if not exists adults integer not null default 2;
alter table public.trips add column if not exists children integer not null default 0;
alter table public.trips add column if not exists traveler_type text;

-- ── trip_stops: ordered route stops, owned per-user ────────────────────────
create table if not exists public.trip_stops (
  id         text primary key,
  trip_id    text not null references public.trips (id) on delete cascade,
  user_id    uuid not null references auth.users (id) on delete cascade,
  name       text not null,
  country    text not null,
  position   integer not null default 0,
  created_at timestamptz not null default now()
);

create index if not exists trip_stops_trip_id_idx on public.trip_stops (trip_id);
create index if not exists trip_stops_user_id_idx on public.trip_stops (user_id);

-- Row-level security: a user may only see and change stops they own.
alter table public.trip_stops enable row level security;

drop policy if exists "Trip stops are viewable by their owner" on public.trip_stops;
create policy "Trip stops are viewable by their owner"
  on public.trip_stops for select
  using (auth.uid() = user_id);

drop policy if exists "Users can insert their own trip stops" on public.trip_stops;
create policy "Users can insert their own trip stops"
  on public.trip_stops for insert
  with check (auth.uid() = user_id);

drop policy if exists "Users can update their own trip stops" on public.trip_stops;
create policy "Users can update their own trip stops"
  on public.trip_stops for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users can delete their own trip stops" on public.trip_stops;
create policy "Users can delete their own trip stops"
  on public.trip_stops for delete
  using (auth.uid() = user_id);
