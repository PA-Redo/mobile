import 'package:flutter/material.dart';
import 'package:pa_mobile/core/model/chat.dart';
import 'package:pa_mobile/flows/authentication/ui/login_screen.dart';
import 'package:pa_mobile/shared/services/storage/jwt_secure_storage.dart';
import 'package:pa_mobile/shared/services/storage/stay_login_secure_storage.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  static const routeName = '/chat-list';

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
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

  Future<List<Chat>> loadChats() {
    return Future.value([
      Chat(1, 'test'),
      Chat(2, 'test2'),
    ]);
  }

  Widget _buildEmpty() {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat,
              color: Colors.redAccent,
              size: 150,
            ),
            SizedBox(height: 50),
            Text(
              'Vous n\'avez pas encore de conversation',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 60),
            //icon pour ajouter un conversation
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
      ),
    );
  }
}
