import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:play_connect/helper/helper_function.dart';
import 'package:play_connect/main.dart';
import 'package:play_connect/pages/booking_page.dart';
import 'package:play_connect/services/auth_services.dart';
import 'package:play_connect/services/booking_playArea.dart';
import 'package:play_connect/services/user_reg_services.dart';
import 'package:play_connect/widgets/widgets.dart';

class BookingForm extends StatefulWidget {

  final String playAreaName;
  final String playAreaVendor;
  // final String userEmail;
  final Key? key;
  const BookingForm(@required this.playAreaName,@required this.playAreaVendor,{this.key}):super(key: key);
  // const BookingForm({super.key});

  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  String selectedValue="";
  final List<String> timeOptions = ['7AM-8AM', '8AM-9AM', '9AM-10AM', '10AM-11AM','11AM-12PM','12PM-1PM','1PM-2PM','2PM-3PM','3PM-4PM','4PM-5PM','5PM-6PM','6PM-7PM','7PM-8PM','8PM-9PM','9PM-10PM','10PM-11PM'];
  List<String> selectedValues = [];
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate= DateTime.now();
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _userPhoneNoController = TextEditingController();
  TextEditingController _userPlayingSportsController = TextEditingController();
  // TextEditingController _userFavSportsTwoController = TextEditingController();
  TextEditingController _bookingDateController= TextEditingController();
  TextEditingController _bookingTimeController= TextEditingController();
  TextEditingController _playAreaVendor = TextEditingController();
  String userName="";
  String email="";
  AuthService authService=AuthService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  gettingUserData() async{
    await HelperFunction.getUserEmailFromSF().then((value) {
      setState(() {
        email=value!;
      });
    });

    await HelperFunction.getUserNameFromSF().then((value) {
      setState(() {
        userName=value!;
      });
    });

  }
  void _showMultiSelect(BuildContext context) async {
    final items = timeOptions
        .map((sport) => MultiSelectItem<String>(sport, sport))
        .toList();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog<String>(
          items: items,
          initialValue: selectedValues,
          title: Text(
            'Select Time:',
            style: TextStyle(color: Colors.deepPurple),
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Details"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Text("Booking for:", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
            Text(widget.playAreaName,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),

            Row(
              children: [
                Text("User Name: ", style: TextStyle(fontSize: 18)),
                Text(userName,style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
              ],
            ),
            const SizedBox(height: 15,),
            Row(
              children: [
                Text("User Email: ", style: TextStyle(fontSize: 18)),
                Text(email,style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
              ],
            ),
            // TextFormField(
            //   controller: _userEmailController,
            //   decoration: InputDecoration(labelText: 'Enter your email'),
            //   keyboardType: TextInputType.phone,
            //   validator: (value) {
            //     if (value!.isEmpty) {
            //       return 'Please enter a email';
            //     }
            //     return null;
            //   },
            // ),

            TextFormField(
              controller: _userPlayingSportsController,
              decoration: InputDecoration(labelText: 'Playing Sport:'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter playing sport';
                }
                return null;
              },
            ),
            const SizedBox(height: 10,),
            Text("Select date:"),
            ElevatedButton(onPressed: () async{
              DateTime? datePicked = await showDatePicker(context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2025)
              ).then((value) {
                setState(() {
                  selectedDate=value!;
                });
              });
              if(datePicked!=null){
                print("Date Selected: ${datePicked.toString()}");
              }
            },
                child: Text("Show")),
            Text("${selectedDate.day.toString()}-${selectedDate.month.toString()}-${selectedDate.year.toString()}"),
            const SizedBox(height: 10,),
            InkWell(
              onTap: () {
                _showMultiSelect(context);
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  focusColor: Colors.deepPurple,
                  labelText: 'booking time',
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





            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Form is valid, submit the data to Django API or perform other actions.
                  // You can access the form field values using the controller variables.
                  // final userName = _userNameController.text;
                  // final userPhoneNo = int.parse(_userPhoneNoController.text);
                  final userEmail = _userEmailController.text;
                  // final userFavSportsOne = _userFavSportsOneController.text;
                  // final userFavSportsTwo = _userFavSportsTwoController.text;
                  // final userLocation = _userLocationController.text;
                  // final userAge = int.parse(_userAgeController.text);
                  final playingSPorts= _userPlayingSportsController.text;

                  sendingBookingDataToServer(
                      userName: userName,
                      userEmail: email,
                      // userPhoneNo: userPhoneNo,
                      playDate: selectedDate,
                      playAreaSports:playingSPorts ,
                      playAreaName: widget.playAreaName,
                      playAreaVendor: widget.playAreaVendor,
                      playingTime: selectedValues);
                }
                showSnackBar(context, Colors.green, "Your booking has been confirmed from ${selectedValues} at ${widget.playAreaName}");
                Navigator.push(context, MaterialPageRoute(builder: (context) => BookingPage(),));
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}



