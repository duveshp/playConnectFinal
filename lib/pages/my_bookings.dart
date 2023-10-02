import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:play_connect/helper/helper_function.dart';
import 'dart:convert';

import 'package:play_connect/services/auth_services.dart';

class MyBookingsPage extends StatefulWidget {
  @override
  _MyBookingsPageState createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  late Future<List<Booking>> _bookings;
  String userName="";
  String email="";
  AuthService authService=AuthService();
  @override
  void initState() {
    super.initState();
    _bookings = fetchUserBookings(email);
    gettingUserData();// Fetch user's bookings when the page loads
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

  Future<List<Booking>> fetchUserBookings(String userEmail) async {
    // Replace with your Django API endpoint to fetch user bookings
    final apiUrl = 'http://192.168.0.103:8000/restfinal/api/bookings/?userEmail=$userEmail';
    // final response = await http.get(Uri.parse(apiUrl));

    final headers = {
      'Content-Type': 'application/json', // Example header for content type
      'Authorization': 'Bearer YourAuthToken',
      'X-User-Email': email,// Example header for authentication token
    };

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers, // Pass the headers in the request
    );


    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List;
      final List<Booking> bookings = jsonData.map((data) {
        return Booking.fromJson(data);
      }).toList();

      return bookings;
    } else {
      throw Exception('Failed to load user bookings');
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
          } else {

            final bookings = snapshot.data;

            if (bookings != null && bookings.isNotEmpty) {
              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return ListTile(
                    title: Text('Play Area: ${booking.playAreaName}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${booking.playAreaDate}'),
                        Text('Time: ${booking.playAreaTime.join(", ")}'),
                        Text('Vendor: ${booking.playAreaVendor}'),
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text('No bookings found.'),
              );

            }
          }
        },
      ),
    );
  }
}

class Booking {
  final String playAreaName;
  final String playAreaDate;
  final List<String> playAreaTime;
  final String playAreaVendor;

  Booking({
    required this.playAreaName,
    required this.playAreaDate,
    required this.playAreaTime,
    required this.playAreaVendor,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      playAreaName: json['playAreaName'],
      playAreaDate: json['playAreaDate'],
      playAreaTime: List<String>.from(json['playAreaTime']),
      playAreaVendor: json['playAreaVendor'],
    );
  }
}
