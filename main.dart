import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_fbase/helper/HelperFunctions.dart';
import 'package:flutter_chat_fbase/helper/UniversalVariables.dart';
import 'package:flutter_chat_fbase/page_widgets/HomePage.dart';
import 'package:flutter_chat_fbase/page_widgets/login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isLoggedIn;

  @override
  void initState(){
    getUserLoggedIn();
    super.initState();
  }

  getUserLoggedIn() async{
    await HelperFunctions.getUserLoggedIn().then((value){
      if(value == null)
        value = false;
      setState(() {
        _isLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: UniversalVariables.blackColor,
        primaryColor: UniversalVariables.lightBlueColor,
        accentColor: UniversalVariables.separatorColor
      ),
      home: _isLoggedIn != null ? _isLoggedIn ? HomePage() : LogIn() : Center(child: CircularProgressIndicator())
    );
  }
}