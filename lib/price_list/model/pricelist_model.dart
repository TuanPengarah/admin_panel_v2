class PriceListModel {
  String model;
  String parts;
  int id;
  int price;

  PriceListModel({this.model, this.parts, this.price, this.id});

  factory PriceListModel.fromJson(dynamic json) {
    return PriceListModel(
      model: json['model'],
      parts: json['parts'],
      price: json['price'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() =>
      {'model': model, 'parts': parts, 'price': price, 'id': id};

  String addParams() {
    return '?model=$model&parts=$parts&price=$price&id=$id';
  }

  String deleteParams() {
    return '?id=${id.toString()}';
  }
}
