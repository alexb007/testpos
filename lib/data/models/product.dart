import 'package:testorders/data/models/product_group.dart';

class Product {
  int id;
  String title;
  int productGroupId;
  ProductGroup? productGroup;
  double price;

  Product(
      this.id, this.title, this.productGroupId, this.price, this.productGroup);

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "productGroupId": productGroupId,
        "price": price,
      };

  factory Product.fromMap(Map<String, dynamic> map, {String? prefix = ""}) =>
      Product(
        map["${prefix}id"],
        map["${prefix}title"],
        map["${prefix}productGroupId"],
        map["${prefix}price"],
        ProductGroup.fromMap(map, prefix: "${prefix}pg__"),
      );
}
