import 'dart:convert';


class CatalogModel{


  static List<PlayArea> playAreas=[];

  //Get item by id
  PlayArea getById(int id) => playAreas.firstWhere((element) => element.id==id, orElse: null);

  // Get Item by position
  PlayArea getByPosition(int pos) => playAreas[pos];

}



class PlayArea {
  final int id;
  final String playAreaName;
  final String playAreaVendor;
  final String playAreaSports;
  final String playAreaLocation;
  final double playAreaPrice;
  final String playAreaImageUrl;

  PlayArea({
    required this.id,
    required this.playAreaName,
    required this.playAreaVendor,
    required this.playAreaSports,
    required this.playAreaLocation,
    required this.playAreaPrice,
    required this.playAreaImageUrl,
  });

  factory PlayArea.fromJson(Map<String, dynamic> json) {
    return PlayArea(
      id: json['id'] ?? 0, // Provide a default value (e.g., 0) for nullable fields
      playAreaName: json['playAreaName'] ?? 'Unknown',
      playAreaSports: json['playAreaSports'] ?? 'Unknown',
      playAreaLocation: json['playAreaLocation'] ?? 'Unknown',
      playAreaPrice: (json['playAreaPrice'] as num?)?.toDouble() ?? 0.0,
      playAreaVendor: json['playAreaVendor'] ?? 'Unknown',
      playAreaImageUrl: json['playAreaImageUrl'] ?? 'No Image', // Provide a default URL or message
    );
  }

}
