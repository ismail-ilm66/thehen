class NavbarItem {
  final bool enabled;
  final int order;
  final String destination;
  final String iconUrl;
  final String label;

  NavbarItem({
    required this.enabled,
    required this.order,
    required this.destination,
    required this.iconUrl,
    required this.label,
  });

  factory NavbarItem.fromMap(Map<String, dynamic> data) {
    return NavbarItem(
      enabled: data['_enabled'] ?? false,
      order: data['_order'] ?? 0,
      destination: data['nav_destination'] ?? '',
      iconUrl: data['nav_icon'] ?? '',
      label: data['nav_label'] ?? '',
    );
  }
}
