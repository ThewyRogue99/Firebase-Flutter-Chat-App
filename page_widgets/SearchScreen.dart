import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_fbase/helper/HelperFunctions.dart';
import 'package:flutter_chat_fbase/helper/SizeConfig.dart';
import 'package:flutter_chat_fbase/helper/UniversalVariables.dart';
import 'package:flutter_chat_fbase/objects/user_objects.dart';
import 'package:flutter_chat_fbase/services/database.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchController = TextEditingController();

  DatabaseMethods _databaseMethods = DatabaseMethods();
  static QuerySnapshot searchSnapshot;
  static String uid;
  
  initiateSearch() async{
    _databaseMethods.getUserByName(searchController.text).then((value){
      setState(() {
        searchSnapshot = value;
      });
    });
  }

  Widget searchList() {
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.docs.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> userData = searchSnapshot.docs[index].data();
          return userData["uid"] != Constants.uid ? UserSearchCard(
            username: userData["name"],
            email: userData["email"],
          ) : Container();
        }
    ) : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leadingWidth: 30,
        title: TextField(
          controller: searchController,
          onChanged: (text){
            initiateSearch();
          },
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.all(12),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            fillColor: Colors.white,
            filled: true
          ),
        )
      ),
      body: searchList(),
    );
  }
}

class UserSearchCard extends StatelessWidget {
  final String username;
  final String email;

  final DatabaseMethods _databaseMethods = DatabaseMethods();

  UserSearchCard({this.username, this.email});

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
      child: Row(
        children: [
          UserCircle(HelperFunctions.getUsernameForProfilePhoto(username), false),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeConfig.getScreenBalancedFontSize(20),
                ),
              ),
              SizedBox(height: 2),
              Text(
                email,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: SizeConfig.getScreenBalancedFontSize(17)
                ),
              ),
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  _databaseMethods.sendFriendRequest(email);
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.add,
                    color: UniversalVariables.lightBlueColor,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}