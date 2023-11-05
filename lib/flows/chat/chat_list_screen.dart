import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pa_mobile/core/model/chat.dart';
import 'package:pa_mobile/core/model/create_chat_dto.dart';
import 'package:pa_mobile/flows/authentication/ui/login_screen.dart';
import 'package:pa_mobile/shared/services/request/http_requests.dart';
import 'package:pa_mobile/shared/services/storage/jwt_secure_storage.dart';
import 'package:pa_mobile/shared/services/storage/secure_storage.dart';
import 'package:pa_mobile/shared/services/storage/stay_login_secure_storage.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  static const routeName = '/chat-list';

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final _formKey = GlobalKey<FormState>();

  //controler
  final TextEditingController _controllerConvName = TextEditingController();
  final TextEditingController _controllerMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadChats(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          print("error");
          JwtSecureStorage().deleteJwtToken();
          StayLoginSecureStorage().notStayLogin();
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginScreen.routeName,
            (route) => false,
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        print("here");
        final chats = snapshot.data as List<Chat>;
        if (chats.isEmpty) {
          return _buildEmpty();
        }
        return createChatView(chats);
      },
    );
  }

  Widget createChatView(List<Chat> chats) {
    return Column(
      children: [
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: chats.length,
          itemBuilder: (BuildContext context, int index) {
            final chat = chats[index];
            return ListTile(
              leading: const Icon(Icons.chat),
              title: Text(chat.convname),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/chat',
                  arguments: chat.conversationId,
                );
              },
            );
          },
        ),
        createNewConversation(),
      ],
    );
  }

  Future<List<Chat>> loadChats() {
    print("test 2222");
    return SecureStorage.get('benef_id').then((value) => getChats(value!));
  }

  static Future<List<Chat>> getChats(String benefId) async {
    final response = await HttpRequests.get('/chat/conversations/$benefId');
    print("test 111111");

    switch (response.statusCode) {
      case 200:
        final list = <Chat>[];
        for (final element in jsonDecode(response.body) as List<dynamic>) {
          list.add(Chat.decode(element as Map<String, dynamic>));
        }
        return list;
      default:
        throw Exception('Error${response.statusCode}');
    }
  }

  Widget _buildEmpty() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.chat,
              color: Colors.redAccent,
              size: 150,
            ),
            const SizedBox(height: 50),
            const Text(
              "Vous n'avez pas encore de conversation",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 60),
            createNewConversation(),
          ],
        ),
      ),
    );
  }

  Widget createNewConversation() {
    return GestureDetector(
      onTap: openDialogChatCreation,
      child: const Column(
        children: [
          Text(
            'Faire une demande',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Icon(
            Icons.add_circle_outline_outlined,
            color: Colors.redAccent,
            size: 50,
          )
        ],
      ),
    );
  }

  Future<void> openDialogChatCreation() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Faire une demande de chat'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nom de la conversation',
                    hintText: 'Entrez un nom de conversation',
                  ),
                  controller: _controllerConvName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nom de conversation';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Message de départ',
                    hintText: 'Entrez un message de départ',
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _controllerMessage,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un message de départ';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => {createChat()},
              child: const Text('Demander'),
            ),
          ],
        ),
      );

  Future<void> createChat() async {
    if (_formKey.currentState!.validate()) {
      final future = await SecureStorage.get('benef_id');
      final createChatDto = CreateChatDto(
        convname: _controllerConvName.text,
        fistMessage: _controllerMessage.text,
        author: int.parse(future!),
      );
      await HttpRequests.post("/chat/conversations", createChatDto.encode());
      Navigator.pop(context);
      setState(() {
        _controllerConvName.clear();
        _controllerMessage.clear();
      });
    }
  }
}
