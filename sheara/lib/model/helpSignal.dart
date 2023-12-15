import 'package:latlong2/latlong.dart';

final String signalsTable = 'signals';

class signalsFields {
  static final List<String> values = [
    id, displayName
  ];
  static final String id = '_id';
  static final String displayName = 'displayName';
}

class helpSignal {
  final int? id;
  String displayName;
  UrgencyLevel urgencyLevel;
  List<LocationInfo> lastSeenLocations;

  helpSignal({
    this.id,
    required this.displayName,
    required this.urgencyLevel,
    required this.lastSeenLocations,
  });

  helpSignal copy({
    int? id,
    String? displayName,
    UrgencyLevel? urgencyLevel,
    List<LocationInfo>? lastSeenLocations,
  }) =>
      helpSignal(
        id: id ?? this.id,
        displayName: displayName ?? this.displayName,
        urgencyLevel: urgencyLevel ?? this.urgencyLevel,
        lastSeenLocations: lastSeenLocations ?? this.lastSeenLocations,
      );

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'urgencyLevel': urgencyLevel.index,
      'lastSeenLocations': lastSeenLocations.map((location) => location.toJson()).toList(),
    };
  }

  factory helpSignal.fromJson(Map<String, dynamic> json) {
    return helpSignal(
      displayName: json['displayName'],
      urgencyLevel: UrgencyLevel.values[json['urgencyLevel']],
      lastSeenLocations: List<LocationInfo>.from(
        json['lastSeenLocations'].map((locationJson) => LocationInfo.fromJson(locationJson)),
      ),
    );
  }
}

enum UrgencyLevel {
  Advisory,
  Low,
  Medium,
  High,
  Critical,
}

class LocationInfo {
  LatLng coordinates;
  DateTime timestamp;

  LocationInfo({
    required this.coordinates,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': coordinates.latitude,
      'longitude': coordinates.longitude,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
      coordinates: LatLng(json['latitude'], json['longitude']),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}