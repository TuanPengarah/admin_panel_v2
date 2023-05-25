class Inventory {
  static const List<String> supplier = [
    'MG',
    'GM',
    'G',
    'OR',
    'RnJ',
    'MA',
    'YCL',
    'CME',
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
      case 'G':
        return 'Golden';

      case 'OR':
        return 'Orange Phonetech';

      case 'GM':
        return 'GM Communication';

      case 'RnJ':
        return 'RnJ Spareparts';

      case 'MA':
        return 'Mars Parts Supply';

      case 'YCL':
        return 'YCL Mobile';

      case 'CME':
      default:
        return code;
    }
  }
}
