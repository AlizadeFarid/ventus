-- Expand the Discover/Explore destination list with 13 new cities and
-- re-order the whole curated set. Rome and Lisbon already have rich
-- descriptions + tips (from 0015) — only their sort_order changes here.
-- Bali is kept active and moved to the end of the list (sort_order 16).
--
-- Images: upload paris.jpeg, dubai.jpeg, istanbul.jpeg, london.jpeg,
-- barcelona.jpeg, amsterdam.jpeg, tokyo.jpeg, new-york.jpeg, bangkok.jpeg,
-- singapore.jpeg, vienna.jpeg, prague.jpeg, athens.jpeg into the `destinations`
-- Storage bucket with these exact names.
--
-- Idempotent: safe to run again. Run in the Supabase SQL editor or via the CLI.

insert into public.destinations (
  id, name, country, description, image_path, sort_order,
  currency, language, best_time, timezone
)
values
  (
    'paris',
    '{"en":"Paris","az":"Paris","tr":"Paris"}',
    '{"en":"France","az":"Fransa","tr":"Fransa"}',
    '{"en":"The city of romance, art, fashion and iconic landmarks, famous for the Eiffel Tower, Louvre Museum, charming streets and exceptional French cuisine.","az":"Eyfel qülləsi, Luvr muzeyi, cazibədar küçələri və gözəl fransız mətbəxi ilə məşhur olan, romantika, sənət və moda şəhəri.","tr":"Eyfel Kulesi, Louvre Müzesi, büyüleyici sokakları ve muhteşem Fransız mutfağıyla ünlü, romantizm, sanat ve moda şehri."}',
    'paris.jpeg', 1,
    '{"en":"Euro (€)","az":"Avro (€)","tr":"Euro (€)"}',
    '{"en":"French","az":"Fransız dili","tr":"Fransızca"}',
    '{"en":"Apr–Jun","az":"Aprel–İyun","tr":"Nisan–Haziran"}',
    'GMT+2'
  ),
  (
    'dubai',
    '{"en":"Dubai","az":"Dubay","tr":"Dubai"}',
    '{"en":"United Arab Emirates","az":"Birləşmiş Ərəb Əmirlikləri","tr":"Birleşik Arap Emirlikleri"}',
    '{"en":"A futuristic city known for luxury shopping, impressive skyscrapers, desert adventures, beautiful beaches and world-famous attractions like Burj Khalifa.","az":"Lüks alış-veriş, təsirli göydələnlər, səhra macəraları, gözəl çimərliklər və Burj Xəlifə kimi dünyaca məşhur cazibə mərkəzləri ilə tanınan futuristik şəhər.","tr":"Lüks alışveriş, etkileyici gökdelenler, çöl maceraları, güzel plajlar ve Burj Halife gibi dünyaca ünlü cazibe merkezleriyle tanınan fütüristik şehir."}',
    'dubai.jpeg', 2,
    '{"en":"UAE Dirham (AED)","az":"BƏƏ Dirhəmi (AED)","tr":"BAE Dirhemi (AED)"}',
    '{"en":"Arabic","az":"Ərəb dili","tr":"Arapça"}',
    '{"en":"Nov–Mar","az":"Noyabr–Mart","tr":"Kasım–Mart"}',
    'GMT+4'
  ),
  (
    'istanbul',
    '{"en":"Istanbul","az":"İstanbul","tr":"İstanbul"}',
    '{"en":"Türkiye","az":"Türkiyə","tr":"Türkiye"}',
    '{"en":"A unique city connecting Europe and Asia, offering historic mosques, vibrant bazaars, Bosphorus views, delicious cuisine and a fascinating cultural atmosphere.","az":"Avropa ilə Asiyanı birləşdirən, tarixi məscidləri, canlı bazarları, Bosfor mənzərələri, dadlı mətbəxi və valehedici mədəni atmosferi olan unikal şəhər.","tr":"Avrupa ile Asya''yı birleştiren, tarihi camileri, canlı çarşıları, Boğaz manzaraları, lezzetli mutfağı ve büyüleyici kültürel atmosferiyle eşsiz bir şehir."}',
    'istanbul.jpeg', 3,
    '{"en":"Turkish Lira (₺)","az":"Türk Lirəsi (₺)","tr":"Türk Lirası (₺)"}',
    '{"en":"Turkish","az":"Türk dili","tr":"Türkçe"}',
    '{"en":"Apr–May","az":"Aprel–May","tr":"Nisan–Mayıs"}',
    'GMT+3'
  ),
  (
    'london',
    '{"en":"London","az":"London","tr":"Londra"}',
    '{"en":"United Kingdom","az":"Birləşmiş Krallıq","tr":"Birleşik Krallık"}',
    '{"en":"A dynamic global city filled with historic landmarks, royal palaces, world-class museums, diverse neighborhoods, famous theaters and iconic British culture.","az":"Tarixi abidələr, kral sarayları, dünya səviyyəli muzeylər, müxtəlif rayonlar, məşhur teatrlar və özünəməxsus Britaniya mədəniyyəti ilə dolu dinamik qlobal şəhər.","tr":"Tarihi anıtlar, kraliyet sarayları, dünya standartlarında müzeler, çeşitli mahalleler, ünlü tiyatrolar ve özgün İngiliz kültürüyle dolu dinamik bir küresel şehir."}',
    'london.jpeg', 4,
    '{"en":"Pound Sterling (£)","az":"Funt Sterlinq (£)","tr":"İngiliz Sterlini (£)"}',
    '{"en":"English","az":"İngilis dili","tr":"İngilizce"}',
    '{"en":"May–Sep","az":"May–Sentyabr","tr":"Mayıs–Eylül"}',
    'GMT+1'
  ),
  (
    'barcelona',
    '{"en":"Barcelona","az":"Barselona","tr":"Barselona"}',
    '{"en":"Spain","az":"İspaniya","tr":"İspanya"}',
    '{"en":"A vibrant Mediterranean city famous for Gaudí architecture, beautiful beaches, lively streets, creative neighborhoods and exceptional Catalan cuisine.","az":"Qaudi memarlığı, gözəl çimərlikləri, canlı küçələri, yaradıcı rayonları və mükəmməl katalan mətbəxi ilə məşhur olan canlı Aralıq dənizi şəhəri.","tr":"Gaudí mimarisi, güzel plajları, hareketli sokakları, yaratıcı mahalleleri ve mükemmel Katalan mutfağıyla ünlü canlı bir Akdeniz şehri."}',
    'barcelona.jpeg', 6,
    '{"en":"Euro (€)","az":"Avro (€)","tr":"Euro (€)"}',
    '{"en":"Spanish","az":"İspan dili","tr":"İspanyolca"}',
    '{"en":"May–Jun","az":"May–İyun","tr":"Mayıs–Haziran"}',
    'GMT+2'
  ),
  (
    'amsterdam',
    '{"en":"Amsterdam","az":"Amsterdam","tr":"Amsterdam"}',
    '{"en":"Netherlands","az":"Niderland","tr":"Hollanda"}',
    '{"en":"A charming European city known for picturesque canals, cycling culture, historic architecture, museums, cozy cafés and relaxed urban atmosphere.","az":"Mənzərəli kanalları, velosiped mədəniyyəti, tarixi memarlığı, muzeyləri, rahat kafeləri və dinc şəhər atmosferi ilə tanınan cazibədar Avropa şəhəri.","tr":"Pitoresk kanalları, bisiklet kültürü, tarihi mimarisi, müzeleri, samimi kafeleri ve rahat kent atmosferiyle bilinen büyüleyici bir Avrupa şehri."}',
    'amsterdam.jpeg', 7,
    '{"en":"Euro (€)","az":"Avro (€)","tr":"Euro (€)"}',
    '{"en":"Dutch","az":"Niderland dili","tr":"Felemenkçe"}',
    '{"en":"Apr–May","az":"Aprel–May","tr":"Nisan–Mayıs"}',
    'GMT+2'
  ),
  (
    'tokyo',
    '{"en":"Tokyo","az":"Tokio","tr":"Tokyo"}',
    '{"en":"Japan","az":"Yaponiya","tr":"Japonya"}',
    '{"en":"A fascinating blend of futuristic technology, ancient traditions, vibrant neighborhoods, incredible food, peaceful temples and unforgettable Japanese culture.","az":"Futuristik texnologiya, qədim ənənələr, canlı rayonlar, inanılmaz yeməklər, dinc məbədlər və unudulmaz yapon mədəniyyətinin valehedici qarışığı.","tr":"Fütüristik teknoloji, kadim gelenekler, canlı mahalleler, inanılmaz lezzetler, huzurlu tapınaklar ve unutulmaz Japon kültürünün büyüleyici karışımı."}',
    'tokyo.jpeg', 8,
    '{"en":"Japanese Yen (¥)","az":"Yapon Yeni (¥)","tr":"Japon Yeni (¥)"}',
    '{"en":"Japanese","az":"Yapon dili","tr":"Japonca"}',
    '{"en":"Mar–May","az":"Mart–May","tr":"Mart–Mayıs"}',
    'GMT+9'
  ),
  (
    'new-york',
    '{"en":"New York","az":"Nyu-York","tr":"New York"}',
    '{"en":"United States","az":"Amerika Birləşmiş Ştatları","tr":"Amerika Birleşik Devletleri"}',
    '{"en":"A legendary metropolis known for Times Square, Central Park, Broadway, diverse neighborhoods, world-class museums and an energetic urban lifestyle.","az":"Times Square, Central Park, Broadway, müxtəlif rayonlar, dünya səviyyəli muzeylər və enerjili şəhər həyatı ilə tanınan əfsanəvi meqapolis.","tr":"Times Meydanı, Central Park, Broadway, çeşitli mahalleler, dünya standartlarında müzeler ve enerjik şehir yaşamıyla bilinen efsanevi bir metropol."}',
    'new-york.jpeg', 9,
    '{"en":"US Dollar ($)","az":"ABŞ Dolları ($)","tr":"Amerikan Doları ($)"}',
    '{"en":"English","az":"İngilis dili","tr":"İngilizce"}',
    '{"en":"Apr–Jun","az":"Aprel–İyun","tr":"Nisan–Haziran"}',
    'GMT-4'
  ),
  (
    'bangkok',
    '{"en":"Bangkok","az":"Banqkok","tr":"Bangkok"}',
    '{"en":"Thailand","az":"Tailand","tr":"Tayland"}',
    '{"en":"A lively Asian capital famous for ornate temples, floating markets, delicious street food, vibrant nightlife and an exciting mix of tradition and modernity.","az":"Naxışlı məbədlər, üzən bazarlar, dadlı küçə yeməkləri, canlı gecə həyatı və ənənə ilə müasirliyin maraqlı qarışığı ilə məşhur canlı Asiya paytaxtı.","tr":"Süslü tapınaklar, yüzen pazarlar, lezzetli sokak yemekleri, canlı gece hayatı ve gelenekle modernliğin heyecan verici karışımıyla ünlü hareketli bir Asya başkenti."}',
    'bangkok.jpeg', 10,
    '{"en":"Thai Baht (฿)","az":"Tayland Bahtı (฿)","tr":"Tayland Bahtı (฿)"}',
    '{"en":"Thai","az":"Tay dili","tr":"Tayca"}',
    '{"en":"Nov–Feb","az":"Noyabr–Fevral","tr":"Kasım–Şubat"}',
    'GMT+7'
  ),
  (
    'singapore',
    '{"en":"Singapore","az":"Sinqapur","tr":"Singapur"}',
    '{"en":"Singapore","az":"Sinqapur","tr":"Singapur"}',
    '{"en":"A modern island city famous for futuristic architecture, clean streets, diverse cuisine, lush gardens and impressive attractions like Marina Bay Sands.","az":"Futuristik memarlığı, təmiz küçələri, müxtəlif mətbəxi, yaşıl bağları və Marina Bay Sands kimi təsirli cazibə mərkəzləri ilə məşhur müasir ada şəhəri.","tr":"Fütüristik mimarisi, temiz sokakları, çeşitli mutfağı, yemyeşil bahçeleri ve Marina Bay Sands gibi etkileyici cazibe merkezleriyle ünlü modern bir ada şehri."}',
    'singapore.jpeg', 11,
    '{"en":"Singapore Dollar (S$)","az":"Sinqapur Dolları (S$)","tr":"Singapur Doları (S$)"}',
    '{"en":"English","az":"İngilis dili","tr":"İngilizce"}',
    '{"en":"Feb–Apr","az":"Fevral–Aprel","tr":"Şubat–Nisan"}',
    'GMT+8'
  ),
  (
    'vienna',
    '{"en":"Vienna","az":"Vyana","tr":"Viyana"}',
    '{"en":"Austria","az":"Avstriya","tr":"Avusturya"}',
    '{"en":"A sophisticated European capital celebrated for imperial palaces, classical music, elegant architecture, historic cafés and rich cultural heritage.","az":"İmperator sarayları, klassik musiqi, zərif memarlıq, tarixi kafelər və zəngin mədəni irsi ilə tanınan zərif Avropa paytaxtı.","tr":"İmparatorluk sarayları, klasik müzik, zarif mimarisi, tarihi kafeleri ve zengin kültürel mirasıyla ünlü sofistike bir Avrupa başkenti."}',
    'vienna.jpeg', 12,
    '{"en":"Euro (€)","az":"Avro (€)","tr":"Euro (€)"}',
    '{"en":"German","az":"Alman dili","tr":"Almanca"}',
    '{"en":"Apr–Jun","az":"Aprel–İyun","tr":"Nisan–Haziran"}',
    'GMT+2'
  ),
  (
    'prague',
    '{"en":"Prague","az":"Praqa","tr":"Prag"}',
    '{"en":"Czech Republic","az":"Çexiya","tr":"Çekya"}',
    '{"en":"A fairy-tale European city with medieval streets, beautiful castles, historic bridges, charming squares and a distinctive Central European atmosphere.","az":"Orta əsr küçələri, gözəl qalaları, tarixi körpüləri, cazibədar meydanları və özünəməxsus Mərkəzi Avropa atmosferi ilə nağıl şəhəri.","tr":"Ortaçağ sokakları, güzel kaleleri, tarihi köprüleri, büyüleyici meydanları ve kendine özgü Orta Avrupa atmosferiyle bir masal şehri."}',
    'prague.jpeg', 13,
    '{"en":"Czech Koruna (Kč)","az":"Çex Korunası (Kč)","tr":"Çek Korunası (Kč)"}',
    '{"en":"Czech","az":"Çex dili","tr":"Çekçe"}',
    '{"en":"Apr–May","az":"Aprel–May","tr":"Nisan–Mayıs"}',
    'GMT+2'
  ),
  (
    'athens',
    '{"en":"Athens","az":"Afina","tr":"Atina"}',
    '{"en":"Greece","az":"Yunanıstan","tr":"Yunanistan"}',
    '{"en":"A historic Mediterranean capital where ancient ruins, vibrant neighborhoods, traditional Greek cuisine and modern city life come together.","az":"Qədim xarabalıqlar, canlı rayonlar, ənənəvi yunan mətbəxi və müasir şəhər həyatının bir araya gəldiyi tarixi Aralıq dənizi paytaxtı.","tr":"Antik kalıntıların, canlı mahallelerin, geleneksel Yunan mutfağının ve modern şehir hayatının bir araya geldiği tarihi bir Akdeniz başkenti."}',
    'athens.jpeg', 15,
    '{"en":"Euro (€)","az":"Avro (€)","tr":"Euro (€)"}',
    '{"en":"Greek","az":"Yunan dili","tr":"Yunanca"}',
    '{"en":"Apr–Jun","az":"Aprel–İyun","tr":"Nisan–Haziran"}',
    'GMT+3'
  )
on conflict (id) do update set
  name        = excluded.name,
  country     = excluded.country,
  description = excluded.description,
  image_path  = excluded.image_path,
  sort_order  = excluded.sort_order,
  currency    = excluded.currency,
  language    = excluded.language,
  best_time   = excluded.best_time,
  timezone    = excluded.timezone;

-- Rome and Lisbon already exist with rich description + tips (0015) — only
-- re-slot their position in the curated order.
update public.destinations set sort_order = 5  where id = 'rome';
update public.destinations set sort_order = 14 where id = 'lisbon';

-- Bali stays active, moved to the end of the curated order.
update public.destinations set sort_order = 16 where id = 'bali';
