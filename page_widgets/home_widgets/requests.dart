import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_fbase/helper/HelperFunctions.dart';
import 'package:flutter_chat_fbase/helper/SizeConfig.dart';
import 'package:flutter_chat_fbase/helper/UniversalVariables.dart';
import 'package:flutter_chat_fbase/objects/user_objects.dart';
import 'package:flutter_chat_fbase/services/database.dart';

class RequestsPage extends StatefulWidget {
  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(Constants.uid)
            .collection("FriendRequests")
            .where("name", isNotEqualTo: "")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData && snapshot.data.size > 0) {
            count = snapshot.data.docs.length;
            return ListView.builder(
              itemCount: count,
              itemBuilder: (context, index){
                return UserRequestCard(userData: snapshot.data.docs[index].data());
              }
            );
          }
          else
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_add,
                  size: 100,
                  color: UniversalVariables.separatorColor,
                ),
                Text(
                  "No friend requests available",
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

class UserRequestCard extends StatelessWidget {
  final Map<String, dynamic> userData;

  final DatabaseMethods _databaseMethods = DatabaseMethods();

  UserRequestCard({this.userData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: UniversalVariables.blackColor,
          border: Border(
              bottom: BorderSide(
                  color: UniversalVariables.separatorColor
              )
          )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              UserCircle(HelperFunctions.getUsernameForProfilePhoto(userData["name"]), false),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData["name"],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.getScreenBalancedFontSize(20),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _databaseMethods.rejectFriendRequest(userData["uid"]);
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.person_remove,
                          color: UniversalVariables.lightBlueColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Map<String, String> cleanUserData = {"name": userData["name"], "email": userData["email"], "uid": userData["uid"]};
                        _databaseMethods.acceptFriendRequest(cleanUserData);
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.person_add,
                          color: UniversalVariables.lightBlueColor,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Text(
            userData["date"],
            style: TextStyle(
              color: Colors.grey
            ),
          )
        ],
      ),
    );
  }
}