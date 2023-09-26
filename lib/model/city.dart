// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class City {
  final String name;
  final String country;
  final String state;
  final double lat;
  final double lon;
  City({
    required this.name,
    required this.country,
    required this.state,
    required this.lat,
    required this.lon,
  });

  City copyWith({
    String? name,
    String? country,
    String? state,
    double? lat,
    double? lon,
  }) {
    return City(
      name: name ?? this.name,
      country: country ?? this.country,
      state: state ?? this.state,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'country': country,
      'state': state,
      'lat': lat,
      'lon': lon,
    };
  }

  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      name: map['name'] as String,
      country: map['country'] as String,
      state: map['state'] as String,
      lat: map['lat'] as double,
      lon: map['lon'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory City.fromJson(String source) => City.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'City(name: $name, country: $country, state: $state, lat: $lat, lon: $lon)';
  }

  @override
  bool operator ==(covariant City other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.country == country &&
      other.state == state &&
      other.lat == lat &&
      other.lon == lon;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      country.hashCode ^
      state.hashCode ^
      lat.hashCode ^
      lon.hashCode;
  }
}
