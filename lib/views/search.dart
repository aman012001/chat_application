import 'package:chatapplication/helper/Helper%20Function.dart';
import 'package:chatapplication/helper/constants.dart';
import 'package:chatapplication/services/database.dart';
import 'package:chatapplication/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'conversations.dart';

  class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

  class _SearchScreenState extends State<SearchScreen> {
    DatabaseMethods databaseMethods =new DatabaseMethods();
    TextEditingController searchTextEditingController = new TextEditingController();
    QuerySnapshot querySnapshot;


    initiateSearch() {
      databaseMethods.getUserByUsername(searchTextEditingController.text).then((val) {
        setState((){
          querySnapshot=val;
        });
      });
    }

  /// create a chatroom, send user to converstaion screen, push replacement
  createChatRoomAndStartConversation({String username}){

    if (username != Constants.myName) {
      String chatRoomId = getChatRoomId(username, Constants.myName);
      List<String> users =[username, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users" : users,
        "chatroomId" : chatRoomId,
      };
      DatabaseMethods().createChatRoom(chatRoomId,chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
        builder: (context) =>  ConversationScreen(chatRoomId: chatRoomId),
      ));
    }else{
      print("you cannot send the message to youself");
    }
  }

  Widget searchList(){
    return querySnapshot != null? ListView.builder(
        itemCount: querySnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
          return searchTile(userName: querySnapshot.documents[index].data["name"], userEmail: querySnapshot.documents[index].data["email"]);
        }) : Container();
  }

  Widget searchTile({String userName, String userEmail})
  {
    return Container(
      height: 80,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left:20.0, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(userName, style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),),
                Text(userEmail, style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),),

              ],
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatRoomAndStartConversation(username: userName);
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blue,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text("Message"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Color(0x54FFFFFF),
                ),

                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          controller: searchTextEditingController,
                          decoration: InputDecoration(
                            hintText: "Search Username...",
                            hintStyle: TextStyle(
                              color: Colors.white54,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: (){
                          initiateSearch();
                        },
                        child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0x36FFFFFF),
                                  const Color(0x0FFFFFFF)
                                ]
                              ),
                              borderRadius: BorderRadius.circular(200),
                            ),
                              child: Image.asset("assets/images/search--v2.png"),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  child: searchList()),
            ],
          )),
    );
  }
}


getChatRoomId(String a , String b)
{
  if(a.substring(0,1).codeUnitAt(0)>b.substring(0,1).codeUnitAt(0)){
    return "$b\_$a";
  } else{
    return "$a\_$b";
  }
}