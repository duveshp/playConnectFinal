import 'dart:convert';
import 'package:http/http.dart' as http;

import '../helper/apiUrl.dart';

Future<void> sendingUserDataToServer({
  required String userName,
  required int userPhoneNo,
  required String userEmail,
  required String userFavSportsOne,
  required String userFavSportsTwo,
  required String userLocation,
  required int userAge,
}) async {
  final apiUrl = '${apiHostUrl}/restfinal/api/users/'; // Replace with your Django API endpoint
  final headers = {'Content-Type': 'application/json'};

  // Create a map of user data
  final userData = {
    'userName': userName,
    'userPhoneNo': userPhoneNo,
    'userEmail': userEmail,
    'userFavSportsOne': userFavSportsOne,
    'userFavSportsTwo': userFavSportsTwo,
    'userLocation': userLocation,
    'userAge': userAge,
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
