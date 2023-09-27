import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:play_connect/helper/helper_function.dart';
import 'package:play_connect/pages/auth/register_page.dart';
import 'package:play_connect/services/auth_services.dart';
import 'package:play_connect/services/database_service.dart';
import 'package:play_connect/widgets/widgets.dart';

import '../../main.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isTextMailFieldFocused=false;
  final formKey=GlobalKey<FormState>();
  String email="";
  String password="";
  bool _isLoading=false;
  AuthService authService=AuthService();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _isLoading? Center(child: CircularProgressIndicator(color: Colors.black,),):SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Play Connect",
                  style: TextStyle(
                    fontSize: 35,fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                const Text("Login now to Play and Connect more",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Image.asset("assets//login.png"),
                TextFormField(
                  onTap: (){
                    isTextMailFieldFocused=true;
                  },

                  decoration: textInputDecoration.copyWith(
                    labelText: "Email",
                    labelStyle: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w400
                    ),
                    prefixIcon: Icon(
                        Icons.mail_outline,
                        color: Colors.deepPurple),
                  ),
                  onChanged: (val){
                    setState(() {
                      email=val;
                    });
                  },
                  validator: (val) {
                    return RegExp(
                        "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}")
                        .hasMatch(val!)
                        ? null
                        : "Please enter a valid email";
                  }

                ),
                const SizedBox(height: 15),
                TextFormField(
                  obscureText: true,
                  onTap: (){
                    isTextMailFieldFocused=true;
                  },

                  decoration: textInputDecoration.copyWith(
                    labelText: "Password",
                    labelStyle: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w400
                    ),
                    prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.deepPurple),
                  ),
                  onChanged: (val){
                    setState(() {
                      password=val;
                    });
                  },

                  //check the validation
                  validator: (val){
                    if(val!.length<6){
                      return "Password is too short";
                      }else{
                      return null;
                    }

                  },
                ),
                const SizedBox(height: 20,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      padding: EdgeInsets.all(20),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)
                      ),
                    ),
                    child: const Text(
                        "Sign In",
                      style: TextStyle(color: Colors.white,fontSize: 16),
                    ),
                    onPressed: (){
                      login();
                    },
                  ),
                ),
                const SizedBox(height: 10,),
                Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(color: Colors.deepPurple,fontSize: 13),
                    children: <TextSpan>[
                      TextSpan(
                        text: "Register here",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline
                        ),
                        recognizer: TapGestureRecognizer()..onTap=(){
                          nextScreen(context, const RegisterPage());
                        }
                      ),
                    ]
                  )
                )

              ],

            ),
          ),
        ),
      ),
    );

  }
  login() async{
    if (formKey.currentState!.validate()){
      setState(() {
        _isLoading=true;
      });
      await authService.loginUserWithEmailandPassword(email, password).then((value) async{
        print(value);
        if(value==true){
          //saving the shared pref state
          QuerySnapshot snapshot=await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);

          // saving our values to shared references
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserNameSF(snapshot.docs[0]['fullName']);
          await HelperFunction.saveUserEmailSF(email);
          nextScreenReplace(context, MyHomePage());


        }else{
          setState(() {
            showSnackBar(context, Colors.deepPurple, value);
            _isLoading=false;
          });
        }
      });

    }
  }
}
