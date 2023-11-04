import 'dart:convert';

import 'package:pa_mobile/core/utils/encode.dart';

class Chat extends Encodable {
  int conversationId;
  String convname;

  Chat(this.conversationId, this.convname);

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

}