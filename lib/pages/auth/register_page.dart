import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:play_connect/helper/helper_function.dart';
import 'package:play_connect/main.dart';
import 'package:play_connect/pages/auth/login_page.dart';
import 'package:play_connect/pages/userForm.dart';
import 'package:play_connect/services/auth_services.dart';
import 'package:play_connect/widgets/widgets.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading=false;
  final formKey=GlobalKey<FormState>();
  String email="";
  String password="";
  String fullName="";
  String selectedValue="";
  final List<String> options = ['Cricket', 'Football', 'Basketball', 'Badminton'];
  List<String> selectedValues = [];
  AuthService authService=AuthService();
  void _showMultiSelect(BuildContext context) async {
    final items = options
        .map((sport) => MultiSelectItem<String>(sport, sport))
        .toList();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog<String>(
          items: items,
          initialValue: selectedValues,
          title: Text(
            'Favorite Sports',
            style: TextStyle(color: Colors.blueGrey),
          ),
          selectedColor: Colors.blueGrey, // Customize the selected color
          unselectedColor: Colors.black, // Customize the unselected color
          backgroundColor: Colors.white, // Customize the background color
          itemsTextStyle: TextStyle(color: Colors.black), // Customize item text color
          selectedItemsTextStyle: TextStyle(color: Colors.blueGrey), // Customize selected item text color
          // searchFieldStyle: TextStyle(color: Colors.white), // Customize search field text color
          searchHintStyle: TextStyle(color: Colors.grey), // Customize search field hint text color
          // confirmButtonTextStyle: TextStyle(color: Colors.white), // Customize confirm button text color
          // cancelButtonTextStyle: TextStyle(color: Colors.white), // Customize cancel button text color
          onConfirm: (values) {
            setState(() {
              selectedValues = values ?? [];
            });
            ;
          },
        );
      },
    );
  }





  @override
  Widget build(BuildContext context) {

    return _isLoading? Center(child: CircularProgressIndicator(color: Colors.black,),):Scaffold(

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20,),
                const Text("Play Connect",
                  style: TextStyle(
                      fontSize: 35,fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                const Text("Connect with new players and Play along",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Image.asset("assets/register.png"),
                TextFormField(
                    onTap: (){
                      // isTextMailFieldFocused=true;
                    },

                    decoration: textInputDecoration.copyWith(
                      labelText: "Full Name",
                      labelStyle: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w400
                      ),
                      prefixIcon: Icon(
                          Icons.person_outlined,
                          color: Colors.blueGrey),
                    ),
                    onChanged: (val){
                      setState(() {
                        fullName=val;
                      });
                    },
                    validator: (val) {
                      return (val!=null)
                          ? null
                          : "Please enter a valid name in proper format";
                    }

                ),
                const SizedBox(height: 15),
                TextFormField(
                    onTap: (){
                      // isTextMailFieldFocused=true;
                    },

                    decoration: textInputDecoration.copyWith(
                      labelText: "Email",
                      labelStyle: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w400
                      ),
                      prefixIcon: Icon(
                          Icons.mail_outline,
                          color: Colors.blueGrey),
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
                    // isTextMailFieldFocused=true;
                  },

                  decoration: textInputDecoration.copyWith(
                    labelText: "Password",
                    labelStyle: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w400
                    ),
                    prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.blueGrey),
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

                const SizedBox(height: 15,),
                InkWell(
                  onTap: () {
                    _showMultiSelect(context);
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      focusColor: Colors.blueGrey,
                      labelText: 'Favorite Sports',
                      labelStyle: TextStyle(color: Colors.blueGrey),
                      prefixIcon: Icon(
                        Icons.sports,
                        color: Colors.blueGrey,
                      ),
                      border: OutlineInputBorder(),
                      fillColor: Colors.black,
                    ),
                    child: Wrap(
                      spacing: 8.0,
                      children: selectedValues.map((sport) {
                        return Chip(
                          label: Text(
                            sport,
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.blueGrey,
                          onDeleted: () {
                            setState(() {
                              selectedValues.remove(sport);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
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
                      "Register",
                      style: TextStyle(color: Colors.white,fontSize: 16),
                    ),
                    onPressed: (){
                      register();
                    },
                  ),
                ),
                const SizedBox(height: 10,),
                Text.rich(
                    TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(color: Colors.blueGrey,fontSize: 13),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Login now",
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline
                              ),
                              recognizer: TapGestureRecognizer()..onTap=(){

                                nextScreen(context, const LoginPage());
                              }
                          ),
                        ]
                    )
                ),

              ],

            ),
          ),
        ),
      ),
    );
  }
  register() async{
    if (formKey.currentState!.validate()){
      setState(() {
        _isLoading=true;
      });
      await authService.registerUserWithEmailandPassword(fullName, email, password).then((value) async{
        if(value==true){
          //saving the shared pref state
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserNameSF(fullName);
          await HelperFunction.saveUserEmailSF(email);
          nextScreenReplace(context, UserForm());


        }else{
          setState(() {
            showSnackBar(context, Colors.blueGrey, value);
            _isLoading=false;
          });
        }
      });

    }
  }
}

