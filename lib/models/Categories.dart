class Categories {
  final int id;
  final String title;
  final String thumbnailUrl;

  static const String TABLE = "categories";
  static final columns = ["id", "title", "thumbnailUrl"];

  Categories({this.id, this.title, this.thumbnailUrl});

  factory Categories.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return Categories(
      id: id,
      title: json['name'] as String,
      thumbnailUrl: json['thumbnail'] as String,
    );
  }

  factory Categories.fromJson2(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return Categories(
      id: id,
      title: json['name'] as String,
      thumbnailUrl: "",
    );
  }

  factory Categories.fromMap(Map<String, dynamic> data) {
    return Categories(
        id: data['id'],
        title: data['title'],
        thumbnailUrl: data['thumbnailUrl']);
  }

  Map<String, dynamic> toMap() =>
      {"id": id, "title": title, "thumbnailUrl": thumbnailUrl};
}
