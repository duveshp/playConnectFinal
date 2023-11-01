import 'package:flutter/material.dart';
import 'package:play_connect/main.dart';
import 'package:play_connect/services/user_reg_services.dart';

import '../widgets/widgets.dart';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _userPhoneNoController = TextEditingController();
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _userFavSportsOneController = TextEditingController();
  TextEditingController _userFavSportsTwoController = TextEditingController();
  TextEditingController _userLocationController = TextEditingController();
  TextEditingController _userAgeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Form"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text("Enter more details about you:",textAlign: TextAlign.left, style: TextStyle(
                  color: Colors.blueGrey, fontWeight: FontWeight.bold,fontSize: 20,
                ),),
                TextFormField(
                  controller: _userNameController,
                  decoration: InputDecoration(labelText: 'Full Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a Full name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _userPhoneNoController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _userEmailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an email address';
                    }
                    if (!value!.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _userFavSportsOneController,
                  decoration: InputDecoration(labelText: 'Favorite Sport 1'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your favorite sport';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _userFavSportsTwoController,
                  decoration: InputDecoration(labelText: 'Favorite Sport 2'),
                ),
                TextFormField(
                  controller: _userLocationController,
                  decoration: InputDecoration(labelText: 'Location'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your location';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _userAgeController,
                  decoration: InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your age';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Form is valid, submit the data to Django API or perform other actions.
                      // You can access the form field values using the controller variables.
                      final userName = _userNameController.text;
                      final userPhoneNo = int.parse(_userPhoneNoController.text);
                      final userEmail = _userEmailController.text;
                      final userFavSportsOne = _userFavSportsOneController.text;
                      final userFavSportsTwo = _userFavSportsTwoController.text;
                      final userLocation = _userLocationController.text;
                      final userAge = int.parse(_userAgeController.text);

                      sendingUserDataToServer(
                        userName: userName,
                        userPhoneNo: userPhoneNo,
                        userEmail: userEmail,
                        userFavSportsOne: userFavSportsOne,
                        userFavSportsTwo: userFavSportsTwo,
                        userLocation: userLocation,
                        userAge: userAge,
                      );
                    }
                    nextScreen(context, MyHomePage());
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


