import 'dart:convert';

class TransportPosition {
  final String transport_id;
  final double lat;
  final double lon;

  TransportPosition({
    required this.transport_id,
    required this.lat,
    required this.lon
  });

  factory TransportPosition.fromRawJson(String str) =>
      TransportPosition.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  factory TransportPosition.fromMap(Map<String, dynamic> json) => TransportPosition(
    transport_id: json['transport_id'],
    lat: json['lat'],
    lon: json['lon']
  );

  Map<String, dynamic> toMap() => {
    'transport_id': transport_id,
    'lat': lat,
    'lon': lon
  };
}