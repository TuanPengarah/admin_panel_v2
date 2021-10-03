class PaymentModel {
  final String title;
  final String technician;
  final String waranti;
  final int harga;

  PaymentModel(this.title, this.technician, this.waranti, this.harga);

  toJson() {
    return {
      'title': title,
      'technician': technician,
      'waranti': waranti,
      'harga': harga,
    };
  }
}
