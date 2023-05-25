import 'package:flutter/material.dart';

class PopupMenuOverview {
  static const items = <IconMenuOverview>[
    edit,
    delete,
  ];

  static const edit = IconMenuOverview(
    text: 'Sunting',
    icon: Icons.edit,
  );

  static const delete = IconMenuOverview(
    text: 'Buang',
    icon: Icons.delete,
  );
}

class IconMenuOverview {
  final String text;
  final IconData icon;

  const IconMenuOverview({required this.text, required this.icon});
}
