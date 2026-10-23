// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Azerbaijani (`az`).
class AppLocalizationsAz extends AppLocalizations {
  AppLocalizationsAz([String locale = 'az']) : super(locale);

  @override
  String get appName => 'Ventus';

  @override
  String get welcomeBack => 'Xoş gəldin';

  @override
  String get welcomeToVentus => 'Ventus-a xoş gəldin';

  @override
  String greeting(String name) {
    return 'Salam, $name';
  }

  @override
  String get yourTrips => 'Səyahətlərin';

  @override
  String get seeAll => 'Hamısına bax';

  @override
  String get allTrips => 'Bütün səyahətlər';

  @override
  String get tripsUpcoming => 'Qarşıdan gələn';

  @override
  String get tripsPast => 'Keçmiş';

  @override
  String get allTripsEmptyBody =>
      'Planladığın və keçmiş səyahətlərin burada görünəcək.';

  @override
  String get sharedViaVentus => 'Ventus ilə planlandı ✈️';

  @override
  String get discover => 'Kəşf et';

  @override
  String get sponsored => 'Reklam';

  @override
  String get planWithAi => 'AI ilə planla';

  @override
  String get planWithAiSubtitle => 'Növbəti dəfə hara gedirsən?';

  @override
  String get whereToFirst => 'Əvvəlcə hara?';

  @override
  String get emptyHomeBody =>
      'Planı özün yaz, ya da bir cümlə de — qalanını Ventus etsin.';

  @override
  String get planNewTrip => 'Yeni səyahət';

  @override
  String tripDaysToGo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gün qalıb',
      one: '$count gün qalıb',
    );
    return '$_temp0';
  }

  @override
  String get tripToday => 'Bu gün';

  @override
  String get tripInProgress => 'Davam edir';

  @override
  String percentPlanned(int percent) {
    return '$percent% planlanıb';
  }

  @override
  String get tripStartPlanning => 'Planlamağa başla';

  @override
  String get couldNotLoadTrips => 'Səyahətlərin yüklənmədi.';

  @override
  String get tryAgain => 'Yenidən cəhd et';

  @override
  String get signOutTitle => 'Çıxış edilsin?';

  @override
  String get signOutBody => 'İstədiyin vaxt yenidən daxil ola bilərsən.';

  @override
  String get cancel => 'Ləğv et';

  @override
  String get back => 'Geri';

  @override
  String get setPasswordTitle => 'Parol təyin et';

  @override
  String get setPasswordAction => 'Parolu təyin et';

  @override
  String get setPasswordNote =>
      'Google ilə daxil olmusan, ona görə hesabında hələ parol yoxdur. Parol təyin etsən, e-poçtunla da giriş edə biləcəksən.';

  @override
  String get passwordSet => 'Parol təyin edildi.';

  @override
  String get dismiss => 'Bağla';

  @override
  String get showPassword => 'Parolu göstər';

  @override
  String get hidePassword => 'Parolu gizlət';

  @override
  String get notificationsTitleShort => 'Bildirişlər';

  @override
  String get offlineBanner =>
      'Oflaynsan — dəyişikliklər qayıdanda sinxronlaşacaq.';

  @override
  String get edit => 'Redaktə';

  @override
  String get clear => 'Təmizlə';

  @override
  String get savedAdd => 'Yadda saxla';

  @override
  String get savedRemove => 'Seçilmişlərdən çıxar';

  @override
  String get signOut => 'Çıxış';

  @override
  String get comingSoon => 'Tezliklə';

  @override
  String get somethingWentWrong => 'Nəsə alınmadı. Yenidən cəhd et.';

  @override
  String get navHome => 'Ana səhifə';

  @override
  String get navTrips => 'Səyahətlər';

  @override
  String get navSaved => 'Saxlanılanlar';

  @override
  String get navTools => 'Alətlər';

  @override
  String get navProfile => 'Profil';

  @override
  String get homeTripSoon => 'Səyahət yaxınlaşır';

  @override
  String get homeTripToday => 'Bu gün yola çıxırsan';

  @override
  String get homeTripOngoing => 'Səyahət davam edir';

  @override
  String get homeWhereTo => 'Hara gedirik?';

  @override
  String get homeSearchHint => 'Hara getmək istəyirsən?';

  @override
  String get createSheetTitle => 'Yeni səyahət';

  @override
  String get createSheetSubtitle => 'Necə başlamaq istəyirsən?';

  @override
  String get createAiBadge => 'SÜRƏTLİ';

  @override
  String get createAiBody =>
      '\"Oktyabrda 4 gün Romaya, muzeylər və yemək\" yaz — plan hazır olsun.';

  @override
  String get createManualBody =>
      'İstiqamət, tarixlər və həmsəyahətçiləri özün seç.';

  @override
  String get sheetClose => 'Bağla';

  @override
  String get tripPickerTitle => 'Səyahətlərim';

  @override
  String get addNewTripShort => 'Yeni';

  @override
  String get emptyHomeTitle => 'Növbəti səyahətini planla';

  @override
  String get toolsSubtitle => 'Yolda lazım olanlar · oflayn işləyir';

  @override
  String get toolCurrency => 'Valyuta çeviricisi';

  @override
  String get toolWeather => 'Hava';

  @override
  String get toolWorldClock => 'Saat qurşağı';

  @override
  String get toolTip => 'Bəxşiş kalkulyatoru';

  @override
  String get toolsSectionWeather => 'Hava və saat';

  @override
  String get toolsSectionMoney => 'Pul';

  @override
  String get toolsOffline => 'Yüklənmədi. Bağlantını yoxla.';

  @override
  String get clockHome => 'Ev vaxtı';

  @override
  String clockBehindHome(String hours) {
    return 'Ev vaxtından $hours saat geri';
  }

  @override
  String clockAheadOfHome(String hours) {
    return 'Ev vaxtından $hours saat irəli';
  }

  @override
  String get clockSameAsHome => 'Ev vaxtı ilə eyni';

  @override
  String get clockSameShort => 'Eyni';

  @override
  String get clockYesterday => 'Dünən';

  @override
  String get clockHourShort => 's';

  @override
  String get clockCityRemoved => 'Şəhər silindi';

  @override
  String currencyUpdated(Object date) {
    return 'Yeniləndi $date';
  }

  @override
  String get curUSD => 'ABŞ dolları';

  @override
  String get curEUR => 'Avro';

  @override
  String get curGBP => 'Britaniya funtu';

  @override
  String get curTRY => 'Türk lirəsi';

  @override
  String get curAZN => 'Azərbaycan manatı';

  @override
  String get curAED => 'BƏƏ dirhəmi';

  @override
  String get curGEL => 'Gürcü larisi';

  @override
  String toolsActiveTripBanner(Object trip) {
    return 'Aktiv səyahət: $trip';
  }

  @override
  String toolsCurrencyHint(
    Object fromGlyph,
    Object rate,
    Object toGlyph,
    Object when,
  ) {
    return '1 $fromGlyph = $rate $toGlyph · $when';
  }

  @override
  String get toolsRateToday => 'bu gün';

  @override
  String toolsTimezoneHint(Object hours, Object away) {
    return '$away · $hours saat fərq';
  }

  @override
  String get toolsTimezoneEmptyHint => 'Şəhər əlavə et, fərqi gör';

  @override
  String toolsWeatherHint(Object temp, Object city) {
    return '$temp° · $city';
  }

  @override
  String get currencyAmountLabel => 'Çevirdiyin məbləğ';

  @override
  String get currencyConvertedLabel => 'Çevrilmiş məbləğ';

  @override
  String currencyRateLine(Object from, Object rate, Object to) {
    return '1 $from = $rate $to';
  }

  @override
  String currencyRateSourceMarket(Object date) {
    return 'Bazar kursu · $date';
  }

  @override
  String currencyRateSource(Object date) {
    return 'Mərkəzi Bankın rəsmi kursu · $date';
  }

  @override
  String get quickAmountsLabel => 'Tez məbləğlər';

  @override
  String get addToBudgetAsExpense => 'Büdcəyə xərc kimi əlavə et';

  @override
  String get expenseAdded => 'Səyahət büdcəsinə əlavə olundu.';

  @override
  String get currencyPickerTitle => 'Valyuta seç';

  @override
  String get currencySearchHint => 'Valyuta və ya ölkə axtar';

  @override
  String get currencyAllLabel => 'Bütün valyutalar';

  @override
  String get currencyHomeCurrency => 'Əsas valyuta';

  @override
  String get currencyTripCurrency => 'Aktiv səyahət valyutası';

  @override
  String get timezoneTripTag => 'aktiv səyahət';

  @override
  String get tipOtherPercent => 'Digər';

  @override
  String get tipCustomPercentHint => 'Faiz';

  @override
  String get weatherToday => 'Bu gün';

  @override
  String get weatherNextDays => 'Növbəti 5 gün';

  @override
  String get weatherNow => 'İndi';

  @override
  String get weatherTomorrow => 'Sabah';

  @override
  String get weatherFeelsLike => 'Hiss olunan';

  @override
  String get weatherWind => 'Külək';

  @override
  String get weatherHumidity => 'Rütubət';

  @override
  String get weatherRainChance => 'Yağış ehtimalı';

  @override
  String get weatherSunrise => 'Gün çıxır';

  @override
  String get weatherSunset => 'Gün batır';

  @override
  String weatherWindKmh(String value) {
    return '$value km/s';
  }

  @override
  String weatherWindMph(String value) {
    return '$value mph';
  }

  @override
  String get wxClear => 'Aydın';

  @override
  String get wxPartly => 'Az buludlu';

  @override
  String get wxCloudy => 'Buludlu';

  @override
  String get wxFog => 'Dumanlı';

  @override
  String get wxDrizzle => 'Çiskin';

  @override
  String get wxRain => 'Yağışlı';

  @override
  String get wxSnow => 'Qarlı';

  @override
  String get wxStorm => 'Ildırımlı leysan';

  @override
  String get tipSubtitle => 'Sürətli bəxşiş · oflayn';

  @override
  String get tipTotal => 'Cəmi';

  @override
  String get tipAmount => 'Bəxşiş';

  @override
  String get tipPerPerson => 'Adambaşı';

  @override
  String get tipBillLabel => 'Hesab məbləği';

  @override
  String get tipPercentLabel => 'Bəxşiş';

  @override
  String get tipSplitLabel => 'Neçə nəfər';

  @override
  String tipExampleBill(String glyph) {
    return 'Hesab ${glyph}0 · 0%';
  }

  @override
  String tipPeopleCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nəfər',
      one: '$count nəfər',
    );
    return '$_temp0';
  }

  @override
  String get searchCity => 'Şəhər axtar';

  @override
  String get searchCityHint => 'Şəhər adı yaz…';

  @override
  String get noCitiesFound => 'Şəhər tapılmadı.';

  @override
  String get exploreTitle => 'Kəşf et';

  @override
  String get exploreSubtitle => 'İlham verən yerlər';

  @override
  String get exploreAsk => 'Ventus-dan soruş';

  @override
  String get exploreEmpty => 'Hələ kəşf ediləcək bir şey yoxdur.';

  @override
  String get exploreSearchHint => 'Şəhər və ya ölkə axtar';

  @override
  String exploreNoMatches(Object query) {
    return '\"$query\" üzrə heç nə tapılmadı.';
  }

  @override
  String get exploreCuratedSection => 'Ventus-da';

  @override
  String get exploreOtherPlacesSection => 'Digər yerlər';

  @override
  String get exploreSearching => 'Axtarılır…';

  @override
  String get exploreStartTripHere => 'Buraya səyahət planla';

  @override
  String get savedTitleShort => 'Seçilmişlər';

  @override
  String get planTripHere => 'Buraya səyahət planla';

  @override
  String get factCurrency => 'Valyuta';

  @override
  String get factLanguage => 'Dil';

  @override
  String get factBestTime => 'İdeal vaxt';

  @override
  String get factTimezone => 'Saat qurşağı';

  @override
  String get destGoodToKnow => 'Bilməyə dəyər';

  @override
  String get destAskPlan => 'Ventus-la planla';

  @override
  String get readMore => 'Daha çox';

  @override
  String get readLess => 'Daha az';

  @override
  String get savedEmptyTitle => 'Hələ saxlanan yer yoxdur';

  @override
  String get savedEmptyBody => 'Kəşf et-də bəyəndiyin yerlərə ürək bas.';

  @override
  String get welcomeTagline => 'AI SƏYAHƏT BƏLƏDÇİN';

  @override
  String get welcomeHeadline => 'Hər səyahət,\ngözəl planlanmış.';

  @override
  String get welcomeSubtitle =>
      'Marşrut, büdcə, sənədlər və biletlər — hamısı bir sakit yerdə.';

  @override
  String get getStarted => 'Başlayaq';

  @override
  String get haveAccount => 'Artıq hesabım var';

  @override
  String get signInSubtitle => 'Səyahətinə davam etmək üçün daxil ol.';

  @override
  String get emailLabel => 'E-poçt';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get passwordLabel => 'Parol';

  @override
  String get rememberMe => 'Məni xatırla';

  @override
  String get forgot => 'Unutdun?';

  @override
  String get signInAction => 'Daxil ol';

  @override
  String get orDivider => 'və ya';

  @override
  String get newToVentus => 'Ventus-da yenisən?';

  @override
  String get createAccountAction => 'Hesab yarat';

  @override
  String providerComingSoon(String provider) {
    return '$provider ilə giriş tezliklə.';
  }

  @override
  String get createAccountTitle => 'Hesab yarat';

  @override
  String get createAccountSubtitle =>
      'Ventus-a qoşul və növbəti səyahətini planla.';

  @override
  String get fullNameLabel => 'Ad və soyad';

  @override
  String get fullNameHint => 'Adın və soyadın';

  @override
  String get passwordHintMin => 'Ən azı 8 simvol';

  @override
  String get agreeTerms => 'Şərtlər və Məxfilik Siyasəti ilə razıyam';

  @override
  String get agreeTermsRich => '[terms] və [privacy] ilə razıyam.';

  @override
  String get termsLinkLabel => 'İstifadə Şərtləri';

  @override
  String get privacyLinkLabel => 'Məxfilik Siyasəti';

  @override
  String get acceptTermsError =>
      'Davam etmək üçün Şərtləri və Məxfilik Siyasətini qəbul et.';

  @override
  String get alreadyHaveAccount => 'Artıq hesabın var?';

  @override
  String get resetPasswordTitle => 'Parolu sıfırla';

  @override
  String get forgotTitle => 'Parolunu unutmusan?';

  @override
  String get forgotBody =>
      'Hesabına bağlı e-poçtu yaz, sənə sıfırlama kodu göndərək.';

  @override
  String get sendResetLink => 'Kod göndər';

  @override
  String get resetSent => 'Sıfırlama linki göndərildi. Poçtunu yoxla.';

  @override
  String get rememberedIt => 'Xatırladın?';

  @override
  String get backToSignIn => 'Girişə qayıt';

  @override
  String get verifyEmailTitle => 'E-poçtunu təsdiqlə';

  @override
  String verifyEmailBody(String email) {
    return '$email ünvanına təsdiq linki göndərdik. Hesabını təsdiqləmək üçün linkə toxun, sonra geri qayıdıb daxil ol.';
  }

  @override
  String get verifyEmailSpamNote =>
      'Gəlmədi? Spam qovluğuna bax və ya yenidən göndər.';

  @override
  String get verifyEmailResend => 'Linki yenidən göndər';

  @override
  String get verifyEmailResent =>
      'Təsdiq e-poçtu göndərildi. Gələnlər qutusunu yoxla.';

  @override
  String get verifyEmailSignIn => 'Girişə keç';

  @override
  String get resetCodeTitle => 'Yeni parol təyin et';

  @override
  String resetCodeBody(String email) {
    return '$email ünvanına 6 rəqəmli kod göndərdik. Onu aşağıya yaz və yeni parol seç.';
  }

  @override
  String get resetCodeLabel => 'Bərpa kodu';

  @override
  String get resetCodeHint => '123456';

  @override
  String get resetSubmit => 'Parolu sıfırla';

  @override
  String get resetSuccess => 'Parol yeniləndi. Hər şey hazırdır.';

  @override
  String get resetResend => 'Kodu yenidən göndər';

  @override
  String get resetResent => 'Yeni kod yola düşdü.';

  @override
  String get authInvalidOtp => 'Kod yanlışdır və ya vaxtı keçib.';

  @override
  String get authRateLimited =>
      'Çox sayda cəhd oldu. Bir az sonra yenidən yoxla.';

  @override
  String get legalUpdated => 'Son yeniləmə: İyun 2026';

  @override
  String get legalContact =>
      'Bu şərtlər və ya datan barədə sualın var? Bizimlə əlaqə saxla: support@ventus.app.';

  @override
  String get legalTermsTitle => 'İstifadə Şərtləri';

  @override
  String get legalTermsIntro =>
      'Ventus-a xoş gəldin. Hesab yaradıb tətbiqdən istifadə etməklə bu Şərtləri qəbul edirsən. Razı deyilsənsə, Ventus-dan istifadə etmə.';

  @override
  String get legalTermsS1Title => 'Ventus-dan istifadə';

  @override
  String get legalTermsS1Body =>
      'Ventus səyahətlərini planlamağa və təşkil etməyə kömək edir. Yalnız qanuni, şəxsi məqsədlər üçün istifadə et; xidməti sui-istifadə etmə, kopyalama və ya pozmağa cəhd etmə. AI ilə yaradılan planlar və təkliflər yalnız istiqamətləndirmə üçündür — vaxtları, qiymətləri, vizaları və rezervasiyaları həmişə özün yoxla.';

  @override
  String get legalTermsS2Title => 'Hesabın';

  @override
  String get legalTermsS2Body =>
      'E-poçtunu, parolunu və PIN-ini təhlükəsiz saxlamaq, eləcə də hesabındakı bütün fəaliyyət sənin məsuliyyətindədir. İcazəsiz istifadə görsən, dərhal bizə bildir.';

  @override
  String get legalTermsS3Title => 'Məzmunun';

  @override
  String get legalTermsS3Body =>
      'Əlavə etdiyin səyahətlər, qeydlər, fayllar və digər məzmun səninkidir. Bu məzmunu yalnız tətbiqin funksiyalarını sənə çatdırmaq üçün saxlamaq, sinxronlaşdırmaq və emal etmək məqsədilə Ventus-a icazə verirsən.';

  @override
  String get legalTermsS4Title => 'Xidmət və məsuliyyət';

  @override
  String get legalTermsS4Body =>
      'Ventus “olduğu kimi”, zəmanətsiz təqdim olunur. Funksiyaları əlavə edə, dəyişə və ya silə bilərik; üçüncü tərəf datasından (xəritə, hava, AI) və ya xidmət fasilələrindən yaranan itkilərə görə məsuliyyət daşımırıq.';

  @override
  String get legalPrivacyTitle => 'Məxfilik Siyasəti';

  @override
  String get legalPrivacyIntro =>
      'Bu siyasət Ventus-un hansı məlumatı topladığını, necə istifadə etdiyini və sənin seçimlərini izah edir.';

  @override
  String get legalPrivacyS1Title => 'Nə toplayırıq';

  @override
  String get legalPrivacyS1Body =>
      'Hesab məlumatların (adın və e-poçtun) və yaratdığın səyahət datası — istiqamətlər, gün planları, yoxlama siyahıları, büdcələr, sənədlər və saxlanmış yerlər. PIN-in yalnız cihazında saxlanılır və heç vaxt serverlərimizə göndərilmir.';

  @override
  String get legalPrivacyS2Title => 'Necə istifadə edirik';

  @override
  String get legalPrivacyS2Body =>
      'Hesabını işlətmək, səyahətlərini cihazlar arasında sinxronlaşdırmaq və AI planlama kimi funksiyalar üçün. Plan yaratdığında lazım olan səyahət təfərrüatları onu hazırlamaq üçün AI provayderimizə (Google Gemini) göndərilir. Datanı heç vaxt satmırıq.';

  @override
  String get legalPrivacyS3Title => 'Saxlama və təhlükəsizlik';

  @override
  String get legalPrivacyS3Body =>
      'Datan backend provayderimizdə (Supabase) təhlükəsiz saxlanılır və ötürülmə zamanı şifrələnir. Xəritə, hava və valyuta funksiyaları üçüncü tərəf xidmətlərinə yalnız sorğunu cavablandırmaq üçün lazım olan datanı göndərir.';

  @override
  String get legalPrivacyS4Title => 'Hüquqların';

  @override
  String get legalPrivacyS4Body =>
      'İstənilən vaxt Tənzimləmələrdən profilini görə və redaktə edə, parolunu və ya PIN-ini dəyişə, hesabının və datanın silinməsini tələb edə bilərsən.';

  @override
  String get createPinTitle => 'PIN yarat';

  @override
  String get createPinBody =>
      'Növbəti dəfə tez və təhlükəsiz girmək üçün 4 rəqəmli kod seç.';

  @override
  String get enterPinToUnlock => 'Kilidi açmaq üçün PIN-i yaz';

  @override
  String get usePasswordInstead => 'Parolla daxil ol';

  @override
  String get incorrectPin => 'PIN yanlışdır.';

  @override
  String get errEmailRequired => 'E-poçtunu yaz';

  @override
  String get errEmailInvalid => 'Düzgün e-poçt ünvanı yaz';

  @override
  String get errPasswordRequired => 'Parolunu yaz';

  @override
  String get errPasswordTooShort => 'Ən azı 8 simvol';

  @override
  String get errNameRequired => 'Adını yaz';

  @override
  String get authInvalidCredentials => 'E-poçt və ya parol yanlışdır.';

  @override
  String get authEmailExists => 'Bu e-poçtla artıq hesab var. Daxil ol.';

  @override
  String get authEmailNotConfirmed =>
      'E-poçtunu təsdiqləmək üçün gələnlər qutusunu yoxla, sonra daxil ol.';

  @override
  String get profileEdit => 'Redaktə';

  @override
  String get editProfileTitle => 'Profili redaktə et';

  @override
  String get changePhoto => 'Şəkli dəyiş';

  @override
  String get avatarTakePhoto => 'Şəkil çək';

  @override
  String get avatarChooseLibrary => 'Qalereyadan seç';

  @override
  String get avatarRemove => 'Şəkli sil';

  @override
  String get emailReadonlyNote => 'E-poçt burada dəyişdirilə bilməz.';

  @override
  String get nameRequired => 'Adını yaz';

  @override
  String get profileSaved => 'Profil yeniləndi';

  @override
  String get profileSaveFailed => 'Profil saxlanmadı. Yenidən cəhd et.';

  @override
  String get profileEditUnavailable => 'Profili redaktə etmək üçün daxil ol.';

  @override
  String get measurementSystem => 'Ölçü sistemi';

  @override
  String get unitMetric => 'Metrik';

  @override
  String get unitMetricDesc => 'Kilometr, °C';

  @override
  String get unitImperial => 'İmperial';

  @override
  String get unitImperialDesc => 'Mil, °F';

  @override
  String get collaboratorsTitle => 'Birgə planlayanlar';

  @override
  String get collaboratorsManageSub => 'Birlikdə planlamaq üçün dəvət et';

  @override
  String collabPeopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nəfər',
      one: '1 nəfər',
    );
    return '$_temp0';
  }

  @override
  String get collabPending => 'Gözləyir';

  @override
  String get collabRemoved => 'Siyahıdan çıxarıldı';

  @override
  String get collabAnyoneWithLink => 'Linki olan hər kəs';

  @override
  String get collabCopy => 'Kopyala';

  @override
  String get collabLinkCopied => 'Dəvət linki kopyalandı';

  @override
  String get collabYou => 'Sən';

  @override
  String get roleOwner => 'Sahib';

  @override
  String get roleEditor => 'Redaktor';

  @override
  String get roleViewer => 'İzləyici';

  @override
  String get roleEditorDesc =>
      'Gün planı, büdcə və sənədləri əlavə edib dəyişə bilər';

  @override
  String get roleViewerDesc => 'Səyahəti görə bilər, dəyişiklik edə bilməz';

  @override
  String get collabInviteSent => 'Dəvət göndərildi · gözləyir';

  @override
  String get removeCollaborator => 'Çıxar';

  @override
  String get inviteTitle => 'Səyahətə dəvət et';

  @override
  String get inviteRoleLabel => 'Rol';

  @override
  String get inviteEmailInvalid => 'Düzgün e-poçt ünvanı yaz';

  @override
  String get sendInvite => 'Dəvət göndər';

  @override
  String get collabInviteSentToast => 'Dəvət göndərildi';

  @override
  String get collabPickTrip => 'Səyahət seç';

  @override
  String get collabNoTrips => 'Kimisə dəvət etmək üçün əvvəlcə səyahət yarat.';

  @override
  String get statCountries => 'Ölkə';

  @override
  String get statCities => 'Şəhər';

  @override
  String get statKmFlown => 'km uçuş';

  @override
  String get statTrips => 'Səyahət';

  @override
  String get goVentusPro => 'Ventus Pro-ya keç';

  @override
  String get goVentusProSub => 'Limitsiz səyahət, oflayn xəritələr və daha çox';

  @override
  String get menuCollaborators => 'Birgə planlayanlar';

  @override
  String get menuNotifications => 'Bildirişlər';

  @override
  String get menuSavedPlaces => 'Saxlanan yerlər';

  @override
  String get menuCurrencyUnits => 'Valyuta və vahidlər';

  @override
  String get menuSettings => 'Görünüş və dil';

  @override
  String get menuPrivacySecurity => 'Hesab və təhlükəsizlik';

  @override
  String get profileSectionPreferences => 'Tərcihlər';

  @override
  String get profileSectionAccount => 'Hesab';

  @override
  String get logOut => 'Çıxış';

  @override
  String get settingsTitle => 'Görünüş və dil';

  @override
  String get appearance => 'Görünüş';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'İşıqlı';

  @override
  String get themeDark => 'Qaranlıq';

  @override
  String get language => 'Dil';

  @override
  String get systemDefault => 'Sistem dili';

  @override
  String get whereTo => 'Hara?';

  @override
  String get destinationSubtitle =>
      'Bir və ya bir neçə yer əlavə et — aralarındakı marşrutu Ventus qurar.';

  @override
  String get searchCityCountry => 'Şəhər və ya ölkə axtar';

  @override
  String get popularRightNow => 'İndi populyar';

  @override
  String get addAnotherStop => 'Başqa dayanacaq əlavə et';

  @override
  String get recent => 'Son';

  @override
  String get popularDestinations => 'Populyar istiqamətlər';

  @override
  String placesMatch(int count, String query) {
    return '“$query” üçün $count yer tapıldı';
  }

  @override
  String addPlace(String name) {
    return '“$name” əlavə et';
  }

  @override
  String get continueAction => 'Davam et';

  @override
  String get searchingPlaces => 'Axtarırıq…';

  @override
  String get keepTyping => 'Axtarış üçün ən azı 3 hərf yaz';

  @override
  String get searchPlacesFailed =>
      'Axtarış alınmadı — aşağıdan əl ilə əlavə edə bilərsən.';

  @override
  String get aiTitle => 'Ventus-a səyahətin haqqında danış';

  @override
  String get aiSubtitle =>
      'Səyahətini öz sözlərinlə təsvir et — Ventus detalları tamamlayar.';

  @override
  String get aiPromptHint =>
      'İki nəfər üçün iyunun ortasında İstanbul və Kappadokiyaya 5 günlük yemək və mədəniyyət səyahəti.';

  @override
  String get aiExamplesLabel => 'Sürətli başla';

  @override
  String get aiExampleRomanticLabel => 'Romantik həftəsonu';

  @override
  String get aiExampleRomanticText =>
      'İki nəfər üçün bu həftə sonu yaxınlıqda romantik bir şəhərə qısa səyahət.';

  @override
  String get aiExampleFamilyLabel => 'Ailəvi istirahət';

  @override
  String get aiExampleFamilyText =>
      'Ailəmizlə (2 böyük, 2 uşaq) avqustda dənizkənarı istirahət, 7 gün.';

  @override
  String get aiExampleFriendsLabel => 'Dostlarla macəra';

  @override
  String get aiExampleFriendsText =>
      '4 dostla sentyabrda dağlıq bir yerə 3 günlük gəzinti və təbiət marşrutu.';

  @override
  String get aiExampleSoloLabel => 'Tək səyahət';

  @override
  String get aiExampleSoloText =>
      'Tək başıma, oktyabrda sakit bir şəhərdə 4 günlük mədəniyyət və istirahət səyahəti.';

  @override
  String get aiExampleCityLabel => 'Qısa şəhər turu';

  @override
  String get aiExampleCityText =>
      'Həftəsonu qısa 3 günlük şəhər turu — tarixi yerlər və yerli mətbəx.';

  @override
  String get aiExampleWinterLabel => 'Qış tətili';

  @override
  String get aiExampleWinterText =>
      'Yanvarda qarlı bir dağ kurortunda 5 günlük qış tətili, xizək və isti şokolad.';

  @override
  String get ventusUnderstood => 'Ventus anladı';

  @override
  String get whosComing => 'Kim gəlir?';

  @override
  String get travelersSubtitle =>
      'Bu, Ventus-un sənə uyğun ritm və təkliflər seçməsinə kömək edir.';

  @override
  String get travelerSolo => 'Tək';

  @override
  String get travelerCouple => 'Cüt';

  @override
  String get travelerFamily => 'Ailə';

  @override
  String get travelerFriends => 'Dostlar';

  @override
  String get travelersAdults => 'Böyüklər';

  @override
  String get travelersAdultsSub => '13+ yaş';

  @override
  String get travelersChildren => 'Uşaqlar';

  @override
  String get travelersChildrenSub => '0–12 yaş';

  @override
  String get inviteCompanions => 'Həmsəyahətçiləri dəvət et';

  @override
  String get inviteCompanionsSub => 'İstəyə bağlı · birlikdə planla';

  @override
  String get inviteAdd => 'Əlavə et';

  @override
  String get inviteAfterCreate =>
      'Səyahəti yaratdıqdan sonra dəvət olunacaqlar.';

  @override
  String get when => 'Nə vaxt?';

  @override
  String get datesSubtitle =>
      'Tarixləri seç, ya da çevik qal — bunu sonra dəyişə bilərsən.';

  @override
  String get presetThisWeekend => 'Bu həftə sonu';

  @override
  String get presetNextWeek => 'Gələn həftə';

  @override
  String get presetInAMonth => 'Bir aya';

  @override
  String get presetFlexible => 'Fərqi yoxdur';

  @override
  String get reviewTrip => 'Səyahətə bax';

  @override
  String get selectDates => 'Tarix seç';

  @override
  String nightsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gecə',
      one: '$count gecə',
    );
    return '$_temp0';
  }

  @override
  String get reviewTitle => 'Son baxış';

  @override
  String stopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dayanacaq',
      one: '$count dayanacaq',
    );
    return '$_temp0';
  }

  @override
  String get routeLabel => 'Marşrut';

  @override
  String get travelersLabel => 'Səyahətçilər';

  @override
  String get datesLabel => 'Tarixlər';

  @override
  String get editAction => 'Redaktə';

  @override
  String adultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count böyük',
      one: '$count böyük',
    );
    return '$_temp0';
  }

  @override
  String childrenCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uşaq',
      one: '$count uşaq',
    );
    return '$_temp0';
  }

  @override
  String get buildPlanWithAi => 'Planımı AI qursun';

  @override
  String get createEmptyTrip => 'Özüm quraram';

  @override
  String get reviewFootnote =>
      'Burada rezervasiya edilmir — bilet və sənədləri istənilən vaxt əlavə edə bilərsən.';

  @override
  String get tripCreated => 'Səyahət yaradıldı';

  @override
  String get tripNotFound => 'Səyahət tapılmadı.';

  @override
  String get tripDetailsTitle => 'Səyahət məlumatları';

  @override
  String get tripOverviewTab => 'İcmal';

  @override
  String get moduleItinerary => 'Gün planı';

  @override
  String get moduleBudget => 'Büdcə';

  @override
  String get moduleDocuments => 'Sənədlər';

  @override
  String get moduleChecklist => 'Yoxlama siyahısı';

  @override
  String get moduleChecklistShort => 'Yoxlama';

  @override
  String get moduleMap => 'Xəritə';

  @override
  String get seeOnMap => 'Xəritədə gör';

  @override
  String get mapRouteTitle => 'Marşrut';

  @override
  String get emptyMapTitle => 'Hələ xəritələnəcək bir şey yoxdur';

  @override
  String get emptyMapBody =>
      'Səyahətinə yerlər əlavə et, onlar burada xəritədə görünəcək.';

  @override
  String get emptyMapNoCoords =>
      'Bu səyahətdəki yerlərin koordinatı hələ bilinmir. Onları xəritəyə çıxarmaq üçün aşağıya toxun.';

  @override
  String get mapFilterAll => 'Hamısı';

  @override
  String get mapLocating => 'Yerlər tapılır…';

  @override
  String get mapFindPlaces => 'Yerləri tap';

  @override
  String mapMissingPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yerin xəritədə yeri yoxdur',
      one: '$count yerin xəritədə yeri yoxdur',
    );
    return '$_temp0';
  }

  @override
  String mapPlacesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yer',
      one: '$count yer',
    );
    return '$_temp0';
  }

  @override
  String mapDayDistance(String km) {
    return '~$km km';
  }

  @override
  String get mapDayEmpty => 'Bu günün planında xəritəyə düşən yer yoxdur';

  @override
  String get mapShowInPlan => 'Gün planında göstər';

  @override
  String mapLocated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yer xəritəyə əlavə olundu',
      one: '$count yer xəritəyə əlavə olundu',
    );
    return '$_temp0';
  }

  @override
  String get mapNothingLocated => 'Yeni yer tapılmadı';

  @override
  String get mapLocateFailed => 'Yerləri tapmaq alınmadı. İnternetini yoxla.';

  @override
  String aiHubTitle(String city) {
    return '$city planını Ventus qursun';
  }

  @override
  String get aiHubBody =>
      'Tarixlərinə, ritminə və seçdiyin yerlərə uyğun gün-gün plan — bir neçə saniyəyə hazır olur.';

  @override
  String get aiHubGenerate => 'Planımı yarat';

  @override
  String get aiGenerating => 'Planın hazırlanır…';

  @override
  String get aiPlanReady => 'Planın hazırdır';

  @override
  String get aiNeedsDestination => 'Əvvəlcə istiqamət əlavə et.';

  @override
  String get aiPlanUnavailable => 'AI ilə planlama hələ əlçatan deyil.';

  @override
  String get aiPlanNetworkError =>
      'Planlayıcıya çatmaq olmadı. Bağlantını yoxla və yenidən cəhd et.';

  @override
  String get aiPlanEmpty =>
      'Plan qurmaq alınmadı. Bir az sonra yenidən cəhd et.';

  @override
  String get aiPlanFailed => 'Plan yaradıla bilmədi. Yenidən cəhd et.';

  @override
  String get aiNeedDescription => 'Əvvəlcə səyahətini təsvir et.';

  @override
  String get aiReadingTrip => 'Səyahətin oxunur…';

  @override
  String get aiParseEmpty =>
      'Burada yer tapılmadı. Bir şəhər adı yazmağa cəhd et.';

  @override
  String get aiParseFailed => 'Səyahətini oxumaq alınmadı. Yenidən cəhd et.';

  @override
  String get orStartManually => 'Yaxud əl ilə başla';

  @override
  String get startBuildItinerary => 'Gün planını qur';

  @override
  String get startBuildItinerarySub => 'Günləri və fəaliyyətləri özün əlavə et';

  @override
  String get startUploadDocs => 'Bilet və sənədləri yüklə';

  @override
  String get startUploadDocsSub =>
      'Uçuşlar, otellər, pasportlar — hamısı bir yerdə';

  @override
  String get startChecklist => 'Yoxlama siyahısı yarat';

  @override
  String get startChecklistSub => 'Nə götürəcəyini və hazırlayacağını izlə';

  @override
  String get deleteTripAction => 'Səyahəti sil';

  @override
  String get deleteTripTitle => 'Bu səyahəti silmək?';

  @override
  String get deleteTripBody =>
      'Bu, səyahəti və bütün məlumatlarını silir. Geri qaytarmaq mümkün deyil.';

  @override
  String get deleteConfirm => 'Sil';

  @override
  String get tripDeleted => 'Səyahət silindi';

  @override
  String get dayLabel => 'Gün';

  @override
  String get emptyDayTitle => 'Hələ heç nə planlanmayıb';

  @override
  String get emptyDayBody => 'Bu gün üçün ilk fəaliyyətini əlavə et.';

  @override
  String get addActivity => 'Fəaliyyət əlavə et';

  @override
  String get newActivity => 'Yeni fəaliyyət';

  @override
  String get editActivity => 'Fəaliyyəti redaktə et';

  @override
  String get activityTitleLabel => 'Ad';

  @override
  String get activityTitleHint => 'məs. Bosfor gün batımı gəzintisi';

  @override
  String get activityTitleRequired => 'Qısa başlıq yaz';

  @override
  String get activityPlaceLabel => 'Yer';

  @override
  String get activityPlaceHint => 'məs. Karaköy';

  @override
  String get activityTimeLabel => 'Vaxt';

  @override
  String get activityAddTime => 'Vaxt əlavə et';

  @override
  String get activityMoreDetails => 'Yer və ya vaxt əlavə et';

  @override
  String get activityKindLabel => 'Növ';

  @override
  String get activityDayLabel => 'Gün';

  @override
  String get kindFlight => 'Uçuş';

  @override
  String get kindStay => 'Yaşayış';

  @override
  String get kindFood => 'Yemək';

  @override
  String get kindSight => 'Görməli yer';

  @override
  String get kindTransport => 'Nəqliyyat';

  @override
  String get kindActivity => 'Fəaliyyət';

  @override
  String get save => 'Yadda saxla';

  @override
  String get selectTime => 'Vaxt seç';

  @override
  String get setTime => 'Təsdiq et';

  @override
  String get deleteActivity => 'Fəaliyyəti sil';

  @override
  String get deleteActivityTitle => 'Bu fəaliyyəti silmək?';

  @override
  String get aiAssistTitle => 'Bəzi günlər hələ boşdur';

  @override
  String get aiAssistBody => 'Qoy Ventus onları sənin üçün hazırlasın';

  @override
  String get planAction => 'Planla';

  @override
  String checklistProgress(int done, int total) {
    return '$total-dən $done hazır';
  }

  @override
  String get checklistItemHint => 'məs. Pasport 6+ ay etibarlı';

  @override
  String get renameChecklistItem => 'Adını dəyiş';

  @override
  String get itemDeleted => 'Silindi';

  @override
  String get undo => 'Geri qaytar';

  @override
  String get emptyChecklistTitle => 'Hələ qeyd ediləsi heç nə yoxdur';

  @override
  String get emptyChecklistBody =>
      'Yığmalı və hazırlamalı olduqlarını əlavə et.';

  @override
  String get checklistCatBeforeYouGo => 'Getməzdən əvvəl';

  @override
  String get checklistCatPack => 'Yığ';

  @override
  String get checklistCatOnArrival => 'Çatanda';

  @override
  String get defChkVisa => 'Vizanı yoxla / al';

  @override
  String get defChkInsurance => 'Səyahət sığortası';

  @override
  String get defChkCheckin => 'Onlayn check-in et';

  @override
  String get defChkCash => 'Valyuta dəyiş / nağd pul';

  @override
  String get defChkPassport => 'Pasport';

  @override
  String get defChkTickets => 'Biletlər (uçuş / qatar)';

  @override
  String get defChkId => 'Şəxsiyyət vəsiqəsi';

  @override
  String get defChkCharger => 'Şarj cihazı / adapter';

  @override
  String get defChkSim => 'Yerli SIM / eSIM';

  @override
  String get defChkHotel => 'Otelə check-in';

  @override
  String get defChkTransport => 'Yerli nəqliyyat';

  @override
  String get addItem => 'Maddə əlavə et';

  @override
  String get addToChecklist => 'Siyahıya əlavə et';

  @override
  String get editChecklistItem => 'Redaktə et';

  @override
  String get deleteChecklistItem => 'Sil';

  @override
  String get checklistCategoryLabel => 'Kateqoriya';

  @override
  String get setReminder => 'Xatırlatma qur';

  @override
  String dueBy(String date) {
    return '$date tarixinə kimi';
  }

  @override
  String documentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fayl',
      one: '$count fayl',
    );
    return '$_temp0';
  }

  @override
  String get docPhotoName => 'Şəkil';

  @override
  String get docFileName => 'Fayl';

  @override
  String get docGroupTickets => 'Biletlər';

  @override
  String get docGroupStays => 'Yaşayış';

  @override
  String get docGroupIdentity => 'Şəxsiyyət';

  @override
  String get docGroupOther => 'Digər';

  @override
  String get docGroupTripWide => 'Bütün səyahət';

  @override
  String get docTypeTicket => 'Bilet';

  @override
  String get docTypeStay => 'Yaşayış';

  @override
  String get docTypeId => 'Şəxsiyyət';

  @override
  String get docTypeOther => 'Digər';

  @override
  String get uploadDocument => 'Sənəd yüklə';

  @override
  String get addDocumentTitle => 'Sənəd əlavə et';

  @override
  String get addDocumentBody =>
      'Biletlər, vauçerlər və şəxsiyyət sənədləri bu səyahətə özəl qalır.';

  @override
  String get sourceFiles => 'Fayllar';

  @override
  String get sourceFilesSub => 'PDF, Pages, istənilən fayl';

  @override
  String get sourceCamera => 'Kamera';

  @override
  String get sourceCameraSub => 'Kağız bilet və ya sənədi skan et';

  @override
  String get sourcePhotos => 'Şəkillər';

  @override
  String get sourcePhotosSub => 'Qalereyadan seç';

  @override
  String get saveDocumentTitle => 'Sənədi yadda saxla';

  @override
  String get documentTypeLabel => 'Növ';

  @override
  String get linkToDayLabel => 'Günə bağla (istəyə bağlı)';

  @override
  String get saveToDocuments => 'Sənədlərə əlavə et';

  @override
  String docDayWithDate(int day, String date) {
    return 'Gün $day · $date';
  }

  @override
  String docDayShort(int day) {
    return 'Gün $day';
  }

  @override
  String get editDocumentTitle => 'Sənədi redaktə et';

  @override
  String get documentNameLabel => 'Ad';

  @override
  String get documentNameHint => 'Sənədin adı';

  @override
  String get deleteDocument => 'Sənədi sil';

  @override
  String get deleteDocumentTitle => 'Bu sənəd silinsin?';

  @override
  String get deleteDocumentBody =>
      'Bu, faylı həmişəlik silir. Geri qaytarmaq mümkün deyil.';

  @override
  String get documentDeleted => 'Sənəd silindi';

  @override
  String get docActionShare => 'Paylaş';

  @override
  String get docActionSave => 'Saxla';

  @override
  String get docActionEdit => 'Redaktə';

  @override
  String get docActionDelete => 'Sil';

  @override
  String documentLinkedTo(String day) {
    return 'Bağlıdır: $day';
  }

  @override
  String get openFile => 'Aç';

  @override
  String get previewUnavailable => 'Bu faylı burada göstərə bilmirik.';

  @override
  String get connectToView => 'Bu faylı görmək üçün internetə qoşul.';

  @override
  String get emptyDocumentsTitle => 'Hələ sənəd yoxdur';

  @override
  String get emptyDocumentsBody =>
      'Biletlərini, vauçerlərini və şəxsiyyət sənədlərini yüklə ki, əlin altında olsun.';

  @override
  String get uploadFailed => 'Yüklənmədi — yenidən cəhd et.';

  @override
  String get budgetRemaining => 'Qalıq';

  @override
  String budgetOfTotal(String total) {
    return '$total-dən';
  }

  @override
  String budgetSpentUsed(String spent, int percent) {
    return '$spent xərclənib · büdcənin $percent%-i';
  }

  @override
  String budgetLeftPct(int percent) {
    return '$percent% qalıb';
  }

  @override
  String get budgetByCategory => 'Kateqoriya üzrə';

  @override
  String get budgetExpenses => 'Xərclər';

  @override
  String get addExpense => 'Xərc əlavə et';

  @override
  String get editExpense => 'Xərci redaktə et';

  @override
  String get editBudget => 'Büdcəni redaktə et';

  @override
  String get budgetTotalLabel => 'Ümumi səyahət büdcəsi';

  @override
  String get budgetAllocateByCategory => 'Kateqoriyalara böl';

  @override
  String get budgetAllocated => 'Bölüşdürülüb';

  @override
  String get budgetSave => 'Büdcəni yadda saxla';

  @override
  String get budgetCurrency => 'Valyuta';

  @override
  String get expCatStay => 'Yaşayış';

  @override
  String get expCatFood => 'Yemək';

  @override
  String get expCatSight => 'Görməli yerlər';

  @override
  String get expCatTransport => 'Nəqliyyat';

  @override
  String get expCatOther => 'Digər';

  @override
  String get expenseNoteHint => 'Qeyd əlavə et…';

  @override
  String addAmountTo(String amount, String category) {
    return '$category üçün $amount əlavə et';
  }

  @override
  String get budgetUnassigned => 'Təyin edilməyib';

  @override
  String get deleteExpense => 'Xərci sil';

  @override
  String get deleteExpenseTitle => 'Bu xərc silinsin?';

  @override
  String get expenseDeleted => 'Xərc silindi';

  @override
  String get amountRequired => 'Məbləği yaz';

  @override
  String get emptyExpensesBody => 'Hələ xərc yazılmayıb.';

  @override
  String get setBudgetTitle => 'Səyahət büdcəni təyin et';

  @override
  String get setBudgetBody =>
      'Ümumi məbləği əlavə et, Ventus xərclədikcə qalanı izləsin.';

  @override
  String get setBudget => 'Büdcə təyin et';

  @override
  String get privacySectionAppLock => 'Tətbiq kilidi';

  @override
  String get privacySectionAccount => 'Hesab';

  @override
  String get privacySectionDanger => 'Hesabın silinməsi';

  @override
  String get privacyChangePin => 'PIN-i dəyiş';

  @override
  String get privacyChangePinSub => 'Bu cihaz üçün sürətli kilid PIN-i';

  @override
  String get privacyChangePasswordSub => 'Hesab parolunu yenilə';

  @override
  String get privacyDeleteAccount => 'Hesabı sil';

  @override
  String get privacyDeleteAccountSub =>
      'Hesabını və məlumatlarını həmişəlik sil';

  @override
  String get deleteAccountTitle => 'Hesab silinsin?';

  @override
  String get deleteAccountBody =>
      'Bu, hesabını və bütün səyahətlərini həmişəlik silir. Geri qaytarmaq mümkün deyil.';

  @override
  String get accountDeleted => 'Hesabın silindi';

  @override
  String get changePinTitle => 'PIN-i dəyiş';

  @override
  String get changePinVerifyTitle => 'Cari PIN-i yaz';

  @override
  String get changePinVerifyBody =>
      'Dəyişməzdən əvvəl sənin olduğunu yoxlayaq.';

  @override
  String get changePinNewTitle => 'Yeni PIN seç';

  @override
  String get changePinNewBody => 'Yadda saxlayacağın 4 rəqəmli PIN seç.';

  @override
  String get changePinConfirmTitle => 'Yeni PIN-i təkrarla';

  @override
  String get changePinConfirmBody => 'Təsdiq üçün yeni PIN-i bir də yaz.';

  @override
  String get changePinWrong => 'PIN yanlışdır. Yenidən cəhd et.';

  @override
  String get changePinMismatch => 'PIN-lər uyğun gəlmədi. Yenidən başla.';

  @override
  String get pinChanged => 'PIN yeniləndi';

  @override
  String get pinTooWeak => 'Bu PIN çox asan təxmin edilir. Başqa bir kod seç.';

  @override
  String get pinLockedOut => 'Çox sayda yanlış cəhd. Gözlə:';

  @override
  String get changePasswordTitle => 'Parolu dəyiş';

  @override
  String get changePasswordAction => 'Parolu yenilə';

  @override
  String get currentPasswordLabel => 'Cari parol';

  @override
  String get newPasswordLabel => 'Yeni parol';

  @override
  String get confirmPasswordLabel => 'Yeni parolu təsdiqlə';

  @override
  String get passwordsDontMatch => 'Parollar uyğun gəlmir.';

  @override
  String get currentPasswordIncorrect => 'Cari parol yanlışdır.';

  @override
  String get passwordChanged => 'Parol yeniləndi';

  @override
  String get authWeakPassword =>
      'Parol çox zəifdir. Ən azı 8 simvol istifadə et.';

  @override
  String get authSamePassword => 'Yeni parol cari paroldan fərqli olmalıdır.';

  @override
  String get proTitle => 'Ventus Pro';

  @override
  String get proTagline => 'Limitsiz planla.';

  @override
  String get proBillingYearly => 'İllik';

  @override
  String get proBillingMonthly => 'Aylıq';

  @override
  String get proSave => '30% qənaət';

  @override
  String get proPerYear => '/il';

  @override
  String get proPerMonth => '/ay';

  @override
  String get proYearlyEquiv => '≈ \$3.50/ay';

  @override
  String get proBilledMonthly => 'aylıq ödəniş';

  @override
  String get proColFeature => 'Funksiya';

  @override
  String get proColFree => 'Pulsuz';

  @override
  String get proColPro => 'Pro';

  @override
  String get proRowTrips => 'Aktiv səyahətlər';

  @override
  String get proRowAiPlans => 'AI gün planları';

  @override
  String get proRowOfflineMaps => 'Oflayn xəritələr';

  @override
  String get proRowCollaborators => 'Birgə planlayanlar';

  @override
  String get proRowVault => 'Sənəd seyfi';

  @override
  String get proFreeAiPlansPerMonth => '5/ay';

  @override
  String get proCtaTrial => '7 günlük pulsuz sınağı başlat';

  @override
  String get proComingSoon =>
      'Ventus Pro üzərində işləyirik. Hazır olan kimi xəbər verəcəyik.';

  @override
  String get proThenYearly => 'Sonra \$41.99/il · istənilən vaxt ləğv et';

  @override
  String get proThenMonthly => 'Sonra \$4.99/ay · istənilən vaxt ləğv et';

  @override
  String get notificationsTitle => 'Bildirişlər';

  @override
  String get notifToday => 'Bu gün';

  @override
  String get notifEarlier => 'Daha əvvəl';

  @override
  String get notifMarkRead => 'Hamısını oxunmuş işarələ';

  @override
  String get notifEmptyTitle => 'Hələ bildiriş yoxdur';

  @override
  String get notifEmptyBody =>
      'Səyahət fəaliyyəti və AI yenilikləri burada görünəcək.';

  @override
  String notifNewCount(int count) {
    return '$count yeni';
  }

  @override
  String notifCollabInvitedTitle(String email) {
    return '$email dəvət olundu';
  }

  @override
  String notifCollabInvitedBody(String trip) {
    return 'Səyahət: $trip. Dəvət göndərildi.';
  }

  @override
  String get notifCollabInvitedBodyShort => 'Dəvət göndərildi.';

  @override
  String get notifAiReadyTitle => 'AI gün planın hazırdır';

  @override
  String notifAiReadyBody(String trip) {
    return 'Səyahət: $trip';
  }

  @override
  String get notifAccepted => 'Qəbul edildi';

  @override
  String get notifAcceptInvite => 'Qəbul et';

  @override
  String get notifGenericTitle => 'Yenilik';

  @override
  String get notifWelcomeTitle => 'Ventus-a xoş gəldin 👋';

  @override
  String get notifWelcomeBody =>
      'Hesabın hazırdır. İlk səyahətini planla, qalanını Ventus-a burax.';

  @override
  String get timeJustNow => 'İndicə';

  @override
  String timeMinutesAgo(int count) {
    return '$count dəq əvvəl';
  }

  @override
  String timeHoursAgo(int count) {
    return '$count saat əvvəl';
  }

  @override
  String get timeYesterday => 'Dünən';

  @override
  String timeDaysAgo(int count) {
    return '$count gün əvvəl';
  }

  @override
  String get changeCoverPhoto => 'Səyahət şəklini dəyiş';

  @override
  String get coverUpdated => 'Şəkil yeniləndi';

  @override
  String get coverRemove => 'Səyahət şəklini sil';

  @override
  String get notifDeleteAll => 'Hamısını sil';

  @override
  String get notifConfirmMarkAllReadTitle => 'Hamısı oxunmuş işarələnsin?';

  @override
  String get notifConfirmMarkAllReadBody =>
      'Bütün bildirişlər oxunmuş kimi işarələnəcək.';

  @override
  String get notifConfirmDeleteAllTitle => 'Bütün bildirişlər silinsin?';

  @override
  String get notifConfirmDeleteAllBody =>
      'Bu, bütün bildirişlərini həmişəlik silir. Geri qaytarmaq mümkün deyil.';

  @override
  String get notifMarkReadConfirm => 'Oxunmuş işarələ';

  @override
  String get notifDeleteAllConfirm => 'Hamısını sil';

  @override
  String get tripStatDaysLeft => 'gün qalıb';

  @override
  String get tripStatPlanned => 'planlanıb';

  @override
  String greetingMorning(String name) {
    return 'Sabahın xeyir, $name';
  }

  @override
  String greetingAfternoon(String name) {
    return 'Günortan xeyir, $name';
  }

  @override
  String greetingEvening(String name) {
    return 'Axşamın xeyir, $name';
  }

  @override
  String get nextStepEyebrow => 'Növbəti addım';

  @override
  String get nextStepPlanTitle => 'Gündəlik planı qur';

  @override
  String get nextStepPlanBody =>
      'İlk fəaliyyəti əlavə et, qalanı asan gələcək.';

  @override
  String get nextStepChecklistTitle => 'Yoxlama siyahısı yarat';

  @override
  String get nextStepChecklistBody => 'Çıxmazdan əvvəl nələri unutmamalısan?';

  @override
  String get nextStepBudgetTitle => 'Büdcəni təyin et';

  @override
  String get nextStepBudgetBody => 'Xərclərini baş verdikcə izlə.';

  @override
  String get nextStepDocsTitle => 'Sənədlərini əlavə et';

  @override
  String get nextStepDocsBody => 'Bilet və rezervasiyalar bir yerdə dursun.';

  @override
  String get planCompleteTitle => 'Plan hazırdır';

  @override
  String get planCompleteBody => 'Hər gün planlanıb. Yaxşı yol!';

  @override
  String get tripDeleteOwnerOnly => 'Səyahəti yalnız sahibi silə bilər.';

  @override
  String get collabTripOwner => 'Səyahət sahibi';

  @override
  String get overviewReadiness => 'Hazırlıq';

  @override
  String get overviewNextUp => 'Növbəti fəaliyyət';

  @override
  String readinessDaysPlanned(int planned, int total) {
    return '$planned/$total gün planlanıb';
  }

  @override
  String readinessActivities(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fəaliyyət',
      one: '$count fəaliyyət',
    );
    return '$_temp0';
  }

  @override
  String get readinessBudgetNotSet => 'Təyin edilməyib';

  @override
  String get readinessNoDocs => 'Heç nə yüklənməyib';

  @override
  String get readinessEmpty => 'Hələ boşdur';

  @override
  String get openInMaps => 'Xəritədə aç';

  @override
  String get taxiSection => 'Taksi';

  @override
  String datesPickStartOnly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gecə',
      one: '$count gecə',
    );
    return '$_temp0 yazmısan, sadəcə yola çıxacağın günü seç.';
  }

  @override
  String get checklistAllDone => 'Hər şey hazırdır. Yaxşı yol!';

  @override
  String get profileSectionSupport => 'Dəstək';

  @override
  String get menuAbout => 'Haqqında';

  @override
  String get menuHelp => 'Yardım';

  @override
  String get menuContact => 'Bizimlə əlaqə';

  @override
  String get aboutTagline => 'Səyahətini bir yerdə planla, saxla və izlə.';

  @override
  String get aboutLegalSection => 'Hüquqi';

  @override
  String get contactMailSubject => 'Ventus dəstək';

  @override
  String contactMailBody(String version, String device) {
    return 'Salam, sualım/probleməm:\n\n\n— Tətbiq: $version\n— Cihaz: $device';
  }

  @override
  String get contactMailFailed =>
      'Mail tətbiqi açılmadı. Bizə bu ünvana yaz: support@ventus.app';

  @override
  String get helpQ1 => 'Səyahəti necə yaradım?';

  @override
  String get helpA1 =>
      'Əsas ekranda mərkəzdəki + düyməsinə bas, yeri və tarixi seç. İstəsən, “AI ilə planla” seçib səyahətini mətnlə də yaza bilərsən — yeri, tarixi və neçə nəfər olduğunu özü tapacaq.';

  @override
  String get helpQ2 => 'AI plan necə işləyir?';

  @override
  String get helpA2 =>
      'Səyahətin səhifəsində “Planımı yarat” düyməsinə bas, Ventus gün-gün plan təklif edəcək. Bunlar istiqamətləndirmə üçündür — vaxtları, qiymətləri və rezervasiyaları həmişə özün yoxla.';

  @override
  String get helpQ3 => 'İnternet olmadan işləyir?';

  @override
  String get helpA3 =>
      'Səyahətlərin, gün planın, yoxlama siyahın və büdcən cihazında saxlanılır, internet olmayanda da açılır. Qayıdanda özü sinxronlaşır. AI, xəritə, hava və valyuta isə internet tələb edir.';

  @override
  String get helpQ4 => 'Sənədlərim harada saxlanılır?';

  @override
  String get helpA4 =>
      'Biletlərin və digər sənədlərin şəxsi, yalnız sənə açıq yerdə təhlükəsiz saxlanılır. Özün paylaşmasan, heç kim görmür.';

  @override
  String get helpQ5 => 'Yeri xəritədə necə açım?';

  @override
  String get helpA5 =>
      'Gün planında fəaliyyət kartının sağındakı kompas ikonuna bas. Telefonundakı xəritə və taksi tətbiqləri çıxacaq, birini seç.';

  @override
  String get helpQ6 => 'Hesabımı necə silim?';

  @override
  String get helpA6 =>
      'Profil → Məxfilik və təhlükəsizlik → Hesabı sil. Bu, hesabını və bütün səyahətlərini həmişəlik silir, geri qaytarmaq mümkün deyil.';
}
