import 'package:firebase_auth/firebase_auth.dart';

enum F_BASE_AUTH_ERROR{
  ERROR_INVALID_EMAIL,
  ERROR_USER_NOT_FOUND,
  ERROR_EMAIL_ALREADY_IN_USE,
  UNDEFINED_ERROR
}

class AuthMethods{

  F_BASE_AUTH_ERROR lastErrorCode;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> signInWithLoginInfo(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword
        (email: email, password: password);
      return result.user;
    }catch(error){
      switch (error.code) {
        case "invalid-email":
          lastErrorCode = F_BASE_AUTH_ERROR.ERROR_INVALID_EMAIL;
          break;
        case "wrong-password":
          lastErrorCode = F_BASE_AUTH_ERROR.ERROR_USER_NOT_FOUND;
          break;
        case "user-not-found":
          lastErrorCode = F_BASE_AUTH_ERROR.ERROR_USER_NOT_FOUND;
          break;
        default:
          lastErrorCode = F_BASE_AUTH_ERROR.UNDEFINED_ERROR;
      }
      return null;
    }
  }

  Future<User> signUpWithUserInfo(String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword
        (email: email, password: password);
      return result.user;
    }catch(error){
      switch (error.code) {
        case "invalid-email":
          lastErrorCode = F_BASE_AUTH_ERROR.ERROR_INVALID_EMAIL;
          break;
        case "wrong-password":
          lastErrorCode = F_BASE_AUTH_ERROR.ERROR_USER_NOT_FOUND;
          break;
        case "user-not-found":
          lastErrorCode = F_BASE_AUTH_ERROR.ERROR_USER_NOT_FOUND;
          break;
        case "email-already-in-use":
          lastErrorCode = F_BASE_AUTH_ERROR.ERROR_EMAIL_ALREADY_IN_USE;
          break;
        default:
          lastErrorCode = F_BASE_AUTH_ERROR.UNDEFINED_ERROR;
      }
      return null;
    }
  }

  void resetPassword(String email) async{
    try{
      await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
    }
  }

  void signOut() async{
    try{
      await _auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }

}