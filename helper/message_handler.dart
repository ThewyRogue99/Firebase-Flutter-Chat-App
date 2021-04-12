import 'package:flutter/material.dart';
import 'package:flutter_chat_fbase/objects/user_objects.dart';

Widget handleMessage(BuildContext context, Map<String, dynamic> messageMap){
  if(messageMap["type"] == "text")
    return chatMessageItem(context, messageMap);
  else
    return Container();
}