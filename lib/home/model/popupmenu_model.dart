import 'package:flutter/material.dart';

class PopupSortMenu {
  static const items = <IconMenu>[
    ascending,
    descending,
    time,
  ];

  static const ascending = IconMenu(
    text: 'Mengikut abjad A-Z',
    icon: Icons.expand_less,
  );

  static const descending = IconMenu(
    text: 'Mengikut abjad Z-A',
    icon: Icons.expand_more,
  );
  static const time = IconMenu(
    text: 'Susun mengikut masa',
    icon: Icons.history,
  );
}

class IconMenu {
  final String text;
  final IconData icon;

  const IconMenu({required this.text, required this.icon});
}
