import '../models/Search.dart';

class Articles {
  final int id;
  final int sourceID;
  final String source;
  final String link;
  final String title;
  final String thumbnail;
  final String content;
  final String location;
  final String lang;
  final String date;
  final String interest;
  final String type;
  final int timeStamp;

  static const String TABLE = "articles";
  static const String BOOKMARKTABLE = "articlesbookmarks";

  static final columns = [
    "id",
    "sourceID",
    "source",
    "link",
    "title",
    "thumbnail",
    "content",
    "location",
    "lang",
    "date",
    "interest",
    "type",
    "timeStamp",
  ];

  Articles(
      {this.id,
      this.sourceID,
      this.source,
      this.link,
      this.title,
      this.thumbnail,
      this.content,
      this.location,
      this.lang,
      this.date,
      this.interest,
      this.type,
      this.timeStamp});

  factory Articles.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return Articles(
      id: id,
      sourceID: int.parse(json['channel'].toString()),
      source: json['source'] as String,
      link: json['link'] as String,
      title: json['title'] as String,
      thumbnail: json['thumbnail'] as String,
      content: json['content'] as String,
      location: json['location'] as String,
      lang: json['lang'] as String,
      date: json['date'] as String,
      interest: json['category'] as String,
      type: json['type'] as String,
      timeStamp: int.parse(json['timeStamp'].toString()),
    );
  }

  factory Articles.fromMap(Map<String, dynamic> data) {
    return Articles(
      id: data['id'],
      sourceID: data['sourceID'],
      source: data['source'],
      link: data['link'],
      title: data['title'],
      thumbnail: data['thumbnail'],
      content: data['content'],
      location: data['location'],
      lang: data['lang'],
      date: data['date'],
      interest: data['interest'],
      type: data['type'],
      timeStamp: data['timeStamp'],
    );
  }

  factory Articles.fromSearch(Search search) {
    return Articles(
      id: search.id,
      sourceID: search.sourceID,
      source: search.source,
      link: search.link,
      title: search.title,
      thumbnail: search.thumbnail,
      content: search.content,
      location: search.location,
      lang: search.lang,
      date: search.date,
      interest: search.interest,
      type: search.type,
      timeStamp: search.timeStamp,
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "sourceID": sourceID,
        "source": source,
        "link": link,
        "title": title,
        "thumbnail": thumbnail,
        "content": content,
        "location": location,
        "lang": lang,
        "date": date,
        "interest": interest,
        "type": type,
        "timeStamp": timeStamp,
      };
}
