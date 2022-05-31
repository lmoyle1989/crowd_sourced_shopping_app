import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// global variables
String testText = '';
int? getUserId;

class LiveFeedScreen extends StatelessWidget {
  const LiveFeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatScreen(),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({required this.name, required this.text, Key? key})
      : super(key: key);
  final String text;
  final String name;

  // creates the avatar and sets up the user's name as it will be displayed on the screen
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: Text(name[0])),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: Theme.of(context).textTheme.headline6),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  static const herokuUri =
      'https://crowd-sourced-shopping-cs467.herokuapp.com/';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages =
      []; //holds the messaages that appear on screen after opening the app and when the user enters a new message
  final _textController =
      TextEditingController(); // reads the string and clears the section after submitting
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  Widget _buildTextComposer() {
    // builds the section to add a comment and print it to the app
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (text) {
                  setState(() {
                    _isComposing = text.isNotEmpty;
                  });
                },
                onSubmitted: _isComposing ? _handleSubmitted : null,
                decoration:
                    const InputDecoration.collapsed(hintText: 'Add a comment'),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                // passes the text to the handleSubmitted function to clear
                onPressed: _isComposing
                    ? () => _handleSubmitted(_textController.text)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Flexible(
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            reverse: true,
            itemBuilder: (_, index) => _messages[index],
            itemCount: _messages.length,
          ),
        ),
        const Divider(height: 1.0),
        Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }

  void _handleSubmitted(String text) {
    // clears the text after submission
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    print("In the handleSubmitted fn");
    print("User text string" + text);
    testText = text;
    postComment();
    // adds a new comment to the _message list
    ChatMessage message = ChatMessage(
      name: 'ciarra murphy', // possible add query connection here
      text: text,
    );
    setState(() {
      _messages.insert(0, message);
    });
    _focusNode.requestFocus();
  }

  Future getData() async {
    // gets the route to the database to fill in the message list when the app opens
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    var retrieveId = preferences.getInt('user_id');
    getUserId = retrieveId;
    print("Below is the current user id of the person logged in");
    print(getUserId);
    //useUserId();
    http.Response response =
        await http.get(Uri.parse(ChatScreen.herokuUri + '/comments'));
    var data = jsonDecode(response.body);
    data.toString();
    for (var myMap = 0; myMap < data.length; myMap++) {
      _messages.add(ChatMessage(
          name: data[myMap]['first_name'] + ' ' + data[myMap]['last_name'],
          text: data[myMap]['comment'] + '  ' + data[myMap]['date']));
    }
  }

  Future postComment() async {
    // posts the comment entered in the TextField to the UserComments table in database
    print("Test text string" + testText);
    String send_comment = ChatScreen.herokuUri +
        '/comments?user_id=$getUserId&new_comment=$testText';
    http.Response response = await http.post(Uri.parse(send_comment));
  }

  // useUserId() async {

  // }

  @override
  void initState() {
    getData();
  }
}
