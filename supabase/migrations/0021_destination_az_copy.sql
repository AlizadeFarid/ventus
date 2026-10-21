-- Rewrite the Azerbaijani copy for all curated destinations: the original
-- text (0015, 0020) was translated too literally from English and reads
-- unnatural / grammatically incomplete (e.g. "Pastel de nata dad").
-- This pass rewrites `description` and, for Rome/Bali/Lisbon, the `tips`
-- title/body text in natural Azerbaijani. English and Turkish copy, plus the
-- short currency/language/best_time facts, are unchanged.
--
-- Idempotent: safe to run again. Run in the Supabase SQL editor or via the CLI.

-- ── Rome ──────────────────────────────────────────────────────────────────
update public.destinations set
  description = jsonb_set(description, '{az}',
    '"Əbədi Şəhər küçələrində demək olar ki, üç min illik tarixi yaşadır — Roma xarabalıqları, Barokko fəvvarələri və İntibah sənəti bir-birinə bir neçə addım məsafəsindədir. Uzun nahar fasilələri, ayaqüstü içilən espresso və qürub vaxtı travertin daşların üzərinə düşən qızılı işıq səni gözləyir."'::jsonb),
  tips = '[
    {"icon":"ticket","title":{"en":"Skip the line","az":"Növbəni keç","tr":"Sırayı atla"},
      "body":{"en":"Book Colosseum and Vatican tickets online to avoid long queues.","az":"Uzun növbələrdən qaçmaq üçün Kolizey və Vatikan biletlərini əvvəlcədən onlayn al.","tr":"Uzun kuyruklardan kaçınmak için Kolezyum ve Vatikan biletlerini çevrimiçi alın."}},
    {"icon":"wallet","title":{"en":"Tipping is optional","az":"Bəxşiş istəyə bağlıdır","tr":"Bahşiş isteğe bağlı"},
      "body":{"en":"A coperto (cover charge) is common; round up the bill for great service.","az":"Restoranlarda coperto (masa haqqı) adətən hesaba əlavə olunur; yaxşı xidmətə görə isə hesabı yuvarlaqlaşdıra bilərsən.","tr":"Coperto (kuver ücreti) yaygındır; iyi servis için hesabı yukarı yuvarlayın."}},
    {"icon":"globe","title":{"en":"Validate your ticket","az":"Biletini ştampla","tr":"Biletinizi onaylayın"},
      "body":{"en":"Stamp bus and metro tickets on board or risk a fine.","az":"Avtobusa və ya metroya mindikdə biletini ştampla, əks halda cərimə ala bilərsən.","tr":"Otobüs ve metro biletlerini araçta damgalayın yoksa ceza yiyebilirsiniz."}}
  ]'::jsonb
where id = 'rome';

-- ── Bali ──────────────────────────────────────────────────────────────────
update public.destinations set
  description = jsonb_set(description, '{az}',
    '"İndoneziyanın məbədləri, pilləli düyü tarlaları və sörf dalğaları ilə tanınan adası. Günlər meşə şəlalələri, çimərlik klubları və buxur ətirli ziyarətgahlar arasında keçir, isti qonaqpərvərlik isə hər yerdə səni izləyir."'::jsonb),
  tips = '[
    {"icon":"wallet","title":{"en":"Carry some cash","az":"Yanında nağd pul saxla","tr":"Yanınızda nakit bulundurun"},
      "body":{"en":"Many warungs and markets are cash-only; ATMs are common in towns.","az":"Bir çox varunq (yerli kafe) və bazar yalnız nağd pul qəbul edir; bankomatlara isə şəhərlərdə tez-tez rast gəlinir.","tr":"Birçok warung ve pazar yalnızca nakit kabul eder; ATM''ler kasabalarda yaygındır."}},
    {"icon":"sun","title":{"en":"Dress for temples","az":"Məbədlər üçün münasib geyin","tr":"Tapınaklar için giyinin"},
      "body":{"en":"Cover shoulders and knees; sarongs are often provided at entrances.","az":"Çiyinlərini və dizlərini örtən geyim seç; giriş qapılarında adətən pulsuz sarong təklif olunur.","tr":"Omuzları ve dizleri örtün; girişlerde genellikle sarong verilir."}},
    {"icon":"route","title":{"en":"Hire a scooter or driver","az":"Skuter və ya sürücü tut","tr":"Scooter veya şoför tutun"},
      "body":{"en":"Traffic is busy — a private driver is cheap for day trips.","az":"Yollar sıxlıqlı olur — günlük gəzintilər üçün şəxsi sürücü tutmaq ucuz başa gəlir.","tr":"Trafik yoğun — günlük geziler için özel şoför ucuzdur."}}
  ]'::jsonb
where id = 'bali';

-- ── Lisbon ────────────────────────────────────────────────────────────────
update public.destinations set
  description = jsonb_set(description, '{az}',
    '"Portuqaliyanın təpələr üzərində qurulmuş paytaxtı — rəngli kafel divarları və taqqıltılı tramvayları ilə Tejo çayına doğru enir. Alfamanın dar küçələrində pastel de nata ətrini izlə, fado musiqisinə qulaq as, sonra bir miradourodan (mənzərə meydançasından) qürub mənzərəsinə tamaşa et."'::jsonb),
  tips = '[
    {"icon":"ticket","title":{"en":"Get a Viva Viagem card","az":"Viva Viagem kartı al","tr":"Viva Viagem kartı alın"},
      "body":{"en":"One rechargeable card covers trams, metro and ferries.","az":"Tək bir doldurulan kartla tramvay, metro və bərələrdən istifadə edə bilərsən.","tr":"Tek bir yüklenebilir kart tramvay, metro ve feribotları kapsar."}},
    {"icon":"route","title":{"en":"Wear good shoes","az":"Rahat ayaqqabı geyin","tr":"İyi ayakkabı giyin"},
      "body":{"en":"The seven hills mean steep, cobbled streets everywhere.","az":"Şəhər yeddi təpə üzərində qurulub, ona görə hər yerdə dik və daş döşəli küçələrlə rastlaşacaqsan.","tr":"Yedi tepe, her yerde dik ve arnavut kaldırımlı sokaklar demek."}},
    {"icon":"cup","title":{"en":"Try a pastel de nata","az":"Pastel de nata-nı sına","tr":"Pastel de nata deneyin"},
      "body":{"en":"Best warm with cinnamon — Belém has the famous original.","az":"Ən dadlısı isti və üzərinə darçın səpilmiş halda olur — məşhur orijinalını Belém rayonunda tapa bilərsən.","tr":"En iyisi sıcak ve tarçınlı — ünlü orijinali Belém''de."}}
  ]'::jsonb
where id = 'lisbon';

-- ── New destinations (0020) ─────────────────────────────────────────────
update public.destinations set description = jsonb_set(description, '{az}',
  '"Romantika, sənət və moda şəhəri — Eyfel qülləsi, Luvr muzeyi, füsunkar küçələri və gözəl fransız mətbəxi ilə məşhurdur."'::jsonb)
where id = 'paris';

update public.destinations set description = jsonb_set(description, '{az}',
  '"Futuristik bir şəhər — lüks alış-veriş mərkəzləri, nəhəng göydələnlər, səhra macəraları, gözəl çimərliklər və Burc Xəlifə kimi dünya şöhrətli məkanlarla tanınır."'::jsonb)
where id = 'dubai';

update public.destinations set description = jsonb_set(description, '{az}',
  '"Avropa ilə Asiyanı birləşdirən eşsiz bir şəhər — tarixi məscidləri, canlı bazarları, Bosfor mənzərələri, ləzzətli mətbəxi və valehedici mədəni atmosferi ilə seçilir."'::jsonb)
where id = 'istanbul';

update public.destinations set description = jsonb_set(description, '{az}',
  '"Tarixi abidələri, kral sarayları, dünya səviyyəli muzeyləri, rəngarəng rayonları, məşhur teatrları və özünəməxsus Britaniya mədəniyyəti ilə dolu dinamik bir qlobal şəhər."'::jsonb)
where id = 'london';

update public.destinations set description = jsonb_set(description, '{az}',
  '"Aralıq dənizinin canlı şəhəri — Qaudinin memarlığı, gözəl çimərlikləri, hərəkətli küçələri, yaradıcı rayonları və mükəmməl katalon mətbəxi ilə məşhurdur."'::jsonb)
where id = 'barcelona';

update public.destinations set description = jsonb_set(description, '{az}',
  '"Mənzərəli kanalları, velosiped mədəniyyəti, tarixi memarlığı, muzeyləri, rahat kafeləri və dinc atmosferi ilə tanınan cazibədar bir Avropa şəhəri."'::jsonb)
where id = 'amsterdam';

update public.destinations set description = jsonb_set(description, '{az}',
  '"Futuristik texnologiyanın, qədim ənənələrin, canlı rayonların, inanılmaz yeməklərin, dinc məbədlərin və unudulmaz yapon mədəniyyətinin valehedici qarışığıdır."'::jsonb)
where id = 'tokyo';

update public.destinations set description = jsonb_set(description, '{az}',
  '"Times Square, Central Park, Broadway, rəngarəng rayonları, dünya səviyyəli muzeyləri və enerjili şəhər həyatı ilə tanınan əfsanəvi bir meqapolis."'::jsonb)
where id = 'new-york';

update public.destinations set description = jsonb_set(description, '{az}',
  '"Zəngin naxışlı məbədləri, üzən bazarları, ləzzətli küçə yeməkləri, canlı gecə həyatı və ənənə ilə müasirliyin maraqlı qovuşuğu ilə seçilən canlı bir Asiya paytaxtı."'::jsonb)
where id = 'bangkok';

update public.destinations set description = jsonb_set(description, '{az}',
  '"Futuristik memarlığı, təmiz küçələri, rəngarəng mətbəxi, yaşıl bağları və Marina Bay Sands kimi təsirli məkanları ilə tanınan müasir bir ada-şəhər."'::jsonb)
where id = 'singapore';

update public.destinations set description = jsonb_set(description, '{az}',
  '"İmperator sarayları, klassik musiqi ənənəsi, zərif memarlığı, tarixi kafeləri və zəngin mədəni irsi ilə tanınan incə bir Avropa paytaxtı."'::jsonb)
where id = 'vienna';

update public.destinations set description = jsonb_set(description, '{az}',
  '"Orta əsr küçələri, gözəl qalaları, tarixi körpüləri, cazibədar meydanları və özünəməxsus Mərkəzi Avropa ab-havası ilə əsl bir nağıl şəhəridir."'::jsonb)
where id = 'prague';

update public.destinations set description = jsonb_set(description, '{az}',
  '"Qədim xarabalıqların, canlı rayonların, ənənəvi yunan mətbəxinin və müasir şəhər həyatının bir araya gəldiyi tarixi bir Aralıq dənizi paytaxtı."'::jsonb)
where id = 'athens';
