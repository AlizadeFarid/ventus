-- Curated Discover/Explore destinations (online content, not local-first).
-- Localized fields are jsonb maps keyed by language code: {"en","az","tr"}.
-- Images live in the `destinations` Storage bucket; the table stores only the
-- object path (e.g. 'rome.jpg'), resolved to a public URL on the client.
--
-- This script is idempotent: safe to run again. It migrates an earlier version
-- of the table (which had an `image_url` column) to `image_path` in place.
-- Run it in the Supabase SQL editor (or via the CLI).

create table if not exists public.destinations (
  id          text primary key,
  name        jsonb not null,
  country     jsonb not null,
  description jsonb not null default '{}'::jsonb,
  image_path  text,
  sort_order  integer not null default 0,
  is_active   boolean not null default true,
  created_at  timestamptz not null default now()
);

-- Migrate an older table shape (image_url) → image_path, if needed.
alter table public.destinations add column if not exists image_path text;
alter table public.destinations drop column if exists image_url;

-- Public, read-only: anyone (incl. anon) may read; no client writes.
alter table public.destinations enable row level security;

drop policy if exists "Destinations are readable by everyone" on public.destinations;
create policy "Destinations are readable by everyone"
  on public.destinations for select
  using (true);

-- Seed / refresh content. After running this, upload rome.jpg / bali.jpg /
-- lisbon.jpg into the `destinations` Storage bucket with these names.
insert into public.destinations (id, name, country, image_path, sort_order)
values
  (
    'rome',
    '{"en":"Rome","az":"Roma","tr":"Roma"}',
    '{"en":"Italy","az":"İtaliya","tr":"İtalya"}',
    'rome.jpg',
    1
  ),
  (
    'bali',
    '{"en":"Bali","az":"Bali","tr":"Bali"}',
    '{"en":"Indonesia","az":"İndoneziya","tr":"Endonezya"}',
    'bali.jpg',
    2
  ),
  (
    'lisbon',
    '{"en":"Lisbon","az":"Lissabon","tr":"Lizbon"}',
    '{"en":"Portugal","az":"Portuqaliya","tr":"Portekiz"}',
    'lisbon.jpg',
    3
  )
on conflict (id) do update set
  name       = excluded.name,
  country    = excluded.country,
  image_path = excluded.image_path,
  sort_order = excluded.sort_order;

-- Public Storage bucket for destination images.
insert into storage.buckets (id, name, public)
values ('destinations', 'destinations', true)
on conflict (id) do nothing;

-- Allow public read of objects in the destinations bucket.
drop policy if exists "Destination images are publicly readable" on storage.objects;
create policy "Destination images are publicly readable"
  on storage.objects for select
  using (bucket_id = 'destinations');
