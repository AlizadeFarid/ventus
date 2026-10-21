"""Export every user-visible string in Ventus into translator-friendly CSVs.

1. translations/ventus_ui_texts.csv      — the 595 ARB keys, grouped by screen
                                            in app order (onboarding → Pro).
2. translations/ventus_destinations.csv  — Explore city content, pulled live
                                            from the Supabase `destinations`
                                            table.
"""

import collections
import csv
import json
import os
import re
import urllib.request

ROOT = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(os.getcwd(), 'translations')

# ── screen order: onboarding → end ───────────────────────────────────────────
# (substring of the source file path, human screen label)
SCREENS = [
    ('auth/presentation/screens/welcome_screen', '01 · Onboarding / Welcome'),
    ('auth/presentation/screens/sign_in_screen', '02 · Sign in'),
    ('auth/presentation/screens/create_account_screen', '03 · Create account'),
    ('auth/presentation/screens/verify_email_screen', '04 · Verify email'),
    ('auth/presentation/screens/forgot_password_screen', '05 · Forgot password'),
    ('auth/presentation/screens/reset_password_screen', '06 · Reset password'),
    ('auth/presentation/screens/legal_screen', '07 · Terms & Privacy'),
    ('auth/presentation/screens/pin_setup_screen', '08 · PIN setup'),
    ('auth/presentation/screens/pin_unlock_screen', '09 · PIN unlock'),
    ('auth/presentation/auth_error_l10n', '10 · Auth error messages'),
    ('auth/presentation/field_error_l10n', '11 · Form validation messages'),
    ('shared/widgets/ventus_bottom_nav', '12 · Bottom navigation'),
    ('trips/presentation/screens/home_screen', '13 · Home'),
    ('trips/presentation/widgets/trip_cards', '14 · Trip cards'),
    ('trips/presentation/screens/all_trips_screen', '15 · All trips'),
    ('shared/widgets/create_trip_sheet', '16 · Create trip — entry sheet'),
    ('create/steps/destination_step', '17 · Create trip — destination'),
    ('create/steps/dates_step', '18 · Create trip — dates'),
    ('create/steps/travelers_step', '19 · Create trip — travelers'),
    ('create/steps/review_step', '20 · Create trip — review'),
    ('trips/presentation/screens/trip_detail_screen', '21 · Trip hub'),
    ('trips/presentation/widgets/cover_source_sheet', '22 · Trip cover photo'),
    ('trips/presentation/screens/itinerary_screen', '23 · Itinerary'),
    ('trips/presentation/widgets/itinerary_day_chip', '24 · Itinerary — day chip'),
    ('trips/presentation/screens/checklist_screen', '25 · Checklist'),
    ('trips/application/checklist_defaults', '26 · Checklist — default items'),
    ('trips/presentation/screens/documents_screen', '27 · Documents'),
    ('trips/presentation/screens/document_detail_screen', '28 · Document detail'),
    ('trips/presentation/widgets/document_format', '29 · Document labels'),
    ('trips/presentation/screens/budget_screen', '30 · Budget & expenses'),
    ('trips/presentation/widgets/budget_format', '31 · Budget labels'),
    ('trips/presentation/screens/map_screen', '32 · Map'),
    ('trips/presentation/screens/collaborators_screen', '33 · Collaborators'),
    ('explore/presentation/screens/explore_screen', '34 · Explore'),
    ('explore/presentation/screens/place_detail_screen', '35 · Place detail'),
    ('explore/presentation/screens/saved_screen', '36 · Saved places'),
    ('tools/presentation/screens/tools_home_screen', '37 · Tools — home'),
    ('tools/presentation/screens/currency_tool_screen', '38 · Tools — currency'),
    ('tools/presentation/widgets/currency_picker', '39 · Tools — currency picker'),
    ('tools/presentation/screens/weather_tool_screen', '40 · Tools — weather'),
    ('tools/presentation/screens/clock_tool_screen', '41 · Tools — world clock'),
    ('tools/presentation/widgets/city_picker', '42 · Tools — city picker'),
    ('tools/presentation/screens/tip_tool_screen', '43 · Tools — tip calculator'),
    ('tools/presentation/tools_format', '44 · Tools — shared labels'),
    ('notifications/presentation/screens/notifications_feed_screen', '45 · Notifications feed'),
    ('profile/presentation/screens/profile_screen', '46 · Profile'),
    ('profile/presentation/screens/settings_screen', '47 · Settings'),
    ('profile/presentation/screens/edit_profile_screen', '48 · Edit profile'),
    ('profile/presentation/screens/currency_units_screen', '49 · Currency & units'),
    ('profile/presentation/screens/notifications_screen', '50 · Notification settings'),
    ('profile/presentation/screens/privacy_security_screen', '51 · Privacy & security'),
    ('profile/presentation/screens/change_pin_screen', '52 · Change PIN'),
    ('profile/presentation/screens/change_password_screen', '53 · Change password'),
    ('profile/presentation/screens/pro_screen', '54 · Ventus Pro'),
]
UNUSED = '55 · Not currently shown (leftover keys)'


def screen_for(path):
    for frag, label in SCREENS:
        if frag in path.replace('\\', '/'):
            return label
    return None


def load_arb(lang):
    return json.load(open(f'lib/l10n/app_{lang}.arb', encoding='utf-8'))


def write_csv(name, rows):
    """utf-8-sig so Excel opens Azerbaijani/Turkish characters correctly."""
    path = os.path.join(OUT, name)
    with open(path, 'w', newline='', encoding='utf-8-sig') as fh:
        w = csv.DictWriter(fh, fieldnames=list(rows[0].keys()))
        w.writeheader()
        w.writerows(rows)
    print(path)


def write_json(name, payload):
    path = os.path.join(OUT, name)
    with open(path, 'w', encoding='utf-8') as fh:
        json.dump(payload, fh, ensure_ascii=False, indent=2)
        fh.write('\n')
    print(path)


def build_ui_csv():
    en, az, tr = load_arb('en'), load_arb('az'), load_arb('tr')
    keys = [k for k in en if not k.startswith('@')]

    # where is each key used?
    usage = collections.defaultdict(set)
    keyset = set(keys)
    for root, _, files in os.walk('lib'):
        if os.sep + 'l10n' in root:
            continue
        for f in files:
            if not f.endswith('.dart'):
                continue
            p = os.path.join(root, f)
            src = open(p, encoding='utf-8').read()
            found = re.findall(r'\bl10n\.([A-Za-z0-9_]+)', src)
            found += re.findall(r'AppLocalizations\.of\([^)]*\)\.([A-Za-z0-9_]+)', src)
            for m in found:
                if m in keyset:
                    usage[m].add(p)

    order = {label: i for i, (_, label) in enumerate(SCREENS)}
    rows = []
    for k in keys:
        labels = sorted({s for p in usage.get(k, ()) if (s := screen_for(p))},
                        key=lambda s: order[s])
        primary = labels[0] if labels else UNUSED
        also = '; '.join(labels[1:])

        meta = en.get('@' + k, {})
        ph = list((meta.get('placeholders') or {}).keys())
        note = []
        if ph:
            note.append('dəyişənlər: ' + ', '.join('{%s}' % p for p in ph))
        if re.search(r'\{\w+,\s*(plural|select)', en[k]):
            note.append('ICU plural/select — struktura toxunma')
        if meta.get('description'):
            note.append(meta['description'])
        if also:
            note.append('həmçinin: ' + also)

        rows.append({
            'Screen': primary,
            'Key': k,
            'EN': en[k],
            'AZ': az.get(k, ''),
            'TR': tr.get(k, ''),
            'NEW_LANG': '',
            'Note': ' | '.join(note),
        })

    rows.sort(key=lambda r: (order.get(r['Screen'], 999), r['Key']))
    write_csv('ventus_ui_texts.csv', rows)

    # Same data as JSON, grouped by screen (screens keep the CSV's app order).
    screens = []
    for row in rows:
        if not screens or screens[-1]['screen'] != row['Screen']:
            screens.append({'screen': row['Screen'], 'strings': []})
        entry = {'key': row['Key'], 'en': row['EN'], 'az': row['AZ'],
                 'tr': row['TR'], 'new': ''}
        if row['Note']:
            entry['note'] = row['Note']
        screens[-1]['strings'].append(entry)
    write_json('ventus_ui_texts.json', {
        'source': 'lib/l10n/app_{en,az,tr}.arb',
        'totalKeys': len(rows),
        'languages': ['en', 'az', 'tr'],
        'newLanguageField': 'new',
        'screens': screens,
    })

    unused = sum(1 for r in rows if r['Screen'] == UNUSED)
    print(f'  {len(rows)} sətir, {len(screens)} ekran ({unused} istifadə olunmayan)')


def build_destinations_csv():
    env = json.load(open('env.json', encoding='utf-8'))
    url = env['SUPABASE_URL'].rstrip('/') + '/rest/v1/destinations?select=*&order=sort_order'
    req = urllib.request.Request(url, headers={
        'apikey': env['SUPABASE_ANON_KEY'],
        'Authorization': 'Bearer ' + env['SUPABASE_ANON_KEY'],
    })
    data = json.load(urllib.request.urlopen(req, timeout=30))

    rows = []

    def add(city, field, path, val):
        if not isinstance(val, dict):
            return
        rows.append({
            'City': city, 'Field': field, 'JSON path': path,
            'EN': val.get('en', ''), 'AZ': val.get('az', ''),
            'TR': val.get('tr', ''), 'NEW_LANG': '',
        })

    for d in data:
        city = d['id']
        add(city, 'City name', 'name', d.get('name'))
        add(city, 'Country', 'country', d.get('country'))
        add(city, 'Description', 'description', d.get('description'))
        add(city, 'Currency fact', 'currency', d.get('currency'))
        add(city, 'Language fact', 'language', d.get('language'))
        add(city, 'Best time fact', 'best_time', d.get('best_time'))
        for i, tip in enumerate(d.get('tips') or []):
            add(city, f'Tip {i + 1} — title', f'tips[{i}].title', tip.get('title'))
            add(city, f'Tip {i + 1} — body', f'tips[{i}].body', tip.get('body'))

    write_csv('ventus_destinations.csv', rows)

    # Same data as JSON, grouped by city.
    cities = []
    for row in rows:
        if not cities or cities[-1]['id'] != row['City']:
            cities.append({'id': row['City'], 'fields': []})
        cities[-1]['fields'].append({
            'field': row['Field'], 'path': row['JSON path'],
            'en': row['EN'], 'az': row['AZ'], 'tr': row['TR'], 'new': '',
        })
    write_json('ventus_destinations.json', {
        'source': 'Supabase public.destinations (live)',
        'totalStrings': len(rows),
        'languages': ['en', 'az', 'tr'],
        'newLanguageField': 'new',
        'cities': cities,
    })

    print(f'  {len(rows)} sətir, {len(data)} şəhər')


if __name__ == '__main__':
    os.makedirs(OUT, exist_ok=True)
    build_ui_csv()
    build_destinations_csv()
