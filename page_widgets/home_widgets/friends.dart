import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_fbase/helper/SizeConfig.dart';
import 'package:flutter_chat_fbase/helper/UniversalVariables.dart';
import 'package:flutter_chat_fbase/objects/user_objects.dart';
import '../chat_room.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(Constants.uid)
            .collection("Friends")
            .where("name", isNotEqualTo: "")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData && snapshot.data.size > 0) {
            count = snapshot.data.docs.length;
            return ListView.builder(
              itemCount: count,
              itemBuilder: (context, index){
                Map<String, dynamic> userData = snapshot.data.docs[index].data();
                return UserViewCard(
                  onTap: () {},
                  userData: userData,
                  actions: [
                    Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ChatRoom(userData)
                              ));
                            },
                            child: Icon(
                              Icons.message,
                              color: UniversalVariables.separatorColor,
                              size: SizeConfig.getScreenBalancedFontSize(30),
                            ),
                          ),
                        )
                    )
                  ],
                );
              }
            );
          }
          else
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person,
                  size: 100,
                  color: UniversalVariables.separatorColor,
                ),
                Text(
                  "No friends available",
                  style: TextStyle(
                    fontSize: SizeConfig.getScreenBalancedFontSize(15),
                    color: UniversalVariables.separatorColor
                  ),
                )
              ],
            );
        }
    );
  }
}