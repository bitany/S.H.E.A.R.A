import 'package:bcrypt/bcrypt.dart';
final String accountsTable = 'accounts';

class accountsFields {
  static final List<String> values = [
    /// Add all fields
    id, password, isAuthenticated, sidnumber, eidnumber, firstname, lastname, dispname, time
  ];

  static final String id = '_id';
  static final String password = 'password';
  static final String isAuthenticated = 'isAuthenticated';
  static final String sidnumber = 'studentIDNumber';
  static final String eidnumber = 'employeeIDNumber';
  static final String firstname = 'firstName';
  static final String lastname = 'lastname';
  static final String dispname = 'displayName';
  static final String time = 'time';
}

class account {
  final int? id;
  final String password;
  final bool isAuthenticated;
  final int sidnumber;
  final int eidnumber;
  final String firstname;
  final String lastname;
  final String dispname;
  final DateTime timeCreated;

  const account({
    this.id,
    required this.password,
    required this.isAuthenticated,
    required this.sidnumber,
    required this.eidnumber,
    required this.firstname,
    required this.lastname,
    required this.dispname,
    required this.timeCreated,
  });

  account copy({
    int? id,
    String? password,
    bool? isAuthenticated,
    int? sidnumber,
    int? eidnumber,
    String? firstname,
    String? lastname,
    String? dispname,
    DateTime? timeCreated,
  }) =>
      account(
        id: id ?? this.id,
        password: password ?? this.password,
        isAuthenticated: isAuthenticated ?? this.isAuthenticated,
        sidnumber: sidnumber ?? this.sidnumber,
        eidnumber: eidnumber ?? this.eidnumber,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        dispname: dispname ?? this.dispname,
        timeCreated: timeCreated ?? this.timeCreated,
      );

  static account fromJson(Map<String, Object?> json) => account(
    id: json[accountsFields.id] as int?,
    password: json[accountsFields.password] as String,
    isAuthenticated: json[accountsFields.isAuthenticated] == 1,
    sidnumber: json[accountsFields.sidnumber] as int,
    eidnumber: json[accountsFields.eidnumber] as int,
    firstname: json[accountsFields.firstname] as String,
    lastname: json[accountsFields.lastname] as String,
    dispname: json[accountsFields.dispname] as String,
    timeCreated: DateTime.parse(json[accountsFields.time] as String),
  );

  Map<String, Object?> toJson() => {
    accountsFields.id: id,
    accountsFields.password: password,
    accountsFields.isAuthenticated: isAuthenticated ? 1 : 0,
    accountsFields.sidnumber: sidnumber,
    accountsFields.eidnumber: eidnumber,
    accountsFields.firstname: firstname,
    accountsFields.lastname: lastname,
    accountsFields.dispname: dispname,
    accountsFields.time: timeCreated.toIso8601String(),
  };
}