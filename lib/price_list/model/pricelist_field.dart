class PriceListField {
  static const id = 'ID';
  static const model = 'MODEL';
  static const parts = 'PARTS';
  static const harga = 'HARGA';

  static List<String> getFields() => [
        id,
        model,
        parts,
        harga,
      ];
}
