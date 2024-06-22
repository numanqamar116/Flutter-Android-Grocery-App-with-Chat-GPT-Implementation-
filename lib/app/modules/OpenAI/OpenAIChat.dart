import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OpenAIChat extends StatefulWidget {
  @override
  _OpenAIChatState createState() => _OpenAIChatState();
}

class _OpenAIChatState extends State<OpenAIChat> {
  int num = 0;

  TextEditingController _textEditingController = TextEditingController();
  List<ChatMessage> _messages = [];

  List<String> conversationHistory = [];

  @override
  void initState() {
    super.initState();
    _sendInitialCommand();
  }

  Future<void> _sendInitialCommand() async {
    _textEditingController.text = '''this is our database

| ID | Product Name        | Price per Kilogram (\$) |
|----|---------------------|-------------------------|
| 1  | Bell Pepper Red     | 5.99                    |
| 2  | Lamb Meat           | 44.99                   |
| 3  | Arabic Ginger       | 4.99                    |
| 4  | Fresh Lettuce       | 3.99                    |
| 5  | Butternut Squash    | 8.99                    |
| 6  | Organic Carrots     | 5.99                    |
| 7  | Fresh Broccoli      | 3.99                    |
| 8  | Cherry Tomato       | 5.99                    |
| 9  | Fresh Spinach       | 2.99                    |''';
    await _sendMessage();
  }

  Future<void> _sendMessage() async {
    final String apiKey = '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';
    final String endpoint = 'https://api.openai.com/v1/engines/text-davinci-003/completions';

    final String prompt = _textEditingController.text;
     _textEditingController.clear();
    conversationHistory.add(prompt);

    final http.Response response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'prompt': conversationHistory.join("\n"), // Send entire conversation history
        'max_tokens': 150,
      }),
    );

    _textEditingController.clear();
    conversationHistory.add('was my last message related to given database?');

          final http.Response response1 = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'prompt': conversationHistory.join("\n"), // Send entire conversation history
        'max_tokens': 150,
      }),
    );
    




    if (response.statusCode == 200 && num>0 && jsonDecode(response1.body)['choices'][0]['text'].toString().contains('yes')) {
            debugPrint('hello world');
      setState(() {
        _messages.add(UserMessage(prompt));
        _messages.add(AIMessage(jsonDecode(response.body)['choices'][0]['text']));
      });
    } else {
      print('Failed to get response. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
    num = 1;
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OpenAI Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _messages[index];
                },
              ),
            ),
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(labelText: 'Type a mess'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await _sendMessage();
                _textEditingController.clear();
              },
              child: Text('Sed'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  ChatMessage(this.text, {this.isUser = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class UserMessage extends ChatMessage {
  UserMessage(String text) : super(text, isUser: true);
}

class AIMessage extends ChatMessage {
  AIMessage(String text) : super(text);
}
