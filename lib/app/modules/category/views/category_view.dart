import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../components/no_data.dart';
// import '../controllers/category_controller.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:io';


import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import 'package:uuid/uuid.dart';

// 

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _MyAppState();
}

class _MyAppState extends State<CategoryView> {
  @override
  Widget build(BuildContext context) => const MaterialApp(
     
    
    debugShowCheckedModeBanner: false,
        home: ChatPage(),
      );
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
   int nums=0;
  
  List<types.Message> _messages = [];
  List<String> conversationHistory = [];
   List<String> conversationHistory1 = [];
  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );

  @override
  void initState() {
    super.initState();

    
   
String initCMD='''this is our database

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
| 9  | Fresh Spinach       | 2.99                    |
analyze it
''';


    final receivedMessage1 = types.TextMessage(
        author: const types.User(
          id: 'some_other_user_id',
        ),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: "Ask me Anything Like ...", // Extract the generated text from the response
      );
      final receivedMessage2 = types.TextMessage(
        author: const types.User(
          id: 'some_other_user_id',
        ),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: "What is price of 1kg of tomato?", // Extract the generated text from the response
      );
      final receivedMessage3 = types.TextMessage(
        author: const types.User(
          id: 'some_other_user_id',
        ),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: "Make total bill (by mentioning products)", // Extract the generated text from the response
      );

        final receivedMessage4 = types.TextMessage(
        author: const types.User(
          id: 'some_other_user_id',
        ),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: """
--Available Products
1. Bell Pepper Red
2. Lamb Meat
3. Arabic Ginger
4. Fresh Lettuce
5. Butternut Squash
6. Organic Carrots
7. Fresh Broccoli
8. Cherry Tomato
9. Fresh Spinach
""", // Extract the generated text from the response
      );
      _handleReceivedMessage(receivedMessage1);
      _handleReceivedMessage(receivedMessage2);
      _handleReceivedMessage(receivedMessage3);
      _handleReceivedMessage(receivedMessage4);
      


    _sendMessageToOpenAI(initCMD);
  }

  Future<void> _sendMessageToOpenAI(String message) async {
    final endpoint = 'https://api.openai.com/v1/engines/text-davinci-003/completions';
    final apiKey = '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';
      final String apiKey2 = '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';
  
    print('message'+message);

    conversationHistory.add(message);

    
try{
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'prompt': conversationHistory.join("\n"),
        'max_tokens': 300, // Adjust as needed
      }),
    );


      
       conversationHistory1.add('Is this message (`$message`) related to this database \n'
'''this is our database

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
| 9  | Fresh Spinach       | 2.99                    |'''
);

 final http.Response response1 = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey2',
      },
      body: jsonEncode({
        'prompt': conversationHistory1.join("\n"), // Send entire conversation history
        'max_tokens': 300,
      }),
    );


      
      print("response1"+jsonDecode(response.body)['choices'][0]['text'].toString().toUpperCase());
      print("response2"+jsonDecode(response1.body)['choices'][0]['text'].toString().toUpperCase());
      print(message.toUpperCase().contains('bill'));


print('nums ki value $nums');
    if (response.statusCode == 200 && nums>0 && jsonDecode(response1.body)['choices'][0]['text'].toString().toUpperCase().contains('YES') || message.toUpperCase().contains('BILL')) {
      final receivedMessage = types.TextMessage(
        author: const types.User(
          id: 'some_other_user_id',
        ),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: jsonDecode(response.body)['choices'][0]['text'], // Extract the generated text from the response
      );
print(receivedMessage.text);
  print('helo value $nums');
    if(nums!=0){
      _handleReceivedMessage(receivedMessage);
      
    }
    
    } else {
      if(nums>0){

                 final receivedMessage = types.TextMessage(
        author: const types.User(
          id: 'some_other_user_id',
        ),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: 'sorry i cant understand command make sure the command is relative to this grocery app (rewrite the command clearly if you think i m wrong)', // Extract the generated text from the response
      );


        _handleReceivedMessage(receivedMessage);

      }

      print('Failed to send message to OpenAI GPT-3 API');
      
    }
    nums=1;
}
catch(e){



  print('Exception $e');
}
  }


  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleReceivedMessage(types.Message receivedMessage) {
    setState(() {
      _messages.insert(0, receivedMessage);
    });
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    // Handle message tap if needed
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {

      
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);

    // Send the user's message to the OpenAI GPT-3 API
    print("kutttttt"+message.text);
    _sendMessageToOpenAI(message.text);
    }
    
  

  @override
  Widget build(BuildContext context) => Scaffold(
  appBar: AppBar(
  backgroundColor: Colors.white70,
  title: const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Icon(
        Icons.chat_bubble_outline, // Replace with your chatbot icon
        color: Colors.green,
      ),
      SizedBox(width: 8), // Adjust the spacing between icon and text
      Text(
        'Grocery AI Chatbot',
        style: TextStyle(
          color: Colors.green,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold
        ),
      ),
    ],
  ),
),
        body: Container(
          color: Colors.red,
          child: Chat(
            messages: _messages,
            onMessageTap: _handleMessageTap,
            onPreviewDataFetched: _handlePreviewDataFetched,
            onSendPressed: _handleSendPressed,
            showUserAvatars: true,
            showUserNames: true,
            user: _user,
            theme: DefaultChatTheme(inputBackgroundColor: Colors.green,
            userAvatarImageBackgroundColor: Colors.lightGreen),
           
            
          
          ),
        ),
     
        
      );

      

}