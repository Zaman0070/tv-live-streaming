class Search {
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

  Search(
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

  factory Search.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return Search(
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
      type: json['feed_type'] as String,
      timeStamp: int.parse(json['timeStamp'].toString()),
    );
  }

  factory Search.fromMap(Map<String, dynamic> data) {
    return Search(
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
      interest: data['category'],
      type: data['type'],
      timeStamp: data['timeStamp'],
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
