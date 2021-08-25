import 'package:flutter/material.dart';

class PopupSortMenu {
  static const items = <IconMenu>[
    ascending,
    descending,
  ];

  static const ascending = IconMenu(
    text: 'A Ke Z',
    icon: Icons.expand_less,
  );

  static const descending = IconMenu(
    text: 'Z Ke A',
    icon: Icons.expand_more,
  );
}

class IconMenu {
  final String text;
  final IconData icon;

  const IconMenu({@required this.text, @required this.icon});
}
