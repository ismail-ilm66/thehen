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
    print('This is the data: $data in the json of the hero item');
    print('This is the enabled: ${data['_enabled'].runtimeType}');
    print('This is the order: ${data['_order'].runtimeType}');
    print('This is the destination: ${data['hero_destination'].runtimeType}');
    print('This is the source: ${data['hero_source'].runtimeType}');

    return HeroItem(
      enabled: data['_enabled'] ?? false,
      order: data['_order'] ?? 0,
      destination: data['hero_destination'] ?? 'www.google.com',
      source: data['hero_source'] ?? '',
    );
  }
}
