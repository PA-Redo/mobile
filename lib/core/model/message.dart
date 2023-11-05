import 'dart:convert';

class Message {
  Message({required this.author, required this.content, required this.date});

  int author;
  String content;
  DateTime date;

  Map<String, dynamic> toJson() {
    return {
      //'conversationId': conversationId,
      //'convname': convname,
      'author': author,
      'content': content,
    };
  }

  @override
  String encode() {
    return jsonEncode(toJson());
  }

  static Message decode(Map<String, dynamic> element) {
    final author = element['author'] as int;
    final content = utf8.decode((element['content'] as String).runes.toList());
    final date = DateTime.parse(element['date'] as String);

    return Message(
      content: content,
      author: author,
      date: date,
    );
  }
}
