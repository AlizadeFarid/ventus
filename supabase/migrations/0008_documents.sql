-- Trip documents: user-uploaded files (tickets, vouchers, IDs, policies) kept
-- private per trip. Two parts:
--   1. a PRIVATE `trip-docs` Storage bucket holding the binaries, owner-only via
--      the `{userId}/...` path convention (reads use signed URLs, not public
--      URLs — see AppStorage.signedUrl);
--   2. a `documents` metadata table (name / type / size / linked day) owned
--      per-user, mirroring the local-first Drift `Documents` table.
--
-- Idempotent: safe to run again. Run after 0001_trips.sql. NOTE: 0003 only
-- covers trip-covers/avatars — documents need this separate bucket + table.
-- Backs the Documents feature (lib/features/trips: TripDocument domain + Drift
-- Documents + the Trip Hub's documents card and the full Documents screen).

-- ── trip-docs: private, owner-only ─────────────────────────────────────────
insert into storage.buckets (id, name, public)
values ('trip-docs', 'trip-docs', false)
on conflict (id) do nothing;

drop policy if exists "Trip docs are owner-readable" on storage.objects;
create policy "Trip docs are owner-readable"
  on storage.objects for select
  using (
    bucket_id = 'trip-docs'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "Trip docs are owner-writable" on storage.objects;
create policy "Trip docs are owner-writable"
  on storage.objects for insert
  with check (
    bucket_id = 'trip-docs'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "Trip docs are owner-updatable" on storage.objects;
create policy "Trip docs are owner-updatable"
  on storage.objects for update
  using (
    bucket_id = 'trip-docs'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "Trip docs are owner-deletable" on storage.objects;
create policy "Trip docs are owner-deletable"
  on storage.objects for delete
  using (
    bucket_id = 'trip-docs'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

-- ── documents: metadata table ──────────────────────────────────────────────
create table if not exists public.documents (
  id           text primary key,
  trip_id      text not null references public.trips (id) on delete cascade,
  user_id      uuid not null references auth.users (id) on delete cascade,
  name         text not null,
  type         text not null default 'other',  -- ticket / stay / id / other
  storage_path text not null,                   -- object path in trip-docs
  ext          text,                            -- e.g. PDF / JPG (display label)
  mime_type    text,
  size_bytes   bigint,
  day          integer,                         -- null = trip-wide, else 1-based
  created_at   timestamptz not null default now()
);

create index if not exists documents_trip_id_idx
  on public.documents (trip_id);
create index if not exists documents_user_id_idx
  on public.documents (user_id);

-- Row-level security: a user may only see and change their own documents.
alter table public.documents enable row level security;

drop policy if exists "Documents are viewable by their owner" on public.documents;
create policy "Documents are viewable by their owner"
  on public.documents for select
  using (auth.uid() = user_id);

drop policy if exists "Users can insert their own documents" on public.documents;
create policy "Users can insert their own documents"
  on public.documents for insert
  with check (auth.uid() = user_id);

drop policy if exists "Users can update their own documents" on public.documents;
create policy "Users can update their own documents"
  on public.documents for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users can delete their own documents" on public.documents;
create policy "Users can delete their own documents"
  on public.documents for delete
  using (auth.uid() = user_id);
