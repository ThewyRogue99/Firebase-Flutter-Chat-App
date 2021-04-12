import 'package:flutter/material.dart';
import 'package:flutter_chat_fbase/helper/HelperFunctions.dart';
import 'package:flutter_chat_fbase/helper/SizeConfig.dart';
import 'package:flutter_chat_fbase/helper/UniversalVariables.dart';
import 'package:flutter_chat_fbase/page_widgets/HomePage.dart';
import 'package:flutter_chat_fbase/page_widgets/login.dart';
import 'package:flutter_chat_fbase/services/auth.dart';
import 'package:flutter_chat_fbase/services/database.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool _isLoading = false;
  String emailError = "";
  String usernameError = "";

  DatabaseMethods _databaseMethods = DatabaseMethods();
  AuthMethods _authMethods = AuthMethods();

  final formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  signMeUp() async
  {
    Map<String, String> values = {"name" : usernameController.text, "email" : emailController.text, "password" : passwordController.text};

    if(formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      bool userExists = await _databaseMethods.userExists(values["name"]);
      if(userExists){
        setState(() {
          emailError = "";
          _isLoading = false;
          usernameError = "This username already exists!";
        });
        return;
      }

      _authMethods.signUpWithUserInfo(values["email"], values["password"])
          .then((value) {

        if (value != null) {
          Map<String, String> userInfo = {
            "name": values["name"],
            "email": values["email"],
            "uid": value.uid
          };

          HelperFunctions.saveUserEmail(values["email"]);
          HelperFunctions.saveUserLoggedIn(true);
          HelperFunctions.saveUserName(values["name"]);
          HelperFunctions.saveUserUid(value.uid);
          _databaseMethods.saveUserInfo(userInfo);

          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => HomePage()
          ));
        }
        else {
          setState(() {
            emailError = "";
            usernameError = "";
            _isLoading = false;

            switch (_authMethods.lastErrorCode) {
              case F_BASE_AUTH_ERROR.ERROR_INVALID_EMAIL:
                emailError = "Invalid email!";
                break;
              case F_BASE_AUTH_ERROR.ERROR_USER_NOT_FOUND:
                emailError = "User is not found!";
                break;
              case F_BASE_AUTH_ERROR.ERROR_EMAIL_ALREADY_IN_USE:
                emailError = "Email already in use";
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
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Sign Up"),
      ),
      body: _isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),)
          : Center(
        child: SingleChildScrollView(
        child: Container(
            alignment: Alignment.center,
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
                            controller: usernameController,
                            validator: (val) {
                              if(val.isEmpty)
                                return "Please provide a username";
                              else if(val.length < 6)
                                return "Username must be longer than 5 characters";
                              else
                                return null;
                            },
                            decoration: InputDecoration(
                              errorText: usernameError != "" ? usernameError : null,
                              hintText: "Username",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              fillColor: Colors.white,
                              filled: true
                            ),
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: emailController,
                            validator: (val) {
                              return RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                                  .hasMatch(val) ? null : "Please enter a valid email address";
                            },
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
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: passwordController,
                            validator: (val) {
                              if(val.length < 6)
                                return "Password must have more than 5 characters";
                              else
                                return null;
                            },
                            decoration: InputDecoration(
                                hintText: "Password",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                fillColor: Colors.white,
                                filled: true
                            ),
                            obscureText: true,
                          ),
                        ],
                      )
                  ),
                  SizedBox(height: 60),
                  GestureDetector(
                    onTap: signMeUp,
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
                            "Sign up",
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
                          "Sign up with Google",
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
                        "Already have an account?  ",
                        style: TextStyle(
                            fontSize: SizeConfig.getScreenBalancedFontSize(16),
                            color: Colors.white
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (context) => LogIn()
                          ));
                        },
                        child: Text(
                          "Log in now",
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
