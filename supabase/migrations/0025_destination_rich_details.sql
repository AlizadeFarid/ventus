-- Rich destination guides: a longer description plus five "good to know" tips
-- per city, fully localized (en / az / tr). Overwrites description and tips for
-- all 15 destinations so every detail screen is complete.
-- Tip `icon` values are VentusIcons names (see lib/shared/widgets/ventus_icon.dart).
-- Idempotent: safe to run again.

update public.destinations set
  description = '{"en": "The Eternal City layers nearly three thousand years of history into its streets — the Colosseum, the Forum, Baroque fountains and Renaissance masterpieces sit a short walk apart. Between the sights, slow down for long lunches, espresso at the counter, cacio e pepe in Trastevere and golden light on travertine at dusk.", "az": "Əbədi Şəhər küçələrində təxminən üç min illik tarixi bir araya gətirir — Kolizey, Forum, Barokko fəvvarələri və İntibah şah əsərləri bir-birindən bir neçə addımlıqdadır. Görməli yerlər arasında uzun nahar fasilələri, piştaxta arxasında espresso, Trastevere-də cacio e pepe və qürub vaxtı travertin üzərində qızılı işığın dadını çıxar.", "tr": "Ebedi Şehir, sokaklarında neredeyse üç bin yıllık tarihi bir araya getirir — Kolezyum, Forum, Barok çeşmeler ve Rönesans şaheserleri birkaç adım ötede. Gezilecek yerlerin arasında uzun öğle yemekleri, tezgâhta espresso, Trastevere''de cacio e pepe ve gün batımında traverten üzerinde altın ışığın tadını çıkarın."}'::jsonb,
  tips = '[
 {
  "icon": "ticket",
  "title": {
   "en": "Skip the line",
   "az": "Növbəni keç",
   "tr": "Sırayı atla"
  },
  "body": {
   "en": "Book Colosseum and Vatican tickets online to avoid long queues.",
   "az": "Uzun növbələrdən qaçmaq üçün Kolizey və Vatikan biletlərini onlayn al.",
   "tr": "Uzun kuyruklardan kaçınmak için Kolezyum ve Vatikan biletlerini çevrimiçi alın."
  }
 },
 {
  "icon": "wallet",
  "title": {
   "en": "Tipping is optional",
   "az": "Bəxşiş istəyə bağlıdır",
   "tr": "Bahşiş isteğe bağlı"
  },
  "body": {
   "en": "A coperto (cover charge) is common; round up the bill for great service.",
   "az": "Coperto (xidmət haqqı) adi haldır; yaxşı xidmət üçün hesabı yuvarlaqlaşdır.",
   "tr": "Coperto (kuver ücreti) yaygındır; iyi servis için hesabı yukarı yuvarlayın."
  }
 },
 {
  "icon": "globe",
  "title": {
   "en": "Validate your ticket",
   "az": "Biletini təsdiqlə",
   "tr": "Biletinizi onaylayın"
  },
  "body": {
   "en": "Stamp bus and metro tickets on board or risk a fine.",
   "az": "Avtobus və metro biletlərini içəridə möhürlə, yoxsa cərimə ola bilər.",
   "tr": "Otobüs ve metro biletlerini araçta damgalayın yoksa ceza yiyebilirsiniz."
  }
 },
 {
  "icon": "cup",
  "title": {
   "en": "Drink from the nasoni",
   "az": "Nasoni-dən su iç",
   "tr": "Nasoni çeşmelerinden için"
  },
  "body": {
   "en": "The small public fountains give free, cold, safe drinking water — refill your bottle.",
   "az": "Kiçik ictimai fəvvarələr pulsuz, soyuq və təhlükəsiz içməli su verir — şüşəni doldur.",
   "tr": "Küçük halk çeşmeleri ücretsiz, soğuk ve güvenli içme suyu verir — şişenizi doldurun."
  }
 },
 {
  "icon": "sun",
  "title": {
   "en": "Cover up in churches",
   "az": "Kilsələrdə üst-başını ört",
   "tr": "Kiliselerde omuz ve dizleri örtün"
  },
  "body": {
   "en": "St. Peter''s and most churches require covered shoulders and knees.",
   "az": "Müqəddəs Pyotr kilsəsi və əksər kilsələr örtülü çiyin və diz tələb edir.",
   "tr": "Aziz Petrus ve çoğu kilise omuz ve dizlerin örtülü olmasını ister."
  }
 },
 {
  "icon": "clock",
  "title": {
   "en": "Beat the crowds",
   "az": "İzdihamdan qaç",
   "tr": "Kalabalıktan kaçın"
  },
  "body": {
   "en": "Visit the Trevi Fountain and Pantheon early morning or late evening.",
   "az": "Trevi fəvvarəsi və Panteonu səhər tezdən və ya axşam gec ziyarət et.",
   "tr": "Trevi Çeşmesi ve Pantheon''u sabah erken ya da akşam geç saatlerde ziyaret edin."
  }
 }
]'::jsonb
where id = 'rome';

update public.destinations set
  description = '{"en": "Indonesia''s island of temples, terraced rice fields and surf breaks. Days drift between jungle waterfalls, beach clubs, volcano sunrises and incense-scented shrines — from lively Canggu and Seminyak to the calm, artistic heart of Ubud — while warm Balinese hospitality follows you everywhere.", "az": "İndoneziyanın məbədlər, pilləli düyü tarlaları və sörf dalğaları adası. Günlər meşə şəlalələri, çimərlik klubları, vulkan üzərində gün doğuşu və buxur ətirli ziyarətgahlar arasında keçir — canlı Canggu və Seminyakdan sakit, sənətkar Ubud-a qədər — isti Bali qonaqpərvərliyi isə hər yerdə səni izləyir.", "tr": "Endonezya''nın tapınaklar, teraslı pirinç tarlaları ve sörf dalgaları adası. Günler orman şelaleleri, plaj kulüpleri, yanardağda gün doğumu ve tütsü kokulu tapınaklar arasında geçer — hareketli Canggu ve Seminyak''tan sakin, sanatsal Ubud''a kadar — sıcak Bali misafirperverliği ise her yerde sizi takip eder."}'::jsonb,
  tips = '[
 {
  "icon": "wallet",
  "title": {
   "en": "Carry some cash",
   "az": "Bir az nağd pul götür",
   "tr": "Yanınızda nakit bulundurun"
  },
  "body": {
   "en": "Many warungs and markets are cash-only; ATMs are common in towns.",
   "az": "Bir çox varunq və bazar yalnız nağd qəbul edir; bankomatlar şəhərlərdə çoxdur.",
   "tr": "Birçok warung ve pazar yalnızca nakit kabul eder; ATM''ler kasabalarda yaygındır."
  }
 },
 {
  "icon": "sun",
  "title": {
   "en": "Dress for temples",
   "az": "Məbədlər üçün geyin",
   "tr": "Tapınaklar için giyinin"
  },
  "body": {
   "en": "Cover shoulders and knees; sarongs are often provided at entrances.",
   "az": "Çiyin və dizləri ört; girişlərdə çox vaxt saronq verilir.",
   "tr": "Omuzları ve dizleri örtün; girişlerde genellikle sarong verilir."
  }
 },
 {
  "icon": "route",
  "title": {
   "en": "Hire a scooter or driver",
   "az": "Skuter və ya sürücü tut",
   "tr": "Scooter veya şoför tutun"
  },
  "body": {
   "en": "Traffic is busy — a private driver is cheap for day trips.",
   "az": "Yollar sıxdır — günlük gəzintilər üçün şəxsi sürücü ucuzdur.",
   "tr": "Trafik yoğun — günlük geziler için özel şoför ucuzdur."
  }
 },
 {
  "icon": "cup",
  "title": {
   "en": "Avoid tap water",
   "az": "Kran suyundan çəkin",
   "tr": "Musluk suyundan kaçının"
  },
  "body": {
   "en": "Drink bottled or filtered water and skip ice from unknown places to avoid ''Bali belly''.",
   "az": "Mədə problemlərinin qarşısını almaq üçün qablaşdırılmış və ya süzülmüş su iç.",
   "tr": "Mide sorunlarından kaçınmak için şişe veya filtrelenmiş su için."
  }
 },
 {
  "icon": "clock",
  "title": {
   "en": "Start early",
   "az": "Erkən başla",
   "tr": "Erken başlayın"
  },
  "body": {
   "en": "Sunrise hikes and popular temples are quietest before 8 a.m.",
   "az": "Gün doğuşu yürüşləri və məşhur məbədlər saat 8-dən əvvəl ən sakit olur.",
   "tr": "Gün doğumu yürüyüşleri ve popüler tapınaklar sabah 8''den önce en sakindir."
  }
 },
 {
  "icon": "shield",
  "title": {
   "en": "Respect offerings",
   "az": "Təqdimlərə hörmət et",
   "tr": "Sunulara saygı gösterin"
  },
  "body": {
   "en": "Don''t step on the small daily flower offerings placed on the ground.",
   "az": "Yerə qoyulan kiçik gündəlik çiçək təqdimlərinin üstünə basma.",
   "tr": "Yere bırakılan küçük günlük çiçek sunularına basmayın."
  }
 }
]'::jsonb
where id = 'bali';

update public.destinations set
  description = '{"en": "Lisbon is a sun-washed city of pastel tiles, steep hills and creaking yellow trams. Wander Alfama''s winding lanes, watch the sunset from a miradouro, eat pastéis de nata still warm from the oven, and finish the night with fado music and a glass of vinho verde.", "az": "Lissabon pastel kaşıları, dik təpələri və cırıldayan sarı tramvayları ilə günəşə qərq olmuş şəhərdir. Alfamanın dolanbac küçələrində gəz, miradouro-dan gün batımına bax, təzə çıxmış pastéis de nata ye və gecəni fado musiqisi və bir qədəh vinho verde ilə bitir.", "tr": "Lizbon; pastel çinileri, dik tepeleri ve gıcırdayan sarı tramvaylarıyla güneşe boyanmış bir şehir. Alfama''nın dolambaçlı sokaklarında gezin, bir miradouro''dan gün batımını izleyin, fırından yeni çıkmış pastéis de nata yiyin ve geceyi fado müziği ve bir kadeh vinho verde ile bitirin."}'::jsonb,
  tips = '[
 {
  "icon": "route",
  "title": {
   "en": "Wear good shoes",
   "az": "Rahat ayaqqabı geyin",
   "tr": "Rahat ayakkabı giyin"
  },
  "body": {
   "en": "The seven hills mean steep, cobbled streets everywhere.",
   "az": "Şəhər yeddi təpə üzərində qurulub, ona görə hər yerdə dik və daş döşəli küçələrlə rastlaşacaqsan.",
   "tr": "Şehir yedi tepe üzerinde, bu yüzden her yerde dik ve arnavut kaldırımlı sokaklarla karşılaşacaksın."
  }
 },
 {
  "icon": "ticket",
  "title": {
   "en": "Get a Viva Viagem card",
   "az": "Viva Viagem kartı al",
   "tr": "Viva Viagem kartı alın"
  },
  "body": {
   "en": "A rechargeable card covers metro, trams, buses and funiculars at lower fares.",
   "az": "Doldurulan kart metro, tramvay, avtobus və funikulyoru ucuz qiymətə əhatə edir.",
   "tr": "Yüklenebilir kart metro, tramvay, otobüs ve füniküleri daha ucuza kapsar."
  }
 },
 {
  "icon": "cup",
  "title": {
   "en": "Try a ginjinha",
   "az": "Ginjinha dad",
   "tr": "Ginjinha deneyin"
  },
  "body": {
   "en": "Order this cherry liqueur at a tiny bar — a classic Lisbon ritual.",
   "az": "Bu albalı likörünü kiçik barlarda sifariş et — klassik Lissabon ənənəsi.",
   "tr": "Bu vişne likörünü küçük bir barda sipariş edin — klasik bir Lizbon ritüeli."
  }
 },
 {
  "icon": "car",
  "title": {
   "en": "Tram 28 gets packed",
   "az": "28 nömrəli tramvay dolu olur",
   "tr": "28 numaralı tramvay çok kalabalık"
  },
  "body": {
   "en": "Ride early in the morning, and watch your pockets in crowds.",
   "az": "Səhər tezdən min və izdihamda cibinə diqqət et.",
   "tr": "Sabah erken binin ve kalabalıkta cebinize dikkat edin."
  }
 },
 {
  "icon": "map-pin",
  "title": {
   "en": "Day trip to Sintra",
   "az": "Sintraya bir günlük səfər",
   "tr": "Sintra''ya günübirlik gezi"
  },
  "body": {
   "en": "Fairytale palaces are 40 minutes away by train from Rossio station.",
   "az": "Nağıl sarayları Rossio stansiyasından qatarla 40 dəqiqəlikdir.",
   "tr": "Masal sarayları Rossio istasyonundan trenle 40 dakika uzaklıkta."
  }
 },
 {
  "icon": "wallet",
  "title": {
   "en": "Cash is handy",
   "az": "Nağd pul faydalıdır",
   "tr": "Nakit işe yarar"
  },
  "body": {
   "en": "Cards work almost everywhere, but small cafés and tascas may prefer cash.",
   "az": "Kartlar demək olar hər yerdə keçir, amma kiçik kafelər nağd üstün tutur.",
   "tr": "Kartlar neredeyse her yerde geçer, ancak küçük kafeler nakit tercih edebilir."
  }
 }
]'::jsonb
where id = 'lisbon';

update public.destinations set
  description = '{"en": "Paris is the city of light, romance and everyday elegance. Cross the Seine to the Louvre and Musée d''Orsay, climb Montmartre for sweeping views, and sit at a corner café with a croissant while the Eiffel Tower sparkles on the horizon. Every arrondissement has its own bakery, bookshop and secret courtyard to discover.", "az": "Paris işıq, romantika və gündəlik zəriflik şəhəridir. Sena çayını keçib Luvr və Orsay muzeyinə get, geniş mənzərə üçün Monmartra qalx və üfüqdə Eyfel qülləsi parıldayarkən küncdəki kafedə kruassanla otur. Hər arrondismanın öz çörək məhsulları dükanı, kitab mağazası və kəşf ediləcək gizli həyəti var.", "tr": "Paris; ışığın, romantizmin ve gündelik zarafetin şehri. Seine''i geçip Louvre ve Orsay Müzesi''ne gidin, geniş manzara için Montmartre''a çıkın ve ufukta Eyfel Kulesi parlarken köşedeki bir kafede kruvasanla oturun. Her bölgenin kendine ait bir fırını, kitapçısı ve keşfedilecek gizli bir avlusu var."}'::jsonb,
  tips = '[
 {
  "icon": "ticket",
  "title": {
   "en": "Book museums ahead",
   "az": "Muzeyləri əvvəlcədən rezerv et",
   "tr": "Müzeleri önceden ayırtın"
  },
  "body": {
   "en": "Reserve time slots for the Louvre and Eiffel Tower to skip hours of queuing.",
   "az": "Saatlarla növbədən qaçmaq üçün Luvr və Eyfel qülləsinə vaxt rezerv et.",
   "tr": "Saatlerce kuyruğu atlamak için Louvre ve Eyfel Kulesi''ne zaman aralığı ayırtın."
  }
 },
 {
  "icon": "globe",
  "title": {
   "en": "Say bonjour",
   "az": "Bonjour de",
   "tr": "Bonjour deyin"
  },
  "body": {
   "en": "Greeting shopkeepers and waiters first is expected and wins warmer service.",
   "az": "Satıcı və ofisiantları əvvəl salamlamaq gözlənilir və daha mehriban xidmət qazandırır.",
   "tr": "Dükkân sahiplerini ve garsonları önce selamlamak beklenir ve daha sıcak hizmet getirir."
  }
 },
 {
  "icon": "wallet",
  "title": {
   "en": "Service is included",
   "az": "Xidmət haqqı daxildir",
   "tr": "Servis ücreti dahildir"
  },
  "body": {
   "en": "Menus include service; leaving a small extra tip is a kind gesture, not required.",
   "az": "Menyuya xidmət haqqı daxildir; kiçik əlavə bəxşiş incəlikdir, məcburi deyil.",
   "tr": "Menülere servis dahildir; küçük ek bahşiş nezaket jestidir, zorunlu değildir."
  }
 },
 {
  "icon": "shield",
  "title": {
   "en": "Watch for pickpockets",
   "az": "Cibgirlərə diqqət et",
   "tr": "Yankesicilere dikkat"
  },
  "body": {
   "en": "Stay alert on the metro and near major sights, especially around the Eiffel Tower and Sacré-Cœur.",
   "az": "Metroda və əsas görməli yerlərdə, xüsusən Eyfel qülləsi və Sakre-Kerin ətrafında ayıq ol.",
   "tr": "Metroda ve ana turistik yerlerde, özellikle Eyfel Kulesi ve Sacré-Cœur çevresinde dikkatli olun."
  }
 },
 {
  "icon": "route",
  "title": {
   "en": "Walk or take the metro",
   "az": "Piyada get və ya metro ilə get",
   "tr": "Yürüyün veya metroya binin"
  },
  "body": {
   "en": "The center is compact; a metro carnet or Navigo pass covers most trips.",
   "az": "Mərkəz yığcamdır; metro kartı və ya Navigo bələdçisi səfərlərin çoxunu əhatə edir.",
   "tr": "Merkez küçüktür; metro karnesi veya Navigo pass çoğu yolculuğu karşılar."
  }
 },
 {
  "icon": "cup",
  "title": {
   "en": "Lunch is the bargain",
   "az": "Nahar sərfəlidir",
   "tr": "Öğle yemeği uygun fiyatlı"
  },
  "body": {
   "en": "Many bistros offer a fixed-price ''formule'' at lunch that costs much less than dinner.",
   "az": "Bir çox bistro nahar vaxtı axşamdan xeyli ucuz sabit qiymətli ''formule'' təklif edir.",
   "tr": "Birçok bistro öğle saatinde akşamdan çok daha ucuz sabit fiyatlı ''formule'' sunar."
  }
 }
]'::jsonb
where id = 'paris';

update public.destinations set
  description = '{"en": "Dubai is a city of superlatives rising from the desert: the Burj Khalifa, palm-shaped islands, vast malls and white-sand beaches. Beyond the skyline, explore the old souks and creek in Deira, ride dunes at sunset, and enjoy world-class dining from street shawarma to Michelin-level tasting menus.", "az": "Dubay səhradan yüksələn ifrat dərəcələr şəhəridir: Burc Xəlifə, palma formalı adalar, nəhəng ticarət mərkəzləri və ağ qumlu çimərliklər. Siluetdən kənarda Deyradakı köhnə bazarları və körfəzi kəşf et, qürub vaxtı kəsəklərdə sür və küçə şavermasından Mişelen səviyyəli menyulara qədər dünya səviyyəli yeməklərin dadına bax.", "tr": "Dubai, çölden yükselen üstünlükler şehridir: Burj Halife, palmiye şeklindeki adalar, dev alışveriş merkezleri ve beyaz kumlu plajlar. Silüetin ötesinde Deira''daki eski çarşıları ve koyu keşfedin, gün batımında kum tepelerinde safari yapın ve sokak şavurmasından Michelin seviyesindeki menülere kadar dünya standartlarında lezzetler deneyin."}'::jsonb,
  tips = '[
 {
  "icon": "sun",
  "title": {
   "en": "Beat the heat",
   "az": "İstidən qaç",
   "tr": "Sıcaktan kaçının"
  },
  "body": {
   "en": "Summers exceed 40°C; plan outdoor activities for early morning or evening.",
   "az": "Yay 40°C-dən yuxarı olur; açıq havada fəaliyyətləri səhər tezdən və ya axşama planla.",
   "tr": "Yazlar 40°C''yi aşar; açık hava etkinliklerini sabah erken veya akşama planlayın."
  }
 },
 {
  "icon": "shield",
  "title": {
   "en": "Dress modestly",
   "az": "Təvazökar geyin",
   "tr": "Mütevazı giyinin"
  },
  "body": {
   "en": "Cover shoulders and knees in malls, mosques and public areas; swimwear belongs at the beach.",
   "az": "Ticarət mərkəzlərində və ictimai yerlərdə çiyin və dizləri ört; çimərlik geyimi yalnız çimərlikdə olmalıdır.",
   "tr": "Alışveriş merkezlerinde, camilerde ve kamusal alanlarda omuz ve dizleri örtün; mayo yalnızca plaj içindir."
  }
 },
 {
  "icon": "route",
  "title": {
   "en": "Use the Metro",
   "az": "Metrodan istifadə et",
   "tr": "Metroyu kullanın"
  },
  "body": {
   "en": "The driverless Metro with a Nol card is cheap and avoids traffic and parking costs.",
   "az": "Nol kartı ilə sürücüsüz metro ucuzdur və tıxac, parkinq xərcindən qurtarır.",
   "tr": "Nol kartıyla sürücüsüz Metro ucuzdur, trafik ve otopark masrafından kurtarır."
  }
 },
 {
  "icon": "ticket",
  "title": {
   "en": "Pre-book attractions",
   "az": "Cazibələri əvvəlcədən al",
   "tr": "Cazibe merkezlerini önceden alın"
  },
  "body": {
   "en": "Burj Khalifa sunset slots sell out — book online for the best price.",
   "az": "Burc Xəlifənin gün batımı vaxtları tükənir — ən yaxşı qiymət üçün onlayn rezerv et.",
   "tr": "Burj Halife gün batımı seansları tükenir — en iyi fiyat için çevrimiçi ayırtın."
  }
 },
 {
  "icon": "globe",
  "title": {
   "en": "Respect local rules",
   "az": "Yerli qaydalara hörmət et",
   "tr": "Yerel kurallara saygı gösterin"
  },
  "body": {
   "en": "Public affection, alcohol outside licensed venues and photographing locals are restricted.",
   "az": "İctimai yerlərdə ehtiras nümayişi, icazəsiz yerlərdə spirtli içki və yerlilərin çəkilişi məhduddur.",
   "tr": "Kamusal alanda sevgi gösterisi, lisanslı mekanlar dışında alkol ve yerlileri fotoğraflamak kısıtlıdır."
  }
 },
 {
  "icon": "wallet",
  "title": {
   "en": "Taxis are metered",
   "az": "Taksilər sayğaclıdır",
   "tr": "Taksiler taksimetrelidir"
  },
  "body": {
   "en": "Official taxis and ride-hailing apps are reliable and reasonably priced.",
   "az": "Rəsmi taksilər və taksi tətbiqləri etibarlı və münasib qiymətlidir.",
   "tr": "Resmi taksiler ve araç çağırma uygulamaları güvenilir ve makul fiyatlıdır."
  }
 }
]'::jsonb
where id = 'dubai';

update public.destinations set
  description = '{"en": "Istanbul straddles two continents and thousands of years of empires. Marvel at Hagia Sophia and the Blue Mosque, haggle in the Grand Bazaar, ferry across the Bosphorus at sunset and graze through simit, börek, kebabs and baklava. The city''s neighborhoods, from Galata to Kadıköy, each feel like a different world.", "az": "İstanbul iki qitəyə və min illərlə imperiyalara yayılıb. Ayasofya və Göy Məscidə heyran qal, Böyük Bazarda pazarlıq et, qürub vaxtı bərə ilə Bosfordan keç və simit, börək, kabab və paxlavanın dadına bax. Qalatadan Kadıköyə qədər şəhərin hər məhəlləsi ayrı bir dünya kimidir.", "tr": "İstanbul iki kıtaya ve binlerce yıllık imparatorluklara yayılır. Ayasofya ve Sultanahmet Camii''ne hayran olun, Kapalıçarşı''da pazarlık yapın, gün batımında vapurla Boğaz''ı geçin ve simit, börek, kebap ve baklavanın tadına bakın. Galata''dan Kadıköy''e şehrin her semti ayrı bir dünya gibi."}'::jsonb,
  tips = '[
 {
  "icon": "ticket",
  "title": {
   "en": "Get an Istanbulkart",
   "az": "İstanbulkart al",
   "tr": "İstanbulkart alın"
  },
  "body": {
   "en": "One rechargeable card pays for metro, trams, buses and ferries at discounted fares.",
   "az": "Bir doldurulan kart metro, tramvay, avtobus və bərə üçün endirimli ödəniş edir.",
   "tr": "Tek bir yüklenebilir kart metro, tramvay, otobüs ve vapur için indirimli ödeme sağlar."
  }
 },
 {
  "icon": "shield",
  "title": {
   "en": "Dress for mosques",
   "az": "Məscidlər üçün geyin",
   "tr": "Camiler için giyinin"
  },
  "body": {
   "en": "Cover shoulders and knees; women should bring a scarf. Remove shoes at the door.",
   "az": "Çiyin və dizləri ört; qadınlar şərf götürsün. Ayaqqabıları girişdə çıxar.",
   "tr": "Omuz ve dizleri örtün; kadınlar eşarp getirsin. Ayakkabıları kapıda çıkarın."
  }
 },
 {
  "icon": "wallet",
  "title": {
   "en": "Bargain with a smile",
   "az": "Gülümsəyərək pazarlıq et",
   "tr": "Gülümseyerek pazarlık edin"
  },
  "body": {
   "en": "Haggling is normal at bazaars; offer around half the first price and stay friendly.",
   "az": "Bazarlarda pazarlıq normaldır; ilk qiymətin təxminən yarısını təklif et və mehriban ol.",
   "tr": "Çarşılarda pazarlık normaldır; ilk fiyatın yaklaşık yarısını önerin ve nazik kalın."
  }
 },
 {
  "icon": "route",
  "title": {
   "en": "Take the ferry",
   "az": "Bərə ilə get",
   "tr": "Vapura binin"
  },
  "body": {
   "en": "A Bosphorus ferry is the cheapest, most scenic way to cross between Europe and Asia.",
   "az": "Bosfor bərəsi Avropa ilə Asiya arasında keçməyin ən ucuz və mənzərəli yoludur.",
   "tr": "Boğaz vapuru Avrupa ile Asya arasında geçmenin en ucuz ve manzaralı yoludur."
  }
 },
 {
  "icon": "cup",
  "title": {
   "en": "Try Turkish tea",
   "az": "Türk çayı dad",
   "tr": "Türk çayı deneyin"
  },
  "body": {
   "en": "Tea in a tulip glass is offered everywhere — accepting it is part of the hospitality.",
   "az": "Armudu stəkanda çay hər yerdə təklif olunur — qəbul etmək qonaqpərvərliyin bir hissəsidir.",
   "tr": "İnce belli bardakta çay her yerde ikram edilir — kabul etmek misafirperverliğin parçasıdır."
  }
 },
 {
  "icon": "clock",
  "title": {
   "en": "Visit early",
   "az": "Erkən get",
   "tr": "Erken gidin"
  },
  "body": {
   "en": "Hagia Sophia and Topkapı are quietest right at opening time.",
   "az": "Ayasofya və Topkapı açılış saatında ən sakit olur.",
   "tr": "Ayasofya ve Topkapı Sarayı açılış saatinde en sakindir."
  }
 }
]'::jsonb
where id = 'istanbul';

update public.destinations set
  description = '{"en": "London is a restless, endlessly layered capital: royal palaces and Roman ruins, free world-class museums, leafy parks, and neighborhoods from Soho to Shoreditch. Catch a West End show, cruise the Thames, browse Borough Market and finish the evening in a historic pub.", "az": "London dinc və qat-qat zəngin paytaxtdır: kral sarayları və Roma xarabalıqları, pulsuz dünya səviyyəli muzeylər, yaşıl parklar və Sohodan Shoreditch-ə qədər məhəllələr. Vest-End şousuna get, Temza çayında gəzintiyə çıx, Borough bazarını gəz və axşamı tarixi pabda bitir.", "tr": "Londra huzursuz ve sonsuz katmanlı bir başkent: kraliyet sarayları ve Roma kalıntıları, ücretsiz dünya standartlarında müzeler, yeşil parklar ve Soho''dan Shoreditch''e uzanan semtler. West End''de bir gösteri izleyin, Thames''te tekne turu yapın, Borough Market''i gezin ve akşamı tarihi bir pubda bitirin."}'::jsonb,
  tips = '[
 {
  "icon": "ticket",
  "title": {
   "en": "Use contactless",
   "az": "Kontaktsız ödəniş et",
   "tr": "Temassız ödeme kullanın"
  },
  "body": {
   "en": "Tap a contactless card or phone on the Tube and buses; fares cap daily automatically.",
   "az": "Metroda və avtobusda kontaktsız kart və ya telefonu yaxınlaşdır; gündəlik tarif avtomatik məhdudlaşır.",
   "tr": "Metroda ve otobüste temassız kart veya telefon kullanın; günlük ücret otomatik sınırlanır."
  }
 },
 {
  "icon": "cloud-rain",
  "title": {
   "en": "Pack an umbrella",
   "az": "Çətir götür",
   "tr": "Şemsiye alın"
  },
  "body": {
   "en": "Weather changes quickly; layers and a light rain jacket are always useful.",
   "az": "Hava tez dəyişir; qat-qat geyim və yüngül yağış gödəkçəsi həmişə faydalıdır.",
   "tr": "Hava hızlı değişir; katmanlı giyim ve hafif yağmurluk her zaman işe yarar."
  }
 },
 {
  "icon": "wallet",
  "title": {
   "en": "Many museums are free",
   "az": "Bir çox muzey pulsuzdur",
   "tr": "Birçok müze ücretsiz"
  },
  "body": {
   "en": "The British Museum, National Gallery and Tate Modern have free entry (special shows excepted).",
   "az": "Britaniya Muzeyi, Milli Qalereya və Tate Modern pulsuzdur (xüsusi sərgilər istisna).",
   "tr": "British Museum, National Gallery ve Tate Modern ücretsizdir (özel sergiler hariç)."
  }
 },
 {
  "icon": "globe",
  "title": {
   "en": "Stand on the right",
   "az": "Eskalatorda sağda dayan",
   "tr": "Yürüyen merdivende sağda durun"
  },
  "body": {
   "en": "On escalators, stand right and walk on the left — a Tube etiquette rule.",
   "az": "Eskalatorda sağda dayan, solda yeri — metro etiketidir.",
   "tr": "Yürüyen merdivende sağda durun, solda yürüyün — metro görgü kuralıdır."
  }
 },
 {
  "icon": "cup",
  "title": {
   "en": "Tipping norms",
   "az": "Bəxşiş qaydaları",
   "tr": "Bahşiş kuralları"
  },
  "body": {
   "en": "A 12.5% service charge is often added; pubs expect no tip at the bar.",
   "az": "Çox vaxt 12,5% xidmət haqqı əlavə olunur; pabda piştaxtada bəxşiş gözlənilmir.",
   "tr": "Genellikle %12,5 servis ücreti eklenir; pubda barda bahşiş beklenmez."
  }
 },
 {
  "icon": "route",
  "title": {
   "en": "Book ahead for the big sights",
   "az": "Böyük görməli yerləri əvvəlcədən al",
   "tr": "Büyük turistik yerleri önceden ayırtın"
  },
  "body": {
   "en": "Tower of London, London Eye and palace tours are cheaper and faster when booked online.",
   "az": "London Qülləsi, London Eye və saray turları onlayn alınanda daha ucuz və sürətli olur.",
   "tr": "Tower of London, London Eye ve saray turları çevrimiçi alındığında daha ucuz ve hızlıdır."
  }
 }
]'::jsonb
where id = 'london';

update public.destinations set
  description = '{"en": "Barcelona mixes Gaudí''s fantastical architecture with Mediterranean beaches and a buzzing food scene. Marvel at the Sagrada Família and Park Güell, get lost in the Gothic Quarter, graze on tapas and cava in El Born, and swim after sunset from Barceloneta.", "az": "Barselona Qaudinin fantastik memarlığını Aralıq dənizi çimərlikləri və canlı yemək mədəniyyəti ilə birləşdirir. Sagrada Familia və Park Güelə heyran qal, Qotik məhəllədə itib-batmaq, El Bornda tapas və kava dad və Barselonetadan qürubdan sonra üz.", "tr": "Barselona, Gaudí''nin fantastik mimarisini Akdeniz plajları ve canlı yemek kültürüyle buluşturur. Sagrada Família ve Park Güell''e hayran olun, Gotik Mahalle''de kaybolun, El Born''da tapas ve cava deneyin ve gün batımından sonra Barceloneta''da yüzün."}'::jsonb,
  tips = '[
 {
  "icon": "ticket",
  "title": {
   "en": "Book Gaudí early",
   "az": "Qaudini əvvəlcədən al",
   "tr": "Gaudí biletlerini erken alın"
  },
  "body": {
   "en": "Sagrada Família and Park Güell need timed tickets — reserve days ahead.",
   "az": "Sagrada Familia və Park Güel vaxtlı bilet tələb edir — günlər əvvəl rezerv et.",
   "tr": "Sagrada Família ve Park Güell saatli bilet ister — günler öncesinden ayırtın."
  }
 },
 {
  "icon": "shield",
  "title": {
   "en": "Beware of pickpockets",
   "az": "Cibgirlərə diqqət et",
   "tr": "Yankesicilere dikkat"
  },
  "body": {
   "en": "La Rambla, the metro and beaches are hotspots — keep valuables zipped away.",
   "az": "La Rambla, metro və çimərliklər riskli yerlərdir — qiymətli əşyaları bağlı saxla.",
   "tr": "La Rambla, metro ve plajlar riskli yerlerdir — değerli eşyaları kapalı tutun."
  }
 },
 {
  "icon": "clock",
  "title": {
   "en": "Eat late",
   "az": "Gec ye",
   "tr": "Geç yemek yiyin"
  },
  "body": {
   "en": "Lunch is around 2 p.m. and dinner after 9 p.m.; many kitchens close between.",
   "az": "Nahar təxminən 14:00-da, şam 21:00-dan sonradır; bir çox mətbəx arada bağlanır.",
   "tr": "Öğle yemeği yaklaşık 14:00, akşam yemeği 21:00''den sonradır; birçok mutfak arada kapanır."
  }
 },
 {
  "icon": "route",
  "title": {
   "en": "Get a T-casual card",
   "az": "T-casual kart al",
   "tr": "T-casual kart alın"
  },
  "body": {
   "en": "A 10-trip card is cheaper for metro, bus and tram, including airport links.",
   "az": "10 səfərlik kart metro, avtobus və tramvay üçün ucuzdur.",
   "tr": "10 yolculuklu kart metro, otobüs ve tramvay için daha ucuzdur."
  }
 },
 {
  "icon": "sun",
  "title": {
   "en": "Beach etiquette",
   "az": "Çimərlik qaydaları",
   "tr": "Plaj görgü kuralları"
  },
  "body": {
   "en": "Cover up away from the beach; swimwear in shops or restaurants can earn a fine.",
   "az": "Çimərlikdən kənarda üstünü ört; mağaza və restoranlarda çimərlik geyimi cərimə gətirə bilər.",
   "tr": "Plaj dışında üstünüzü örtün; mağaza veya restoranda mayo para cezası getirebilir."
  }
 },
 {
  "icon": "cup",
  "title": {
   "en": "Menú del día",
   "az": "Günün menyusu",
   "tr": "Günün menüsü"
  },
  "body": {
   "en": "Weekday lunch menus offer three courses at a fixed price — great value.",
   "az": "Həftə içi nahar menyuları sabit qiymətə üç yemək təklif edir — çox sərfəlidir.",
   "tr": "Hafta içi öğle menüleri sabit fiyata üç yemek sunar — çok uygun."
  }
 }
]'::jsonb
where id = 'barcelona';

update public.destinations set
  description = '{"en": "Amsterdam is a compact city of canals, gabled houses and bicycles. Visit the Rijksmuseum, Van Gogh Museum and Anne Frank House, cycle through Vondelpark, taste stroopwafels and Dutch cheese, and drift along candle-lit canals at dusk.", "az": "Amsterdam kanallar, qabarıq damlı evlər və velosipedlər şəhəridir. Rijksmuseum, Van Qoq muzeyi və Anna Frank evini ziyarət et, Vondelpark-da velosiped sür, stroopwafel və Hollandiya pendirini dad və qürub vaxtı şam işıqlı kanallarda süz.", "tr": "Amsterdam; kanalların, kabartmalı cepheli evlerin ve bisikletlerin kompakt şehri. Rijksmuseum, Van Gogh Müzesi ve Anne Frank Evi''ni ziyaret edin, Vondelpark''ta bisiklete binin, stroopwafel ve Hollanda peynirini tadın ve gün batımında mum ışıklı kanallarda süzülün."}'::jsonb,
  tips = '[
 {
  "icon": "route",
  "title": {
   "en": "Mind the bike lanes",
   "az": "Velosiped zolaqlarına diqqət et",
   "tr": "Bisiklet yollarına dikkat edin"
  },
  "body": {
   "en": "Cyclists have priority and move fast; never walk or stand in the red lanes.",
   "az": "Velosipedçilərin üstünlüyü var və sürətlə gedirlər; qırmızı zolaqlarda yeriməyin.",
   "tr": "Bisikletliler önceliklidir ve hızlıdır; kırmızı şeritlerde yürümeyin veya durmayın."
  }
 },
 {
  "icon": "ticket",
  "title": {
   "en": "Book Anne Frank early",
   "az": "Anna Frank evini əvvəlcədən al",
   "tr": "Anne Frank''i erken ayırtın"
  },
  "body": {
   "en": "Tickets are online-only and release weeks ahead — they sell out fast.",
   "az": "Biletlər yalnız onlayndır və həftələr əvvəl satışa çıxır — tez tükənir.",
   "tr": "Biletler yalnızca çevrimiçidir ve haftalar önce satışa çıkar — hızla tükenir."
  }
 },
 {
  "icon": "wallet",
  "title": {
   "en": "Cards over cash",
   "az": "Kartı nağddan üstün tut",
   "tr": "Nakitten çok kart"
  },
  "body": {
   "en": "Many places are card-only (debit/contactless); carry a card that works with Maestro/Visa.",
   "az": "Bir çox yer yalnız kart qəbul edir; Maestro/Visa ilə işləyən kart götür.",
   "tr": "Birçok yer yalnızca kart kabul eder; Maestro/Visa ile çalışan bir kart bulundurun."
  }
 },
 {
  "icon": "cloud-rain",
  "title": {
   "en": "Expect rain",
   "az": "Yağış gözlə",
   "tr": "Yağmur bekleyin"
  },
  "body": {
   "en": "Showers are common year-round; bring a compact umbrella and light layers.",
   "az": "İl boyu leysan tez-tez olur; yığcam çətir və yüngül geyim götür.",
   "tr": "Yıl boyu sağanak yaygındır; kompakt şemsiye ve hafif katlar alın."
  }
 },
 {
  "icon": "map-pin",
  "title": {
   "en": "Day trip to the tulips",
   "az": "Lalə tarlalarına səfər",
   "tr": "Lale tarlalarına gezi"
  },
  "body": {
   "en": "In April, Keukenhof and the bulb fields are a short train ride away.",
   "az": "Aprel ayında Keukenhof və soğan tarlaları qısa qatar yolu uzaqlığındadır.",
   "tr": "Nisan''da Keukenhof ve lale tarlaları kısa bir tren yolculuğu uzaklıkta."
  }
 },
 {
  "icon": "shield",
  "title": {
   "en": "Respect residents",
   "az": "Sakinlərə hörmət et",
   "tr": "Sakinlere saygı gösterin"
  },
  "body": {
   "en": "Keep noise down, especially in the Red Light District, and don''t photograph workers.",
   "az": "Xüsusən Qırmızı İşıq rayonunda səsi azalt və işçilərin şəklini çəkmə.",
   "tr": "Özellikle Kırmızı Işık Bölgesi''nde sesi kısın ve çalışanları fotoğraflamayın."
  }
 }
]'::jsonb
where id = 'amsterdam';

update public.destinations set
  description = '{"en": "Tokyo blends neon-lit skyscrapers with quiet shrines and tiny izakayas. Cross Shibuya, wander Asakusa''s Senso-ji, hunt for gadgets and anime in Akihabara, queue for fresh sushi at Toyosu and find calm in Meiji Shrine. Everything runs on time and every detail is considered.", "az": "Tokio neon işıqlı göydələnləri sakit ziyarətgahlar və kiçik izakayalarla birləşdirir. Şibuyanı keç, Asakusadakı Sensoji-də gəz, Akihabarada qadcet və anime axtar, Toyosuda təzə suşi üçün növbəyə dur və Meyci ziyarətgahında sakitlik tap. Hər şey vaxtında işləyir və hər detala fikir verilib.", "tr": "Tokyo, neon ışıklı gökdelenleri sakin tapınaklar ve küçük izakayalarla harmanlar. Shibuya''yı geçin, Asakusa''daki Senso-ji''de dolaşın, Akihabara''da gadget ve anime arayın, Toyosu''da taze suşi için sıraya girin ve Meiji Tapınağı''nda huzur bulun. Her şey zamanında işler ve her ayrıntı düşünülmüştür."}'::jsonb,
  tips = '[
 {
  "icon": "ticket",
  "title": {
   "en": "Get a Suica or Pasmo",
   "az": "Suica və ya Pasmo al",
   "tr": "Suica veya Pasmo alın"
  },
  "body": {
   "en": "Add an IC card to your phone wallet; it works on trains, buses and convenience stores.",
   "az": "IC kartını telefon cüzdanına əlavə et; qatar, avtobus və mağazalarda işləyir.",
   "tr": "Telefon cüzdanınıza bir IC kart ekleyin; tren, otobüs ve marketlerde geçer."
  }
 },
 {
  "icon": "wallet",
  "title": {
   "en": "No tipping",
   "az": "Bəxşiş yoxdur",
   "tr": "Bahşiş verilmez"
  },
  "body": {
   "en": "Tipping isn''t practiced and can cause confusion — great service is standard.",
   "az": "Bəxşiş ənənəsi yoxdur və çaşqınlıq yarada bilər — əla xidmət standartdır.",
   "tr": "Bahşiş verilmez ve kafa karıştırabilir — mükemmel hizmet standarttır."
  }
 },
 {
  "icon": "globe",
  "title": {
   "en": "Cash still matters",
   "az": "Nağd pul hələ də vacibdir",
   "tr": "Nakit hâlâ önemli"
  },
  "body": {
   "en": "Shrines, small restaurants and vending machines often take cash only; 7-Eleven ATMs accept foreign cards.",
   "az": "Ziyarətgahlar, kiçik restoranlar və avtomatlar çox vaxt yalnız nağd qəbul edir; 7-Eleven bankomatları xarici kartları qəbul edir.",
   "tr": "Tapınaklar, küçük restoranlar ve otomatlar çoğunlukla yalnızca nakit alır; 7-Eleven ATM''leri yabancı kartları kabul eder."
  }
 },
 {
  "icon": "shield",
  "title": {
   "en": "Quiet on trains",
   "az": "Qatarda sakit ol",
   "tr": "Trenlerde sessiz olun"
  },
  "body": {
   "en": "Avoid phone calls and loud talk on trains; silent mode is expected.",
   "az": "Qatarda zəng və uca danışıqdan çəkin; səssiz rejim gözlənilir.",
   "tr": "Trenlerde telefon görüşmesi ve yüksek sesten kaçının; sessiz mod beklenir."
  }
 },
 {
  "icon": "cup",
  "title": {
   "en": "Eat at counters",
   "az": "Piştaxtada ye",
   "tr": "Tezgâhta yemek yiyin"
  },
  "body": {
   "en": "Ramen shops and standing bars are cheap and quick; pay via ticket machine at the door.",
   "az": "Ramen dükanları və ayaq üstü barlar ucuz və sürətlidir; ödənişi qapıdakı avtomatdan et.",
   "tr": "Ramen dükkânları ve ayakta barlar ucuz ve hızlıdır; ödemeyi girişteki makineden yapın."
  }
 },
 {
  "icon": "trash",
  "title": {
   "en": "Carry your trash",
   "az": "Zibilini özünlə daşı",
   "tr": "Çöpünüzü yanınızda taşıyın"
  },
  "body": {
   "en": "Public bins are rare; pack a small bag for wrappers until you find one.",
   "az": "İctimai zibil qutuları azdır; tapana qədər qablaşdırmalar üçün kiçik torba götür.",
   "tr": "Çöp kutuları azdır; bulana kadar ambalajlar için küçük bir poşet taşıyın."
  }
 }
]'::jsonb
where id = 'tokyo';

update public.destinations set
  description = '{"en": "New York never sleeps — skyscrapers, Broadway lights, Central Park, world-famous museums and every cuisine imaginable within a few subway stops. Walk the High Line, cross the Brooklyn Bridge, grab a slice of pizza and a bagel, and feel the city''s relentless energy.", "az": "Nyu-York heç vaxt yatmır — göydələnlər, Brodvey işıqları, Mərkəzi Park, dünyaca məşhur muzeylər və bir neçə metro dayanacağı məsafədə ağlına gələn hər mətbəx. High Line boyunca gəz, Bruklin körpüsündən keç, bir dilim pizza və bagel al və şəhərin dayanmayan enerjisini hiss et.", "tr": "New York hiç uyumaz — gökdelenler, Broadway ışıkları, Central Park, dünyaca ünlü müzeler ve birkaç metro durağı mesafede aklınıza gelen her mutfak. High Line''da yürüyün, Brooklyn Köprüsü''nü geçin, bir dilim pizza ve bagel alın ve şehrin durmayan enerjisini hissedin."}'::jsonb,
  tips = '[
 {
  "icon": "wallet",
  "title": {
   "en": "Tip generously",
   "az": "Səxavətlə bəxşiş ver",
   "tr": "Cömertçe bahşiş verin"
  },
  "body": {
   "en": "Restaurants expect 18–22%; add $1–2 per drink at bars and per bag for porters.",
   "az": "Restoranlar 18–22% gözləyir; barda hər içkiyə və yük daşıyıcıya hər çantaya 1–2$ əlavə et.",
   "tr": "Restoranlar %18–22 bekler; barlarda içki başına, hamallara çanta başına 1–2$ ekleyin."
  }
 },
 {
  "icon": "ticket",
  "title": {
   "en": "Pay with tap",
   "az": "Toxunaraq ödə",
   "tr": "Dokunarak ödeyin"
  },
  "body": {
   "en": "Tap a contactless card or phone at OMNY readers on the subway; weekly fares cap automatically.",
   "az": "Metroda OMNY oxuyucularında kontaktsız kart və ya telefonla ödə; həftəlik tarif avtomatik məhdudlaşır.",
   "tr": "Metroda OMNY okuyucularında temassız kart veya telefonla ödeyin; haftalık ücret otomatik sınırlanır."
  }
 },
 {
  "icon": "route",
  "title": {
   "en": "Walk the grid",
   "az": "Şəbəkə üzrə gəz",
   "tr": "Izgara düzeninde yürüyün"
  },
  "body": {
   "en": "Avenues run north–south and streets east–west; most places are easy to reach on foot.",
   "az": "Prospektlər şimal–cənub, küçələr şərq–qərb istiqamətindədir; əksər yerlərə piyada getmək asandır.",
   "tr": "Avenue''ler kuzey–güney, sokaklar doğu–batı yönündedir; çoğu yere yürüyerek ulaşılır."
  }
 },
 {
  "icon": "ticket",
  "title": {
   "en": "Same-day show deals",
   "az": "Eyni gün şou endirimləri",
   "tr": "Aynı gün gösteri indirimi"
  },
  "body": {
   "en": "TKTS booths sell discounted Broadway tickets on the day of the performance.",
   "az": "TKTS köşkləri tamaşa günü endirimli Brodvey biletləri satır.",
   "tr": "TKTS gişeleri gösteri günü indirimli Broadway biletleri satar."
  }
 },
 {
  "icon": "shield",
  "title": {
   "en": "Stay aware at night",
   "az": "Gecə ayıq ol",
   "tr": "Geceleri dikkatli olun"
  },
  "body": {
   "en": "Stick to well-lit, busy streets late at night and keep your phone out of sight on trains.",
   "az": "Gec saatlarda işıqlı, işlək küçələrdə qal və qatarda telefonu gizlət.",
   "tr": "Gece geç saatlerde ışıklı, işlek sokaklarda kalın ve trende telefonunuzu gizleyin."
  }
 },
 {
  "icon": "sun",
  "title": {
   "en": "Plan for extremes",
   "az": "Ekstremallara hazırlaş",
   "tr": "Aşırı havalara hazırlıklı olun"
  },
  "body": {
   "en": "Summers are humid and winters can drop below freezing — dress in layers.",
   "az": "Yay rütubətli, qış sıfırdan aşağı ola bilər — qat-qat geyin.",
   "tr": "Yazlar nemli, kışlar donma noktasının altına düşebilir — katmanlı giyinin."
  }
 }
]'::jsonb
where id = 'new-york';

update public.destinations set
  description = '{"en": "Bangkok is a sensory overload in the best way: gilded temples like Wat Pho and Wat Arun, floating markets, sizzling street food, rooftop bars and the constant buzz of tuk-tuks and river boats. Explore Chinatown at night, shop at Chatuchak and cool off in air-conditioned malls.", "az": "Banqkok ən yaxşı mənada hissləri doyduran şəhərdir: Wat Pho və Wat Arun kimi qızıllı məbədlər, üzən bazarlar, qızarmış küçə yeməkləri, dam barları və tuk-tuk və çay qayıqlarının dayanmayan səsi. Gecə Çinatauna bax, Chatuchakda alış-veriş et və kondisionerli ticarət mərkəzlərində sərinlə.", "tr": "Bangkok en güzel anlamda duyuları zorlar: Wat Pho ve Wat Arun gibi yaldızlı tapınaklar, yüzen pazarlar, cızırdayan sokak yemekleri, çatı barları ve tuk-tuk ile nehir teknelerinin durmayan uğultusu. Geceleri Çin Mahallesi''ni gezin, Chatuchak''ta alışveriş yapın ve klimalı AVM''lerde serinleyin."}'::jsonb,
  tips = '[
 {
  "icon": "shield",
  "title": {
   "en": "Dress for temples",
   "az": "Məbədlər üçün geyin",
   "tr": "Tapınaklar için giyinin"
  },
  "body": {
   "en": "Cover shoulders and knees at the Grand Palace and temples; shoes come off inside.",
   "az": "Böyük Saray və məbədlərdə çiyin və dizləri ört; içəridə ayaqqabılar çıxarılır.",
   "tr": "Büyük Saray ve tapınaklarda omuz ve dizleri örtün; içeride ayakkabılar çıkarılır."
  }
 },
 {
  "icon": "car",
  "title": {
   "en": "Agree on the fare",
   "az": "Qiymətə əvvəlcədən razılaş",
   "tr": "Ücreti önceden belirleyin"
  },
  "body": {
   "en": "Insist on the meter in taxis or use ride-hailing apps; settle tuk-tuk prices first.",
   "az": "Taksidə sayğac tələb et və ya tətbiqdən istifadə et; tuk-tuk qiymətini əvvəlcədən danış.",
   "tr": "Taksilerde taksimetre isteyin veya uygulama kullanın; tuk-tuk fiyatını önceden konuşun."
  }
 },
 {
  "icon": "route",
  "title": {
   "en": "Use the BTS and boats",
   "az": "BTS və qayıqdan istifadə et",
   "tr": "BTS ve tekneleri kullanın"
  },
  "body": {
   "en": "The Skytrain, MRT and Chao Phraya boats beat traffic and are cheap.",
   "az": "Skytrain, MRT və Chao Phraya qayıqları tıxacdan qurtarır və ucuzdur.",
   "tr": "Skytrain, MRT ve Chao Phraya tekneleri trafiği atlatır ve ucuzdur."
  }
 },
 {
  "icon": "cup",
  "title": {
   "en": "Street food is safe",
   "az": "Küçə yeməyi təhlükəsizdir",
   "tr": "Sokak yemeği güvenli"
  },
  "body": {
   "en": "Choose busy stalls with fresh turnover; stick to bottled water and avoid ice if unsure.",
   "az": "Alıcısı çox olan səyyar dükanları seç; şüşə su iç və əmin deyilsənsə buzdan çəkin.",
   "tr": "Kalabalık tezgâhları seçin; şişe su için ve emin değilseniz buzdan kaçının."
  }
 },
 {
  "icon": "sun",
  "title": {
   "en": "Beat the heat",
   "az": "İstidən qaç",
   "tr": "Sıcaktan kaçının"
  },
  "body": {
   "en": "It''s hot and humid year-round; visit sights early and rest at midday.",
   "az": "İl boyu isti və rütubətlidir; görməli yerləri səhər tezdən gəz, günorta dincəl.",
   "tr": "Yıl boyu sıcak ve nemlidir; gezilecek yerleri erken gidin, öğlen dinlenin."
  }
 },
 {
  "icon": "shield",
  "title": {
   "en": "Respect the monarchy",
   "az": "Monarxiyaya hörmət et",
   "tr": "Monarşiye saygı gösterin"
  },
  "body": {
   "en": "Speaking disrespectfully about the royal family is illegal — avoid the topic.",
   "az": "Kral ailəsi haqqında hörmətsiz danışmaq qanunsuzdur — mövzudan uzaq dur.",
   "tr": "Kraliyet ailesi hakkında saygısız konuşmak yasadışıdır — konudan uzak durun."
  }
 }
]'::jsonb
where id = 'bangkok';

update public.destinations set
  description = '{"en": "Singapore is a spotless, multicultural city-state where Chinese, Malay, Indian and Western traditions meet. Wander Gardens by the Bay, Hawker centres, Little India and Chinatown, ride the Singapore Flyer and finish the night with a Marina Bay light show.", "az": "Sinqapur Çin, Malay, Hind və Qərb ənənələrinin qovuşduğu tər-təmiz, çoxmədəniyyətli şəhər-dövlətdir. Gardens by the Bay, Hawker mərkəzləri, Kiçik Hindistan və Çinatauna bax, Singapore Flyer-ə min və gecəni Marina Bay işıq şousu ilə bitir.", "tr": "Singapur; Çin, Malay, Hint ve Batı geleneklerinin buluştuğu tertemiz, çok kültürlü bir şehir devletidir. Gardens by the Bay''i, Hawker merkezlerini, Küçük Hindistan''ı ve Çin Mahallesi''ni gezin, Singapore Flyer''a binin ve geceyi Marina Bay ışık şovuyla bitirin."}'::jsonb,
  tips = '[
 {
  "icon": "shield",
  "title": {
   "en": "Know the strict rules",
   "az": "Sərt qaydaları bil",
   "tr": "Katı kuralları bilin"
  },
  "body": {
   "en": "Littering, chewing gum import and vaping carry heavy fines — follow signs closely.",
   "az": "Zibil atmaq, saqqız gətirmək və vape ağır cərimələrə səbəb olur — işarələrə diqqət et.",
   "tr": "Çöp atmak, sakız ithali ve vape ağır para cezası getirir — tabelalara dikkat edin."
  }
 },
 {
  "icon": "cup",
  "title": {
   "en": "Eat at hawker centres",
   "az": "Hawker mərkəzlərində ye",
   "tr": "Hawker merkezlerinde yiyin"
  },
  "body": {
   "en": "Michelin-listed stalls serve full meals for a few dollars — try chicken rice.",
   "az": "Mişelen siyahılı dükanlar bir neçə dollara tam yemək verir — toyuqlu düyü dad.",
   "tr": "Michelin listesindeki tezgâhlar birkaç dolara tam yemek sunar — tavuklu pilav deneyin."
  }
 },
 {
  "icon": "ticket",
  "title": {
   "en": "Use contactless",
   "az": "Kontaktsız istifadə et",
   "tr": "Temassız kullanın"
  },
  "body": {
   "en": "Tap a bank card or phone on MRT and buses, or get an EZ-Link card.",
   "az": "MRT və avtobusda bank kartı və ya telefonla ödə, yaxud EZ-Link kartı al.",
   "tr": "MRT ve otobüste banka kartı veya telefonla ödeyin ya da EZ-Link alın."
  }
 },
 {
  "icon": "sun",
  "title": {
   "en": "Stay cool and hydrated",
   "az": "Sərin qal və su iç",
   "tr": "Serin kalın ve sıvı alın"
  },
  "body": {
   "en": "It''s hot and humid daily with sudden showers — carry water and an umbrella.",
   "az": "Hər gün isti və rütubətli, qəfil leysanlı olur — su və çətir götür.",
   "tr": "Her gün sıcak, nemli ve ani sağanaklı — su ve şemsiye taşıyın."
  }
 },
 {
  "icon": "wallet",
  "title": {
   "en": "No tip needed",
   "az": "Bəxşiş lazım deyil",
   "tr": "Bahşiş gerekmez"
  },
  "body": {
   "en": "Tipping isn''t expected; a 10% service charge is usually added to bills.",
   "az": "Bəxşiş gözlənilmir; hesaba adətən 10% xidmət haqqı əlavə olunur.",
   "tr": "Bahşiş beklenmez; hesaplara genellikle %10 servis ücreti eklenir."
  }
 },
 {
  "icon": "route",
  "title": {
   "en": "Walk indoors",
   "az": "Qapalı yerlərdə gəz",
   "tr": "Kapalı geçitleri kullanın"
  },
  "body": {
   "en": "Underground walkways and linked malls help you avoid heat and rain.",
   "az": "Yeraltı keçidlər və birləşən ticarət mərkəzləri istidən və yağışdan qoruyur.",
   "tr": "Yeraltı geçitler ve bağlı AVM''ler sıcaktan ve yağmurdan korur."
  }
 }
]'::jsonb
where id = 'singapore';

update public.destinations set
  description = '{"en": "Vienna is the imperial capital of music and coffeehouses. Tour Schönbrunn and the Hofburg, hear a concert in the Musikverein, linger over Sachertorte and melange in a historic café, and stroll the Ringstrasse and Naschmarkt. Elegant, calm and wonderfully walkable.", "az": "Vyana musiqi və qəhvəxanaların imperiya paytaxtıdır. Şönbrunn və Hofburqu gəz, Musikverein-də konsert dinlə, tarixi kafedə Sachertorte və melanj dad, Ringstrasse və Naschmarkt boyunca gəz. Zərif, sakit və gəzmək üçün gözəl.", "tr": "Viyana; müziğin ve kahvehanelerin imparatorluk başkentidir. Schönbrunn ve Hofburg''u gezin, Musikverein''da konser dinleyin, tarihi bir kafede Sachertorte ve melange ile oyalanın, Ringstrasse ve Naschmarkt''ta yürüyün. Zarif, sakin ve yürümek için harika."}'::jsonb,
  tips = '[
 {
  "icon": "ticket",
  "title": {
   "en": "Get a transit pass",
   "az": "Nəqliyyat bileti al",
   "tr": "Ulaşım kartı alın"
  },
  "body": {
   "en": "24/48/72-hour passes cover U-Bahn, trams and buses; the 1-year card is a bargain for long stays.",
   "az": "24/48/72 saatlıq biletlər metro, tramvay və avtobusu əhatə edir.",
   "tr": "24/48/72 saatlik biletler metro, tramvay ve otobüsü kapsar."
  }
 },
 {
  "icon": "cup",
  "title": {
   "en": "Coffeehouse etiquette",
   "az": "Qəhvəxana qaydaları",
   "tr": "Kahvehane görgüsü"
  },
  "body": {
   "en": "Take your time — waiters won''t rush you; ask for ''die Rechnung'' when ready to pay.",
   "az": "Tələsmə — ofisiantlar tələsdirməz; ödəməyə hazır olanda ''die Rechnung'' de.",
   "tr": "Acele etmeyin — garsonlar sizi aceleye getirmez; hazır olunca ''die Rechnung'' deyin."
  }
 },
 {
  "icon": "wallet",
  "title": {
   "en": "Tip by rounding up",
   "az": "Yuvarlaqlaşdıraraq bəxşiş ver",
   "tr": "Yuvarlayarak bahşiş verin"
  },
  "body": {
   "en": "Add about 5–10% or round up; say the final amount when paying the waiter.",
   "az": "Təxminən 5–10% əlavə et və ya yuvarlaqlaşdır; ofisianta ödəyərkən son məbləği de.",
   "tr": "Yaklaşık %5–10 ekleyin veya yuvarlayın; garsona öderken son tutarı söyleyin."
  }
 },
 {
  "icon": "ticket",
  "title": {
   "en": "Concert tickets",
   "az": "Konsert biletləri",
   "tr": "Konser biletleri"
  },
  "body": {
   "en": "Standing tickets at the State Opera are cheap; book classical concerts ahead.",
   "az": "Dövlət Operasında ayaq biletləri ucuzdur; klassik konsertləri əvvəlcədən rezerv et.",
   "tr": "Devlet Operası''nda ayakta biletler ucuzdur; klasik konserleri önceden ayırtın."
  }
 },
 {
  "icon": "sun",
  "title": {
   "en": "Winter is cold",
   "az": "Qış soyuqdur",
   "tr": "Kışlar soğuk"
  },
  "body": {
   "en": "Christmas markets are magical, but pack warm layers from November to February.",
   "az": "Milad bazarları sehrlidir, amma noyabrdan fevrala qədər isti geyim götür.",
   "tr": "Noel pazarları büyülüdür, ancak Kasım–Şubat arası sıcak giysiler alın."
  }
 },
 {
  "icon": "cup",
  "title": {
   "en": "Tap water is excellent",
   "az": "Kran suyu əladır",
   "tr": "Musluk suyu mükemmel"
  },
  "body": {
   "en": "Vienna''s tap water comes from Alpine springs — refill your bottle freely.",
   "az": "Vyananın kran suyu Alp bulaqlarından gəlir — şüşəni sərbəst doldur.",
   "tr": "Viyana''nın musluk suyu Alp kaynaklarından gelir — şişenizi rahatça doldurun."
  }
 }
]'::jsonb
where id = 'vienna';

update public.destinations set
  description = '{"en": "Prague is a fairy-tale city of spires, red rooftops and cobbled lanes. Cross Charles Bridge at dawn, explore Prague Castle, admire the Astronomical Clock, sip world-famous Czech beer in a cellar pub and wander quiet Malá Strana. Affordable, romantic and compact.", "az": "Praqa qüllələr, qırmızı damlar və daş döşəli küçələr olan nağıl şəhəridir. Səhər tezdən Karlov körpüsündən keç, Praqa qalasını kəşf et, Astronomik saata heyran qal, zirzəmi pabında dünyaca məşhur Çex pivəsini dad və sakit Malá Stranada gəz. Əlverişli, romantik və yığcamdır.", "tr": "Prag; kuleler, kırmızı çatılar ve arnavut kaldırımlı sokaklarla dolu bir masal şehri. Şafakta Charles Köprüsü''nü geçin, Prag Kalesi''ni keşfedin, Astronomik Saat''e hayran olun, bir mahzen pubunda dünyaca ünlü Çek biranızı yudumlayın ve sakin Malá Strana''da dolaşın. Uygun fiyatlı, romantik ve kompakt."}'::jsonb,
  tips = '[
 {
  "icon": "wallet",
  "title": {
   "en": "Use koruna, not euros",
   "az": "Avro yox, kronla ödə",
   "tr": "Euro değil kron kullanın"
  },
  "body": {
   "en": "Pay in Czech koruna (CZK); avoid exchange booths with poor rates — use ATMs instead.",
   "az": "Çex kronu (CZK) ilə ödə; pis kurslu mübadilə məntəqələrindən qaç.",
   "tr": "Çek kronu (CZK) ile ödeyin; kötü kurlu döviz büfelerinden kaçının."
  }
 },
 {
  "icon": "route",
  "title": {
   "en": "Walk or tram",
   "az": "Piyada və ya tramvay",
   "tr": "Yürüyün veya tramvay"
  },
  "body": {
   "en": "The center is walkable; trams and the metro cover the rest cheaply.",
   "az": "Mərkəz piyada gəzmək üçündür; tramvay və metro qalanını ucuz əhatə edir.",
   "tr": "Merkez yürünebilir; tramvay ve metro gerisini ucuza karşılar."
  }
 },
 {
  "icon": "clock",
  "title": {
   "en": "Beat the Charles Bridge crowds",
   "az": "Karlov körpüsü izdihamından qaç",
   "tr": "Charles Köprüsü kalabalığından kaçının"
  },
  "body": {
   "en": "Visit at sunrise for empty views and the best photos.",
   "az": "Boş mənzərə və ən yaxşı şəkillər üçün gün doğanda get.",
   "tr": "Boş manzara ve en iyi fotoğraflar için gün doğumunda gidin."
  }
 },
 {
  "icon": "cup",
  "title": {
   "en": "Beer is cheap",
   "az": "Pivə ucuzdur",
   "tr": "Bira ucuz"
  },
  "body": {
   "en": "Czech lager often costs less than water — try Pilsner Urquell in a cellar pub.",
   "az": "Çex lagerı çox vaxt sudan ucuzdur — zirzəmi pabında Pilsner Urquell dad.",
   "tr": "Çek birası çoğu zaman sudan ucuz — mahzen pubunda Pilsner Urquell deneyin."
  }
 },
 {
  "icon": "shield",
  "title": {
   "en": "Watch for scams",
   "az": "Fırıldaqlara diqqət et",
   "tr": "Dolandırıcılığa dikkat"
  },
  "body": {
   "en": "Use official taxis or apps; avoid street money changers and fixed-price offers.",
   "az": "Rəsmi taksi və ya tətbiqdən istifadə et; küçədə pul dəyişənlərdən qaç.",
   "tr": "Resmi taksi veya uygulama kullanın; sokak döviz bozdurucularından kaçının."
  }
 },
 {
  "icon": "map-pin",
  "title": {
   "en": "Day trip to Kutná Hora",
   "az": "Kutná Horaya səfər",
   "tr": "Kutná Hora''ya gezi"
  },
  "body": {
   "en": "A bone church and medieval town are an easy train ride away.",
   "az": "Sümük kilsəsi və orta əsr şəhəri qatarla asan çatılır.",
   "tr": "Kemik kilisesi ve ortaçağ kasabası trenle kolayca ulaşılır."
  }
 }
]'::jsonb
where id = 'prague';

update public.destinations set
  description = '{"en": "Athens is where ancient history meets lively modern life. Climb the Acropolis to the Parthenon, wander Plaka''s lanes, explore the Ancient Agora and eat souvlaki, feta and honeyed loukoumades in a rooftop taverna with the Acropolis glowing above you.", "az": "Afina qədim tarixlə canlı müasir həyatın qovuşduğu yerdir. Akropolisə Parfenona qədər qalx, Plakanın dar küçələrində gəz, Qədim Aqoranı kəşf et və Akropolis üzərində parıldayarkən dam tavernasında suvlaki, feta və ballı lukumades ye.", "tr": "Atina, antik tarihin canlı modern hayatla buluştuğu yerdir. Akropolis''e Parthenon''a kadar tırmanın, Plaka''nın sokaklarında dolaşın, Antik Agora''yı keşfedin ve Akropolis tepede parlarken çatı tavernasında souvlaki, feta ve ballı lokma yiyin."}'::jsonb,
  tips = '[
 {
  "icon": "clock",
  "title": {
   "en": "Visit the Acropolis early",
   "az": "Akropolisə erkən get",
   "tr": "Akropolis''e erken gidin"
  },
  "body": {
   "en": "Go at opening or after 5 p.m. to avoid midday heat and the biggest crowds.",
   "az": "İsti və izdihamdan qaçmaq üçün açılışda və ya saat 17:00-dan sonra get.",
   "tr": "Sıcak ve kalabalıktan kaçmak için açılışta veya 17:00''den sonra gidin."
  }
 },
 {
  "icon": "ticket",
  "title": {
   "en": "Buy a combo ticket",
   "az": "Kombo bilet al",
   "tr": "Kombine bilet alın"
  },
  "body": {
   "en": "One pass covers the Acropolis and several archaeological sites for five days.",
   "az": "Bir bilet Akropolis və bir neçə arxeoloji sahəni beş gün əhatə edir.",
   "tr": "Tek bir bilet Akropolis ve birkaç arkeolojik alanı beş gün kapsar."
  }
 },
 {
  "icon": "sun",
  "title": {
   "en": "Cover up and hydrate",
   "az": "Üstünü ört və su iç",
   "tr": "Örtünün ve su için"
  },
  "body": {
   "en": "Summer reaches 38°C+; wear a hat, sunscreen and sturdy shoes — marble is slippery.",
   "az": "Yay 38°C+ olur; papaq, günəş kremi və möhkəm ayaqqabı götür — mərmər sürüşkəndir.",
   "tr": "Yaz 38°C üzerine çıkar; şapka, güneş kremi ve sağlam ayakkabı alın — mermer kaygandır."
  }
 },
 {
  "icon": "wallet",
  "title": {
   "en": "Tip a little",
   "az": "Bir az bəxşiş ver",
   "tr": "Küçük bahşiş verin"
  },
  "body": {
   "en": "Leave around 5–10% or round up at tavernas; service isn''t always included.",
   "az": "Tavernalarda təxminən 5–10% və ya yuvarlaqlaşdır; xidmət həmişə daxil deyil.",
   "tr": "Tavernalarda %5–10 bırakın veya yuvarlayın; servis her zaman dahil değildir."
  }
 },
 {
  "icon": "route",
  "title": {
   "en": "Metro is fast",
   "az": "Metro sürətlidir",
   "tr": "Metro hızlı"
  },
  "body": {
   "en": "The metro links the airport to the center; ancient artifacts are displayed in stations.",
   "az": "Metro hava limanını mərkəzlə bağlayır; stansiyalarda qədim artefaktlar nümayiş olunur.",
   "tr": "Metro havalimanını merkeze bağlar; istasyonlarda antik eserler sergilenir."
  }
 },
 {
  "icon": "map-pin",
  "title": {
   "en": "Island day trips",
   "az": "Adalara səfər",
   "tr": "Adalara günübirlik gezi"
  },
  "body": {
   "en": "Ferries from Piraeus reach Hydra, Aegina and Poros in a day.",
   "az": "Pireydən bərələr Hidra, Eqina və Porosa bir gündə çatır.",
   "tr": "Pire''den vapurlar Hydra, Aegina ve Poros''a bir günde ulaşır."
  }
 }
]'::jsonb
where id = 'athens';
