class TableModel {
  int id;
  String title;

  TableModel(this.id, this.title);

  Map<String, dynamic> toMap() => {"id": id, "title": title};

  factory TableModel.fromMap(Map<String, dynamic> map) =>
      TableModel(map["id"], map["title"]);
}
