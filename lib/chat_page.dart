import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'open_ai/open_ai_chat_bot_service.dart';

class ChatPage extends StatefulWidget {
  final response;

  ChatPage(this.response);

  @override
  _ChatPageState createState() => _ChatPageState(this.response);
}
class _ChatPageState extends State<ChatPage> {
  List<types.Message> messages = [];
  final response;

  _ChatPageState(this.response);


  final user = types.User(id: 'user_123');
  final uuid = Uuid();
  final OpenAIChatBotService _openAIChatBotService = OpenAIChatBotService();

  @override
  void initState() {
    super.initState();
    loadMessages();
    firstMessage();

  }

  Future<void> firstMessage() async {
    try {
      final responseText = await widget.response;
      final msg = types.TextMessage(
        author: types.User(id: 'gpt'),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: 'gpt',
        text: responseText,
      );
      bool messageExists = messages.any((message) => message.id == msg.id);

      if (!messageExists) {
        setState(() {
          messages.insert(0, msg);
        });
        await saveMessages();
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesString = prefs.getString('chat_messages');
    if (messagesString != null) {
      final messagesJson = json.decode(messagesString) as List;
      setState(() {
        messages = messagesJson.map((message) => types.TextMessage.fromJson(message)).toList();
      });
    }
  }

  Future<void> saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = messages.map((message) => message.toJson()).toList();
    await prefs.setString('chat_messages', json.encode(messagesJson));
  }

  Future<void> sendMessage(String text) async {
    final userMessage = types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: uuid.v4(),
      text: text,
    );

    setState(() {
      messages.insert(0, userMessage);
    });
    await saveMessages();

    final response = await _openAIChatBotService.createModel(text);
    final gptMessage = types.TextMessage(
      author: types.User(id: 'gpt'),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: uuid.v4(),
      text: response,
    );

    setState(() {
      messages.insert(0, gptMessage);
    });
    await saveMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("단단이"),
      ),
      body: Chat(
        messages: messages,
        onSendPressed: (types.PartialText message) {
          sendMessage(message.text);
        },
        user: user,
        theme: DefaultChatTheme(
          inputBackgroundColor: Colors.grey.shade800,
          inputTextColor: Colors.white,
        ),
      ),
    );
  }
}