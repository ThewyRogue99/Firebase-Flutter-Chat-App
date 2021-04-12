import 'package:flutter/material.dart';
import 'package:flutter_chat_fbase/helper/HelperFunctions.dart';
import 'package:flutter_chat_fbase/helper/SizeConfig.dart';
import 'package:flutter_chat_fbase/objects/user_objects.dart';

class ProfileInfo extends StatelessWidget {
  final Map<String, dynamic> userInfo;

  ProfileInfo({@required this.userInfo});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(userInfo["name"]),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(height: 30),
                UserCircle(
                  HelperFunctions.getUsernameForProfilePhoto(userInfo["name"]),
                  false,
                  width: 100,
                  height: 100,
                ),
                SizedBox(height: 20),
                OptionsCard(
                  onTap: () {},
                  actions: [
                    Text(
                      "Name: " + userInfo["name"],
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: SizeConfig.getScreenBalancedFontSize(20)
                      ),
                    )
                  ],
                ),
                SizedBox(height: 30),
                OptionsCard(
                  onTap: () {},
                  actions: [
                    Text(
                      "Email: " + userInfo["email"],
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: SizeConfig.getScreenBalancedFontSize(20)
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
