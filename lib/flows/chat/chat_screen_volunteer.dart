import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa_mobile/core/model/chat.dart';
import 'package:pa_mobile/core/model/message.dart';
import 'package:pa_mobile/shared/services/request/http_requests.dart';
import 'package:pa_mobile/shared/services/storage/secure_storage.dart';

class ChatVolunteerScreen extends StatefulWidget {
  const ChatVolunteerScreen({Key? key}) : super(key: key);

  static const routeName = '/chat_volunteer';

  @override
  State<ChatVolunteerScreen> createState() => _ChatVolunteerScreenState();
}

class _ChatVolunteerScreenState extends State<ChatVolunteerScreen> {
  final TextEditingController _controllerMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Chat;
    final messages = _getMessages(args.conversationId);
    final myId = getId();

    return Scaffold(
      appBar: AppBar(
        title: Text(args.convname),
      ),
      body: SafeArea(
        child: Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder(
                  future: Future.wait([messages, myId]),
                  builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data![0].length as int,
                        itemBuilder: (context, index) {
                          final message = snapshot.data![0][index] as Message;
                          if (message.author == int.parse(snapshot.data![1] as String)) {
                            return ListTile(
                              trailing: const Icon(Icons.person),
                              title: Text(
                                message.content,
                                textAlign: TextAlign.right,
                              ),
                              subtitle: Text(
                                "${message.date.year}-${message.date.month.toString().padLeft(2, '0')}-${message.date.day.toString().padLeft(2, '0')} ${message.date.hour.toString().padLeft(2, '0')}:${message.date.minute.toString().padLeft(2, '0')}",
                                textAlign: TextAlign.right,
                              ),
                            );
                          }
                          return ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(message.content),
                            subtitle: Text(
                              "${message.date.year}-${message.date.month.toString().padLeft(2, '0')}-${message.date.day.toString().padLeft(2, '0')} ${message.date.hour.toString().padLeft(2, '0')}:${message.date.minute.toString().padLeft(2, '0')}",
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              FutureBuilder<int>(
                future: myId.then((value) => int.parse(value as String)),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _controllerMessage,
                              decoration: const InputDecoration(
                                hintText: 'Message',
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final response = await HttpRequests.post(
                              '/chat/messages/${args.conversationId}',
                              Message(
                                author: int.parse(snapshot.data.toString()),
                                content: _controllerMessage.text,
                                date: DateTime.now(),
                              ).encode(),
                            );
                            if (response.statusCode == 200) {
                              setState(() {
                                _controllerMessage.clear();
                              });
                            }
                          },
                          icon: const Icon(Icons.send),
                        ),
                      ],
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Message>> _getMessages(int args) async {
    final response = await HttpRequests.get('/chat/messages/$args');

    switch (response.statusCode) {
      case 200:
        final list = <Message>[];
        for (final element in jsonDecode(response.body) as List<dynamic>) {
          list.add(Message.decode(element as Map<String, dynamic>));
        }
        return list;
      default:
        throw Exception('Error ${response.statusCode}');
    }
  }

  Future<String?> getId() async {
    print(await SecureStorage.get('volunteer_id'));
    return await SecureStorage.get('volunteer_id');
  }
}
