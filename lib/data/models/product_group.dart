class ProductGroup {
  int id;
  String title;

  ProductGroup(this.id, this.title);

  Map<String, dynamic> toMap() => {"id": id, "title": title};

  factory ProductGroup.fromMap(Map<String, dynamic> map,
          {String? prefix = ""}) =>
      ProductGroup(
        map["${prefix}id"] as int,
        map["${prefix}title"] as String,
      );
}
