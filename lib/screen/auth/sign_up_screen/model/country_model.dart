class CountryModelData {
  final String name;
  final String flag;
  final String code; // নতুন যোগ করা: 2-digit ISO code
  final double lat;
  final double lng;

  CountryModelData({
    required this.name,
    required this.flag,
    required this.code,
    required this.lat,
    required this.lng,
  });

  factory CountryModelData.fromJson(Map<String, dynamic> json) {
    final coordinates = json['coordinates'] as Map<String, dynamic>;
    return CountryModelData(
      name: json['name'] as String,
      flag: json['flag'] as String,
      code: json['code'] as String, // JSON থেকে code নেওয়া
      lat: (coordinates['latitude'] as num).toDouble(),
      lng: (coordinates['longitude'] as num).toDouble(),
    );
  }

  @override
  String toString() {
    return 'Country(name: $name, code: $code, flag: $flag, lat: $lat, lng: $lng)';
  }
}

final List<CountryModelData> countries = [
  CountryModelData(name: "Pakistan", flag: "https://flagcdn.com/pk.svg", code: "PK", lat: 30.3753, lng: 69.3451),
];
