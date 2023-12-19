import 'package:latlong2/latlong.dart';

final String signalsTable = 'signals';

class signalsFields {
  static final List<String> values = [
    id, victimName, urgencyLevel, lastSeenLocation
  ];
  static final String id = '_id';
  static final String victimName = 'victimName';
  static final String urgencyLevel = 'urgencyLevel';
  static final String lastSeenLocation = 'lastSeenLocation';
}

class helpSignal {
  final int? id;
  String victimName;
  UrgencyLevel urgencyLevel;
  String lastSeenLocation;

  void updateLocation(String newLocation) {
    lastSeenLocation = newLocation;
  }

  helpSignal({
    this.id,
    required this.victimName,
    required this.urgencyLevel,
    required this.lastSeenLocation,
  });

  helpSignal copy({
    int? id,
    String? victimName,
    UrgencyLevel? urgencyLevel,
    String? lastSeenLocation,
  }) =>
      helpSignal(
        id: id ?? this.id,
        victimName: victimName ?? this.victimName,
        urgencyLevel: urgencyLevel ?? this.urgencyLevel,
        lastSeenLocation: lastSeenLocation ?? this.lastSeenLocation,
      );

  Map<String, dynamic> toJson() {
    return {
      'victimName': victimName,
      'urgencyLevel': urgencyLevel.index,
      'lastSeenLocation': lastSeenLocation,
    };
  }

  factory helpSignal.fromJson(Map<String, dynamic> json) {
    return helpSignal(
      victimName: json['victimName'],
      urgencyLevel: UrgencyLevel.values[json['urgencyLevel']],
      lastSeenLocation: json[signalsFields.lastSeenLocation] as String,
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
