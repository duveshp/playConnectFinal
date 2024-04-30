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
    final availabilityData = json.decode(response.body) as Map<String, dynamic>;
    final isAvailable = availabilityData['available'];

    return isAvailable;
  } else {
    throw Exception('Failed to check booking availability: ${response.statusCode}');
  }
}

Future<String> getCsrfToken() async {
  final response = await http.get(
    Uri.parse('${apiHostUrl}/restfinal/get_csrf_token/'),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['csrf_token'];
  } else {
    throw Exception('Failed to get CSRF token');
  }
}

void main() async {
  try {
    final playAreaName = 'YourPlayAreaName'; // Replace with the selected play area
    final bookingDate = '2023-10-02';
    final bookingTime = '12AM-1AM';

    bool isAvailable = await checkBookingAvailability(playAreaName, bookingDate, bookingTime);

    if (isAvailable) {
      print('Booking slot is available for the selected play area. You can proceed with the booking.');
    } else {
      print('Booking slot is not available for the selected play area.');
    }
  } catch (e) {
    print('Error: $e');
  }
}
