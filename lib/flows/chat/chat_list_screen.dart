import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pa_mobile/core/model/chat.dart';
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadChats(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
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
        final chats = snapshot.data as List<Chat>;
        if (chats.isEmpty) {
          return _buildEmpty();
        }
        return ListView.builder(
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
        );
      },
    );
  }

  //todo faire l'appel api pour récupérer les conversations
  Future<List<Chat>> loadChats() {
    /*return Future.value([
      Chat(
        conversationId: 1,
        convname: 'Conversation 1',
      ),
      Chat(
        conversationId: 2,
        convname: 'Conversation 2',
      ),
      Chat(
        conversationId: 3,
        convname: 'Conversation 3',
      ),
    ]);*/
    return SecureStorage.get('benef_id').then((value) => getChats(value!));
  }

  static Future<List<Chat>> getChats(String benefId) async {
    final response = await HttpRequests.get('/chat/conversations/$benefId');

    switch (response.statusCode) {
      case 200:
        final list = <Chat>[];
        for (final element in jsonDecode(response.body) as List<dynamic>) {
          list.add(Chat.decode(element as Map<String, dynamic>));
        }
        print(list);
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
            GestureDetector(
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
                )),
          ],
        ),
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
                //todo faire le champ de saisie pour le nom de la conversation
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nom de la conversation',
                  hintText: 'Entrez un nom de conversation',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom de conversation';
                  }
                  return null;
                },
              )
                //todo faire le champ de saisie pour le message de départ de la conv
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => {
                Navigator.pop(context),
                //todo faire l'appel api pour créer une conversation
              },
              child: const Text('Demander'),
            ),
          ],
        ),
      );
}
