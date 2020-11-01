import 'package:chatapp/helper/helperFunctions.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/constantsFields.dart';
import 'package:chatapp/components/input_field.dart';
import 'package:chatapp/components/sign_Button.dart';
import 'chatRoomsScreen.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();

  signUpMe()
  {
      if(formKey.currentState.validate())
      {
        Map<String, String> userInfoMap = {
          "name": nameTextEditingController.text,
          "email": emailTextEditingController.text
        };
        HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
        HelperFunctions.saveUserNameSharedPreference(nameTextEditingController.text);
        Constants.myName = nameTextEditingController.toString();

        setState(() {
          isLoading = true;

        });
        authMethods.signUpWithEmailAndPassword(emailTextEditingController.text.trim(), passwordTextEditingController.text)
            .then((value){
          //print(value.userId);
          databaseMethods.uploadInfo(userInfoMap);
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context)=> ChatRoom()
          ));
        });
      }

  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff2B475D),
        body: isLoading? Container(
          child: Center(child: CircularProgressIndicator()),
        ) : SingleChildScrollView(
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
                  'Sign Up',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    InputField(
                      obsecureText: false,
                      validator: (val) {
                        if (val.length<2)
                          return'Invalid Username';
                        else if (val.isEmpty)
                          return 'Please enter the username';
                        return null;
                      },
                      textEditingController: nameTextEditingController,
                      hint: 'Name',
                    ),
                    InputField(
                      obsecureText: false,
                      validator: (val){
                        bool valid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val);
                        if (!valid)
                          return 'Invalid email';
                        else if (val.isEmpty)
                          return 'Please enter your email';
                        return null;
                      },
                      textEditingController: emailTextEditingController,
                      hint: 'Email',
                    ),
                    InputField(
                      obsecureText: true,
                      validator: (val){
                        return val.length>6? null : 'Please enter a strong password';
                      },
                      textEditingController: passwordTextEditingController,
                      hint: 'Password',
                    ),

                  ],
                ),
              ),
             /* SignButton(
                onPressed: signUpMe(),
                text: 'Sign Up',
              ),*/
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: signUpMe,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),),
                    child: Text(
                      'Sign UP',
                      style: TextStyle(
                        color: Color(0xff2B475D),
                        fontSize: 20,
                      ),
                    ),
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );;
  }
}
