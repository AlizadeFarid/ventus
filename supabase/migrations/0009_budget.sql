-- Trip budget & expenses: a per-trip budget (total + per-category allocations,
-- in the trip's single currency) plus the logged expenses. Manual/factual — no
-- AI, single user (no splitting). Two tables:
--   1. `trip_budgets` — one row per trip: currency, total, and a JSONB map of
--      per-category allocations (category name -> amount);
--   2. `expenses` — individual spends, owned per-user, optionally linked to a
--      1-based itinerary day.
--
-- Idempotent: safe to run again. Run after 0001_trips.sql. Backs the Budget
-- feature (lib/features/trips: Expense + TripBudget domain + Drift mirrors + the
-- Trip Hub's budget card and the full Budget screen).

-- ── trip_budgets: one row per trip ─────────────────────────────────────────
create table if not exists public.trip_budgets (
  trip_id     text primary key references public.trips (id) on delete cascade,
  user_id     uuid not null references auth.users (id) on delete cascade,
  currency    text not null default 'USD',
  total       numeric not null default 0,
  allocations jsonb not null default '{}'::jsonb,  -- {category: amount}
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index if not exists trip_budgets_user_id_idx
  on public.trip_budgets (user_id);

alter table public.trip_budgets enable row level security;

drop policy if exists "Budgets are viewable by their owner" on public.trip_budgets;
create policy "Budgets are viewable by their owner"
  on public.trip_budgets for select
  using (auth.uid() = user_id);

drop policy if exists "Users can insert their own budget" on public.trip_budgets;
create policy "Users can insert their own budget"
  on public.trip_budgets for insert
  with check (auth.uid() = user_id);

drop policy if exists "Users can update their own budget" on public.trip_budgets;
create policy "Users can update their own budget"
  on public.trip_budgets for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users can delete their own budget" on public.trip_budgets;
create policy "Users can delete their own budget"
  on public.trip_budgets for delete
  using (auth.uid() = user_id);

-- ── expenses: individual spends ────────────────────────────────────────────
create table if not exists public.expenses (
  id         text primary key,
  trip_id    text not null references public.trips (id) on delete cascade,
  user_id    uuid not null references auth.users (id) on delete cascade,
  category   text not null default 'other',  -- stay / food / sight / transport / other
  amount     numeric not null default 0,     -- in the trip's currency
  note       text,
  day        integer,                        -- null = unassigned, else 1-based
  created_at timestamptz not null default now()
);

create index if not exists expenses_trip_id_idx
  on public.expenses (trip_id);
create index if not exists expenses_user_id_idx
  on public.expenses (user_id);

alter table public.expenses enable row level security;

drop policy if exists "Expenses are viewable by their owner" on public.expenses;
create policy "Expenses are viewable by their owner"
  on public.expenses for select
  using (auth.uid() = user_id);

drop policy if exists "Users can insert their own expenses" on public.expenses;
create policy "Users can insert their own expenses"
  on public.expenses for insert
  with check (auth.uid() = user_id);

drop policy if exists "Users can update their own expenses" on public.expenses;
create policy "Users can update their own expenses"
  on public.expenses for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users can delete their own expenses" on public.expenses;
create policy "Users can delete their own expenses"
  on public.expenses for delete
  using (auth.uid() = user_id);
