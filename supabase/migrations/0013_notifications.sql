-- Activity-feed notifications (Profile.jsx -> NotificationsFeed). Each row is a
-- single feed entry owned by the user it's for (user_id); RLS restricts all
-- access to that owner. Entries are produced by real events (a collaborator
-- invite, an AI plan finishing) and stored local-first in Drift, mirrored here.
-- The display trip_title / subject are denormalised so the feed needs no joins.
-- Idempotent.

create table if not exists public.notifications (
  id          text primary key,
  user_id     uuid not null references auth.users (id) on delete cascade,
  kind        text not null default 'generic',
  trip_id     text,
  trip_title  text,
  subject     text,
  read        boolean not null default false,
  created_at  timestamptz not null default now()
);

create index if not exists notifications_user_created_idx
  on public.notifications (user_id, created_at desc);

alter table public.notifications enable row level security;

drop policy if exists "Notifications are viewable by the owner" on public.notifications;
create policy "Notifications are viewable by the owner"
  on public.notifications for select
  using (auth.uid() = user_id);

drop policy if exists "Users can insert their own notifications" on public.notifications;
create policy "Users can insert their own notifications"
  on public.notifications for insert
  with check (auth.uid() = user_id);

drop policy if exists "Users can update their own notifications" on public.notifications;
create policy "Users can update their own notifications"
  on public.notifications for update
  using (auth.uid() = user_id);

drop policy if exists "Users can delete their own notifications" on public.notifications;
create policy "Users can delete their own notifications"
  on public.notifications for delete
  using (auth.uid() = user_id);
