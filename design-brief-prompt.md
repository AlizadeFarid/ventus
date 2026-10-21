# Ventus — Yeni Dizayn üçün Məhsul Brifi

> Bu sənəd bir UX/UI dizayner üçün hazırlanmış brifdir. Məqsəd: aşağıda təsvir olunan mobil tətbiqin **funksionallığını, məqsədini və istifadəçi axınlarını** tam anlayıb, **hazırkı vizual dizaynı, rəng sxemini, komponent üslubunu və struktur qərarlarını tamamilə kənara qoyaraq**, sıfırdan, öz təxəyyülünlə yeni bir vizual dizayn və (istəsən) yeni bir naviqasiya strukturu təklif etməkdir.
>
> Bu sənəddə qəsdən texnologiya, framework, kod strukturu, verilənlər bazası kimi texniki detallar yoxdur — yalnız istifadəçinin gördüyü, etdiyi və əldə etdiyi funksionallıq təsvir olunub.
>
> Sənədi oxuduqdan sonra mənimlə danış: əvvəlcə tətbiqin ümumi məqsədini və hədəf istifadəçisini necə anladığını qısa izah et, sonra mərhələli şəkildə — **onboarding/giriş ekranından başlayaraq, sona qədər** — hər bir ekranı/axını bir-bir dizayn et. Hər mərhələdə mənim təsdiqimi gözlə, sonra növbəti mərhələyə keç.

---

## 1. Tətbiqin məqsədi

**Ventus** — fərdi səyahət planlama tətbiqidir. Əsas dəyər təklifi: səyahət planlamasının adətən fərqli yerlərə (qeydlər, mesajlaşma, ayrı valyuta çeviricisi, ayrı bağlama siyahısı, email-lərdə itən biletlər) səpələnmiş hissələrini **bir tətbiqdə** birləşdirmək:

- Hara getmək barədə ilham almaq
- Marşrut, tarixlər və həmsəyahətçiləri müəyyən etmək
- Süni intellektin köməyi ilə (və ya əl ilə) gündəlik plan qurmaq
- Büdcəni izləmək və xərcləri qeyd etmək
- Bağlama/hazırlıq siyahısını idarə etmək
- Bilet, bron, sənəd və şəkilləri bir yerdə saxlamaq
- Səyahəti dostlar/ailə ilə birgə planlamaq (paylaşma və əməkdaşlıq)
- Səyahət zamanı lazım olan gündəlik alətlərə (valyuta, hava, saat, bəxşiş) sürətli çıxış əldə etmək

Tətbiq **oflayn-first** məntiqlə işləyir — istifadəçinin əsas məlumatları (səyahətlər, büdcə, bağlama siyahısı, sənədlər) internetsiz də mövcud olmalıdır, internet olduqda arxa planda sinxronlaşır.

## 2. Hədəf istifadəçi

Fərdi və ya kiçik qrup şəklində (cütlük, ailə, dostlarla) səyahət edən, mobil telefonundan planlama edən istifadəçi. Bəzən tək, bəzən başqaları ilə birgə planlaşdırır. Həm qısa şəhər səyahətləri, həm uzun tətillər üçün istifadə edə bilər. Dizaynda bu profilin rahatlığı, sürəti və mobil-first təcrübəsi prioritet olmalıdır. Naviqasiya/İA (informasiya arxitekturası) sərbəst yenidən düşünülə bilər — aşağıdakı qruplaşdırma sadəcə **hazırkı funksional təşkilatı** izah etmək üçündür, məcburi struktur şablonu deyil.

## 3. Əsas funksional sahələr (icmal)

1. Qeydiyyat/Giriş və hesab təhlükəsizliyi
2. Kəşf (ilham/destinasiya axtarışı)
3. Səyahət yaratma (əl ilə və ya AI ilə)
4. Səyahət idarəetməsi (marşrut, gündəlik plan, büdcə, bağlama siyahısı, sənədlər, xəritə, birgə planlama)
5. Saxlanılan yerlər
6. Gündəlik alətlər (valyuta, hava, saat, bəxşiş)
7. Bildirişlər
8. Profil, tənzimləmələr və abunəlik (Pro)

---

## 4. Ekranlar və axınlar — mərhələ-mərhələ

Aşağıda hər bir ekran/axın: **məqsədi, istifadəçinin nə edə biləcəyi, göstərilən məlumat, mümkün vəziyyətlər (boş/yüklənmə/xəta) və növbəti addım** ilə təsvir olunub. Dizayn işini məhz bu ardıcıllıqla aparmağını istəyirəm.

### 4.1. Giriş axını (Onboarding → Auth)

**Qarşılama ekranı (Welcome)**
İlk açılışda görünən ekran. Tətbiqin adı/şüarı, tam ekran ilhamverici görüntü, iki əsas call-to-action: "Başla" (hesab yarat) və "Artıq hesabım var" (giriş et).

**Hesab yaratma (Sign Up)**
Ad, email, şifrə sahələri; şərtlər/məxfilik siyasətinə razılıq checkbox-ı (mətndaxili linklərlə); əsas "Hesab yarat" düyməsi; alternativ olaraq Google və Apple ilə bir kliklə qeydiyyat; girişə keçid linki. Email təsdiqi aktivdirsə istifadəçi "Emailini yoxla" ekranına yönləndirilir, deyilsə birbaşa tətbiqə buraxılır.

**Email təsdiqi gözlənilir**
"Poçt qutunu yoxla" mesajı, təsdiq linkini yenidən göndərmək düyməsi, alternativ olaraq giriş ekranına qayıtmaq imkanı.

**Giriş (Sign In)**
Email/şifrə sahələri, "məni xatırla" seçimi, "şifrəni unutdum" linki, Google/Apple ilə giriş, hesab yaratmaq linki.

**Şifrəni unutdum → Yeniləmə**
Email daxil edib bərpa kodu istəmək → emailə gələn kodu və yeni şifrəni daxil etmək, kodu yenidən göndərmək imkanı.

**Şərtlər və Məxfilik siyasəti**
Sadə, oxunaqlı statik mətn ekranı (iki ayrı sənəd: İstifadə şərtləri, Məxfilik siyasəti).

**Sürətli açma PIN-i (App Lock)**
Hesaba email/şifrə ilə girdikdən sonra istifadəçidən 4 rəqəmli PIN qurması istənir (rahatlıq üçün, hər dəfə şifrə yazmasın deyə). Növbəti açılışlarda bu PIN ilə (parol yazmadan) tez giriş edilir; "parol ilə gir" alternativi də mövcuddur (bu, tam çıxış/sign-out kimi işləyir). PIN dəyişdirmə/sıfırlama profil bölməsindən mümkündür.

---

### 4.2. Əsas naviqasiya

Tətbiqin əsas skeleti 4 bölmədən ibarətdir: **Ana səhifə, Saxlanılanlar, Alətlər, Profil** — üstəlik hər zaman görünən, "yeni səyahət yarat" axınını açan mərkəzi bir hərəkət düyməsi. Kəşf (Explore) bölməsi bu dörd bölmədən ayrıca, Ana səhifədən və ya yer detalından açılan tam-ekran bir təcrübədir (dizayner istəsə bunu əsas naviqasiyaya da inteqrasiya edə bilər).

---

### 4.3. Ana səhifə (Home)

İstifadəçinin ilk gördüyü "ev" ekranı. Tərkibi:
- Şəxsi salamlama (ad ilə)
- **Aktiv/gələcək səyahət** üçün önə çıxan bir kart: örtük şəkli, geriyə qalan gün sayı, planlaşdırma tamamlanma faizi
- İstifadəçinin bütün səyahətlərinin üfüqi siyahısı, "hamısına bax" linki ilə
- Sponsorlu/tövsiyə olunan üçüncü tərəf təklifləri karuseli (aviabilet, otel, tur təklifləri kimi düşün — reklam xarakterli, aydın "Sponsorlu" etiketi ilə)
- "AI ilə plan qur" kartı — süni intellektə səyahət təsvirini yazıb avtomatik plan aldırmaq təklifi
- "İlham lazımdır?" bölməsi — Kəşf-dən populyar destinasiyaların qısa önizləməsi

Səyahət yoxdursa: xoş görünüşlü boş vəziyyət (ikon, mətn, "Yeni səyahət planla" və "AI ilə planla" düymələri) + yenə də ilham bölməsi göstərilir. Yüklənə bilmirsə: aydın xəta mesajı + "Yenidən cəhd et" düyməsi.

---

### 4.4. Kəşf (Explore / Discover)

İlham məqsədli, kartlar şəklində destinasiya qalereyası (2 sütunlu grid). Hər kart: şəkil, ad, ölkə, ürək ikonu ilə saxlama (favorilərə əlavə). Üstdə "Ventus-dan soruş" (AI-a sərbəst mətnlə sual/istək yazmaq) zolağı — bu, birbaşa AI ilə səyahət yaratma axınına aparır.

**Yer detalı ekranı**: böyük hero şəkil (yuxarı sürüşdükcə kiçilən), sürətli faktlar (valyuta, dil, ən yaxşı fəsil, saat qurşağı), təsviri mətn, "bilməkdə fayda var" məsləhətlər siyahısı, aşağıda sabit "Bu yerə səyahət planla" düyməsi (bu, seçilmiş destinasiya ilə əvvəlcədən doldurulmuş səyahət yaratma axınını açır).

---

### 4.5. Səyahət yaratma axını (Create Trip)

4 addımlı, xətti (bir-birinin ardınca) proses. İstifadəçi geri qayıda bilər, addımlar arasında keçid mümkündür.

**Giriş rejimi seçimi**: İki yol var —
- **Əl ilə**: destinasiya axtarışı (yazdıqca canlı təkliflər), populyar yerlər siyahısı, seçilən yerləri marşrut kimi əlavə etmək (bir neçə dayanacaq əlavə oluna bilər, sıralana bilər, silinə bilər)
- **AI ilə**: sərbəst mətn qutusuna istəyini yaz ("3 günlük Bakı-İstanbul səyahəti, büdcə orta"), süni intellekt bunu təhlil edib marşrutu, tarixləri, həmsəyahətçi tipini avtomatik təxmin edir və formu doldurur

**Addım 1 — Destinasiya**: yuxarıda təsvir olunan axtarış/AI girişi + seçilmiş marşrut kartı (dayanacaqlar siyahısı).

**Addım 2 — Həmsəyahətçilər**: səyahət tipi seçimi (tək, cütlük, ailə, dostlar), böyük/uşaq sayı üçün +/− sayğaclar, email ilə "yoldaş dəvət et" imkanı (dəvətlər səyahət yaradıldıqdan sonra göndərilir).

**Addım 3 — Tarixlər**: tez seçim çipləri (bu həftə sonu, gələn həftə, bir ay sonra, çevik), iki toxunuşlu təqvim aralığı seçimi, seçilmiş aralıq və gecə sayı göstəricisi.

**Addım 4 — Baxış və Təsdiq**: avtomatik yaradılan (redaktə edilə bilən) başlıq, örtük şəkli seçimi (kamera/qalereya), hər bölmə üçün "Düzəlt" linki ilə xülasə (marşrut, həmsəyahətçilər, tarixlər). İki əsas düymə: **"AI ilə plan qur"** (səyahəti yaradır və gündəlik planı avtomatik doldurmağa çalışır) və **"Boş səyahət yarat"** (planı sonra əl ilə doldurmaq üçün).

---

### 4.6. Səyahət mərkəzi (Trip Hub)

Bir səyahətə daxil olduqda gələn əsas ekran — səyahətin "idarəetmə mərkəzi". Tərkibi:
- Örtük şəkli ilə böyük başlıq bölməsi, geri sayım (neçə gün qaldığı), ümumi hazırlıq faiz zolağı
- Modul kartları: **Gündəlik plan, Büdcə, Bağlama siyahısı, Sənədlər, Xəritə, Birgə planlama** — hər biri qısa önizləmə ilə (məs. büdcə kartında xərclənən/qalan məbləğ, bağlama siyahısında tamamlanma faizi)
- Marşrut və həmsəyahətçi xülasəsi kartı
- AI-la əlaqəli təkliflər ("bu günlərin planı hələ boşdur, AI-dan istə" kimi)

Hər modul kartına toxunanda müvafiq tam ekrana keçilir:

**Gündəlik plan (Itinerary)**: gün-gün seçici zolaq + seçilmiş günün xronoloji fəaliyyət siyahısı (uçuş, qalma, yemək, gəzinti, nəqliyyat, ümumi fəaliyyət növləri). Fəaliyyət əlavə etmək/redaktə etmək üçün alt-vərəq (bottom sheet) açılır (başlıq, vaxt, yer, növ). Boş gün üçün "fəaliyyət əlavə et" dəvəti.

**Büdcə (Budget)**: qalan büdcə göstərən böyük hero blok + xərc paylanması zolağı, kateqoriya üzrə bölgü (**qalma, yemək, gəzinti/attraksion, nəqliyyat, digər**), günlərə görə qruplaşdırılmış xərc siyahısı, xərc əlavə etmə/redaktə forması, ümumi büdcə təyin etmə.

**Bağlama siyahısı (Checklist)**: kateqoriyalara bölünmüş (**getməzdən əvvəl, bağlanacaq əşyalar, çatandan sonra**) tapşırıq siyahısı, tamamlanma faiz göstəricisi, hər maddəyə xatırlatma tarixi qoymaq imkanı, əlavə et/redaktə et forması.

**Sənədlər (Documents)**: növə görə filtr çipləri (**hamısı, biletlər, qalma sənədləri, şəxsiyyət sənədləri**), günə və ya növə görə qruplaşdırılmış siyahı, fayl yükləmə axını (mənbə seçimi → növ/gün təyini), sənəd detalı ekranında önizləmə + paylaş/yadda saxla/redaktə/sil əməliyyatları.

**Xəritə (Map)**: marşrutdakı dayanacaqların nömrələnmiş pin-lərlə xəritədə göstərilməsi, aralarında xətt, aşağıda sürüşdürülə bilən dayanacaq siyahısı (xəritə üzərində mərkəzləşdirmək üçün).

**Birgə planlama (Collaborators)**: dəvət linki/kartı, sahib və aktiv iştirakçıların siyahısı, gözləyən dəvətlər bölməsi, hər iştirakçı üçün rol idarəsi (**redaktə edə bilən** — plan, büdcə, sənədlərə dəyişiklik edə bilir; **yalnız baxa bilən** — dəyişiklik edə bilmir).

---

### 4.7. Saxlanılanlar (Saved)

Ürəklənmiş (bəyənilmiş) yerlərin grid görünüşü. Boş olduqda: "hələ saxlanılan yer yoxdur" mesajı + Kəşf-ə keçid dəvəti.

---

### 4.8. Alətlər (Tools)

Dörd sürətli, əksəriyyəti internetsiz işləyən mini-alət, əsas ekranda grid şəklində:

- **Valyuta çevirici**: bir neçə valyuta arasında canlı məzənnə ilə çevirmə, xüsusi rəqəm klaviaturası
- **Hava proqnozu**: cari hava + saatlıq zolaq + 5 günlük proqnoz, şəhər seçici
- **Dünya saatı**: ev vaxtı + istifadəçinin əlavə etdiyi şəhərlərin saatı (fərqlə)
- **Bəxşiş hesablayıcı**: hesab məbləği, faiz seçimi, neçə nəfərə bölüşdürülməsi — tam oflayn

---

### 4.9. Bildirişlər (Notifications)

Xronoloji fəaliyyət lenti ("bu gün" / "əvvəlki günlər" qruplaşdırması). Bildiriş növləri: xoş gəlmisən mesajı, kimsə səni səyahətə dəvət etdi (qəbul et düyməsi ilə), AI planı hazırdır. Bildirişi sola sürüşdürüb silmək, hamısını oxunmuş işarələmək/silmək imkanı, oxunmamış göstəricisi.

---

### 4.10. Profil və Tənzimləmələr

**Profil əsas ekranı**: istifadəçi şəkli/adı, redaktə linki, "səyahət pasportu" statistikası (neçə ölkə, şəhər, səyahət), menyu bölmələri: Tənzimləmələr, Bildiriş seçimləri, Valyuta və Ölçü vahidləri, Birgə iştirakçılar idarəsi, Məxfilik və Təhlükəsizlik, Çıxış.

**Profili redaktə et**: profil şəkli (kamera/qalereya/silmə), ad, (dəyişməz) email.

**Tənzimləmələr**: tema seçimi (sistem/açıq/qaranlıq), dil seçimi (bir neçə dil dəstəklənir).

**Bildiriş seçimləri**: kateqoriyalara görə aç/bağla açarları (səyahət fəaliyyəti, səyahət xatırlatmaları, tətbiq xəbərləri və s.).

**Valyuta və vahidlər**: əsas valyuta seçimi, metrik/imperial ölçü sistemi.

**Məxfilik və Təhlükəsizlik**: PIN dəyişdirmə, şifrə dəyişdirmə, çıxış, hesabı tamamilə silmə (təsdiq dialoqu ilə).

**Şifrə/PIN dəyişdirmə axınları**: mövcud PIN/şifrəni təsdiqləmə → yenisini seçmə → təkrar təsdiqləmə mərhələləri.

**Abunəlik (Pro) ekranı**: illik/aylıq plan kartları, pulsuz vs Pro müqayisə cədvəli (məsələn: məhdud sayda səyahət/AI planı vs limitsiz, oflayn xəritələr, birgə planlama, sənəd anbarı tutumu kimi fərqlər), abunə olma düyməsi.

---

## 5. Məzmun konsepsiyaları (dizaynı formalaşdıracaq detallar)

Bunlar verilənlər bazası deyil — dizaynerin ikonoqrafiya, çip/etiket sistemi və forma dizaynı üçün bilməli olduğu **məzmun kateqoriyalarıdır**:

- **Səyahətçi tipi**: tək, cütlük, ailə, dostlar
- **Fəaliyyət növləri (gündəlik planda)**: uçuş, qalma, yemək, görməli yer, nəqliyyat, ümumi fəaliyyət
- **Xərc kateqoriyaları (büdcədə)**: qalma, yemək, görməli yerlər, nəqliyyat, digər
- **Bağlama siyahısı kateqoriyaları**: getməzdən əvvəl, bağlanacaq əşyalar, çatandan sonra
- **Sənəd növləri**: bilet, qalma sənədi, şəxsiyyət sənədi, digər
- **İştirakçı rolları**: redaktə edə bilən, yalnız baxa bilən

## 6. Xüsusi funksiyalar (dizaynda nəzərə alınmalı)

- **Süni intellekt dəstəyi**: iki yerdə işləyir — (1) sərbəst mətndən avtomatik səyahət qurulması, (2) mövcud səyahət üçün gündəlik planın avtomatik doldurulması. Bu, tətbiqin fərqləndirici xüsusiyyətidir və "sehrli", sürətli hiss etdirilməlidir — yüklənmə vəziyyəti, uğursuzluq halında sadə əl ilə davam etmə seçimi ilə birlikdə dizayn olunmalıdır.
- **Oflayn işləmə**: səyahətlər, büdcə, bağlama siyahısı, sənədlər internetsiz görünməli/redaktə oluna bilməlidir. Bəxşiş hesablayıcı tam oflayndır. Bu, istifadəçiyə hiss etdirilməli deyil (sadəcə həmişə işləməlidir), amma sinxronizasiya vəziyyəti üçün diskret bir gösərici (məs. "yenilənir…") faydalı ola bilər.
- **Çoxdillilik**: tətbiq bir neçə dildə işləyir — mətn uzunluqları dillər arasında dəyişə bilər, dizaynda buna yer buraxılmalıdır.
- **Reklam/sponsorluq**: Ana səhifədə aydın şəkildə "Sponsorlu" işarəli, aqressiv olmayan tövsiyə kartları formasında.
- **Pulsuz/Pro fərqi**: bəzi funksiyalar (limitsiz səyahət/AI planı, oflayn xəritə, geniş sənəd anbarı) Pro istifadəçilər üçün nəzərdə tutulub — bu fərqin dizaynda münasib, təzyiqsiz şəkildə göstərilməsi lazımdır.

## 7. Boş, yüklənmə və xəta vəziyyətləri

Demək olar hər siyahı/məlumat ekranının üç əlavə vəziyyəti nəzərə alınmalıdır: **məlumat hələ yoxdur (boş)** — istiqamətləndirici ikon+mətn+hərəkət düyməsi ilə; **yüklənir**; **xəta/internet yoxdur** — aydın mesaj + təkrar cəhd imkanı. Bu üç vəziyyət bütün tətbiqdə vizual olaraq ardıcıl bir dil daşımalıdır.

---

## 8. Sənəddən necə istifadə etməlisən

1. Əvvəlcə yuxarıdakı hər şeyi oxu və mənə **öz sözlərinlə** tətbiqin nə üçün mövcud olduğunu və kimin üçün nəyi həll etdiyini izah et (mən təsdiq edim ya düzəliş verim).
2. Sonra mənimlə danışaraq, ümumi bir vizual istiqamət (ton, əhval-ruhiyyə, ilham mənbələri) üzərində razılaşaq.
3. Bundan sonra **ardıcıl olaraq** bu sırayla dizayn et, hər addımdan sonra mənim rəyimi al:
   - Onboarding/Qarşılama → Qeydiyyat/Giriş axını (PIN daxil)
   - Əsas naviqasiya konsepsiyası
   - Ana səhifə
   - Kəşf + Yer detalı
   - Səyahət yaratma axını (4 addım)
   - Səyahət mərkəzi + hər alt-modul (gündəlik plan, büdcə, bağlama siyahısı, sənədlər, xəritə, birgə planlama)
   - Saxlanılanlar
   - Alətlər (4 alət)
   - Bildirişlər
   - Profil + bütün alt-ekranlar (tənzimləmələr, məxfilik, Pro/abunəlik)
4. Hazırkı tətbiqin rəng sxemini, tipoqrafiyasını, komponent formasını **təkrarlama** — tamamilə öz təklifini ver. Yalnız yuxarıdakı funksionallığı və istifadəçi məqsədini qoru.
