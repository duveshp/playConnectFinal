class Booking {
  final String playAreaName;
  final String playAreaDate;
  final String playAreaTime;
  final String playAreaVendor;
  final String playAreaSports;

  Booking({
    required this.playAreaName,
    required this.playAreaDate,
    required this.playAreaTime,
    required this.playAreaVendor,
    required this.playAreaSports,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      playAreaName: json['bookingPlayAreaName'],
      playAreaDate: json['bookingPlayAreaDate'],
      playAreaTime: json['bookingPlayAreaTime'],
      playAreaVendor: json['bookingPlayAreaVendor'],
      playAreaSports: json['bookingPlayAreaSports'],
    );
  }
}
