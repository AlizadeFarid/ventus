/// A sponsored ad shown on the Home dashboard.
///
/// Online content managed in the Supabase `ads` table (not local-first). Plain
/// advertiser text — not localized — since the copy comes from the advertiser.
class Ad {
  const Ad({
    required this.id,
    required this.title,
    this.advertiser,
    this.subtitle,
    this.imageUrl,
    this.linkUrl,
  });

  final String id;
  final String title;
  final String? advertiser;
  final String? subtitle;
  final String? imageUrl;
  final String? linkUrl;

  factory Ad.fromJson(Map<String, dynamic> json) => Ad(
    id: json['id'].toString(),
    title: (json['title'] as String?) ?? '',
    advertiser: json['advertiser'] as String?,
    subtitle: json['subtitle'] as String?,
    imageUrl: json['image_url'] as String?,
    linkUrl: json['link_url'] as String?,
  );
}
