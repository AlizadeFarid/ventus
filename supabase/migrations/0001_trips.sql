-- Trips table for the Home / My Trips feature.
-- Local-first: the app's source of truth is on-device Drift; this table is the
-- synced remote copy. Run this in the Supabase SQL editor (or via the CLI).

create table if not exists public.trips (
  id              text primary key,
  user_id         uuid not null references auth.users (id) on delete cascade,
  title           text not null,
  country         text not null,
  cover_image_url text,
  start_date      timestamptz not null,
  end_date        timestamptz not null,
  planned_percent integer not null default 0,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create index if not exists trips_user_id_idx on public.trips (user_id);

-- Row-level security: a user may only see and change their own trips.
alter table public.trips enable row level security;

create policy "Trips are viewable by their owner"
  on public.trips for select
  using (auth.uid() = user_id);

create policy "Users can insert their own trips"
  on public.trips for insert
  with check (auth.uid() = user_id);

create policy "Users can update their own trips"
  on public.trips for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "Users can delete their own trips"
  on public.trips for delete
  using (auth.uid() = user_id);
