class SubCategories {
  final int id;
  final String title;

  SubCategories({this.id, this.title});

  factory SubCategories.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return SubCategories(
      id: id,
      title: json['name'] as String,
    );
  }
}
