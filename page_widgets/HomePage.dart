import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_fbase/helper/HelperFunctions.dart';
import 'package:flutter_chat_fbase/helper/SizeConfig.dart';
import 'package:flutter_chat_fbase/helper/UniversalVariables.dart';
import 'package:flutter_chat_fbase/objects/user_objects.dart';
import 'package:flutter_chat_fbase/page_widgets/SearchScreen.dart';
import 'package:flutter_chat_fbase/page_widgets/home_widgets/friends.dart';
import 'package:flutter_chat_fbase/page_widgets/home_widgets/requests.dart';
import 'package:flutter_chat_fbase/page_widgets/login.dart';
import 'package:flutter_chat_fbase/page_widgets/profile_info.dart';
import 'package:flutter_chat_fbase/services/auth.dart';
import 'package:flutter/foundation.dart';
import 'chat_room.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController = PageController();
  int _page = 0;
  bool isInit = false;

  AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context){
    setLoading();
    return isInit ? Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Chat App"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => SearchScreen()
              ));
            },
          )
        ],
      ),
      drawer: Drawer(
          child: Column(
            children: [
              Container(
                width: 310,
                height: 220,
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).accentColor,
                    )
                  )
                ),
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ProfileInfo(userInfo: Constants.getMap())));
                      },
                      child: UserCircle(
                        HelperFunctions.getUsernameForProfilePhoto(Constants.username),
                        false,
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Text(
                      Constants.username,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: SizeConfig.getScreenBalancedFontSize(20)
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      Constants.email,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: SizeConfig.getScreenBalancedFontSize(15)
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).backgroundColor,
                  child: Column(
                    children: [
                      OptionsCard(
                        actions: [
                          Icon(
                            Icons.logout,
                            color: Colors.grey,
                            size: 33,
                          ),
                          Text(
                            "Log out",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: SizeConfig.getScreenBalancedFontSize(18)
                            ),
                          )
                        ],
                        onTap: () {
                          _authMethods.signOut();
                          HelperFunctions.saveUserLoggedIn(false);
                          Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (context) => LogIn()));
                        }
                      )
                    ],
                  ),
                ),
              )
            ],
          )
      ),
      body: PageView(
        children: [
          getChats(),
          FriendsPage(),
          Center(child: Text("Calls")),
          RequestsPage()
        ],
        controller: _pageController,
        onPageChanged: (page) {setState(() {_page = page;});}
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).accentColor
            )
          )
        ),
        child: CupertinoTabBar(
          backgroundColor: Theme.of(context).backgroundColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.chat,
                color: _page == 0 ? Colors.lightBlue : Colors.grey,
              )
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: _page == 1 ? Colors.lightBlue : Colors.grey,
              )
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.call,
                color: _page == 2 ? Colors.lightBlue : Colors.grey,
              )
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: 40,
                height: 40,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.person_add,
                        color: _page == 3 ? Colors.lightBlue : Colors.grey,
                      ),
                    ),
                    getRequest()
                  ],
                ),
              ),
            ),
          ],
          onTap: (index){
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 350),
              curve: Curves.easeInOut
            );
          },
          currentIndex: _page,
        ),
      ),
    ) : Center(child: CircularProgressIndicator());
  }

  setLoading() async{
    await Constants.init();
    SizeConfig.init(context);

    setState(() {
      isInit = true;
    });
  }

  Widget getRequest(){
    int requestCount = 0;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(Constants.uid)
            .collection("FriendRequests")
            .where("name", isNotEqualTo: "")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData && snapshot.data.size > 0) {
            requestCount = snapshot.data.docs.length;
            return requestCount != 0 ? Align(
                alignment: Alignment.topRight,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle
                  ),
                  child: Container(
                    padding: EdgeInsets.all(2),
                    child: Text(
                      "+" + requestCount.toString(),
                      style: TextStyle(
                        fontSize: 10
                      ),
                    ),
                  ),
                )
            ) : Container();
          }
          else
            return Container();
        }
    );
  }

  Widget getChats(){
    int count = 0;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(Constants.uid)
            .collection("ChatRooms")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if (snapshot.hasData && snapshot.data.size > 0) {
            count = snapshot.data.docs.length;
            return ListView.builder(
              itemCount: count,
              itemBuilder: (context, index){
                Map<String, dynamic> temp = snapshot.data.docs[index].data();
                Map<String, dynamic> userData = mapEquals(temp["user1"], Constants.getMap()) ? temp["user2"] : temp["user1"];
                return UserViewCard(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ChatRoom(userData)
                    ));
                  },
                  userData: userData
                );
              }
            );
          }
          else
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat,
                  size: 100,
                  color: UniversalVariables.separatorColor,
                ),
                Text(
                  "No chats available",
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