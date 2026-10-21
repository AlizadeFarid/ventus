-- Public, admin-managed app chrome images (welcome hero, banners, etc.).
-- Public read, no client writes — you upload these from the Supabase dashboard.
-- Idempotent: safe to run again. Matches StorageBuckets.publicAssets in code.
--
-- After running, upload `welcome.jpg` into the `public-assets` bucket.

insert into storage.buckets (id, name, public)
values ('public-assets', 'public-assets', true)
on conflict (id) do nothing;

drop policy if exists "Public assets are readable by everyone" on storage.objects;
create policy "Public assets are readable by everyone"
  on storage.objects for select
  using (bucket_id = 'public-assets');
