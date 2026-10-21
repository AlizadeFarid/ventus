-- Saved tab: destinations a user has hearted in Explore. Denormalised name /
-- country / image so the Saved list works offline and survives a destination
-- being removed. One row per (user, destination). Idempotent.

create table if not exists public.saved_places (
  user_id        uuid not null references auth.users (id) on delete cascade,
  destination_id text not null,
  name           text not null,
  country        text not null,
  image_url      text,
  created_at     timestamptz not null default now(),
  primary key (user_id, destination_id)
);

create index if not exists saved_places_user_id_idx on public.saved_places (user_id);

alter table public.saved_places enable row level security;

drop policy if exists "Saved places are viewable by their owner" on public.saved_places;
create policy "Saved places are viewable by their owner"
  on public.saved_places for select
  using (auth.uid() = user_id);

drop policy if exists "Users can insert their own saved places" on public.saved_places;
create policy "Users can insert their own saved places"
  on public.saved_places for insert
  with check (auth.uid() = user_id);

drop policy if exists "Users can delete their own saved places" on public.saved_places;
create policy "Users can delete their own saved places"
  on public.saved_places for delete
  using (auth.uid() = user_id);
