// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'Ventus';

  @override
  String get welcomeBack => 'Tekrar hoş geldin';

  @override
  String get welcomeToVentus => 'Ventus\'a hoş geldin';

  @override
  String greeting(String name) {
    return 'Merhaba, $name';
  }

  @override
  String get yourTrips => 'Gezilerin';

  @override
  String get seeAll => 'Tümünü gör';

  @override
  String get allTrips => 'Tüm geziler';

  @override
  String get tripsUpcoming => 'Yaklaşan';

  @override
  String get tripsPast => 'Geçmiş';

  @override
  String get allTripsEmptyBody =>
      'Planladığın ve geçmiş gezilerin burada görünecek.';

  @override
  String get sharedViaVentus => 'Ventus ile planlandı ✈️';

  @override
  String get discover => 'Keşfet';

  @override
  String get sponsored => 'Sponsorlu';

  @override
  String get planWithAi => 'AI ile planla';

  @override
  String get planWithAiSubtitle => 'Sıradaki gezin nereye?';

  @override
  String get whereToFirst => 'Önce nereye?';

  @override
  String get emptyHomeBody =>
      'Planı kendin yaz ya da bir cümle söyle — gerisini Ventus halletsin.';

  @override
  String get planNewTrip => 'Yeni gezi';

  @override
  String tripDaysToGo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gün kaldı',
      one: '$count gün kaldı',
    );
    return '$_temp0';
  }

  @override
  String get tripToday => 'Bugün';

  @override
  String get tripInProgress => 'Devam ediyor';

  @override
  String percentPlanned(int percent) {
    return '%$percent planlandı';
  }

  @override
  String get tripStartPlanning => 'Planlamaya başla';

  @override
  String get couldNotLoadTrips => 'Gezilerin yüklenemedi.';

  @override
  String get tryAgain => 'Tekrar dene';

  @override
  String get signOutTitle => 'Çıkış yapılsın mı?';

  @override
  String get signOutBody => 'İstediğin zaman tekrar giriş yapabilirsin.';

  @override
  String get cancel => 'İptal';

  @override
  String get back => 'Geri';

  @override
  String get setPasswordTitle => 'Şifre belirle';

  @override
  String get setPasswordAction => 'Şifreyi belirle';

  @override
  String get setPasswordNote =>
      'Google ile giriş yaptın, bu yüzden hesabında henüz şifre yok. Bir şifre belirlersen e-postanla da giriş yapabilirsin.';

  @override
  String get passwordSet => 'Şifre belirlendi.';

  @override
  String get dismiss => 'Kapat';

  @override
  String get showPassword => 'Şifreyi göster';

  @override
  String get hidePassword => 'Şifreyi gizle';

  @override
  String get notificationsTitleShort => 'Bildirimler';

  @override
  String get offlineBanner =>
      'Çevrimdışısın — değişiklikler döndüğünde eşitlenecek.';

  @override
  String get edit => 'Düzenle';

  @override
  String get clear => 'Temizle';

  @override
  String get savedAdd => 'Kaydet';

  @override
  String get savedRemove => 'Kaydedilenlerden çıkar';

  @override
  String get signOut => 'Çıkış yap';

  @override
  String get comingSoon => 'Yakında';

  @override
  String get somethingWentWrong => 'Bir şeyler ters gitti. Tekrar dene.';

  @override
  String get navHome => 'Ana Sayfa';

  @override
  String get navTrips => 'Geziler';

  @override
  String get navSaved => 'Kaydedilen';

  @override
  String get navTools => 'Araçlar';

  @override
  String get navProfile => 'Profil';

  @override
  String get homeTripSoon => 'Gezin yaklaşıyor';

  @override
  String get homeTripToday => 'Bugün yola çıkıyorsun';

  @override
  String get homeTripOngoing => 'Gezin devam ediyor';

  @override
  String get homeWhereTo => 'Nereye gidiyoruz?';

  @override
  String get homeSearchHint => 'Şehir, ülke veya yer';

  @override
  String get createSheetTitle => 'Yeni gezi';

  @override
  String get createSheetSubtitle => 'Nasıl başlamak istersin?';

  @override
  String get createAiBadge => 'HIZLI';

  @override
  String get createAiBody =>
      '\"Ekimde Roma\'ya 4 gün, müzeler ve yemek\" yaz — plan hazır olsun.';

  @override
  String get createManualBody =>
      'Rotayı, tarihleri ve yol arkadaşlarını kendin seç.';

  @override
  String get sheetClose => 'Kapat';

  @override
  String get tripPickerTitle => 'Gezilerim';

  @override
  String get addNewTripShort => 'Yeni';

  @override
  String get emptyHomeTitle => 'Sıradaki gezini planla';

  @override
  String get toolsSubtitle => 'Yolda pratik · çevrimdışı çalışır';

  @override
  String get toolCurrency => 'Döviz çevirici';

  @override
  String get toolWeather => 'Hava';

  @override
  String get toolWorldClock => 'Saat dilimi';

  @override
  String get toolTip => 'Bahşiş hesaplayıcı';

  @override
  String get toolsSectionWeather => 'Hava ve saat';

  @override
  String get toolsSectionMoney => 'Para';

  @override
  String get toolsOffline => 'Yüklenemedi. Bağlantını kontrol et.';

  @override
  String get clockHome => 'Ev saati';

  @override
  String clockBehindHome(String hours) {
    return 'Ev saatinden $hours saat geri';
  }

  @override
  String clockAheadOfHome(String hours) {
    return 'Ev saatinden $hours saat ileri';
  }

  @override
  String get clockSameAsHome => 'Ev saatiyle aynı';

  @override
  String get clockSameShort => 'Aynı';

  @override
  String get clockYesterday => 'Dün';

  @override
  String get clockHourShort => 's';

  @override
  String get clockCityRemoved => 'Şehir kaldırıldı';

  @override
  String currencyUpdated(Object date) {
    return 'Güncellendi $date';
  }

  @override
  String get curUSD => 'ABD doları';

  @override
  String get curEUR => 'Euro';

  @override
  String get curGBP => 'İngiliz sterlini';

  @override
  String get curTRY => 'Türk lirası';

  @override
  String get curAZN => 'Azerbaycan manatı';

  @override
  String get curAED => 'BAE dirhemi';

  @override
  String get curGEL => 'Gürcistan larisi';

  @override
  String toolsActiveTripBanner(Object trip) {
    return 'Aktif gezi: $trip';
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
  String get toolsRateToday => 'bugün';

  @override
  String toolsTimezoneHint(Object hours, Object away) {
    return '$away · $hours saat fark';
  }

  @override
  String get toolsTimezoneEmptyHint => 'Şehir ekle, farkı gör';

  @override
  String toolsWeatherHint(Object temp, Object city) {
    return '$temp° · $city';
  }

  @override
  String get currencyAmountLabel => 'Çevirdiğin tutar';

  @override
  String get currencyConvertedLabel => 'Çevrilen tutar';

  @override
  String currencyRateLine(Object from, Object rate, Object to) {
    return '1 $from = $rate $to';
  }

  @override
  String currencyRateSourceMarket(Object date) {
    return 'Piyasa kuru · $date';
  }

  @override
  String currencyRateSource(Object date) {
    return 'Azerbaycan Merkez Bankası resmi kuru · $date';
  }

  @override
  String get quickAmountsLabel => 'Hızlı tutarlar';

  @override
  String get addToBudgetAsExpense => 'Bütçeye gider olarak ekle';

  @override
  String get expenseAdded => 'Gezi bütçesine eklendi.';

  @override
  String get currencyPickerTitle => 'Para birimi seç';

  @override
  String get currencySearchHint => 'Para birimi veya ülke ara';

  @override
  String get currencyAllLabel => 'Tüm para birimleri';

  @override
  String get currencyHomeCurrency => 'Ana para birimi';

  @override
  String get currencyTripCurrency => 'Aktif gezi para birimi';

  @override
  String get timezoneTripTag => 'aktif gezi';

  @override
  String get tipOtherPercent => 'Diğer';

  @override
  String get tipCustomPercentHint => 'Yüzde';

  @override
  String get weatherToday => 'Bugün';

  @override
  String get weatherNextDays => 'Sonraki 5 gün';

  @override
  String get weatherNow => 'Şimdi';

  @override
  String get weatherTomorrow => 'Yarın';

  @override
  String get weatherFeelsLike => 'Hissedilen';

  @override
  String get weatherWind => 'Rüzgar';

  @override
  String get weatherHumidity => 'Nem';

  @override
  String get weatherRainChance => 'Yağış ihtimali';

  @override
  String get weatherSunrise => 'Gün doğumu';

  @override
  String get weatherSunset => 'Gün batımı';

  @override
  String weatherWindKmh(String value) {
    return '$value km/sa';
  }

  @override
  String weatherWindMph(String value) {
    return '$value mph';
  }

  @override
  String get wxClear => 'Açık';

  @override
  String get wxPartly => 'Parçalı bulutlu';

  @override
  String get wxCloudy => 'Bulutlu';

  @override
  String get wxFog => 'Sisli';

  @override
  String get wxDrizzle => 'Çisenti';

  @override
  String get wxRain => 'Yağmurlu';

  @override
  String get wxSnow => 'Karlı';

  @override
  String get wxStorm => 'Gök gürültülü fırtına';

  @override
  String get tipSubtitle => 'Hızlı bahşiş · çevrimdışı';

  @override
  String get tipTotal => 'Toplam';

  @override
  String get tipAmount => 'Bahşiş';

  @override
  String get tipPerPerson => 'Kişi başı';

  @override
  String get tipBillLabel => 'Hesap tutarı';

  @override
  String get tipPercentLabel => 'Bahşiş';

  @override
  String get tipSplitLabel => 'Kaç kişi';

  @override
  String tipExampleBill(String glyph) {
    return 'Hesap ${glyph}0 · 0%';
  }

  @override
  String tipPeopleCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kişi',
      one: '$count kişi',
    );
    return '$_temp0';
  }

  @override
  String get searchCity => 'Şehir ara';

  @override
  String get searchCityHint => 'Şehir adı yaz…';

  @override
  String get noCitiesFound => 'Şehir bulunamadı.';

  @override
  String get exploreTitle => 'Keşfet';

  @override
  String get exploreSubtitle => 'İlham veren yerler';

  @override
  String get exploreAsk => 'Ventus\'a sor';

  @override
  String get exploreEmpty => 'Henüz keşfedilecek bir şey yok.';

  @override
  String get exploreSearchHint => 'Şehir veya ülke ara';

  @override
  String exploreNoMatches(Object query) {
    return '\"$query\" için sonuç bulunamadı.';
  }

  @override
  String get exploreCuratedSection => 'Ventus\'ta';

  @override
  String get exploreOtherPlacesSection => 'Diğer yerler';

  @override
  String get exploreSearching => 'Aranıyor…';

  @override
  String get exploreStartTripHere => 'Buraya gezi planla';

  @override
  String get savedTitleShort => 'Kaydedilenler';

  @override
  String get planTripHere => 'Buraya gezi planla';

  @override
  String get factCurrency => 'Para birimi';

  @override
  String get factLanguage => 'Dil';

  @override
  String get factBestTime => 'En iyi zaman';

  @override
  String get factTimezone => 'Saat dilimi';

  @override
  String get destGoodToKnow => 'Bilmekte fayda var';

  @override
  String get destAskPlan => 'Ventus ile planla';

  @override
  String get readMore => 'Devamı';

  @override
  String get readLess => 'Daha az';

  @override
  String get savedEmptyTitle => 'Henüz kayıtlı yer yok';

  @override
  String get savedEmptyBody => 'Keşfet\'te beğendiğin yerlere kalp bas.';

  @override
  String get welcomeTagline => 'AI SEYAHAT ARKADAŞIN';

  @override
  String get welcomeHeadline => 'Her yolculuk,\nözenle planlanmış.';

  @override
  String get welcomeSubtitle =>
      'Rota, bütçe, belgeler ve biletler — hepsi tek bir sakin yerde.';

  @override
  String get getStarted => 'Başla';

  @override
  String get haveAccount => 'Zaten hesabım var';

  @override
  String get signInSubtitle => 'Yolculuğuna devam etmek için giriş yap.';

  @override
  String get emailLabel => 'E-posta';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get passwordLabel => 'Şifre';

  @override
  String get rememberMe => 'Beni hatırla';

  @override
  String get forgot => 'Unuttun mu?';

  @override
  String get signInAction => 'Giriş yap';

  @override
  String get orDivider => 'veya';

  @override
  String get newToVentus => 'Ventus\'ta yeni misin?';

  @override
  String get createAccountAction => 'Hesap oluştur';

  @override
  String providerComingSoon(String provider) {
    return '$provider ile giriş yakında.';
  }

  @override
  String get createAccountTitle => 'Hesap oluştur';

  @override
  String get createAccountSubtitle =>
      'Ventus\'a katıl ve sıradaki gezini planla.';

  @override
  String get fullNameLabel => 'Ad soyad';

  @override
  String get fullNameHint => 'Adın ve soyadın';

  @override
  String get passwordHintMin => 'En az 8 karakter';

  @override
  String get agreeTerms => 'Şartları ve Gizlilik Politikasını kabul ediyorum';

  @override
  String get agreeTermsRich => '[terms] ve [privacy] kabul ediyorum.';

  @override
  String get termsLinkLabel => 'Kullanım Şartları';

  @override
  String get privacyLinkLabel => 'Gizlilik Politikası';

  @override
  String get acceptTermsError =>
      'Devam etmek için Şartları ve Gizlilik Politikasını kabul et.';

  @override
  String get alreadyHaveAccount => 'Zaten hesabın var mı?';

  @override
  String get resetPasswordTitle => 'Şifreyi sıfırla';

  @override
  String get forgotTitle => 'Şifreni mi unuttun?';

  @override
  String get forgotBody =>
      'Hesabına bağlı e-postayı yaz, sana sıfırlama bağlantısı gönderelim.';

  @override
  String get sendResetLink => 'Sıfırlama bağlantısı gönder';

  @override
  String get resetSent =>
      'Sıfırlama bağlantısı gönderildi. Gelen kutunu kontrol et.';

  @override
  String get rememberedIt => 'Hatırladın mı?';

  @override
  String get backToSignIn => 'Girişe dön';

  @override
  String get verifyEmailTitle => 'E-postanı doğrula';

  @override
  String verifyEmailBody(String email) {
    return '$email adresine bir doğrulama bağlantısı gönderdik. Hesabını doğrulamak için bağlantıya dokun, sonra geri dönüp giriş yap.';
  }

  @override
  String get verifyEmailSpamNote =>
      'Gelmedi mi? Spam klasörüne bak veya yeniden gönder.';

  @override
  String get verifyEmailResend => 'E-postayı yeniden gönder';

  @override
  String get verifyEmailResent =>
      'Doğrulama e-postası gönderildi. Gelen kutunu kontrol et.';

  @override
  String get verifyEmailSignIn => 'Girişe git';

  @override
  String get resetCodeTitle => 'Yeni bir şifre belirle';

  @override
  String resetCodeBody(String email) {
    return '$email adresine 6 haneli bir kod gönderdik. Aşağıya yaz ve yeni bir şifre seç.';
  }

  @override
  String get resetCodeLabel => 'Sıfırlama kodu';

  @override
  String get resetCodeHint => '123456';

  @override
  String get resetSubmit => 'Şifreyi sıfırla';

  @override
  String get resetSuccess => 'Şifre güncellendi. Her şey hazır.';

  @override
  String get resetResend => 'Kodu yeniden gönder';

  @override
  String get resetResent => 'Yeni bir kod yolda.';

  @override
  String get authInvalidOtp => 'Bu kod yanlış veya süresi dolmuş.';

  @override
  String get authRateLimited =>
      'Çok fazla deneme yapıldı. Birkaç dakika sonra tekrar dene.';

  @override
  String get legalUpdated => 'Son güncelleme: Haziran 2026';

  @override
  String get legalContact =>
      'Bu şartlar veya verilerin hakkında soruların mı var? Bize ulaş: support@ventus.app.';

  @override
  String get legalTermsTitle => 'Kullanım Şartları';

  @override
  String get legalTermsIntro =>
      'Ventus\'a hoş geldin. Bir hesap oluşturup uygulamayı kullanarak bu Şartları kabul edersin. Kabul etmiyorsan lütfen Ventus\'u kullanma.';

  @override
  String get legalTermsS1Title => 'Ventus\'u kullanmak';

  @override
  String get legalTermsS1Body =>
      'Ventus gezilerini planlamana ve düzenlemene yardımcı olur. Yalnızca yasal, kişisel amaçlarla kullan; hizmeti kötüye kullanma, kopyalama veya bozmaya çalışma. AI tarafından oluşturulan planlar ve öneriler yalnızca yol gösterme amaçlıdır — saatleri, fiyatları, vizeleri ve rezervasyonları her zaman kendin doğrula.';

  @override
  String get legalTermsS2Title => 'Hesabın';

  @override
  String get legalTermsS2Body =>
      'E-postanı, şifreni ve PIN\'ini güvende tutmak ve hesabındaki tüm etkinlik senin sorumluluğundadır. Yetkisiz bir kullanım fark edersen hemen bize bildir.';

  @override
  String get legalTermsS3Title => 'İçeriğin';

  @override
  String get legalTermsS3Body =>
      'Eklediğin geziler, notlar, dosyalar ve diğer içerik senindir. Bu içeriği yalnızca uygulamanın özelliklerini sana sunmak amacıyla saklamak, eşitlemek ve işlemek için Ventus\'a izin verirsin.';

  @override
  String get legalTermsS4Title => 'Hizmet ve sorumluluk';

  @override
  String get legalTermsS4Body =>
      'Ventus “olduğu gibi”, garantisiz sunulur. Özellikleri ekleyebilir, değiştirebilir veya kaldırabiliriz; üçüncü taraf verilerinden (harita, hava, AI) veya hizmet kesintilerinden doğan kayıplardan sorumlu değiliz.';

  @override
  String get legalPrivacyTitle => 'Gizlilik Politikası';

  @override
  String get legalPrivacyIntro =>
      'Bu politika, Ventus\'un hangi bilgileri topladığını, nasıl kullandığını ve sahip olduğun seçimleri açıklar.';

  @override
  String get legalPrivacyS1Title => 'Neleri topluyoruz';

  @override
  String get legalPrivacyS1Body =>
      'Hesap bilgilerin (adın ve e-postan) ve oluşturduğun gezi verileri — varış noktaları, gün planları, kontrol listeleri, bütçeler, belgeler ve kaydedilen yerler. PIN\'in yalnızca cihazında saklanır ve sunucularımıza asla gönderilmez.';

  @override
  String get legalPrivacyS2Title => 'Nasıl kullanıyoruz';

  @override
  String get legalPrivacyS2Body =>
      'Hesabını çalıştırmak, gezilerini cihazlar arasında eşitlemek ve AI planlama gibi özellikleri sağlamak için. Bir plan oluşturduğunda, gereken gezi ayrıntıları onu hazırlamak için AI sağlayıcımıza (Google Gemini) gönderilir. Verilerini asla satmayız.';

  @override
  String get legalPrivacyS3Title => 'Saklama ve güvenlik';

  @override
  String get legalPrivacyS3Body =>
      'Verilerin backend sağlayıcımızda (Supabase) güvenle saklanır ve aktarım sırasında şifrelenir. Harita, hava ve döviz özellikleri üçüncü taraf hizmetlerine yalnızca isteğini yanıtlamak için gereken veriyi gönderir.';

  @override
  String get legalPrivacyS4Title => 'Hakların';

  @override
  String get legalPrivacyS4Body =>
      'İstediğin zaman Ayarlar\'dan profilini görüntüleyip düzenleyebilir, şifreni veya PIN\'ini değiştirebilir, hesabının ve verilerinin silinmesini talep edebilirsin.';

  @override
  String get createPinTitle => 'PIN oluştur';

  @override
  String get createPinBody =>
      'Bir sonraki sefer hızlı ve güvenli girmek için 4 haneli bir kod seç.';

  @override
  String get enterPinToUnlock => 'Kilidi açmak için PIN\'ini yaz';

  @override
  String get usePasswordInstead => 'Şifreyle giriş yap';

  @override
  String get incorrectPin => 'PIN yanlış.';

  @override
  String get errEmailRequired => 'E-postanı yaz';

  @override
  String get errEmailInvalid => 'Geçerli bir e-posta yaz';

  @override
  String get errPasswordRequired => 'Şifreni yaz';

  @override
  String get errPasswordTooShort => 'En az 8 karakter';

  @override
  String get errNameRequired => 'Adını yaz';

  @override
  String get authInvalidCredentials => 'E-posta veya şifre yanlış.';

  @override
  String get authEmailExists =>
      'Bu e-posta ile zaten bir hesap var. Giriş yap.';

  @override
  String get authEmailNotConfirmed =>
      'E-postanı onaylamak için gelen kutunu kontrol et, sonra giriş yap.';

  @override
  String get profileEdit => 'Düzenle';

  @override
  String get editProfileTitle => 'Profili düzenle';

  @override
  String get changePhoto => 'Fotoğrafı değiştir';

  @override
  String get avatarTakePhoto => 'Fotoğraf çek';

  @override
  String get avatarChooseLibrary => 'Galeriden seç';

  @override
  String get avatarRemove => 'Fotoğrafı kaldır';

  @override
  String get emailReadonlyNote => 'E-posta buradan değiştirilemez.';

  @override
  String get nameRequired => 'Adını yaz';

  @override
  String get profileSaved => 'Profil güncellendi';

  @override
  String get profileSaveFailed => 'Profil kaydedilemedi. Tekrar dene.';

  @override
  String get profileEditUnavailable => 'Profili düzenlemek için giriş yap.';

  @override
  String get measurementSystem => 'Ölçü sistemi';

  @override
  String get unitMetric => 'Metrik';

  @override
  String get unitMetricDesc => 'Kilometre, °C';

  @override
  String get unitImperial => 'Emperyal';

  @override
  String get unitImperialDesc => 'Mil, °F';

  @override
  String get notificationSettingsTitle => 'Bildirim ayarları';

  @override
  String get notifSectionTripActivity => 'Gezi etkinliği';

  @override
  String get notifSectionTravelAlerts => 'Seyahat uyarıları';

  @override
  String get notifSectionVentus => 'Ventus';

  @override
  String get notifCollaboratorChanges => 'Gezideki değişiklikler';

  @override
  String get notifCollaboratorChangesSub => 'Biri geziyi değiştirdiğinde';

  @override
  String get notifItineraryUpdates => 'Gün planı güncellemeleri';

  @override
  String get notifChecklistReminders => 'Kontrol listesi';

  @override
  String get notifChecklistRemindersSub => 'Son tarih hatırlatmaları';

  @override
  String get notifWeatherChanges => 'Hava değişiklikleri';

  @override
  String get notifDocumentExpiry => 'Belgenin süresi';

  @override
  String get notifDocumentExpirySub => 'Pasaport ve vize kontrolleri';

  @override
  String get notifCheckInDeparture => 'Check-in ve kalkış';

  @override
  String get notifTravelTips => 'Seyahat ipuçları';

  @override
  String get notifProductNews => 'Ürün haberleri ve teklifler';

  @override
  String get collaboratorsTitle => 'Birlikte planlayanlar';

  @override
  String get collaboratorsManageSub => 'Birlikte planlamak için davet et';

  @override
  String collabPeopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kişi',
      one: '1 kişi',
    );
    return '$_temp0';
  }

  @override
  String get collabPending => 'Bekliyor';

  @override
  String get collabRemoved => 'Listeden çıkarıldı';

  @override
  String get collabAnyoneWithLink => 'Bağlantısı olan herkes';

  @override
  String get collabCopy => 'Kopyala';

  @override
  String get collabLinkCopied => 'Davet bağlantısı kopyalandı';

  @override
  String get collabYou => 'Sen';

  @override
  String get roleOwner => 'Sahip';

  @override
  String get roleEditor => 'Düzenleyici';

  @override
  String get roleViewer => 'İzleyici';

  @override
  String get roleEditorDesc =>
      'Gün planı, bütçe ve belgeleri ekleyip değiştirebilir';

  @override
  String get roleViewerDesc => 'Geziyi görebilir, değişiklik yapamaz';

  @override
  String get collabInviteSent => 'Davet gönderildi · bekliyor';

  @override
  String get removeCollaborator => 'Çıkar';

  @override
  String get inviteTitle => 'Geziye davet et';

  @override
  String get inviteRoleLabel => 'Rol';

  @override
  String get inviteEmailInvalid => 'Geçerli bir e-posta yaz';

  @override
  String get sendInvite => 'Davet gönder';

  @override
  String get collabInviteSentToast => 'Davet gönderildi';

  @override
  String get collabPickTrip => 'Bir gezi seç';

  @override
  String get collabNoTrips => 'Birini davet etmek için önce bir gezi oluştur.';

  @override
  String get statCountries => 'Ülke';

  @override
  String get statCities => 'Şehir';

  @override
  String get statKmFlown => 'km uçuş';

  @override
  String get statTrips => 'Gezi';

  @override
  String get goVentusPro => 'Ventus Pro\'ya geç';

  @override
  String get goVentusProSub =>
      'Sınırsız gezi, çevrimdışı haritalar ve daha fazlası';

  @override
  String get menuCollaborators => 'Birlikte planlayanlar';

  @override
  String get menuNotifications => 'Bildirimler';

  @override
  String get menuSavedPlaces => 'Kayıtlı yerler';

  @override
  String get menuCurrencyUnits => 'Para birimi ve birimler';

  @override
  String get menuSettings => 'Ayarlar';

  @override
  String get menuPrivacySecurity => 'Gizlilik ve güvenlik';

  @override
  String get profileSectionPreferences => 'Tercihler';

  @override
  String get profileSectionAccount => 'Hesap';

  @override
  String get logOut => 'Çıkış yap';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get appearance => 'Görünüm';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get language => 'Dil';

  @override
  String get systemDefault => 'Sistem dili';

  @override
  String get whereTo => 'Nereye?';

  @override
  String get destinationSubtitle =>
      'Bir veya daha fazla yer ekle — aralarındaki rotayı Ventus planlar.';

  @override
  String get searchCityCountry => 'Şehir veya ülke ara';

  @override
  String get popularRightNow => 'Şu an popüler';

  @override
  String get addAnotherStop => 'Başka durak ekle';

  @override
  String get recent => 'Son';

  @override
  String get popularDestinations => 'Popüler destinasyonlar';

  @override
  String placesMatch(int count, String query) {
    return '“$query” ile $count yer eşleşiyor';
  }

  @override
  String addPlace(String name) {
    return '“$name” ekle';
  }

  @override
  String get continueAction => 'Devam et';

  @override
  String get searchingPlaces => 'Arıyoruz…';

  @override
  String get keepTyping => 'Aramak için en az 3 harf yaz';

  @override
  String get searchPlacesFailed =>
      'Arama olmadı — aşağıdan elle ekleyebilirsin.';

  @override
  String get aiTitle => 'Ventus’a gezini anlat';

  @override
  String get aiSubtitle =>
      'Gezini kendi kelimelerinle anlat — Ventus detayları tamamlar.';

  @override
  String get aiPromptHint =>
      'İki kişi için haziran ortasında İstanbul ve Kapadokya’ya 5 günlük yemek ve kültür gezisi.';

  @override
  String get aiExamplesLabel => 'Hızlı başla';

  @override
  String get aiExampleRomanticLabel => 'Romantik hafta sonu';

  @override
  String get aiExampleRomanticText =>
      'Bu hafta sonu yakın bir şehre iki kişilik kısa romantik bir kaçamak.';

  @override
  String get aiExampleFamilyLabel => 'Aile tatili';

  @override
  String get aiExampleFamilyText =>
      'Ailemizle (2 yetişkin, 2 çocuk) ağustosta 7 günlük bir sahil tatili.';

  @override
  String get aiExampleFriendsLabel => 'Arkadaşlarla gezi';

  @override
  String get aiExampleFriendsText =>
      'Eylülde 4 arkadaşla dağlık bir bölgeye 3 günlük doğa yürüyüşü gezisi.';

  @override
  String get aiExampleSoloLabel => 'Tek gezi';

  @override
  String get aiExampleSoloText =>
      'Ekimde sakin bir şehre tek başıma 4 günlük kültür ve dinlenme gezisi.';

  @override
  String get aiExampleCityLabel => 'Kısa şehir turu';

  @override
  String get aiExampleCityText =>
      'Hafta sonu kısa 3 günlük şehir turu — tarihi yerler ve yerel mutfak.';

  @override
  String get aiExampleWinterLabel => 'Kış tatili';

  @override
  String get aiExampleWinterText =>
      'Ocakta karlı bir dağ tatil köyünde 5 günlük kayak ve sıcak çikolatalı kış tatili.';

  @override
  String get ventusUnderstood => 'Ventus anladı';

  @override
  String get whosComing => 'Kimler geliyor?';

  @override
  String get travelersSubtitle =>
      'Bu, Ventus’un sana uygun tempoyu ve önerileri seçmesine yardımcı olur.';

  @override
  String get travelerSolo => 'Tek';

  @override
  String get travelerCouple => 'Çift';

  @override
  String get travelerFamily => 'Aile';

  @override
  String get travelerFriends => 'Arkadaşlar';

  @override
  String get travelersAdults => 'Yetişkinler';

  @override
  String get travelersAdultsSub => '13+ yaş';

  @override
  String get travelersChildren => 'Çocuklar';

  @override
  String get travelersChildrenSub => '0–12 yaş';

  @override
  String get inviteCompanions => 'Yol arkadaşlarını davet et';

  @override
  String get inviteCompanionsSub => 'İsteğe bağlı · birlikte planla';

  @override
  String get inviteAdd => 'Ekle';

  @override
  String get inviteAfterCreate => 'Geziyi oluşturduğunda davet edilecekler.';

  @override
  String get when => 'Ne zaman?';

  @override
  String get datesSubtitle =>
      'Tarihleri seç ya da esnek kal — bunu sonra değiştirebilirsin.';

  @override
  String get presetThisWeekend => 'Bu hafta sonu';

  @override
  String get presetNextWeek => 'Gelecek hafta';

  @override
  String get presetInAMonth => 'Bir ay içinde';

  @override
  String get presetFlexible => 'Fark etmez';

  @override
  String get reviewTrip => 'Geziyi gözden geçir';

  @override
  String get selectDates => 'Tarih seç';

  @override
  String nightsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gece',
      one: '$count gece',
    );
    return '$_temp0';
  }

  @override
  String get reviewTitle => 'Son bakış';

  @override
  String stopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count durak',
      one: '$count durak',
    );
    return '$_temp0';
  }

  @override
  String get routeLabel => 'Rota';

  @override
  String get travelersLabel => 'Yolcular';

  @override
  String get datesLabel => 'Tarihler';

  @override
  String get editAction => 'Düzenle';

  @override
  String adultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yetişkin',
      one: '$count yetişkin',
    );
    return '$_temp0';
  }

  @override
  String childrenCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count çocuk',
      one: '$count çocuk',
    );
    return '$_temp0';
  }

  @override
  String get buildPlanWithAi => 'Planımı AI oluştursun';

  @override
  String get createEmptyTrip => 'Kendim oluştururum';

  @override
  String get reviewFootnote =>
      'Burada rezervasyon yapılmaz — bilet ve belgeleri istediğin zaman ekleyebilirsin.';

  @override
  String get tripCreated => 'Gezi oluşturuldu';

  @override
  String get tripNotFound => 'Gezi bulunamadı.';

  @override
  String get tripDetailsTitle => 'Gezi ayrıntıları';

  @override
  String get tripOverviewTab => 'Genel bakış';

  @override
  String get moduleItinerary => 'Gün planı';

  @override
  String get moduleBudget => 'Bütçe';

  @override
  String get moduleDocuments => 'Belgeler';

  @override
  String get moduleChecklist => 'Kontrol listesi';

  @override
  String get moduleChecklistShort => 'Kontrol';

  @override
  String get moduleMap => 'Harita';

  @override
  String get seeOnMap => 'Haritada gör';

  @override
  String get mapRouteTitle => 'Rota';

  @override
  String get emptyMapTitle => 'Henüz haritalanacak bir şey yok';

  @override
  String get emptyMapBody =>
      'Gezine yerler ekle, burada haritada görünecekler.';

  @override
  String get emptyMapNoCoords =>
      'Bu gezideki yerlerin konumu henüz bilinmiyor. Haritaya eklemek için aşağıya dokun.';

  @override
  String get mapFilterAll => 'Tümü';

  @override
  String get mapLocating => 'Yerler bulunuyor…';

  @override
  String get mapFindPlaces => 'Yerleri bul';

  @override
  String mapMissingPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yerin haritada konumu yok',
      one: '$count yerin haritada konumu yok',
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
  String get mapDayEmpty => 'Bu günün planında haritaya düşen yer yok';

  @override
  String get mapShowInPlan => 'Gün planında göster';

  @override
  String mapLocated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yer haritaya eklendi',
      one: '$count yer haritaya eklendi',
    );
    return '$_temp0';
  }

  @override
  String get mapNothingLocated => 'Yeni yer bulunamadı';

  @override
  String get mapLocateFailed => 'Yerler bulunamadı. Bağlantını kontrol et.';

  @override
  String aiHubTitle(String city) {
    return '$city planını Ventus yapsın';
  }

  @override
  String get aiHubBody =>
      'Tarihlerine, temponuna ve seçtiğin yerlere göre günlük plan — saniyeler içinde hazır olur.';

  @override
  String get aiHubGenerate => 'Planımı oluştur';

  @override
  String get aiGenerating => 'Planın hazırlanıyor…';

  @override
  String get aiPlanReady => 'Planın hazır';

  @override
  String get aiNeedsDestination => 'Önce bir varış noktası ekle.';

  @override
  String get aiPlanUnavailable => 'AI ile planlama henüz kullanılamıyor.';

  @override
  String get aiPlanNetworkError =>
      'Planlayıcıya ulaşılamadı. Bağlantını kontrol edip tekrar dene.';

  @override
  String get aiPlanEmpty => 'Plan oluşturulamadı. Birazdan tekrar dene.';

  @override
  String get aiPlanFailed => 'Plan oluşturulamadı. Tekrar dene.';

  @override
  String get aiNeedDescription => 'Önce gezini tarif et.';

  @override
  String get aiReadingTrip => 'Gezin okunuyor…';

  @override
  String get aiParseEmpty =>
      'Burada bir yer bulunamadı. Bir şehir adı yazmayı dene.';

  @override
  String get aiParseFailed => 'Gezin okunamadı. Tekrar dene.';

  @override
  String get orStartManually => 'Ya da elle başla';

  @override
  String get startBuildItinerary => 'Gün planı oluştur';

  @override
  String get startBuildItinerarySub => 'Günleri ve etkinlikleri kendin ekle';

  @override
  String get startUploadDocs => 'Bilet ve belgeleri yükle';

  @override
  String get startUploadDocsSub =>
      'Uçuşlar, oteller, pasaportlar — hepsi tek yerde';

  @override
  String get startChecklist => 'Kontrol listesi oluştur';

  @override
  String get startChecklistSub => 'Ne alacağını ve hazırlayacağını takip et';

  @override
  String get deleteTripAction => 'Geziyi sil';

  @override
  String get deleteTripTitle => 'Bu gezi silinsin mi?';

  @override
  String get deleteTripBody =>
      'Bu, geziyi ve tüm ayrıntılarını siler. Geri alınamaz.';

  @override
  String get deleteConfirm => 'Sil';

  @override
  String get tripDeleted => 'Gezi silindi';

  @override
  String get dayLabel => 'Gün';

  @override
  String get emptyDayTitle => 'Henüz bir plan yok';

  @override
  String get emptyDayBody => 'Bu gün için ilk etkinliğini ekle.';

  @override
  String get addActivity => 'Etkinlik ekle';

  @override
  String get newActivity => 'Yeni etkinlik';

  @override
  String get editActivity => 'Etkinliği düzenle';

  @override
  String get activityTitleLabel => 'Etkinlik';

  @override
  String get activityTitleHint => 'örn. Boğaz gün batımı yürüyüşü';

  @override
  String get activityTitleRequired => 'Kısa bir başlık yaz';

  @override
  String get activityPlaceLabel => 'Yer';

  @override
  String get activityPlaceHint => 'örn. Karaköy';

  @override
  String get activityTimeLabel => 'Saat';

  @override
  String get activityAddTime => 'Saat ekle';

  @override
  String get activityKindLabel => 'Tür';

  @override
  String get activityDayLabel => 'Gün';

  @override
  String get kindFlight => 'Uçuş';

  @override
  String get kindStay => 'Konaklama';

  @override
  String get kindFood => 'Yemek';

  @override
  String get kindSight => 'Gezilecek yer';

  @override
  String get kindTransport => 'Ulaşım';

  @override
  String get kindActivity => 'Etkinlik';

  @override
  String get save => 'Kaydet';

  @override
  String get selectTime => 'Saat seç';

  @override
  String get setTime => 'Onayla';

  @override
  String get deleteActivity => 'Etkinliği sil';

  @override
  String get deleteActivityTitle => 'Bu etkinlik silinsin mi?';

  @override
  String get aiAssistTitle => 'Bazı günler hâlâ boş';

  @override
  String get aiAssistBody => 'Bırak Ventus senin için taslak hazırlasın';

  @override
  String get planAction => 'Planla';

  @override
  String checklistProgress(int done, int total) {
    return '$done/$total tamam';
  }

  @override
  String get checklistItemHint => 'örn. Pasaport 6+ ay geçerli';

  @override
  String get renameChecklistItem => 'Adını değiştir';

  @override
  String get itemDeleted => 'Silindi';

  @override
  String get undo => 'Geri al';

  @override
  String get emptyChecklistTitle => 'Henüz işaretlenecek bir şey yok';

  @override
  String get emptyChecklistBody => 'Toplaman ve hazırlaman gerekenleri ekle.';

  @override
  String get checklistCatBeforeYouGo => 'Gitmeden önce';

  @override
  String get checklistCatPack => 'Topla';

  @override
  String get checklistCatOnArrival => 'Varışta';

  @override
  String get defChkVisa => 'Vize kontrol / başvuru';

  @override
  String get defChkInsurance => 'Seyahat sigortası';

  @override
  String get defChkCheckin => 'Online check-in';

  @override
  String get defChkCash => 'Döviz bozdur / nakit';

  @override
  String get defChkPassport => 'Pasaport';

  @override
  String get defChkTickets => 'Biletler (uçuş / tren)';

  @override
  String get defChkId => 'Kimlik kartı';

  @override
  String get defChkCharger => 'Şarj cihazı / adaptör';

  @override
  String get defChkSim => 'Yerel SIM / eSIM';

  @override
  String get defChkHotel => 'Otele check-in';

  @override
  String get defChkTransport => 'Yerel ulaşım';

  @override
  String get addItem => 'Madde ekle';

  @override
  String get addToChecklist => 'Listeye ekle';

  @override
  String get editChecklistItem => 'Düzenle';

  @override
  String get deleteChecklistItem => 'Sil';

  @override
  String get checklistCategoryLabel => 'Kategori';

  @override
  String get setReminder => 'Hatırlatma kur';

  @override
  String dueBy(String date) {
    return '$date tarihine kadar';
  }

  @override
  String documentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dosya',
      one: '$count dosya',
    );
    return '$_temp0';
  }

  @override
  String get docPhotoName => 'Fotoğraf';

  @override
  String get docFileName => 'Dosya';

  @override
  String get docGroupTickets => 'Biletler';

  @override
  String get docGroupStays => 'Konaklama';

  @override
  String get docGroupIdentity => 'Kimlik';

  @override
  String get docGroupOther => 'Diğer';

  @override
  String get docGroupTripWide => 'Tüm gezi';

  @override
  String get docTypeTicket => 'Bilet';

  @override
  String get docTypeStay => 'Konaklama';

  @override
  String get docTypeId => 'Kimlik';

  @override
  String get docTypeOther => 'Diğer';

  @override
  String get uploadDocument => 'Belge yükle';

  @override
  String get addDocumentTitle => 'Belge ekle';

  @override
  String get addDocumentBody =>
      'Biletler, kuponlar ve kimlikler bu geziye özel kalır.';

  @override
  String get sourceFiles => 'Dosyalar';

  @override
  String get sourceFilesSub => 'PDF, Pages, her şey';

  @override
  String get sourceCamera => 'Kamera';

  @override
  String get sourceCameraSub => 'Kağıt bir bilet veya kimlik tara';

  @override
  String get sourcePhotos => 'Fotoğraflar';

  @override
  String get sourcePhotosSub => 'Galerinden seç';

  @override
  String get saveDocumentTitle => 'Belgeyi kaydet';

  @override
  String get documentTypeLabel => 'Tür';

  @override
  String get linkToDayLabel => 'Güne bağla (isteğe bağlı)';

  @override
  String get saveToDocuments => 'Belgelere kaydet';

  @override
  String docDayWithDate(int day, String date) {
    return '$day. gün · $date';
  }

  @override
  String docDayShort(int day) {
    return '$day. gün';
  }

  @override
  String get editDocumentTitle => 'Belgeyi düzenle';

  @override
  String get documentNameLabel => 'Ad';

  @override
  String get documentNameHint => 'Belge adı';

  @override
  String get deleteDocument => 'Belgeyi sil';

  @override
  String get deleteDocumentTitle => 'Bu belge silinsin mi?';

  @override
  String get deleteDocumentBody =>
      'Bu, dosyayı kalıcı olarak siler. Geri alınamaz.';

  @override
  String get documentDeleted => 'Belge silindi';

  @override
  String get docActionShare => 'Paylaş';

  @override
  String get docActionSave => 'Kaydet';

  @override
  String get docActionEdit => 'Düzenle';

  @override
  String get docActionDelete => 'Sil';

  @override
  String documentLinkedTo(String day) {
    return 'Bağlı: $day';
  }

  @override
  String get openFile => 'Aç';

  @override
  String get previewUnavailable => 'Bu dosyayı burada gösteremiyoruz.';

  @override
  String get connectToView => 'Bu dosyayı görüntülemek için internete bağlan.';

  @override
  String get emptyDocumentsTitle => 'Henüz belge yok';

  @override
  String get emptyDocumentsBody =>
      'Biletlerini, kuponlarını ve kimliklerini yükle, hep elinin altında olsun.';

  @override
  String get uploadFailed => 'Yüklenemedi — tekrar dene.';

  @override
  String get budgetRemaining => 'Kalan';

  @override
  String budgetOfTotal(String total) {
    return '/ $total';
  }

  @override
  String budgetSpentUsed(String spent, int percent) {
    return '$spent harcandı · bütçenin %$percent\'i';
  }

  @override
  String budgetLeftPct(int percent) {
    return '%$percent kaldı';
  }

  @override
  String get budgetByCategory => 'Kategoriye göre';

  @override
  String get budgetExpenses => 'Harcamalar';

  @override
  String get addExpense => 'Harcama ekle';

  @override
  String get editExpense => 'Harcamayı düzenle';

  @override
  String get editBudget => 'Bütçeyi düzenle';

  @override
  String get budgetTotalLabel => 'Toplam gezi bütçesi';

  @override
  String get budgetAllocateByCategory => 'Kategorilere ayır';

  @override
  String get budgetAllocated => 'Ayrılan';

  @override
  String get budgetSave => 'Bütçeyi kaydet';

  @override
  String get budgetCurrency => 'Para birimi';

  @override
  String get expCatStay => 'Konaklama';

  @override
  String get expCatFood => 'Yemek';

  @override
  String get expCatSight => 'Gezilecek yerler';

  @override
  String get expCatTransport => 'Ulaşım';

  @override
  String get expCatOther => 'Diğer';

  @override
  String get expenseNoteHint => 'Not ekle…';

  @override
  String addAmountTo(String amount, String category) {
    return '$category için $amount ekle';
  }

  @override
  String get budgetUnassigned => 'Atanmamış';

  @override
  String get deleteExpense => 'Harcamayı sil';

  @override
  String get deleteExpenseTitle => 'Bu harcama silinsin mi?';

  @override
  String get expenseDeleted => 'Harcama silindi';

  @override
  String get amountRequired => 'Tutarı yaz';

  @override
  String get emptyExpensesBody => 'Henüz harcama eklenmedi.';

  @override
  String get setBudgetTitle => 'Gezi bütçeni belirle';

  @override
  String get setBudgetBody =>
      'Bir toplam ekle, Ventus harcadıkça kalanı takip etsin.';

  @override
  String get setBudget => 'Bütçe belirle';

  @override
  String get privacySectionAppLock => 'Uygulama kilidi';

  @override
  String get privacySectionAccount => 'Hesap';

  @override
  String get privacySectionDanger => 'Hesabı silme';

  @override
  String get privacyChangePin => 'PIN\'i değiştir';

  @override
  String get privacyChangePinSub => 'Bu cihaz için hızlı kilit PIN\'i';

  @override
  String get privacyChangePasswordSub => 'Hesap şifreni güncelle';

  @override
  String get privacyDeleteAccount => 'Hesabı sil';

  @override
  String get privacyDeleteAccountSub =>
      'Hesabını ve verilerini kalıcı olarak sil';

  @override
  String get deleteAccountTitle => 'Hesap silinsin mi?';

  @override
  String get deleteAccountBody =>
      'Bu, hesabını ve tüm gezilerini kalıcı olarak siler. Geri alınamaz.';

  @override
  String get accountDeleted => 'Hesabın silindi';

  @override
  String get changePinTitle => 'PIN\'i değiştir';

  @override
  String get changePinVerifyTitle => 'Mevcut PIN\'i yaz';

  @override
  String get changePinVerifyBody =>
      'Değiştirmeden önce senin olduğunu doğrulayalım.';

  @override
  String get changePinNewTitle => 'Yeni PIN seç';

  @override
  String get changePinNewBody => 'Hatırlayacağın 4 haneli bir PIN seç.';

  @override
  String get changePinConfirmTitle => 'Yeni PIN\'i tekrar gir';

  @override
  String get changePinConfirmBody => 'Onaylamak için yeni PIN\'i bir daha yaz.';

  @override
  String get changePinWrong => 'PIN yanlış. Tekrar dene.';

  @override
  String get changePinMismatch => 'PIN\'ler eşleşmedi. Baştan başla.';

  @override
  String get pinChanged => 'PIN güncellendi';

  @override
  String get pinTooWeak =>
      'Bu PIN çok kolay tahmin edilebilir. Farklı bir kod seç.';

  @override
  String get pinLockedOut => 'Çok fazla hatalı deneme. Bekle:';

  @override
  String get changePasswordTitle => 'Şifreyi değiştir';

  @override
  String get changePasswordAction => 'Şifreyi güncelle';

  @override
  String get currentPasswordLabel => 'Mevcut şifre';

  @override
  String get newPasswordLabel => 'Yeni şifre';

  @override
  String get confirmPasswordLabel => 'Yeni şifreyi onayla';

  @override
  String get passwordsDontMatch => 'Şifreler eşleşmiyor.';

  @override
  String get currentPasswordIncorrect => 'Mevcut şifre yanlış.';

  @override
  String get passwordChanged => 'Şifre güncellendi';

  @override
  String get authWeakPassword => 'Şifre çok zayıf. En az 8 karakter kullan.';

  @override
  String get authSamePassword => 'Yeni şifre mevcut şifreden farklı olmalı.';

  @override
  String get proTitle => 'Ventus Pro';

  @override
  String get proTagline => 'Sınırsız planla.';

  @override
  String get proBillingYearly => 'Yıllık';

  @override
  String get proBillingMonthly => 'Aylık';

  @override
  String get proSave => '%30 tasarruf';

  @override
  String get proPerYear => '/yıl';

  @override
  String get proPerMonth => '/ay';

  @override
  String get proYearlyEquiv => '≈ \$3.50/ay';

  @override
  String get proBilledMonthly => 'aylık faturalandırılır';

  @override
  String get proColFeature => 'Özellik';

  @override
  String get proColFree => 'Ücretsiz';

  @override
  String get proColPro => 'Pro';

  @override
  String get proRowTrips => 'Aktif geziler';

  @override
  String get proRowAiPlans => 'AI gün planları';

  @override
  String get proRowOfflineMaps => 'Çevrimdışı haritalar';

  @override
  String get proRowCollaborators => 'Birlikte planlayanlar';

  @override
  String get proRowVault => 'Belge kasası';

  @override
  String get proFreeAiPlansPerMonth => '5/ay';

  @override
  String get proCtaTrial => '7 günlük ücretsiz denemeyi başlat';

  @override
  String get proComingSoon =>
      'Ventus Pro\'yu hâlâ geliştiriyoruz. Hazır olduğunda haber vereceğiz.';

  @override
  String get proThenYearly => 'Sonra \$41.99/yıl · istediğin zaman iptal et';

  @override
  String get proThenMonthly => 'Sonra \$4.99/ay · istediğin zaman iptal et';

  @override
  String get notificationsTitle => 'Bildirimler';

  @override
  String get notifToday => 'Bugün';

  @override
  String get notifEarlier => 'Daha önce';

  @override
  String get notifMarkRead => 'Hepsini okundu işaretle';

  @override
  String get notifEmptyTitle => 'Henüz bildirim yok';

  @override
  String get notifEmptyBody =>
      'Gezi etkinliği ve AI güncellemeleri burada görünecek.';

  @override
  String notifNewCount(int count) {
    return '$count yeni';
  }

  @override
  String notifCollabInvitedTitle(String email) {
    return '$email davet edildi';
  }

  @override
  String notifCollabInvitedBody(String trip) {
    return '$trip gezisine eklendi. Davet gönderildi.';
  }

  @override
  String get notifCollabInvitedBodyShort => 'Davet gönderildi.';

  @override
  String get notifAiReadyTitle => 'AI gün planın hazır';

  @override
  String notifAiReadyBody(String trip) {
    return 'Ventus $trip için bir plan hazırladı.';
  }

  @override
  String get notifAccepted => 'Kabul edildi';

  @override
  String get notifAcceptInvite => 'Kabul et';

  @override
  String get notifGenericTitle => 'Güncelleme';

  @override
  String get notifWelcomeTitle => 'Ventus\'a hoş geldin 👋';

  @override
  String get notifWelcomeBody =>
      'Hesabın hazır. İlk gezini planla, gerisini Ventus halletsin.';

  @override
  String get timeJustNow => 'Az önce';

  @override
  String timeMinutesAgo(int count) {
    return '$count dk önce';
  }

  @override
  String timeHoursAgo(int count) {
    return '$count sa önce';
  }

  @override
  String get timeYesterday => 'Dün';

  @override
  String timeDaysAgo(int count) {
    return '$count gün önce';
  }

  @override
  String get changeCoverPhoto => 'Kapak fotoğrafını değiştir';

  @override
  String get coverUpdated => 'Kapak güncellendi';

  @override
  String get coverRemove => 'Kapak fotoğrafını kaldır';

  @override
  String get notifDeleteAll => 'Hepsini sil';

  @override
  String get notifConfirmMarkAllReadTitle =>
      'Hepsi okundu olarak işaretlensin mi?';

  @override
  String get notifConfirmMarkAllReadBody =>
      'Tüm bildirimler okundu olarak işaretlenecek.';

  @override
  String get notifConfirmDeleteAllTitle => 'Tüm bildirimler silinsin mi?';

  @override
  String get notifConfirmDeleteAllBody =>
      'Bu, tüm bildirimlerini kalıcı olarak siler. Geri alınamaz.';

  @override
  String get notifMarkReadConfirm => 'Okundu işaretle';

  @override
  String get notifDeleteAllConfirm => 'Hepsini sil';

  @override
  String get tripStatDaysLeft => 'gün kaldı';

  @override
  String get tripStatPlanned => 'planlandı';

  @override
  String greetingMorning(String name) {
    return 'Günaydın, $name';
  }

  @override
  String greetingAfternoon(String name) {
    return 'Tünaydın, $name';
  }

  @override
  String greetingEvening(String name) {
    return 'İyi akşamlar, $name';
  }

  @override
  String get nextStepEyebrow => 'Sıradaki adım';

  @override
  String get nextStepPlanTitle => 'Gün gün planını kur';

  @override
  String get nextStepPlanBody => 'İlk aktiviteyi ekle, gerisi kolay gelir.';

  @override
  String get nextStepChecklistTitle => 'Kontrol listesi oluştur';

  @override
  String get nextStepChecklistBody => 'Çıkmadan önce neleri unutmamalısın?';

  @override
  String get nextStepBudgetTitle => 'Bütçeni belirle';

  @override
  String get nextStepBudgetBody => 'Harcamalarını yaptıkça takip et.';

  @override
  String get nextStepDocsTitle => 'Belgelerini ekle';

  @override
  String get nextStepDocsBody => 'Bilet ve rezervasyonlar tek yerde dursun.';

  @override
  String get planCompleteTitle => 'Plan hazır';

  @override
  String get planCompleteBody => 'Her gün planlandı. İyi yolculuklar!';

  @override
  String get tripDeleteOwnerOnly => 'Geziyi yalnızca sahibi silebilir.';

  @override
  String get collabTripOwner => 'Gezi sahibi';

  @override
  String get overviewReadiness => 'Hazırlık';

  @override
  String get overviewNextUp => 'Sıradaki etkinlik';

  @override
  String readinessDaysPlanned(int planned, int total) {
    return '$planned/$total gün planlandı';
  }

  @override
  String readinessActivities(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count etkinlik',
      one: '$count etkinlik',
    );
    return '$_temp0';
  }

  @override
  String get readinessBudgetNotSet => 'Belirlenmedi';

  @override
  String get readinessNoDocs => 'Henüz yüklenmedi';

  @override
  String get readinessEmpty => 'Henüz boş';

  @override
  String get openInMaps => 'Haritada aç';

  @override
  String get taxiSection => 'Taksi';

  @override
  String datesPickStartOnly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gece',
      one: '$count gece',
    );
    return '$_temp0 yazdın, sadece yola çıkacağın günü seç.';
  }

  @override
  String get checklistAllDone => 'Her şey hazır. İyi yolculuklar!';

  @override
  String get profileSectionSupport => 'Destek';

  @override
  String get menuAbout => 'Hakkında';

  @override
  String get menuHelp => 'Yardım';

  @override
  String get menuContact => 'Bize ulaş';

  @override
  String get aboutTagline => 'Gezini tek yerde planla, sakla ve takip et.';

  @override
  String get aboutLegalSection => 'Yasal';

  @override
  String get contactMailSubject => 'Ventus destek';

  @override
  String contactMailBody(String version, String device) {
    return 'Merhaba, sorum/sorunum:\n\n\n— Uygulama: $version\n— Cihaz: $device';
  }

  @override
  String get contactMailFailed =>
      'Mail uygulaması açılamadı. Bize şu adrese yaz: support@ventus.app';

  @override
  String get helpQ1 => 'Gezi nasıl oluştururum?';

  @override
  String get helpA1 =>
      'Ana ekranın ortasındaki + düğmesine bas, yeri ve tarihi seç. İstersen “AI ile planla” seçip gezini bir cümleyle de yazabilirsin; yeri, tarihi ve kaç kişi olduğunu kendisi bulur.';

  @override
  String get helpQ2 => 'AI planı nasıl çalışır?';

  @override
  String get helpA2 =>
      'Gezi sayfasında “Planımı oluştur” düğmesine bas, Ventus gün gün bir plan önerir. Bunlar yalnızca yönlendirme içindir; saatleri, fiyatları ve rezervasyonları her zaman kendin kontrol et.';

  @override
  String get helpQ3 => 'İnternetsiz çalışır mı?';

  @override
  String get helpA3 =>
      'Gezilerin, gün planın, kontrol listen ve bütçen telefonunda saklanır, internet olmadan da açılır. Bağlantı gelince kendiliğinden eşitlenir. AI, harita, hava durumu ve döviz için internet gerekir.';

  @override
  String get helpQ4 => 'Belgelerim nerede saklanıyor?';

  @override
  String get helpA4 =>
      'Biletlerin ve diğer belgelerin yalnızca senin açabildiğin özel bir alanda güvenle saklanır. Sen paylaşmadıkça kimse göremez.';

  @override
  String get helpQ5 => 'Bir yeri haritada nasıl açarım?';

  @override
  String get helpA5 =>
      'Gün planında etkinlik kartının sağındaki pusula simgesine bas. Telefonundaki harita ve taksi uygulamaları çıkar, birini seç.';

  @override
  String get helpQ6 => 'Hesabımı nasıl silerim?';

  @override
  String get helpA6 =>
      'Profil → Gizlilik ve güvenlik → Hesabı sil. Bu işlem hesabını ve tüm gezilerini kalıcı olarak siler, geri alınamaz.';
}
