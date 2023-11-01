import 'dart:convert';

import '../helper/apiUrl.dart';
import '../models/bookings.dart';
import 'package:http/http.dart' as http;

Future<List<Booking>> fetchUserBookings(String userEmail) async {
  try {
    // Replace with your Django API endpoint to fetch user bookings
    final apiUrl = "${apiHostUrl}/restfinal/api/bookings";
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      print("Response body: ${response.body}");
      final jsonData = json.decode(response.body) as List;
      final List<Booking> bookings = jsonData.map((data) {
        return Booking.fromJson(data);
      }).toList();

      return bookings;
    } else {
      print("Request failed with status: ${response.statusCode}");
      throw Exception('Failed to load user bookings');
    }
  } catch (e) {
    // Handle the exception here
    print("Error: $e");
    throw e; // Re-throw the exception to be handled by the caller
  }
}
