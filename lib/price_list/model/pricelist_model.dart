class PriceListModel {
  String model;
  String parts;
  String price;

  PriceListModel({this.model, this.parts, this.price});

  factory PriceListModel.fromJson(dynamic json) {
    return PriceListModel(
      model: json['model'],
      parts: json['parts'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() => {
        'model': model,
        'parts': parts,
        'price': price,
      };

  String toParams() {
    return '?model=$model&parts=$parts&price=$price';
  }
}
