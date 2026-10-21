-- Rich content for the destination detail screen (city/country guide):
-- a longer "about" description, quick facts (currency / language / best time /
-- timezone) and a list of "good to know" tips.
--
-- Localized fields stay as jsonb maps keyed by language code: {"en","az","tr"}.
-- `timezone` is a plain label (e.g. "GMT+1"). `tips` is a jsonb array of
-- {"icon", "title": {..}, "body": {..}} objects, where `icon` is a VentusIcons
-- name (ticket, wallet, globe, sun, route, cup, ...).
--
-- Idempotent: safe to run again. Run in the Supabase SQL editor or via the CLI.

alter table public.destinations add column if not exists currency  jsonb not null default '{}'::jsonb;
alter table public.destinations add column if not exists language  jsonb not null default '{}'::jsonb;
alter table public.destinations add column if not exists best_time jsonb not null default '{}'::jsonb;
alter table public.destinations add column if not exists timezone  text;
alter table public.destinations add column if not exists tips      jsonb not null default '[]'::jsonb;

-- ── Rome ──────────────────────────────────────────────────────────────────
update public.destinations set
  description = '{
    "en":"The Eternal City layers nearly three thousand years of history into its streets — Roman ruins, Baroque fountains and Renaissance art sit a short walk apart. Expect long lunches, espresso on your feet, and golden light on travertine at dusk.",
    "az":"Əbədi Şəhər küçələrində təxminən üç min illik tarixi bir araya gətirir — Roma xarabalıqları, Barokko fəvvarələri və İntibah sənəti bir-birindən bir neçə addımlıqdadır. Uzun nahar fasilələri, ayaqüstü espresso və qürub vaxtı travertin üzərində qızılı işıq gözlə.",
    "tr":"Ebedi Şehir, sokaklarında neredeyse üç bin yıllık tarihi bir araya getirir — Roma kalıntıları, Barok çeşmeler ve Rönesans sanatı birkaç adım ötede. Uzun öğle yemekleri, ayaküstü espresso ve gün batımında traverten üzerinde altın ışık sizi bekliyor."
  }'::jsonb,
  currency  = '{"en":"Euro (€)","az":"Avro (€)","tr":"Euro (€)"}'::jsonb,
  language  = '{"en":"Italian","az":"İtalyanca","tr":"İtalyanca"}'::jsonb,
  best_time = '{"en":"Apr–Jun","az":"Apr–İyun","tr":"Nis–Haz"}'::jsonb,
  timezone  = 'GMT+1',
  tips = '[
    {"icon":"ticket","title":{"en":"Skip the line","az":"Növbəni keç","tr":"Sırayı atla"},
      "body":{"en":"Book Colosseum and Vatican tickets online to avoid long queues.","az":"Uzun növbələrdən qaçmaq üçün Kolizey və Vatikan biletlərini onlayn al.","tr":"Uzun kuyruklardan kaçınmak için Kolezyum ve Vatikan biletlerini çevrimiçi alın."}},
    {"icon":"wallet","title":{"en":"Tipping is optional","az":"Bəxşiş istəyə bağlıdır","tr":"Bahşiş isteğe bağlı"},
      "body":{"en":"A coperto (cover charge) is common; round up the bill for great service.","az":"Coperto (xidmət haqqı) adi haldır; yaxşı xidmət üçün hesabı yuvarlaqlaşdır.","tr":"Coperto (kuver ücreti) yaygındır; iyi servis için hesabı yukarı yuvarlayın."}},
    {"icon":"globe","title":{"en":"Validate your ticket","az":"Biletini təsdiqlə","tr":"Biletinizi onaylayın"},
      "body":{"en":"Stamp bus and metro tickets on board or risk a fine.","az":"Avtobus və metro biletlərini içəridə möhürlə, yoxsa cərimə ola bilər.","tr":"Otobüs ve metro biletlerini araçta damgalayın yoksa ceza yiyebilirsiniz."}}
  ]'::jsonb
where id = 'rome';

-- ── Bali ──────────────────────────────────────────────────────────────────
update public.destinations set
  description = '{
    "en":"Indonesia''s island of temples, terraced rice fields and surf breaks. Days drift between jungle waterfalls, beach clubs and incense-scented shrines, while warm hospitality follows you everywhere.",
    "az":"İndoneziyanın məbədlər, pilləli düyü tarlaları və sörf dalğaları adası. Günlər meşə şəlalələri, çimərlik klubları və buxur ətirli ziyarətgahlar arasında keçir, isti qonaqpərvərlik isə hər yerdə səni izləyir.",
    "tr":"Endonezya''nın tapınaklar, teraslı pirinç tarlaları ve sörf dalgaları adası. Günler orman şelaleleri, plaj kulüpleri ve tütsü kokulu tapınaklar arasında geçerken, sıcak misafirperverlik her yerde sizi takip eder."
  }'::jsonb,
  currency  = '{"en":"Rupiah (Rp)","az":"Rupi (Rp)","tr":"Rupiah (Rp)"}'::jsonb,
  language  = '{"en":"Indonesian","az":"İndoneziyaca","tr":"Endonezyaca"}'::jsonb,
  best_time = '{"en":"Apr–Oct","az":"Apr–Okt","tr":"Nis–Eki"}'::jsonb,
  timezone  = 'GMT+8',
  tips = '[
    {"icon":"wallet","title":{"en":"Carry some cash","az":"Bir az nağd pul götür","tr":"Yanınızda nakit bulundurun"},
      "body":{"en":"Many warungs and markets are cash-only; ATMs are common in towns.","az":"Bir çox varunq və bazar yalnız nağd qəbul edir; bankomatlar şəhərlərdə çoxdur.","tr":"Birçok warung ve pazar yalnızca nakit kabul eder; ATM''ler kasabalarda yaygındır."}},
    {"icon":"sun","title":{"en":"Dress for temples","az":"Məbədlər üçün geyin","tr":"Tapınaklar için giyinin"},
      "body":{"en":"Cover shoulders and knees; sarongs are often provided at entrances.","az":"Çiyin və dizləri ört; girişlərdə çox vaxt saronq verilir.","tr":"Omuzları ve dizleri örtün; girişlerde genellikle sarong verilir."}},
    {"icon":"route","title":{"en":"Hire a scooter or driver","az":"Skuter və ya sürücü tut","tr":"Scooter veya şoför tutun"},
      "body":{"en":"Traffic is busy — a private driver is cheap for day trips.","az":"Yollar sıxdır — günlük gəzintilər üçün şəxsi sürücü ucuzdur.","tr":"Trafik yoğun — günlük geziler için özel şoför ucuzdur."}}
  ]'::jsonb
where id = 'bali';

-- ── Lisbon ────────────────────────────────────────────────────────────────
update public.destinations set
  description = '{
    "en":"Portugal''s hilly capital tumbles down to the Tagus in pastel tiles and rattling trams. Follow the smell of custard tarts through Alfama''s lanes, then catch fado and a sunset view from a miradouro.",
    "az":"Portuqaliyanın təpəlik paytaxtı pastel kafel və taqqıldayan tramvaylarla Taxo çayına doğru enir. Alfamanın dar küçələrində kustard tartların ətrini izlə, sonra fado dinlə və miradurodan qürub mənzərəsinə bax.",
    "tr":"Portekiz''in tepelik başkenti, pastel karolar ve tıkırdayan tramvaylarla Tejo''ya doğru iner. Alfama''nın dar sokaklarında pastel de nata kokusunu takip edin, ardından fado dinleyin ve bir miradouro''dan gün batımını izleyin."
  }'::jsonb,
  currency  = '{"en":"Euro (€)","az":"Avro (€)","tr":"Euro (€)"}'::jsonb,
  language  = '{"en":"Portuguese","az":"Portuqalca","tr":"Portekizce"}'::jsonb,
  best_time = '{"en":"Mar–Jun","az":"Mar–İyun","tr":"Mar–Haz"}'::jsonb,
  timezone  = 'GMT+0',
  tips = '[
    {"icon":"ticket","title":{"en":"Get a Viva Viagem card","az":"Viva Viagem kartı al","tr":"Viva Viagem kartı alın"},
      "body":{"en":"One rechargeable card covers trams, metro and ferries.","az":"Bir doldurulan kart tramvay, metro və bərələri əhatə edir.","tr":"Tek bir yüklenebilir kart tramvay, metro ve feribotları kapsar."}},
    {"icon":"route","title":{"en":"Wear good shoes","az":"Rahat ayaqqabı geyin","tr":"İyi ayakkabı giyin"},
      "body":{"en":"The seven hills mean steep, cobbled streets everywhere.","az":"Yeddi təpə hər yerdə dik, daş döşəli küçələr deməkdir.","tr":"Yedi tepe, her yerde dik ve arnavut kaldırımlı sokaklar demek."}},
    {"icon":"cup","title":{"en":"Try a pastel de nata","az":"Pastel de nata dad","tr":"Pastel de nata deneyin"},
      "body":{"en":"Best warm with cinnamon — Belém has the famous original.","az":"Ən yaxşısı isti və darçınlıdır — məşhur orijinalı Beləmdədir.","tr":"En iyisi sıcak ve tarçınlı — ünlü orijinali Belém''de."}}
  ]'::jsonb
where id = 'lisbon';
