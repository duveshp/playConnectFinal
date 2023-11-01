import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:play_connect/helper/helper_function.dart';
import 'dart:convert';

import 'package:play_connect/services/auth_services.dart';

import '../helper/apiUrl.dart';
import '../models/bookings.dart';
import '../services/userBookings.dart';

class MyBookingsPage extends StatefulWidget {
  @override
  _MyBookingsPageState createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  late Future<List<Booking>> _bookings = Future.value([]);
  String userName="";
  String email="";
  AuthService authService=AuthService();
  @override
  void initState() {
    super.initState();
    gettingUserData();// Fetch user's bookings when the page loads
  }


  gettingUserData() async {
    String? userEmail;
    String? fetchedUserName;

    // Fetch the user's email
    await HelperFunction.getUserEmailFromSF().then((value) {
      userEmail = value;
    });

    // Fetch the user's name
    await HelperFunction.getUserNameFromSF().then((value) {
      fetchedUserName = value;
    });

    // Check if both email and name are available before setting _bookings
    if (userEmail != null && fetchedUserName != null) {
      setState(() {
        email = userEmail!;
        userName = fetchedUserName!;
        _bookings = fetchUserBookings(email);
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
      ),
      body: FutureBuilder<List<Booking>>(
        future: _bookings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            print(snapshot);
            return Center(
              child: Text('Error: ${snapshot}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No bookings found.'),
            );
          } else {
            final bookings = snapshot.data!; // Use ! to assert non-null because the data should be available at this point

            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(

                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Colors.blueGrey.shade100,),
                    child: ListTile(
                      title: Text('Play Area: ${booking.playAreaName}',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date: ${booking.playAreaDate}'),
                          Text('Time: ${booking.playAreaTime}'),
                          Text('Vendor: ${booking.playAreaVendor}'),
                          Text('Sports: ${booking.playAreaSports}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),

    );
  }
}

