import 'dart:convert';

import 'package:cipicapachat/screens/chat.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, ChatModel>((ref) {
  return ChatNotifier();
});

class ChatModel {
  final List<String> messages;

  ChatModel(this.messages);
}

class ChatNotifier extends StateNotifier<ChatModel> {
  ChatNotifier() : super(ChatModel([]));

  void addMessage(String message) {
    state = ChatModel([...state.messages, message]);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Chatbot App'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const ChatScreen(),
                  ));
                },
                icon: const Icon(Icons.message))
          ],
        ),
        body: Column(
          children: [
            const Expanded(
              child: ConversationWidget(),
            ),
            InputWidget(),
          ],
        ),
      ),
    );
  }
}

class ConversationWidget extends ConsumerWidget {
  const ConversationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chat = ref.watch(chatProvider);

    return ListView(
      reverse: true, // Display the latest messages at the bottom
      children: [
        for (final message in chat.messages.reversed)
          ChatBubble(message: message),
      ],
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;

  const ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUserMessage = message.startsWith('You: ');

    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isUserMessage ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: SelectableText(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class InputWidget extends ConsumerWidget {
  final TextEditingController _textController = TextEditingController();

  InputWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(hintText: 'Type a message...'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              _sendMessage(context, ref);
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage(BuildContext context, WidgetRef ref) async {
    final userInput = _textController.text;
    Map<String, dynamic> jsonData = {
      "messages": [
        {"id": "VjfeUJ5", "content": userInput, "role": "user"}
      ],
      "id": "VjfeUJ5",
      "previewToken": null,
      "userId": "b98ca8e8-7d50-4e37-84d7-c39b88662c6a",
      "codeModelMode": true,
      "agentMode": {},
      "trendingAgentMode": {},
      "isMicMode": false
    };

    if (userInput.isNotEmpty) {
      final chat = ref.read(chatProvider.notifier);
      chat.addMessage('You: $userInput');

      try {
        final response = await http.post(
          Uri.parse(
            'https://www.blackbox.ai/api/chat',
          ),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(jsonData),
        );

        if (response.statusCode == 200) {
          chat.addMessage(response.body);
        } else {
          throw Exception('Failed to get chatbot response');
        }
      } catch (error) {
        chat.addMessage('Error occurred while processing your request.');
      }

      _textController.clear();
    }
  }
}
