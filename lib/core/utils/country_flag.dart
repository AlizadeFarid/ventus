/// Best-effort country name → flag emoji. Trip countries are free text (from
/// Photon or typed by hand, in EN/AZ/TR), so names are matched after folding
/// case and diacritics. Returns null when the name isn't recognised.
String? countryFlag(String? country) {
  if (country == null) return null;
  final key = _fold(country);
  if (key.isEmpty) return null;
  final code = _byName[key];
  if (code == null) return null;
  return String.fromCharCodes(code.codeUnits.map((c) => 0x1F1E6 + c - 0x41));
}

/// ISO 3166 alpha-2 code for a country name in any of the supported spellings,
/// or null when it isn't recognised.
String? countryIsoCode(String? country) {
  if (country == null) return null;
  final key = _fold(country);
  return key.isEmpty ? null : _byName[key];
}

/// Folds case and diacritics so "Türkiyə", "turkiye" and "TURKIYE" compare equal.
String foldCountryName(String s) => _fold(s);

String _fold(String s) {
  const from = 'çğıöşüâîûéèáàíóúñäëïü';
  const to = 'cgiosuaiueeaaiounaeiu';
  final b = StringBuffer();
  for (final c in s.toLowerCase().trim().split('')) {
    final i = from.indexOf(c);
    b.write(i >= 0 ? to[i] : c);
  }
  return b.toString().replaceAll('ə', 'e').replaceAll('i̇', 'i');
}

// ISO code → names (en / az / tr / common variants), already folded.
const _names = <String, List<String>>{
  'AZ': ['azerbaijan', 'azerbaycan'],
  'TR': ['turkey', 'turkiye', 'turkiye'],
  'IT': ['italy', 'italiya', 'italya', 'italia'],
  'TH': ['thailand', 'tayland'],
  'FR': ['france', 'fransa'],
  'ES': ['spain', 'ispaniya', 'ispanya', 'espana'],
  'DE': ['germany', 'almaniya', 'almanya', 'deutschland'],
  'GB': [
    'united kingdom',
    'uk',
    'great britain',
    'england',
    'britaniya',
    'birlesik krallik',
    'ingiltere',
    'boyuk britaniya',
  ],
  'US': [
    'united states',
    'usa',
    'united states of america',
    'amerika birlesik statlari',
    'abs',
    'abs-si',
    'amerika',
  ],
  'GE': ['georgia', 'gurcustan'],
  'AE': [
    'united arab emirates',
    'uae',
    'birlesmis erab emirliyi',
    'birlesik arap emirlikleri',
    'dubai',
  ],
  'GR': ['greece', 'yunanistan'],
  'PT': ['portugal', 'portuqaliya', 'portekiz'],
  'NL': ['netherlands', 'holland', 'niderland', 'hollandiya', 'hollanda'],
  'CH': ['switzerland', 'isvecre'],
  'AT': ['austria', 'avstriya', 'avusturya'],
  'BE': ['belgium', 'belcika'],
  'CZ': ['czechia', 'czech republic', 'cexiya', 'cekya'],
  'PL': ['poland', 'polsa', 'polonya'],
  'HU': ['hungary', 'macaristan'],
  'HR': ['croatia', 'xorvatiya', 'hirvatistan'],
  'SE': ['sweden', 'isvec'],
  'NO': ['norway', 'norvec'],
  'DK': ['denmark', 'danimarka'],
  'FI': ['finland', 'finlandiya'],
  'IS': ['iceland', 'islandiya', 'izlanda'],
  'IE': ['ireland', 'irlandiya', 'irlanda'],
  'RU': ['russia', 'rusiya', 'rusya'],
  'UA': ['ukraine', 'ukrayna'],
  'JP': ['japan', 'yaponiya', 'japonya'],
  'CN': ['china', 'cin'],
  'KR': ['south korea', 'korea', 'cenubi koreya', 'guney kore'],
  'IN': ['india', 'hindistan'],
  'ID': ['indonesia', 'indoneziya', 'endonezya'],
  'MY': ['malaysia', 'malayziya', 'malezya'],
  'SG': ['singapore', 'sinqapur', 'singapur'],
  'VN': ['vietnam'],
  'MV': ['maldives', 'maldiv', 'maldivler'],
  'EG': ['egypt', 'misir'],
  'MA': ['morocco', 'merakes', 'fas'],
  'TN': ['tunisia', 'tunis'],
  'ZA': ['south africa', 'cenubi afrika', 'guney afrika'],
  'KE': ['kenya'],
  'BR': ['brazil', 'braziliya', 'brezilya'],
  'AR': ['argentina', 'arqentina', 'arjantin'],
  'MX': ['mexico', 'meksika'],
  'CA': ['canada', 'kanada'],
  'AU': ['australia', 'avstraliya', 'avustralya'],
  'NZ': ['new zealand', 'yeni zelandiya', 'yeni zelanda'],
  'SA': ['saudi arabia', 'seudiyye erebistani', 'suudi arabistan'],
  'QA': ['qatar', 'katar'],
  'IL': ['israel', 'israil'],
  'JO': ['jordan', 'iordaniya', 'urdun'],
  'IR': ['iran'],
  'KZ': ['kazakhstan', 'qazaxistan', 'kazakistan'],
  'UZ': ['uzbekistan', 'ozbekistan'],
  'KG': ['kyrgyzstan', 'qirgizistan', 'kirgizistan'],
  'AM': ['armenia', 'ermenistan'],
  'CY': ['cyprus', 'kipr', 'kibris'],
  'MT': ['malta'],
  'AL': ['albania', 'albaniya', 'arnavutluk'],
  'ME': ['montenegro', 'monteneqro', 'karadag'],
  'RS': ['serbia', 'serbiya', 'sirbistan'],
  'BG': ['bulgaria', 'bolqarstan', 'bulgaristan'],
  'RO': ['romania', 'rumuniya', 'romanya'],
  'SK': ['slovakia', 'slovakiya'],
  'SI': ['slovenia', 'sloveniya', 'slovenya'],
  'EE': ['estonia', 'estoniya', 'estonya'],
  'LV': ['latvia', 'latviya', 'letonya'],
  'LT': ['lithuania', 'litva', 'litvanya'],
  'LU': ['luxembourg', 'lüksemburq', 'luksemburq', 'luksemburg'],
  'LK': ['sri lanka'],
  'NP': ['nepal'],
  'PH': ['philippines', 'filippin'],
  'KH': ['cambodia', 'kamboca', 'kambocya'],
  'CU': ['cuba', 'kuba'],
  'PE': ['peru'],
  'CL': ['chile', 'cili', 'sili'],
  'CO': ['colombia', 'kolumbiya', 'kolombiya'],
};

final Map<String, String> _byName = {
  for (final e in _names.entries)
    for (final n in e.value) _fold(n): e.key,
};
