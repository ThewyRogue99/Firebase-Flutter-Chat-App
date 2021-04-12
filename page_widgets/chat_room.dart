import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_fbase/helper/HelperFunctions.dart';
import 'package:flutter_chat_fbase/helper/SizeConfig.dart';
import 'package:flutter_chat_fbase/helper/UniversalVariables.dart';
import 'package:flutter_chat_fbase/helper/message_handler.dart';
import 'package:flutter_chat_fbase/objects/user_objects.dart';
import 'package:flutter_chat_fbase/services/database.dart';

class ChatRoom extends StatefulWidget {
  final Map<String, dynamic> userInfo;

  ChatRoom(this.userInfo);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  FocusNode textFieldFocusNode = FocusNode();

  DatabaseMethods _databaseMethods = DatabaseMethods();
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme
            .of(context)
            .backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .primaryColor,
          leadingWidth: 20,
          title: Row(
            children: [
              UserCircle(HelperFunctions.getUsernameForProfilePhoto(
                  widget.userInfo["name"]), true),
              Text(widget.userInfo["name"])
            ],
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.call),
                onPressed: () {}
            ),
            IconButton(
                icon: Icon(Icons.video_call),
                onPressed: () {}
            )
          ],
        ),
        body: messageListView()
    );
  }

  Widget messageListView() {
    return SingleChildScrollView(
      child: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight - 80,
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Users")
                        .doc(Constants.uid)
                        .collection("ChatRooms")
                        .doc(HelperFunctions.createChatRoomId(
                        Constants.uid, widget.userInfo["uid"]))
                        .collection("Chats")
                        .orderBy("date", descending: false)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData && snapshot.data.size > 0) {
                        count = snapshot.data.docs.length;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 250),
                              curve: Curves.easeInOut
                          );
                        });
                        return ListView.builder(
                            shrinkWrap: true,
                            controller: _scrollController,
                            padding: EdgeInsets.all(5),
                            itemCount: count,
                            itemBuilder: (context, index) {
                              return handleMessage(context, snapshot.data
                                  .docs[index].data());
                            }
                        );
                      }
                      else
                        return Container();
                    }
                )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: textFieldFocusNode,
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: "Send message..",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50)
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme
                            .of(context)
                            .primaryColor,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          if (_messageController.text.isNotEmpty) {
                            _databaseMethods.sendMessage(
                                _messageController.text,
                                widget.userInfo);
                            _messageController.clear();
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}