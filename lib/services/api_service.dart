import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/playAreas.dart';

Future<List<PlayArea>> fetchPlayAreas() async {
  final response = await http.get(Uri.parse('http://192.168.0.103:8000/restfinal/api/playareas/'));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body) as List;
    final List<PlayArea> playAreas = jsonData.map((data) {
      return PlayArea.fromJson(
        {
          'id': data['id'],
          'playAreaName': data['playAreaName'],
          'playAreaSports': data['playAreaSports'],
          'playAreaLocation': data['playAreaLocation'],
          'playAreaPrice': data['playAreaPrice'],
          'playAreaVendor': data['playAreaVendor'],
          'playAreaImageUrl': data['playAreaImageUrl'], // Include the image URL
        },
      );
    }).toList();

    return playAreas;
  } else {
    throw Exception('Failed to load playAreas');
  }
}

// Assuming your PlayArea model includes a 'playAreaImageUrl' field.

class PlayAreaListItem extends StatelessWidget {
  final PlayArea playArea;

  PlayAreaListItem({required this.playArea});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(playArea.playAreaName),
      subtitle: Text(playArea.playAreaLocation),
      leading: Image.network(playArea.playAreaImageUrl), // Display image from URL
    );
  }
}


