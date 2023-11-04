import 'dart:convert';

import 'package:pa_mobile/core/utils/encode.dart';

class Chat extends Encodable {
  int conversationId;
  String convname;

  Chat({required this.conversationId, required this.convname});

  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'convname': convname,
    };
  }

  @override
  String encode() {
    return jsonEncode(toJson());
  }

  static Chat decode(Map<String, dynamic> element) {
    final conversationId = element['conversationId'] as int;
    final convname = utf8.decode((element['convname'] as String).runes.toList());

    return Chat(
      conversationId: conversationId,
      convname: convname,
    );
  }

}