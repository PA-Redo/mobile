import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  static const routeName = '/chat-list';

  @override
  Widget build(BuildContext context) {
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
