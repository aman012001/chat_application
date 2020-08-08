import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  getUserByUsername(String username) async{
   return await Firestore.instance.collection("users").where("name", isEqualTo: username).getDocuments();
  }
  getUserByUserEmail(String email) async{
    return await Firestore.instance.collection("users").where("email", isEqualTo: email).getDocuments();
  }

  uploadUserInfo(usermap){
    Firestore.instance.collection("users").add(usermap);
  }
  
  createChatRoom(String chatRoomId, chatRoomMap){
    Firestore.instance.collection("chatroom").document(chatRoomId).setData(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }

  addConverstaionMessage(String chatRoomId, messageMap){
    Firestore.instance.collection("chatroom").document(chatRoomId).collection("chats").add(messageMap).catchError((e){
      print(e.toString());
    });
  }

  getConverstaionMessage(String chatRoomId) async{
    return await Firestore.instance.collection("chatroom").document(chatRoomId).collection("chats").orderBy("time",descending: false).snapshots();
  }

  getChatRooms(String Username) async{
    return await Firestore.instance.collection("chatroom").where("users",arrayContains: Username).snapshots();
  }
}