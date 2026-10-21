-- Trip collaborators (co-planning): people the trip owner invites, with a role
-- (editor/viewer) and a status (pending/active). Owner-scoped: every row is
-- owned by the inviter (user_id), and RLS restricts all access to that owner.
-- Phase 1 stores the invite list only; invited users don't yet gain access to
-- the trip itself (that's a later, larger sharing change). Idempotent.

create table if not exists public.trip_collaborators (
  id          text primary key,
  user_id     uuid not null references auth.users (id) on delete cascade,
  trip_id     text not null,
  email       text not null,
  name        text,
  role        text not null default 'viewer',
  status      text not null default 'pending',
  created_at  timestamptz not null default now()
);

create index if not exists trip_collaborators_user_trip_idx
  on public.trip_collaborators (user_id, trip_id);

alter table public.trip_collaborators enable row level security;

drop policy if exists "Collaborators are viewable by the owner" on public.trip_collaborators;
create policy "Collaborators are viewable by the owner"
  on public.trip_collaborators for select
  using (auth.uid() = user_id);

drop policy if exists "Users can insert their own collaborators" on public.trip_collaborators;
create policy "Users can insert their own collaborators"
  on public.trip_collaborators for insert
  with check (auth.uid() = user_id);

drop policy if exists "Users can update their own collaborators" on public.trip_collaborators;
create policy "Users can update their own collaborators"
  on public.trip_collaborators for update
  using (auth.uid() = user_id);

drop policy if exists "Users can delete their own collaborators" on public.trip_collaborators;
create policy "Users can delete their own collaborators"
  on public.trip_collaborators for delete
  using (auth.uid() = user_id);
