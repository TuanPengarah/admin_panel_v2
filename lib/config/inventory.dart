class Inventory {
  static const List<String> supplier = [
    'MG',
    'GM',
    'G',
    'OR',
    'RnJ',
    'Lain...',
  ];
  static final List<String> quality = [
    'OEM',
    'ORI',
    'AAA',
    'AA',
    'AP',
    'OLED',
    'OLED Burn In',
    'GX OLED',
    'ORI Change Glass',
    'ORI China',
    'ORI Used',
  ];

  static String getSupplierCode(String code) {
    switch (code) {
      case 'MG':
        return 'Mobile Gadget Resources';
        break;
      case 'G':
        return 'Golden';
        break;
      case 'OR':
        return 'Orange Phonetech';
        break;
      case 'GM':
        return 'GM Communication';
        break;
      case 'RnJ':
        return 'RnJ Spareparts';
        break;
      default:
        return code;
    }
  }
}
