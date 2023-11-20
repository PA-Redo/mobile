import 'package:pa_mobile/core/utils/encode.dart';

class CreateChatDto extends Encodable {
  final String convname;
  final int author;
  final String fistMessage;

  CreateChatDto({
    required this.convname,
    required this.author,
    required this.fistMessage,
  });

  @override
  String encode() {
    return '{'
        '"convname": "$convname",'
        '"author": $author,'
        '"fistMessage": "$fistMessage"'
        '}';
  }
}
