# Ventus — tərcümə faylları

Appda görünən bütün mətnlər burada, tərcüməyə göndərmək üçün hazır CSV və JSON
formatında. Fayllar `export_texts.py` ilə yaradılır — mətn dəyişəndə skripti
yenidən işə salıb faylları təzələmək olar.

## Fayllar

Eyni məzmun iki formatdadır — **CSV** insan tərcüməçi üçün (Excel / Google Sheets),
**JSON** isə proqram/agent üçün (skript və ya AI ilə tərcümə edəndə).

| Fayl | Nə var | Sətir |
|---|---|---|
| `ventus_ui_texts.csv` / `.json` | Appın bütün interfeys mətnləri, ekran sırası ilə (Onboarding → Ventus Pro) | 595 |
| `ventus_destinations.csv` / `.json` | Explore-dakı 16 şəhərin adı, təsviri, faktları və məsləhətləri | 114 |

## JSON strukturu

`ventus_ui_texts.json` — ekranlara görə qruplaşdırılıb, ekran sırası CSV ilə eynidir:

```json
{
  "totalKeys": 595,
  "newLanguageField": "new",
  "screens": [
    {
      "screen": "01 · Onboarding / Welcome",
      "strings": [
        { "key": "getStarted", "en": "Get started", "az": "Başlayaq",
          "tr": "Başla", "new": "" }
      ]
    }
  ]
}
```

`ventus_destinations.json` — şəhərlərə görə qruplaşdırılıb:

```json
{
  "cities": [
    {
      "id": "paris",
      "fields": [
        { "field": "City name", "path": "name", "en": "Paris",
          "az": "Paris", "tr": "Paris", "new": "" }
      ]
    }
  ]
}
```

Yeni dilin mətni hər obyektin **`new`** sahəsinə yazılır. `key` / `path` sahələri
koda bağlıdır — dəyişdirilməməlidir. `note` sahəsi yalnız izahat lazım olan
açarlarda görünür.

## ventus_ui_texts.csv sütunları

- **Screen** — mətnin göründüyü ekran, nömrə ilə sıralanıb (`01 · Onboarding` → `54 · Ventus Pro`)
- **Key** — koddakı texniki açar. **Dəyişdirmə.**
- **EN / AZ / TR** — mövcud tərcümələr (üçü də tamdır)
- **NEW_LANG** — boş sütun; tərcüməçi yeni dili bura yazır
- **Note** — dəyişənlər (`{name}` kimi), ICU plural xəbərdarlığı, və mətn birdən çox ekranda işlənirsə hansılarda

`55 · Not currently shown` qrupundakı 25 açar hazırda heç bir ekranda işlənmir
(köhnə qalıqlardır) — istəsən tərcümədən çıxara bilərsən.

## ventus_destinations.csv sütunları

- **City** — şəhər id-si (`paris`, `rome`, …)
- **Field** — insan üçün sahə adı (`Description`, `Tip 2 — body`, …)
- **JSON path** — bazaya geri yazmaq üçün texniki yol. **Dəyişdirmə.**
- **EN / AZ / TR / NEW_LANG** — eyni məntiq

## Tərcüməçi üçün qaydalar

1. **Yalnız EN/AZ/TR və ya NEW_LANG sütunlarına toxun.** `Key`, `Screen`,
   `JSON path` sütunları koda bağlıdır.
2. **Fiqurlu mötərizədəki dəyişənləri olduğu kimi saxla:** `{name}`, `{count}`,
   `{days}`. Onlar app işləyərkən real dəyərlə əvəzlənir. Silinsə app crash edir.
3. **ICU plural/select strukturuna toxunma.** Belə mətnlərdə yalnız sözləri
   dəyiş, `{count, plural, =1{...} other{...}}` skeletini saxla:
   ```
   {count, plural, =1{1 gün} other{{count} gün}}
   ```
4. **Sətir sonlarını saxla.** Bəzi başlıqlarda mətnin ortasında sətir keçidi var
   (məs. `Every journey,\nbeautifully planned.`) — o, dizayn üçündür.
5. **Emoji və simvolları saxla** (`✈️`, `€`, `·`).
6. Mətn uzunluğuna diqqət: düymə mətnləri qısa olmalıdır, əks halda ekranda kəsilir.

## Geri qaytarandan sonra

Doldurulmuş faylı geri versən (fərqi yoxdur — CSV və ya JSON):
- `ventus_ui_texts` → yeni `lib/l10n/app_XX.arb` faylına çevirilir,
  `flutter gen-l10n` işə salınır, `localeProvider`-ə yeni dil əlavə edilir
- `ventus_destinations` → yeni Supabase migration faylına (`jsonb_set` ilə)
  çevrilir

## Qeyd: kod içindəki qalıqlar

Kodda 37 ədəd ARB-dən kənar sətir var, amma onların demək olar hamısı rəqəm/format
şablonudur (`${temp}°`, `$percent%`, `© OpenStreetMap`) və ya yalnız dev rejimində
görünən Design Gallery ekranıdır. Tərcümə tələb etmir.

## Faylları yenidən yaratmaq

```bash
python3 translations/export_texts.py
```

Şəhər məzmunu canlı Supabase-dən çəkilir, ona görə `env.json` lazımdır.
