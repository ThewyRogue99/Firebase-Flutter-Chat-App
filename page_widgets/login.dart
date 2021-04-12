import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_fbase/helper/HelperFunctions.dart';
import 'package:flutter_chat_fbase/helper/SizeConfig.dart';
import 'package:flutter_chat_fbase/helper/UniversalVariables.dart';
import 'package:flutter_chat_fbase/page_widgets/signup.dart';
import 'package:flutter_chat_fbase/services/auth.dart';
import 'package:flutter_chat_fbase/services/database.dart';
import 'HomePage.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  final formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  String emailError = "";
  String passwordError = "";

  AuthMethods _authMethods = AuthMethods();
  DatabaseMethods _databaseMethods = DatabaseMethods();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  logMeIn(){

    Map<String, String> values = {"name" : "", "email" : emailController.text, "password" : passwordController.text};

    if(formKey.currentState.validate()){

      setState(() {
        _isLoading = true;
      });

      _authMethods.signInWithLoginInfo(values["email"], values["password"]).then((value) async
      {
        if(value != null) {
          QuerySnapshot snapshot = await _databaseMethods.getUserByEmail(values["email"]);
          values["name"] = snapshot.docs[0].data()["name"];

          HelperFunctions.saveUserEmail(values["email"]);
          HelperFunctions.saveUserLoggedIn(true);
          HelperFunctions.saveUserName(values["name"]);
          HelperFunctions.saveUserUid(value.uid);

          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => HomePage()
          ));
        }
        else{
          setState(() {
            emailError = "";
            passwordError = "";
            _isLoading = false;

            switch(_authMethods.lastErrorCode)
            {
              case F_BASE_AUTH_ERROR.ERROR_INVALID_EMAIL:
                emailError = "Invalid email!";
                break;
              case F_BASE_AUTH_ERROR.ERROR_USER_NOT_FOUND:
                emailError = "User is not found!";
                break;
              default:
                emailError = "Failed to log in!";
                break;
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(!SizeConfig.isInit())
      SizeConfig.init(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Log In"),
      ),
      body: _isLoading ? Container(
        child: Center(child: CircularProgressIndicator()))
          : Center(
            child: SingleChildScrollView(
        child: Container(
            child: Container(
              margin: EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            errorText: emailError != "" ? emailError : null,
                            hintText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                            ),
                            fillColor: Colors.white,
                            filled: true
                          ),
                          validator: (val) {
                            return RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                                .hasMatch(val) ? null : "Please enter a valid email address";
                          },
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            errorText: passwordError != "" ? passwordError : null,
                            hintText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                            ),
                            fillColor: Colors.white,
                            filled: true
                          ),
                          validator: (val) {
                            if(val.length < 6)
                              return "Password must have more than 5 characters";
                            else
                              return null;
                          },
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forgot password?    ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.getScreenBalancedFontSize(16)
                      ),
                    ),
                  ),
                  SizedBox(height: 60),
                  GestureDetector(
                    onTap: logMeIn,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: Container(
                        alignment: Alignment.center,
                          margin: EdgeInsets.all(20),
                          child: Text(
                            "Log in",
                            style: TextStyle(
                              fontSize: SizeConfig.getScreenBalancedFontSize(17),
                              color: Colors.white
                            ),
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(20),
                        child: Text(
                          "Log in with Google",
                          style: TextStyle(
                              fontSize: SizeConfig.getScreenBalancedFontSize(17),
                          ),
                        )
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?  ",
                        style: TextStyle(
                          fontSize: SizeConfig.getScreenBalancedFontSize(16),
                          color: Colors.white
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (context) => SignUp()
                          ));
                        },
                        child: Text(
                          "Create an Account",
                          style: TextStyle(
                            fontSize: SizeConfig.getScreenBalancedFontSize(16),
                            color: Colors.white,
                            decoration: TextDecoration.underline
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
        ),
      ),
          ),
    );
  }
}
