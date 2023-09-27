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
  final String playAreaSports;
  final String playAreaLocation;
  final double playAreaPrice;
  final String playAreaImageUrl;

  PlayArea({
    required this.id,
    required this.playAreaName,
    required this.playAreaSports,
    required this.playAreaLocation,
    required this.playAreaPrice,
    required this.playAreaImageUrl,
  });

  factory PlayArea.fromJson(Map<String, dynamic> json) {
    return PlayArea(
      id: json['id'],
      playAreaName: json['playAreaName'],
      playAreaSports: json['playAreaSports'],
      playAreaLocation: json['playAreaLocation'],
      playAreaPrice: json['playAreaPrice'].toDouble(),
      playAreaImageUrl: json['playAreaImageUrl'], // Store the image URL as a string
    );
  }
}
