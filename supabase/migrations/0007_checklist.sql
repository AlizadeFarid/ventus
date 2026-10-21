-- Trip checklist: per-trip to-dos (pack / prepare), owned per-user.
-- Idempotent: safe to run again. Run after 0001_trips.sql. Backs the Checklist
-- feature (lib/features/trips: ChecklistItem domain + Drift ChecklistItems +
-- the Trip Hub's checklist card and the full Checklist screen).

create table if not exists public.checklist_items (
  id         text primary key,
  trip_id    text not null references public.trips (id) on delete cascade,
  user_id    uuid not null references auth.users (id) on delete cascade,
  title      text not null,
  done       boolean not null default false,
  category   text not null default 'beforeYouGo',
  due_date   timestamptz,            -- optional reminder date (date-only)
  position   integer not null default 0,
  created_at timestamptz not null default now()
);

-- Categories + reminder date were added after the first cut; add them here too
-- so the migration is correct whether or not the table already existed.
alter table public.checklist_items
  add column if not exists category text not null default 'beforeYouGo';
alter table public.checklist_items
  add column if not exists due_date timestamptz;

create index if not exists checklist_items_trip_id_idx
  on public.checklist_items (trip_id);
create index if not exists checklist_items_user_id_idx
  on public.checklist_items (user_id);

-- Row-level security: a user may only see and change their own checklist items.
alter table public.checklist_items enable row level security;

drop policy if exists "Checklist items are viewable by their owner" on public.checklist_items;
create policy "Checklist items are viewable by their owner"
  on public.checklist_items for select
  using (auth.uid() = user_id);

drop policy if exists "Users can insert their own checklist items" on public.checklist_items;
create policy "Users can insert their own checklist items"
  on public.checklist_items for insert
  with check (auth.uid() = user_id);

drop policy if exists "Users can update their own checklist items" on public.checklist_items;
create policy "Users can update their own checklist items"
  on public.checklist_items for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users can delete their own checklist items" on public.checklist_items;
create policy "Users can delete their own checklist items"
  on public.checklist_items for delete
  using (auth.uid() = user_id);
