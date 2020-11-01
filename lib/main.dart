import 'package:chatapp/helper/helperFunctions.dart';
import 'package:chatapp/mainScreens/chatRoomsScreen.dart';
import 'package:flutter/material.dart';
import 'mainScreens/signIn.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatefulWidget {
  @override
  _ChatAppState createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  bool userLoggedIn;

  @override
  void initState() {
    getLoggedIn();
    super.initState();
  }

  getLoggedIn ()
  async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme:AppBarTheme(
          color: Color(0xff213443),
        ),
      ),
      home: userLoggedIn != null ? ChatRoom() : SignIn(),
    );
  }
}

