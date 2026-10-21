-- Sponsored ads shown on the Home dashboard (online content, not local-first).
-- Plain-text advertiser content (not localized): create as many rows as you
-- like and the Home banner slides through the active ones, ordered by
-- sort_order. Images are referenced by a full URL in image_url (paste any
-- public URL — an advertiser CDN, Unsplash, or a Supabase Storage public URL).
--
-- This script is idempotent: safe to run again. Run it in the Supabase SQL
-- editor (or via the CLI).

create table if not exists public.ads (
  id          uuid primary key default gen_random_uuid(),
  advertiser  text,
  title       text not null,
  subtitle    text,
  image_url   text,
  link_url    text,
  sort_order  integer not null default 0,
  is_active   boolean not null default true,
  created_at  timestamptz not null default now()
);

-- Public, read-only: anyone (incl. anon) may read; no client writes.
alter table public.ads enable row level security;

drop policy if exists "Ads are readable by everyone" on public.ads;
create policy "Ads are readable by everyone"
  on public.ads for select
  using (true);

-- Seed a few sample ads so the banner has content out of the box. Edit/replace
-- these rows or add your own in the Supabase table editor.
insert into public.ads (advertiser, title, subtitle, image_url, sort_order)
values
  (
    'Wizz Air',
    'Baku → Istanbul, $99',
    'Summer sale · book by Jun 10',
    'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800&q=80',
    1
  ),
  (
    'Booking.com',
    'Stays up to 30% off',
    'Genius deals in 100+ cities',
    'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800&q=80',
    2
  ),
  (
    'GetYourGuide',
    'Skip-the-line tours',
    'Top experiences, instant tickets',
    'https://images.unsplash.com/photo-1525874684015-58379d421a52?w=800&q=80',
    3
  );
