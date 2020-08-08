import 'package:chatapplication/helper/constants.dart';
import 'package:chatapplication/services/database.dart';
import 'package:flutter/material.dart';


class ConversationScreen extends StatefulWidget {

  final String chatRoomId;

  ConversationScreen({this.chatRoomId});



  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageTextController = new TextEditingController();
  Stream messageStream;

  Widget chatMessageList()
  {
    return StreamBuilder(
      stream: messageStream,
      builder: (context,snapshot){
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context,index) {
              return MessageTile(snapshot.data.documents[index].data["message"], snapshot.data.documents[index].data["sendBy"]== Constants.myName);
        }): Container();
      }
    );
  }

  sendMessage(){
    if(messageTextController.text.isNotEmpty){
      Map<String, dynamic> messageMap ={
      "message" : messageTextController.text,
      "sendby" : Constants.myName,
        "time" : DateTime.now().millisecondsSinceEpoch,
    };
    databaseMethods.addConverstaionMessage(widget.chatRoomId, messageMap);
    messageTextController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getConverstaionMessage(widget.chatRoomId).then((val){
      setState(() {
        messageStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    title: Image.asset("assets/images/logo.png",height: 50,),
    centerTitle: true,

    leading: IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: (){Navigator.pop(context);}
    ),
    ),

    body: Container(
      child: Stack(
        children: [
             chatMessageList(),
             Container(alignment: Alignment.bottomCenter,
               child: Container(
                 alignment: Alignment.bottomCenter,
                   child: Container(
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
                                    controller: messageTextController,
                                    decoration: InputDecoration(
                                    hintText: "Message ...",
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
                                sendMessage();
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


               ),
             ),
          ],
      ),
     )
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;

  MessageTile(this.message,this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.only(left: isSendByMe?0:24,right:isSendByMe?24:0 ),
      margin:  EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,

      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),

        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe ? [
              const Color(0xff007EF4),
              const Color(0xff2A75Bc),
            ]
                : [
                  const Color(0x1AFFFFFF),
              const Color(0x1AFFFFFF),

            ]
          ),
        ),
        child: Text(message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),),
      ),
    );
  }
}
