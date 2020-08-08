import 'package:chatapplication/helper/Helper%20Function.dart';
import 'package:chatapplication/helper/authenticate.dart';
import 'package:chatapplication/helper/constants.dart';
import 'package:chatapplication/services/auth.dart';
import 'package:chatapplication/services/database.dart';
import 'package:chatapplication/views/conversations.dart';
import 'package:flutter/material.dart';
import 'search.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}


class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context,snapshot){
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context,index){
              return ChatroomTile(snapshot.data.documents[index].data["chatroomId"].toString().replaceAll("_", "").replaceAll(Constants.myName, ""),snapshot.data.documents[index].data["chatroomId"], );
            }):Container();
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    super.initState();
  }

  //Made a seperate function because we can't apply await on init and it will take some time to retrive data from th firestore
  getUserInfo() async {
    databaseMethods.getChatRooms(Constants.myName).then((val){
      setState(() {
        chatRoomStream=val;
      });
    });
    Constants.myName = await HelperFunction.getUserNameSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/logo.png",height: 50,),
        centerTitle: true,

        actions: <Widget>[
          GestureDetector(
            onTap: (){
              HelperFunction.saveUserLoggedInSharedPreference(false);
             authMethods.signOut();
             Navigator.pushReplacement(context, MaterialPageRoute(
               builder: (context) => Authenticate(),
             ));
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(Icons.exit_to_app),
            ),
          ),

        ],
      ),

      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
            child: Icon(Icons.search),
            onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => SearchScreen(),
            ));
            },
      ),
    );
  }
}
class ChatroomTile extends StatelessWidget {

  final String username;
  final String chatRoomId;
  ChatroomTile(this.username,this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId: chatRoomId),
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40)
              ),
              child: Text("${username.substring(0,1).toUpperCase()}"),
            ),
            SizedBox(width: 8,),

            Text("username"),
            Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  color: Colors.green)
            ),
          ])
        ),
      );
  }
}

