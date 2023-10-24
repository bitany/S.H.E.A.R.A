import 'package:bcrypt/bcrypt.dart';
final String accountsTable = 'accounts';

class accountsFields {
  static final List<String> values = [
    id, password, isAuthenticated, isStudent,  idNumber, firstname, lastname, dispname, time
  ];
  static final String id = '_id';
  static final String password = 'password';
  static final String isAuthenticated = 'isAuthenticated';
  static final String isStudent = 'isStudent';
  static final String idNumber = 'idNumber';
  static final String firstname = 'firstName';
  static final String lastname = 'lastname';
  static final String dispname = 'displayName';
  static final String time = 'time';
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
  final DateTime timeCreated;

  account({
    this.id,
    required this.password,
    required this.isAuthenticated,
    required this.isStudent,
    this.idNumber,
    this.firstname = '',
    this.lastname = '',
    required this.dispname,
    required this.timeCreated,

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
    DateTime? timeCreated,
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
      timeCreated: timeCreated ?? this.timeCreated,
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
    timeCreated: DateTime.parse(json[accountsFields.time] as String),
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
    accountsFields.time: timeCreated.toIso8601String(),
  };
}