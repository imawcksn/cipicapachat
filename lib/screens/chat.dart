import 'package:cipicapachat/widgets/chat_messages.dart';
import 'package:cipicapachat/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Guest Talk!'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              // Custom action on back button press
              // For example, pop twice to go back to the home screen
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout),
              color: Theme.of(context).colorScheme.primary,
            )
          ],
        ),
        body: const Column(
          children: [Expanded(child: ChatMessages()), NewMessage()],
        ));
  }
}
