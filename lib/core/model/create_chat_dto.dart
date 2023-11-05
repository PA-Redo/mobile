import 'package:pa_mobile/core/utils/encode.dart';

class CreateChatDto extends Encodable {
  //private final String convname;
  //     private final long author;
  //     private final String fistMessage;

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
