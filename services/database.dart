import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_fbase/helper/HelperFunctions.dart';
import 'package:flutter_chat_fbase/helper/UniversalVariables.dart';
import 'package:intl/intl.dart';

class DatabaseMethods{

  Future<QuerySnapshot> getUserByName(String username) async{
    return await FirebaseFirestore.instance.collection("Users").where("name", isEqualTo: username).get();
  }

  Future<QuerySnapshot> getUserByEmail(String email) async{
    return await FirebaseFirestore.instance.collection("Users").where("email", isEqualTo: email).get();
  }
  
  Future<String> getUserUidByEmail(String email) async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("Users").where("email", isEqualTo: email).get();
    
    if(snapshot.docs.length != 0)
      return snapshot.docs[0].data()["uid"];
    else
      return null;
  }

  Future<bool> userExists(String username) async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("Users").where("name", isEqualTo: username).get();

    if(snapshot.size != 0)
      return true;
    else
      return false;
  }

  Future<bool> isFriend(String uid) async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(Constants.uid)
        .collection("Friends")
        .where("uid", isEqualTo: uid)
        .get();

    if(snapshot.size != 0)
      return true;
    else
      return false;
  }

  saveUserInfo(userInfo){
    FirebaseFirestore.instance.collection("Users").doc(userInfo["uid"]).set(userInfo);
  }

  sendMessage(String message, Map<String, dynamic> userInfo) async{
    bool isFriend = await this.isFriend(userInfo["uid"]);
    if(isFriend) {
      String time = DateFormat("dd/MM/yy hh:mm").format(DateTime.now());
      Map<String, dynamic> messageMap = {
        "message": message,
        "type": "text",
        "senderUid": Constants.uid,
        "receiverUid": userInfo["uid"],
        "date": FieldValue.serverTimestamp()
      };

      await this.createChatRoom(userInfo, {"user1": Constants.getMap(), "user2": userInfo});

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(Constants.uid)
          .collection("ChatRooms")
          .doc(HelperFunctions.createChatRoomId(Constants.uid, userInfo["uid"]))
          .collection("Chats")
          .add(messageMap);

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userInfo["uid"])
          .collection("ChatRooms")
          .doc(HelperFunctions.createChatRoomId(Constants.uid, userInfo["uid"]))
          .collection("Chats")
          .add(messageMap);
    }
  }

  createChatRoom(Map<String, dynamic> userInfo, Map<String, dynamic> chatRoomMap) async{
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(userInfo["uid"])
        .collection("ChatRooms")
        .doc(HelperFunctions.createChatRoomId(Constants.uid, userInfo["uid"]))
        .set(chatRoomMap);

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(Constants.uid)
        .collection("ChatRooms")
        .doc(HelperFunctions.createChatRoomId(Constants.uid, userInfo["uid"]))
        .set(chatRoomMap);
  }

  sendFriendRequest(String emailToAdd) async{
    String uid = await this.getUserUidByEmail(emailToAdd);
    String time = DateFormat("dd/MM/yy hh:mm").format(DateTime.now());
    Map<String, dynamic> data = {"name": Constants.username, "email": Constants.email, "uid": Constants.uid, "date": time};
    FirebaseFirestore.instance.collection("Users").doc(uid).collection("FriendRequests").doc(Constants.uid).set(data);
  }

  acceptFriendRequest(Map<String, String> userInfo) async{
    Map<String, String> data = {"name": Constants.username, "email": Constants.email, "uid": Constants.uid};
    await FirebaseFirestore.instance.collection("Users").doc(userInfo["uid"]).collection("Friends").doc(Constants.uid).set(data);
    await FirebaseFirestore.instance.collection("Users").doc(Constants.uid).collection("Friends").doc(userInfo["uid"]).set(userInfo);
    await FirebaseFirestore.instance.collection("Users").doc(Constants.uid).collection("FriendRequests").doc(userInfo["uid"]).delete();
  }

  rejectFriendRequest(String userUid) async{
    await FirebaseFirestore.instance.collection("Users").doc(Constants.uid).collection("FriendRequests").doc(userUid).delete();
  }
}