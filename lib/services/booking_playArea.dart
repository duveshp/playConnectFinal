import 'dart:convert';
import 'package:http/http.dart' as http;
Future<void> sendingBookingDataToServer({
  required String userName,
  required DateTime playDate,
  required String playAreaSports,
  required String playAreaName,
  required String playAreaVendor,
  required List<String> playingTime,
  required String userEmail,

}) async {
  final apiUrl = 'http://192.168.0.103:8000/restfinal/api/create_booking/'; // Replace with your Django API endpoint
  final headers = {'Content-Type': 'application/json'};
  final finalPlayDate="${playDate.year.toString()}-${playDate.month.toString()}-${playDate.day.toString()}";
  // Convert the DateTime to ISO 8601 string format
  // final formattedPlayDate = finalPlayDate.toIso8601String();

  // Create a map of user data
  final userData = {
    'bookingPlayAreaName': playAreaName,
    'bookingPlayAreaDate': finalPlayDate,
    'bookingPlayAreaTime': playingTime,
    'bookingPlayAreaVendor': playAreaVendor,
    'bookingPlayAreaUser': userName,
    'bookingPlayAreaSports': playAreaSports,
    'bookingPlayAreaUserEmail':userEmail,
  };

  final jsonBody = json.encode(userData);

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonBody,
    );

    if (response.statusCode == 201) {
      // Successfully sent data to the server
      print(userData);
      print('Data sent to the server successfully');
    } else {
      // Failed to send data to the server
      print('Failed to send data to the server');
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    // Handle any exceptions that occur during the HTTP request
    print('Error sending data: $e');
  }
}
