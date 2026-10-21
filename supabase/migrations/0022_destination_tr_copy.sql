-- Rewrite the Turkish copy for the curated destinations that carried it.
-- The original text (0015) addressed the reader formally ("alın", "giyinin",
-- "sizi bekliyor") while the rest of the app speaks to the user informally
-- ("sen"), so Discover read like a different product. This pass rewrites the
-- Turkish `description` and `tips` for Rome/Bali/Lisbon in the app's voice.
-- English and Azerbaijani copy (0015, 0020, 0021) is carried over unchanged.
--
-- Idempotent: safe to run again. Run in the Supabase SQL editor or via the CLI.

-- ── Rome ──────────────────────────────────────────────────────────────────
update public.destinations set
  description = jsonb_set(description, '{tr}',
    '"Ebedi Şehir, sokaklarında neredeyse üç bin yıllık tarihi bir araya getirir — Roma kalıntıları, Barok çeşmeler ve Rönesans sanatı birkaç adım ötede. Uzun öğle yemekleri, ayaküstü espresso ve gün batımında traverten üzerinde altın ışık seni bekliyor."'::jsonb),
  tips = '[
    {"icon":"ticket","title":{"en":"Skip the line","az":"Növbəni keç","tr":"Sırayı atla"},
      "body":{"en":"Book Colosseum and Vatican tickets online to avoid long queues.","az":"Uzun növbələrdən qaçmaq üçün Kolizey və Vatikan biletlərini əvvəlcədən onlayn al.","tr":"Uzun kuyruklara takılmamak için Kolezyum ve Vatikan biletlerini önceden çevrimiçi al."}},
    {"icon":"wallet","title":{"en":"Tipping is optional","az":"Bəxşiş istəyə bağlıdır","tr":"Bahşiş isteğe bağlı"},
      "body":{"en":"A coperto (cover charge) is common; round up the bill for great service.","az":"Restoranlarda coperto (masa haqqı) adətən hesaba əlavə olunur; yaxşı xidmətə görə isə hesabı yuvarlaqlaşdıra bilərsən.","tr":"Restoranlarda coperto (kuver ücreti) genelde hesaba eklenir; iyi servis içinse hesabı yukarı yuvarlayabilirsin."}},
    {"icon":"globe","title":{"en":"Validate your ticket","az":"Biletini ştampla","tr":"Biletini damgala"},
      "body":{"en":"Stamp bus and metro tickets on board or risk a fine.","az":"Avtobusa və ya metroya mindikdə biletini ştampla, əks halda cərimə ala bilərsən.","tr":"Otobüse ya da metroya binince biletini damgala, yoksa ceza yiyebilirsin."}}
  ]'::jsonb
where id = 'rome';

-- ── Bali ──────────────────────────────────────────────────────────────────
update public.destinations set
  description = jsonb_set(description, '{tr}',
    '"Endonezya''nın tapınaklar, teraslı pirinç tarlaları ve sörf dalgaları adası. Günler orman şelaleleri, plaj kulüpleri ve tütsü kokulu tapınaklar arasında geçerken, sıcak misafirperverlik her yerde seni takip eder."'::jsonb),
  tips = '[
    {"icon":"wallet","title":{"en":"Carry some cash","az":"Yanında nağd pul saxla","tr":"Yanında nakit bulundur"},
      "body":{"en":"Many warungs and markets are cash-only; ATMs are common in towns.","az":"Bir çox varunq (yerli kafe) və bazar yalnız nağd pul qəbul edir; bankomatlara isə şəhərlərdə tez-tez rast gəlinir.","tr":"Birçok warung (yerel lokanta) ve pazar yalnızca nakit kabul eder; ATM''lere ise kasabalarda sık rastlarsın."}},
    {"icon":"sun","title":{"en":"Dress for temples","az":"Məbədlər üçün münasib geyin","tr":"Tapınaklar için uygun giyin"},
      "body":{"en":"Cover shoulders and knees; sarongs are often provided at entrances.","az":"Çiyinlərini və dizlərini örtən geyim seç; giriş qapılarında adətən pulsuz sarong təklif olunur.","tr":"Omuzlarını ve dizlerini örten bir şey seç; girişlerde genellikle sarong verilir."}},
    {"icon":"route","title":{"en":"Hire a scooter or driver","az":"Skuter və ya sürücü tut","tr":"Scooter ya da şoför tut"},
      "body":{"en":"Traffic is busy — a private driver is cheap for day trips.","az":"Yollar sıxlıqlı olur — günlük gəzintilər üçün şəxsi sürücü tutmaq ucuz başa gəlir.","tr":"Trafik yoğun olur — günlük geziler için özel şoför ucuza geliyor."}}
  ]'::jsonb
where id = 'bali';

-- ── Lisbon ────────────────────────────────────────────────────────────────
update public.destinations set
  description = jsonb_set(description, '{tr}',
    '"Portekiz''in tepelik başkenti, pastel karolar ve tıkırdayan tramvaylarla Tejo''ya doğru iner. Alfama''nın dar sokaklarında pastel de nata kokusunu takip et, sonra fado dinle ve bir miradouro''dan (manzara terasından) gün batımını izle."'::jsonb),
  tips = '[
    {"icon":"ticket","title":{"en":"Get a Viva Viagem card","az":"Viva Viagem kartı al","tr":"Viva Viagem kartı al"},
      "body":{"en":"One rechargeable card covers trams, metro and ferries.","az":"Tək bir doldurulan kartla tramvay, metro və bərələrdən istifadə edə bilərsən.","tr":"Tek bir yüklenebilir kartla tramvaya, metroya ve feribotlara binebilirsin."}},
    {"icon":"route","title":{"en":"Wear good shoes","az":"Rahat ayaqqabı geyin","tr":"Rahat ayakkabı giy"},
      "body":{"en":"The seven hills mean steep, cobbled streets everywhere.","az":"Şəhər yeddi təpə üzərində qurulub, ona görə hər yerdə dik və daş döşəli küçələrlə rastlaşacaqsan.","tr":"Şehir yedi tepe üzerinde, bu yüzden her yerde dik ve arnavut kaldırımlı sokaklarla karşılaşacaksın."}},
    {"icon":"cup","title":{"en":"Try a pastel de nata","az":"Pastel de nata-nı sına","tr":"Pastel de nata dene"},
      "body":{"en":"Best warm with cinnamon — Belém has the famous original.","az":"Ən dadlısı isti və üzərinə darçın səpilmiş halda olur — məşhur orijinalını Belém rayonunda tapa bilərsən.","tr":"En iyisi sıcak ve tarçınlı — ünlü orijinalini Belém''de bulabilirsin."}}
  ]'::jsonb
where id = 'lisbon';
