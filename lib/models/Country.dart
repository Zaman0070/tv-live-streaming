class Country{
  final int id;
  final String title;
  final String thumbnailUrl;

  static const String TABLE = "country";
  static final columns = ["id", "title", "thumbnailUrl"]; 

  Country({this.id, this.title, this.thumbnailUrl});

  factory Country.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return Country(
      id: id,
      title: json['name'] as String,
      thumbnailUrl: json['thumbnail'] as String,
    );
  }

   factory Country.fromMap(Map<String, dynamic> data) {
      return Country( 
         id: data['id'], 
         title: data['title'], 
         thumbnailUrl : data['thumbnailUrl']
      ); 
   } 

  Map<String, dynamic> toMap() => {
      "id": id, 
      "title": title, 
      "thumbnailUrl": thumbnailUrl
   };
}