import 'package:flutter/material.dart';
import 'package:flutter_chat_fbase/helper/HelperFunctions.dart';
import 'package:flutter_chat_fbase/helper/SizeConfig.dart';
import 'package:flutter_chat_fbase/helper/UniversalVariables.dart';
import 'package:flutter_chat_fbase/page_widgets/profile_info.dart';

class UserCircle extends StatelessWidget {
  final String text;
  final bool isOnline;
  final double width;
  final double height;

  UserCircle(this.text, this.isOnline, {this.width = 40, this.height = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(7),
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: UniversalVariables.separatorColor,
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: UniversalVariables.lightBlueColor,
                fontSize: SizeConfig.getScreenBalancedFontSize((width + height) / 6),
              ),
            ),
          ),
          isOnline ? Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: UniversalVariables.blackColor, width: 2
                  ),
                  color: UniversalVariables.onlineDotColor
              ),
            ),
          ) : Container()
        ],
      ),
    );
  }
}

class UserViewCard extends StatelessWidget {
  final Map<String, dynamic> userData;
  final List<Widget> actions;
  final Function onTap;

  UserViewCard({@required this.userData, this.actions = const [], @required this.onTap});

  @override
  Widget build(BuildContext context) {
    final List<Widget> def = [
      GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => ProfileInfo(userInfo: userData)));
        },
        child: UserCircle(HelperFunctions.getUsernameForProfilePhoto(userData["name"]), true)
      ),
      Text(
        userData["name"],
        style: TextStyle(
          color: Colors.white,
          fontSize: SizeConfig.getScreenBalancedFontSize(20),
        ),
      ),
    ];
    def.addAll(actions);
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              children: def
            ),
          ],
        ),
      ),
    );
  }
}

class OptionsCard extends StatelessWidget {
  final List<Widget> actions;
  final Function onTap;

  OptionsCard({this.actions = const [], @required this.onTap});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                children: actions
            ),
          ],
        ),
      ),
    );
  }
}

Widget chatMessageItem(BuildContext context, Map<String, dynamic> snapshot) {
  return Container(
    margin: EdgeInsets.all(3),
    child: Container(
      alignment: snapshot["senderUid"] == Constants.uid
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: messageLayout(context, snapshot["message"], snapshot["senderUid"] == Constants.uid)
    ),
  );
}

Widget messageLayout(BuildContext context, String message, bool isSender) {
  Radius messageRadius = Radius.circular(10);

  return Container(
    margin: EdgeInsets.only(top: 12),
    constraints:
    BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
    decoration: BoxDecoration(
      color: Colors.grey,
      borderRadius: isSender ? BorderRadius.only(
        topLeft: messageRadius,
        topRight: messageRadius,
        bottomLeft: messageRadius,
      ) : BorderRadius.only(
        topLeft: messageRadius,
        topRight: messageRadius,
        bottomRight: messageRadius,
      )
    ),
    child: Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        message,
        style: TextStyle(
          fontSize: SizeConfig.getScreenBalancedFontSize(16)
        ),
      ),
    ),
  );
}