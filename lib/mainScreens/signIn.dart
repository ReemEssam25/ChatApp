import 'package:chatapp/helper/helperFunctions.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/constantsFields.dart';
import 'chatRoomsScreen.dart';
import 'signUp.dart';
import 'package:chatapp/components/input_field.dart';
import 'package:chatapp/components/sign_Button.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;

  signIn()
  {
    if (formKey.currentState.validate())
      {
        HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);

        databaseMethods.getUserByEmail(emailTextEditingController.text)
            .then((val){
          snapshotUserInfo = val;
          HelperFunctions
              .saveUserNameSharedPreference(snapshotUserInfo.documents[0].data["name"]);
          Constants.myName = snapshotUserInfo.documents[0].data["name"].toString();

        });
        setState(() {
          isLoading = true;
        });

        authMethods.signInWithEmailAndPassword(emailTextEditingController.text,
            passwordTextEditingController.text)
        .then((value) {
          if (value != null) {
            HelperFunctions.saveUserLoggedInSharedPreference(true);
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context)=> ChatRoom()
            ));
          }
        });

      }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff2B475D),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 70,
              ),
              CircleAvatar(
                child: Icon(Icons.image),
                radius: 40,
              ),
              Text (
                'Scholar Chat',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 70,
              ),
              Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InputField(
                      obsecureText: false,
                      textEditingController: emailTextEditingController,
                      hint: 'Email',
                      validator: (val) {
                        if (val.isEmpty)
                          return 'Please enter the username';
                        return null;
                      },
                    ),
                    InputField(
                      obsecureText: true,
                      textEditingController: passwordTextEditingController,
                      hint: 'Password',
                      validator: (val) {
                        if (val.isEmpty)
                          return 'Please enter the Password';
                        return null;
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          onPressed:(){
                            signIn();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: Color(0xff2B475D),
                              fontSize: 20,
                            ),
                          ),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return SignUp();
                        }));
                      },
                      child: Text(
                        "don't have an account Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
