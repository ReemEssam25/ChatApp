import 'package:chatapp/constantsFields.dart';
import 'package:chatapp/helper/helperFunctions.dart';
import 'package:chatapp/mainScreens/conversationScreen.dart';
import 'package:chatapp/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/services/auth.dart';
import 'signIn.dart';
import 'searchScreen.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRoomsStream;

  Widget ChaRoomList()
  {
    return StreamBuilder(
      stream:  chatRoomsStream,
      builder: (context, snapshot){
        return snapshot.hasData? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index){
            return ChatRoomTile(snapshot.data.documents[index].data["chatroomId"].toString()
            .replaceAll("_", "").replaceAll(Constants.myName, ""), snapshot.data.documents[index].data["chatroomId"]);
          },
        ): Container();
      }
    );
  }

  @override
  void initState() {
    //getUserInfo();
    databaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomsStream = value;
      });
    });
    super.initState();
  }

  /*getUserInfo() async{
    Constants.myName =await HelperFunctions.getUserNameSharedPreference().toString();
    print( Constants.myName +"  reeeeeeeeeeeeeeeeeeeeeeee");
    setState(() {

    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
        actions: [
          GestureDetector(
            onTap: (){
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context)=> SignIn()
              ));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.exit_to_app,),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => SearchScreen()
          ));
        },
        child: Icon(Icons.search),
      ),
      body: ChaRoomList(),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  const ChatRoomTile(this.userName, this.chatRoomId) ;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ConversationScreen(chatRoomId)));
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.blueAccent
                  ),
                  child: Text("${userName.substring(0,1).toUpperCase()}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: 16,),
                Text(userName,
                  style: TextStyle(
                    fontSize: 20,
                ),)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

