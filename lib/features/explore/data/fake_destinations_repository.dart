import '../domain/destination.dart';
import '../domain/destinations_repository.dart';

/// In-memory destinations for offline/dev (no backend) so Discover still has
/// content. Images are null here (no Storage offline) → the branded gradient
/// fallback shows; the real app resolves images from Supabase Storage.
///
/// Content mirrors the Supabase seed (migration 0015) so the detail screen
/// looks the same in dev as in production.
class FakeDestinationsRepository implements DestinationsRepository {
  @override
  Future<List<Destination>> fetchAll() async {
    return const [
      Destination(
        id: 'rome',
        name: {'en': 'Rome', 'az': 'Roma', 'tr': 'Roma'},
        country: {'en': 'Italy', 'az': 'İtaliya', 'tr': 'İtalya'},
        description: {
          'en':
              'The Eternal City layers nearly three thousand years of history into its streets — Roman ruins, Baroque fountains and Renaissance art sit a short walk apart. Expect long lunches, espresso on your feet, and golden light on travertine at dusk.',
          'az':
              'Əbədi Şəhər küçələrində təxminən üç min illik tarixi bir araya gətirir — Roma xarabalıqları, Barokko fəvvarələri və İntibah sənəti bir-birindən bir neçə addımlıqdadır. Uzun nahar fasilələri, ayaqüstü espresso və qürub vaxtı travertin üzərində qızılı işıq gözlə.',
          'tr':
              'Ebedi Şehir, sokaklarında neredeyse üç bin yıllık tarihi bir araya getirir — Roma kalıntıları, Barok çeşmeler ve Rönesans sanatı birkaç adım ötede. Uzun öğle yemekleri, ayaküstü espresso ve gün batımında traverten üzerinde altın ışık seni bekliyor.',
        },
        currency: {'en': 'Euro (€)', 'az': 'Avro (€)', 'tr': 'Euro (€)'},
        language: {'en': 'Italian', 'az': 'İtalyan dili', 'tr': 'İtalyanca'},
        bestTime: {'en': 'Apr–Jun', 'az': 'Apr–İyun', 'tr': 'Nis–Haz'},
        timezone: 'GMT+1',
        tips: [
          DestinationTip(
            icon: 'ticket',
            title: {
              'en': 'Skip the line',
              'az': 'Növbəni keç',
              'tr': 'Sırayı atla',
            },
            body: {
              'en':
                  'Book Colosseum and Vatican tickets online to avoid long queues.',
              'az':
                  'Uzun növbələrdən qaçmaq üçün Kolizey və Vatikan biletlərini onlayn al.',
              'tr':
                  'Uzun kuyruklardan kaçınmak için Kolezyum ve Vatikan biletlerini çevrimiçi al.',
            },
          ),
          DestinationTip(
            icon: 'wallet',
            title: {
              'en': 'Tipping is optional',
              'az': 'Bəxşiş istəyə bağlıdır',
              'tr': 'Bahşiş isteğe bağlı',
            },
            body: {
              'en':
                  'A coperto (cover charge) is common; round up the bill for great service.',
              'az':
                  'Coperto (xidmət haqqı) adi haldır; yaxşı xidmət üçün hesabı yuvarlaqlaşdır.',
              'tr':
                  'Coperto (kuver ücreti) yaygındır; iyi servis için hesabı yukarı yuvarla.',
            },
          ),
        ],
      ),
      Destination(
        id: 'bali',
        name: {'en': 'Bali', 'az': 'Bali', 'tr': 'Bali'},
        country: {'en': 'Indonesia', 'az': 'İndoneziya', 'tr': 'Endonezya'},
        description: {
          'en':
              "Indonesia's island of temples, terraced rice fields and surf breaks. Days drift between jungle waterfalls, beach clubs and incense-scented shrines, while warm hospitality follows you everywhere.",
          'az':
              'İndoneziyanın məbədlər, pilləli düyü tarlaları və sörf dalğaları adası. Günlər meşə şəlalələri, çimərlik klubları və buxur ətirli ziyarətgahlar arasında keçir, isti qonaqpərvərlik isə hər yerdə səni izləyir.',
          'tr':
              "Endonezya'nın tapınaklar, teraslı pirinç tarlaları ve sörf dalgaları adası. Günler orman şelaleleri, plaj kulüpleri ve tütsü kokulu tapınaklar arasında geçerken, sıcak misafirperverlik her yerde seni takip eder.",
        },
        currency: {'en': 'Rupiah (Rp)', 'az': 'Rupi (Rp)', 'tr': 'Rupiah (Rp)'},
        language: {
          'en': 'Indonesian',
          'az': 'İndoneziya dili',
          'tr': 'Endonezyaca',
        },
        bestTime: {'en': 'Apr–Oct', 'az': 'Apr–Okt', 'tr': 'Nis–Eki'},
        timezone: 'GMT+8',
        tips: [
          DestinationTip(
            icon: 'wallet',
            title: {
              'en': 'Carry some cash',
              'az': 'Bir az nağd pul götür',
              'tr': 'Yanında nakit bulundur',
            },
            body: {
              'en':
                  'Many warungs and markets are cash-only; ATMs are common in towns.',
              'az':
                  'Bir çox varunq və bazar yalnız nağd qəbul edir; bankomatlar şəhərlərdə çoxdur.',
              'tr':
                  "Birçok warung ve pazar yalnızca nakit kabul eder; ATM'ler kasabalarda yaygındır.",
            },
          ),
          DestinationTip(
            icon: 'sun',
            title: {
              'en': 'Dress for temples',
              'az': 'Məbədlər üçün geyin',
              'tr': 'Tapınaklar için giyin',
            },
            body: {
              'en':
                  'Cover shoulders and knees; sarongs are often provided at entrances.',
              'az': 'Çiyin və dizləri ört; girişlərdə çox vaxt saronq verilir.',
              'tr':
                  'Omuzları ve dizleri ört; girişlerde genellikle sarong verilir.',
            },
          ),
        ],
      ),
      Destination(
        id: 'lisbon',
        name: {'en': 'Lisbon', 'az': 'Lissabon', 'tr': 'Lizbon'},
        country: {'en': 'Portugal', 'az': 'Portuqaliya', 'tr': 'Portekiz'},
        description: {
          'en':
              "Portugal's hilly capital tumbles down to the Tagus in pastel tiles and rattling trams. Follow the smell of custard tarts through Alfama's lanes, then catch fado and a sunset view from a miradouro.",
          'az':
              'Portuqaliyanın təpəlik paytaxtı pastel kafel və taqqıldayan tramvaylarla Taxo çayına doğru enir. Alfamanın dar küçələrində kustard tartların ətrini izlə, sonra fado dinlə və miradurodan qürub mənzərəsinə bax.',
          'tr':
              "Portekiz'in tepelik başkenti, pastel karolar ve tıkırdayan tramvaylarla Tejo'ya doğru iner. Alfama'nın dar sokaklarında pastel de nata kokusunu takip et, ardından fado dinle ve bir miradouro'dan gün batımını izle.",
        },
        currency: {'en': 'Euro (€)', 'az': 'Avro (€)', 'tr': 'Euro (€)'},
        language: {
          'en': 'Portuguese',
          'az': 'Portuqal dili',
          'tr': 'Portekizce',
        },
        bestTime: {'en': 'Mar–Jun', 'az': 'Mar–İyun', 'tr': 'Mar–Haz'},
        timezone: 'GMT+0',
        tips: [
          DestinationTip(
            icon: 'ticket',
            title: {
              'en': 'Get a Viva Viagem card',
              'az': 'Viva Viagem kartı al',
              'tr': 'Viva Viagem kartı al',
            },
            body: {
              'en': 'One rechargeable card covers trams, metro and ferries.',
              'az':
                  'Bir doldurulan kart tramvay, metro və bərələri əhatə edir.',
              'tr':
                  'Tek bir yüklenebilir kart tramvay, metro ve feribotları kapsar.',
            },
          ),
          DestinationTip(
            icon: 'cup',
            title: {
              'en': 'Try a pastel de nata',
              'az': 'Pastel de nata dad',
              'tr': 'Pastel de nata dene',
            },
            body: {
              'en': 'Best warm with cinnamon — Belém has the famous original.',
              'az':
                  'Ən yaxşısı isti və darçınlıdır — məşhur orijinalı Beləmdədir.',
              'tr': "En iyisi sıcak ve tarçınlı — ünlü orijinali Belém'de.",
            },
          ),
        ],
      ),
    ];
  }
}
