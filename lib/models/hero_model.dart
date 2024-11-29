class HeroItem {
  final bool enabled;
  final int order;
  final String destination;
  final String source;

  HeroItem({
    required this.enabled,
    required this.order,
    required this.destination,
    required this.source,
  });

  factory HeroItem.fromMap(Map<String, dynamic> data) {
    return HeroItem(
      enabled: data['_enabled'] ?? false,
      order: int.tryParse(data['_order'] ?? '0') ?? 0,
      destination: data['hero_destination'] ?? 'www.google.com',
      source: data['hero_source'] ?? '',
    );
  }
}
