import 'package:chatapp/constantsFields.dart';
import 'package:chatapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'conversationScreen.dart';


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();
  QuerySnapshot searchSnapshot ;

  initiateSearch()
  {
    databaseMethods.getUserByUsername(searchTextEditingController.text).then((val){
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  Widget searchList()
  {
    return searchSnapshot != null ? ListView.builder(
      shrinkWrap: true,
      itemCount: searchSnapshot.documents.length,
      itemBuilder: (context, index){
        return SearchTile(
          username: searchSnapshot.documents[index].data["name"],
          email: searchSnapshot.documents[index].data["email"],
        );
      }
    ): Container();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  createChatRoomAndStartConversation(String username)
  {
    String chatRoomId = getChatRoomId(username, Constants.myName);

    List <String> users = [username , Constants.myName];
    Map <String , dynamic > chatRoomMap = {
      "users": users,
      "chatroomId" : chatRoomId
    };
    databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => new ConversationScreen(chatRoomId)
    ));
  }

  Widget SearchTile ({String email, String username})
  {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(
                    fontSize: 17
                ),
              ),
              Text(
                email,
                style: TextStyle(
                    fontSize: 17
                ),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap:()
            {
              createChatRoomAndStartConversation(username);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(30)
              ),
              child: Text(
                'Message',
                style: TextStyle(
                    fontSize: 17
                ),),
            ),
          )
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchTextEditingController,
                    decoration: InputDecoration(
                      hintText: "Search Username...",
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: ()
                  {
                    initiateSearch();
                  },
                  child: Icon (Icons.search),
                ),
              ],
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}


getChatRoomId(String a, String b){
  if (a.substring(0,1).codeUnitAt(0) == b.substring(0,1).codeUnitAt(0))
    {
      if (a.substring(1,2).codeUnitAt(0) > b.substring(1,2).codeUnitAt(0))
      {
        return "$b\_$a";
      } else
      {
        return "$a\_$b";
      }
    }
  else if (a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0))
    {
      return "$b\_$a";
    } else
      {
        return "$a\_$b";
      }
}