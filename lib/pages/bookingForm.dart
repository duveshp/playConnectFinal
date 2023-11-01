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

import '../services/checkBookingAvailability.dart';



class BookingForm extends StatefulWidget {
  final String playAreaName;
  final String playAreaVendor;
  final Key? key;
  const BookingForm(
      @required this.playAreaName,
      @required this.playAreaVendor, {
        this.key,
      }) : super(key: key);

  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  String selectedValue = "";
  final List<String> timeOptions = [
    '7AM-8AM',
    '8AM-9AM',
    '9AM-10AM',
    '10AM-11AM',
    '11AM-12PM',
    '12PM-1PM',
    '1PM-2PM',
    '2PM-3PM',
    '3PM-4PM',
    '4PM-5PM',
    '5PM-6PM',
    '6PM-7PM',
    '7PM-8PM',
    '8PM-9PM',
    '9PM-10PM',
    '10PM-11PM'
  ];
  String selectedValues = ""; // Change to String
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate; // Nullable DateTime
  TextEditingController _userPlayingSportsController = TextEditingController();
  String userName = "";
  String email = "";
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunction.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });

    await HelperFunction.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
  }

  void _showSingleSelect(BuildContext context) async {
    final items = timeOptions.map((time) {
      return ListTile(
        title: Text(time),
        onTap: () {
          Navigator.of(context).pop(time); // Pop the selected time
        },
      );
    }).toList();

    final selectedValue = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Time:',
            style: TextStyle(color: Colors.deepPurple),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: items,
            ),
          ),
        );
      },
    );

    if (selectedValue != null) {
      setState(() {
        selectedValues = selectedValue;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  "Booking for:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Text(
                  widget.playAreaName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 22,),
                Row(
                  children: [
                    Text("User Name: ", style: TextStyle(fontSize: 18)),
                    Text(userName,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  children: [
                    Text("User Email: ", style: TextStyle(fontSize: 18)),
                    Text(email,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
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
                const SizedBox(
                  height: 18,
                ),
                Container(
                    alignment:Alignment.topLeft,
                    child: Row(
                      children: [
                        Text("Select date:",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                        SizedBox(width: 15,),
                        ElevatedButton(
                          onPressed: () async {
                            DateTime? datePicked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2025),
                            );
                            if (datePicked != null) {
                              setState(() {
                                selectedDate = datePicked;
                              });
                              print("Date Selected: ${selectedDate.toString()}");
                            }
                          },
                          child: Text("Select Date"),
                        ),
                        if (selectedDate != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                                "${selectedDate!.day.toString()}-${selectedDate!.month.toString()}-${selectedDate!.year.toString()}"),
                          ),
                  ],
                )),

                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    _showSingleSelect(context);
                  },
                  child: SingleChildScrollView(
                    child: InputDecorator(
                      decoration: InputDecoration(
                        focusColor: Colors.deepPurple,
                        labelText: 'Booking Time',
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
                        children: selectedValues.isNotEmpty
                            ? [
                          Chip(
                            label: Text(
                              selectedValues,
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.blueGrey,
                            onDeleted: () {
                              setState(() {
                                selectedValues = "";
                              });
                            },
                          )
                        ]
                            : [],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Form is valid, proceed with submitting data.
                        if (selectedDate == null) {
                          showSnackBar(
                              context, Colors.red, 'Please select a date.');
                          return;
                        }
                        if (selectedValues.isEmpty) {
                          showSnackBar(context, Colors.red,
                              'Please select booking time.');
                          return;
                        }
                        final playingSports =
                            _userPlayingSportsController.text;
                        sendingBookingDataToServer(
                          userName: userName,
                          userEmail: email,
                          playDate: selectedDate!,
                          playAreaSports: playingSports,
                          playAreaName: widget.playAreaName,
                          playAreaVendor: widget.playAreaVendor,
                          playingTime: selectedValues,
                        );
                        showSnackBar(
                          context,
                          Colors.green,
                          'Your booking has been confirmed from $selectedValues at ${widget.playAreaName}',
                        );
                        // Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BookingPage()));
                      }
                    },
                    style: ButtonStyle(),
                    child: Text('Book Now',style: TextStyle(fontSize: 15),),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
      bottomSheet: SingleChildScrollView(
        child: Column(
          children: [Container()],
        ),
      ),
    );
  }
}
