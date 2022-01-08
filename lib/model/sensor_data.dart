class SensorData {
  SensorData(
      {required this.name,
      required this.timestamp,
      required this.temp,
      required this.hum});

  String name;
  DateTime timestamp;
  double temp;
  double hum;

  factory SensorData.fromJson(Map<String, dynamic> json) => SensorData(
        name: json["name"],
        timestamp: DateTime.parse(json["timestamp"]),
        temp: json["temp"],
        hum: json["hum"],
      );
}
