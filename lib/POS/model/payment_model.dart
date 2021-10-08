class PaymentModel {
  final String title;
  final String technician;
  final String waranti;
  final int harga;
  final bool isPending;

  PaymentModel(
      this.title, this.technician, this.waranti, this.harga, this.isPending);

  toJson() {
    return {
      'title': title,
      'technician': technician,
      'waranti': waranti,
      'harga': harga,
      'isPending': isPending
    };
  }
}
