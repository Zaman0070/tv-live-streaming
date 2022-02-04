class Sources {
  final int id;
  final String title, category, type;

  Sources({this.id, this.title, this.category, this.type});

  factory Sources.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return Sources(
      id: id,
      title: json['source'] as String,
      category: json['category'] as String,
      type: json['type'] as String,
    );
  }
}
