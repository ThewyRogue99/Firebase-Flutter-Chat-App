import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

class HelperFunctions{

  static String sharedPreferenceUserLoggedInKey = "USERLOGGEDINKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserUidKey = "USERUIDKEY";

  static Future<bool> saveUserLoggedIn(bool isLoggedIn) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedInKey, isLoggedIn);
  }

  static Future<bool> saveUserEmail(String email) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserEmailKey, email);
  }

  static Future<bool> saveUserName(String userName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<bool> saveUserUid(String uid) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserUidKey, uid);
  }

  static Future<bool> getUserLoggedIn() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String> getUserEmail() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserEmailKey);
  }

  static Future<String> getUserName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserNameKey);
  }

  static Future<String> getUserUid() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserUidKey);
  }

  static String createChatRoomId(String user1, String user2){
    return genHash(user1, user2);
  }

  static String genHash(String s1, String s2) {
    if (s1.compareTo(s2) > 0) return md5.convert(utf8.encode("$s1${s1.length}$s2${s2.length}")).toString();
    else return md5.convert(utf8.encode("$s2${s2.length}$s1${s1.length}")).toString();
  }

  static String getUsernameForProfilePhoto(String name){
    List<String> nameSplit = name.split(" ");
    String firstNameInitial = nameSplit[0][0];
    String lastNameInitial = "";
    if(nameSplit.length > 1)
      lastNameInitial = nameSplit[nameSplit.length - 1][0];

    return firstNameInitial + lastNameInitial;
  }
}