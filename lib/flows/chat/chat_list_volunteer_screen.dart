import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pa_mobile/core/model/chat.dart';
import 'package:pa_mobile/core/model/create_chat_dto.dart';
import 'package:pa_mobile/flows/authentication/ui/login_screen.dart';
import 'package:pa_mobile/shared/services/request/http_requests.dart';
import 'package:pa_mobile/shared/services/storage/jwt_secure_storage.dart';
import 'package:pa_mobile/shared/services/storage/secure_storage.dart';
import 'package:pa_mobile/shared/services/storage/stay_login_secure_storage.dart';

class ChatListVolunteerScreen extends StatefulWidget {
  const ChatListVolunteerScreen({Key? key}) : super(key: key);

  static const routeName = '/chat-list-volunteer';

  @override
  State<ChatListVolunteerScreen> createState() => _ChatListVolunteerScreenState();
}

class _ChatListVolunteerScreenState extends State<ChatListVolunteerScreen> {

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
                  '/chat_volunteer',
                  arguments: chat,
                );
              },
            );
          },
        ),
      ],
    );
  }


  static Future<List<Chat>> loadChats() async {
    final response = await HttpRequests.get('/chat/conversations');

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
              "Vous n'avez pas encore de conversation",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
