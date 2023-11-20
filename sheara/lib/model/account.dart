import 'package:bcrypt/bcrypt.dart';
final String accountsTable = 'accounts';

class accountsFields {
  static final List<String> values = [
    id, password, isAuthenticated, isStudent,  idNumber, firstname, lastname, dispname, favColor, time, lastSeenLocation, lastSeenTime, needsHelp
  ];
  static final String id = '_id';
  static final String password = 'password';
  static final String isAuthenticated = 'isAuthenticated';
  static final String isStudent = 'isStudent';
  static final String idNumber = 'idNumber';
  static final String firstname = 'firstName';
  static final String lastname = 'lastname';
  static final String dispname = 'dispname';
  static final String favColor = 'favColor';
  static final String time = 'time';
  static final String lastSeenLocation = 'lastSeenLocation';
  static final String lastSeenTime = 'lastSeenTime';
  static final String needsHelp = 'needsHelp';
}

class account {
  final int? id;
  String password;
  bool isAuthenticated;
  bool isStudent;
  int? idNumber;
  String firstname;
  String lastname;
  String dispname;
  String favColor;
  final DateTime timeCreated;
  String lastSeenLocation;
  DateTime lastSeenTime;
  bool needsHelp;

  void updateLocation(String newLocation) {
    lastSeenLocation = newLocation;
  }

  void updateLastSeenTime() {
    lastSeenTime = DateTime.now();
  }

  account({
    this.id,
    required this.password,
    required this.isAuthenticated,
    required this.isStudent,
    this.idNumber,
    this.firstname = '',
    this.lastname = '',
    required this.dispname,
    required this.favColor,
    required this.timeCreated,
    required this.lastSeenLocation,
    required this.lastSeenTime,
    required this.needsHelp,

  });

  account copy({
    int? id,
    String? password,
    bool? isAuthenticated,
    bool? isStudent,
    int? idNumber,
    String? firstname,
    String? lastname,
    String? dispname,
    String? favColor,
    DateTime? timeCreated,
    String? lastSeenLocation,
    DateTime? lastSeenTime,
    bool? needsHelp,
  }) =>
    account(
      id: id ?? this.id,
      password: password ?? this.password,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isStudent: isStudent ?? this.isStudent,
      idNumber: idNumber ?? this.idNumber,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      dispname: dispname ?? this.dispname,
      favColor: favColor ?? this.favColor,
      timeCreated: timeCreated ?? this.timeCreated,
      lastSeenLocation: lastSeenLocation ?? this.lastSeenLocation,
      lastSeenTime: lastSeenTime ?? this.lastSeenTime,
      needsHelp: needsHelp ?? this.needsHelp,
    );

  static account fromJson(Map<String, Object?> json) => account(
    id: json[accountsFields.id] as int?,
    password: json[accountsFields.password] as String,
    isAuthenticated: json[accountsFields.isAuthenticated] == 1,
    isStudent: json[accountsFields.isStudent] == 1,
    idNumber: json[accountsFields.idNumber] as int?,
    firstname: json[accountsFields.firstname] as String,
    lastname: json[accountsFields.lastname] as String,
    dispname: json[accountsFields.dispname] as String,
    favColor: json[accountsFields.favColor] as String,
    timeCreated: DateTime.parse(json[accountsFields.time] as String),
    lastSeenLocation: json[accountsFields.lastSeenLocation] as String,
    lastSeenTime: DateTime.parse(json[accountsFields.lastSeenTime] as String),
    needsHelp: json[accountsFields.needsHelp] == 0,
  );

  Map<String, Object?> toJson() => {
    accountsFields.id: id,
    accountsFields.password: password,
    accountsFields.isAuthenticated: isAuthenticated ? 1 : 0,
    accountsFields.isStudent: isStudent ? 1 : 0,
    accountsFields.idNumber: idNumber,
    accountsFields.firstname: firstname,
    accountsFields.lastname: lastname,
    accountsFields.dispname: dispname,
    accountsFields.favColor: favColor,
    accountsFields.time: timeCreated.toIso8601String(),
    accountsFields.lastSeenLocation: lastSeenLocation,
    accountsFields.lastSeenTime: lastSeenTime.toIso8601String(),
    accountsFields.needsHelp: needsHelp ? 1 : 0,
  };
}