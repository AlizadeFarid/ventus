import 'country_flag.dart';

/// Country names as displayed in each app language (en, az, tr). Trip countries
/// are free text from the geocoder, which only knows English spellings, so the
/// UI maps recognised ones to the user's language and leaves the rest as typed.
const _display = <String, (String, String, String)>{
  'AZ': ('Azerbaijan', 'Azərbaycan', 'Azerbaycan'),
  'TR': ('Türkiye', 'Türkiyə', 'Türkiye'),
  'IT': ('Italy', 'İtaliya', 'İtalya'),
  'TH': ('Thailand', 'Tailand', 'Tayland'),
  'FR': ('France', 'Fransa', 'Fransa'),
  'ES': ('Spain', 'İspaniya', 'İspanya'),
  'DE': ('Germany', 'Almaniya', 'Almanya'),
  'GB': ('United Kingdom', 'Böyük Britaniya', 'Birleşik Krallık'),
  'US': ('United States', 'ABŞ', 'ABD'),
  'GE': ('Georgia', 'Gürcüstan', 'Gürcistan'),
  'AE': (
    'United Arab Emirates',
    'Birləşmiş Ərəb Əmirlikləri',
    'Birleşik Arap Emirlikleri',
  ),
  'GR': ('Greece', 'Yunanıstan', 'Yunanistan'),
  'PT': ('Portugal', 'Portuqaliya', 'Portekiz'),
  'NL': ('Netherlands', 'Niderland', 'Hollanda'),
  'CH': ('Switzerland', 'İsveçrə', 'İsviçre'),
  'AT': ('Austria', 'Avstriya', 'Avusturya'),
  'BE': ('Belgium', 'Belçika', 'Belçika'),
  'CZ': ('Czechia', 'Çexiya', 'Çekya'),
  'PL': ('Poland', 'Polşa', 'Polonya'),
  'HU': ('Hungary', 'Macarıstan', 'Macaristan'),
  'HR': ('Croatia', 'Xorvatiya', 'Hırvatistan'),
  'SE': ('Sweden', 'İsveç', 'İsveç'),
  'NO': ('Norway', 'Norveç', 'Norveç'),
  'DK': ('Denmark', 'Danimarka', 'Danimarka'),
  'FI': ('Finland', 'Finlandiya', 'Finlandiya'),
  'IS': ('Iceland', 'İslandiya', 'İzlanda'),
  'IE': ('Ireland', 'İrlandiya', 'İrlanda'),
  'RU': ('Russia', 'Rusiya', 'Rusya'),
  'UA': ('Ukraine', 'Ukrayna', 'Ukrayna'),
  'JP': ('Japan', 'Yaponiya', 'Japonya'),
  'CN': ('China', 'Çin', 'Çin'),
  'KR': ('South Korea', 'Cənubi Koreya', 'Güney Kore'),
  'IN': ('India', 'Hindistan', 'Hindistan'),
  'ID': ('Indonesia', 'İndoneziya', 'Endonezya'),
  'MY': ('Malaysia', 'Malayziya', 'Malezya'),
  'SG': ('Singapore', 'Sinqapur', 'Singapur'),
  'VN': ('Vietnam', 'Vyetnam', 'Vietnam'),
  'MV': ('Maldives', 'Maldiv adaları', 'Maldivler'),
  'EG': ('Egypt', 'Misir', 'Mısır'),
  'MA': ('Morocco', 'Mərakeş', 'Fas'),
  'TN': ('Tunisia', 'Tunis', 'Tunus'),
  'ZA': ('South Africa', 'Cənubi Afrika', 'Güney Afrika'),
  'KE': ('Kenya', 'Keniya', 'Kenya'),
  'BR': ('Brazil', 'Braziliya', 'Brezilya'),
  'AR': ('Argentina', 'Argentina', 'Arjantin'),
  'MX': ('Mexico', 'Meksika', 'Meksika'),
  'CA': ('Canada', 'Kanada', 'Kanada'),
  'AU': ('Australia', 'Avstraliya', 'Avustralya'),
  'NZ': ('New Zealand', 'Yeni Zelandiya', 'Yeni Zelanda'),
  'SA': ('Saudi Arabia', 'Səudiyyə Ərəbistanı', 'Suudi Arabistan'),
  'QA': ('Qatar', 'Qətər', 'Katar'),
  'IL': ('Israel', 'İsrail', 'İsrail'),
  'JO': ('Jordan', 'İordaniya', 'Ürdün'),
  'IR': ('Iran', 'İran', 'İran'),
  'KZ': ('Kazakhstan', 'Qazaxıstan', 'Kazakistan'),
  'UZ': ('Uzbekistan', 'Özbəkistan', 'Özbekistan'),
  'KG': ('Kyrgyzstan', 'Qırğızıstan', 'Kırgızistan'),
  'AM': ('Armenia', 'Ermənistan', 'Ermenistan'),
  'CY': ('Cyprus', 'Kipr', 'Kıbrıs'),
  'MT': ('Malta', 'Malta', 'Malta'),
  'AL': ('Albania', 'Albaniya', 'Arnavutluk'),
  'ME': ('Montenegro', 'Monteneqro', 'Karadağ'),
  'RS': ('Serbia', 'Serbiya', 'Sırbistan'),
  'BG': ('Bulgaria', 'Bolqarıstan', 'Bulgaristan'),
  'RO': ('Romania', 'Rumıniya', 'Romanya'),
  'SK': ('Slovakia', 'Slovakiya', 'Slovakya'),
  'SI': ('Slovenia', 'Sloveniya', 'Slovenya'),
  'EE': ('Estonia', 'Estoniya', 'Estonya'),
  'LV': ('Latvia', 'Latviya', 'Letonya'),
  'LT': ('Lithuania', 'Litva', 'Litvanya'),
  'LU': ('Luxembourg', 'Lüksemburq', 'Lüksemburg'),
  'LK': ('Sri Lanka', 'Şri-Lanka', 'Sri Lanka'),
  'NP': ('Nepal', 'Nepal', 'Nepal'),
  'PH': ('Philippines', 'Filippin', 'Filipinler'),
  'KH': ('Cambodia', 'Kamboca', 'Kamboçya'),
  'CU': ('Cuba', 'Kuba', 'Küba'),
  'PE': ('Peru', 'Peru', 'Peru'),
  'CL': ('Chile', 'Çili', 'Şili'),
  'CO': ('Colombia', 'Kolumbiya', 'Kolombiya'),
};

/// [country] in [lang] when it is a recognised country, otherwise unchanged.
String localizedCountryName(String country, String lang) {
  final code = countryIsoCode(country);
  final names = code == null ? null : _display[code];
  if (names == null) return country;
  return switch (lang) {
    'az' => names.$2,
    'tr' => names.$3,
    _ => names.$1,
  };
}

/// A place title that may just be a country name ("France" typed as the
/// destination): localised when it equals [country], otherwise as is.
String localizedPlaceTitle(String title, String country, String lang) {
  if (country.isEmpty) return title;
  return foldCountryName(title) == foldCountryName(country)
      ? localizedCountryName(country, lang)
      : title;
}
