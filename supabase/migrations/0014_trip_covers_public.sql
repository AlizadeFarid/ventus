-- Make the trip-covers bucket public-read (like avatars). Trip cover photos are
-- low-sensitivity travel images and the app already resolves them with
-- AppStorage.publicUrl (getPublicUrl), which only works on a public bucket — so
-- this aligns the bucket with the existing read path. Object paths stay
-- owner-scoped `{userId}/...` and writes/updates/deletes remain owner-only
-- (those policies from 0003 are unchanged); only SELECT becomes public.
-- Idempotent.

update storage.buckets set public = true where id = 'trip-covers';

drop policy if exists "Trip covers are owner-readable" on storage.objects;
drop policy if exists "Trip covers are publicly readable" on storage.objects;
create policy "Trip covers are publicly readable"
  on storage.objects for select
  using (bucket_id = 'trip-covers');
