-- Per-user Storage buckets, prepared for upcoming features (trip covers,
-- avatars). Object paths follow the convention `{userId}/...`, and owner RLS
-- checks the first path folder against auth.uid().
--
-- OPTIONAL FOR NOW: only needed once trip-cover / avatar upload is built.
-- Idempotent: safe to run again. Matches StorageBuckets in lib/core/storage.

-- ── trip-covers: private, owner-only ───────────────────────────────────────
insert into storage.buckets (id, name, public)
values ('trip-covers', 'trip-covers', false)
on conflict (id) do nothing;

drop policy if exists "Trip covers are owner-readable" on storage.objects;
create policy "Trip covers are owner-readable"
  on storage.objects for select
  using (
    bucket_id = 'trip-covers'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "Trip covers are owner-writable" on storage.objects;
create policy "Trip covers are owner-writable"
  on storage.objects for insert
  with check (
    bucket_id = 'trip-covers'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "Trip covers are owner-updatable" on storage.objects;
create policy "Trip covers are owner-updatable"
  on storage.objects for update
  using (
    bucket_id = 'trip-covers'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "Trip covers are owner-deletable" on storage.objects;
create policy "Trip covers are owner-deletable"
  on storage.objects for delete
  using (
    bucket_id = 'trip-covers'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

-- ── avatars: public read, owner write ──────────────────────────────────────
insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict (id) do nothing;

drop policy if exists "Avatars are publicly readable" on storage.objects;
create policy "Avatars are publicly readable"
  on storage.objects for select
  using (bucket_id = 'avatars');

drop policy if exists "Avatars are owner-writable" on storage.objects;
create policy "Avatars are owner-writable"
  on storage.objects for insert
  with check (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "Avatars are owner-updatable" on storage.objects;
create policy "Avatars are owner-updatable"
  on storage.objects for update
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "Avatars are owner-deletable" on storage.objects;
create policy "Avatars are owner-deletable"
  on storage.objects for delete
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );
