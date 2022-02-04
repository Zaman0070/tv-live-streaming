class LiveStreams {
  final int id;
  final String title, coverphoto, description, streamurl, type, extra;
  final bool isfree;

  LiveStreams(
      {this.id,
      this.title,
      this.coverphoto,
      this.type,
      this.description,
      this.isfree,
      this.extra,
      this.streamurl});

  static const String TABLE = "livestreams";
  static final columns = [
    "id",
    "title",
    "coverphoto",
    "type",
    "description",
    "isfree",
    "extra",
    "streamurl"
  ];

  factory LiveStreams.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return LiveStreams(
        id: id,
        title: json['title'] as String,
        coverphoto: json['cover_photo'] as String,
        type: json['type'] as String,
        description: json['description'] as String,
        extra: json['extra'] as String,
        isfree: int.parse(json['is_free'].toString()) == 0,
        streamurl: json['source'] as String);
  }

  factory LiveStreams.fromMap(Map<String, dynamic> data) {
    return LiveStreams(
        id: data['id'],
        title: data['title'],
        coverphoto: data['coverphoto'],
        description: data['description'],
        isfree: true,
        streamurl: data['streamurl'],
        extra: data['extra'],
        type: data['type']);
  }

  Map<String, dynamic> to2Map() => {
        "id": id,
        "title": title,
        "cover_photo": coverphoto,
        "type": type,
        "is_free": isfree,
        "stream_url": streamurl,
        "description": description,
        "extra": extra
      };
}
