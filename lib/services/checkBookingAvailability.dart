import 'dart:convert';
import 'package:http/http.dart' as http;

import '../helper/apiUrl.dart';
Future<bool> checkBookingAvailability(String playAreaName, String bookingDate, String bookingTime) async {
  final csrfToken = await getCsrfToken();

  final response = await http.post(
    Uri.parse('${apiHostUrl}/restfinal/check_booking_availability/'),
    body: {
      'play_area_name': playAreaName,
      'booking_date': bookingDate,
      'booking_time': bookingTime,
    },
    headers: {
      'X-CSRFToken': csrfToken,
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['available'];
  } else {
    throw Exception('Failed to check booking availability: ${response.statusCode}');
  }
}

Future<String> getCsrfToken() async {
  final response = await http.get(
    Uri.parse('${apiHostUrl}/restfinal/get_csrf_token/'), // Replace with your Django server URL
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['csrf_token'];
  } else {
    throw Exception('Failed to get CSRF token');
  }
}