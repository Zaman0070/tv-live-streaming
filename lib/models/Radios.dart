class Radios {
  final int id;
  final String title;
  final String link, tv;
  final String thumbnail, extra;
  final String interest;

  static const String TABLE = "radio";
  static const String RECORD_TABLE = "recordradio";
  static final columns = [
    "id",
    "title",
    "thumbnail",
    "link",
    "tv",
    "interest",
    "extra"
  ];

  Radios(
      {this.id,
      this.title,
      this.thumbnail,
      this.link,
      this.tv,
      this.interest,
      this.extra});

  factory Radios.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return Radios(
        id: id,
        title: json['title'] as String,
        thumbnail: json['thumbnail'] as String,
        link: json['link'] as String,
        tv: json['tv'] as String,
        extra: json['extra'] as String,
        interest: json['interest'] as String);
  }

  factory Radios.fromMap(Map<String, dynamic> data) {
    return Radios(
        id: data['id'],
        title: data['title'],
        thumbnail: data['thumbnail'],
        link: data['link'],
        tv: data['tv'],
        extra: data['extra'],
        interest: data['interest']);
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "thumbnail": thumbnail,
        "link": link,
        "tv": tv,
        "interest": interest,
        "extra": extra
      };
}
