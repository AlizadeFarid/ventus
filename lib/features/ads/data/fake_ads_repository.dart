import '../domain/ad.dart';
import '../domain/ads_repository.dart';

/// In-memory ads for offline/dev (no backend). Mirrors the Supabase seed
/// (migration 0016) so the Home banner has content in dev too.
class FakeAdsRepository implements AdsRepository {
  @override
  Future<List<Ad>> fetchAll() async {
    return const [
      Ad(
        id: 'wizzair',
        advertiser: 'Wizz Air',
        title: 'Baku → Istanbul, \$99',
        subtitle: 'Summer sale · book by Jun 10',
        imageUrl:
            'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800&q=80',
      ),
      Ad(
        id: 'booking',
        advertiser: 'Booking.com',
        title: 'Stays up to 30% off',
        subtitle: 'Genius deals in 100+ cities',
        imageUrl:
            'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800&q=80',
      ),
      Ad(
        id: 'gyg',
        advertiser: 'GetYourGuide',
        title: 'Skip-the-line tours',
        subtitle: 'Top experiences, instant tickets',
        imageUrl:
            'https://images.unsplash.com/photo-1525874684015-58379d421a52?w=800&q=80',
      ),
    ];
  }
}
