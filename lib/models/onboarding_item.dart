import 'package:flutter/material.dart';

class OnboardingItem {
  final String title;
  final String text;
  final String icon;
  final bool enabled;
  final int order;

  OnboardingItem({
    required this.title,
    required this.text,
    this.icon = "",
    required this.enabled,
    required this.order,
  });

  factory OnboardingItem.fromMap(Map<String, dynamic> map) {
    return OnboardingItem(
      title: map['title'] ?? '',
      text: map['text'] ?? '',
      icon: map['icon'] ??
          'https://www.iconpacks.net/icons/2/free-rocket-icon-3430-thumb.png',
      enabled: map['_enabled'] ?? false,
      order: int.tryParse(map['_order'] ?? "0") ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'text': text,
      'icon': icon,
      '_enabled': enabled,
      '_order': order.toString(),
    };
  }
}
