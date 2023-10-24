import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../model/account.dart';
import '../database/accountsDatabase.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _selectedUserType = 'Student'; // Default user type

  TextEditingController _idxController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _performLogin() async {
    String idx = _idxController.text;
    String password = _passwordController.text;

    if (idx.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill out all the required fields.');
      return;
    }

    int? id;
    String userType;

    if (_selectedUserType == 'Student') {
      userType = 'Student';
      id = int.tryParse(idx);

      if (id == null || id <= 0) {
        _showSnackBar('Invalid Student ID number.');
        return;
      }
    } else {
      userType = 'Employee';
      id = int.tryParse(idx);

      if (id == null || id <= 0) {
        _showSnackBar('Invalid Employee ID number.');
        return;
      }
    }

    try {
      account? userAccount = await accountsDatabase.instance.getAccountByIdAndType(id, userType);

      if (userAccount != null && userAccount.password == password) {
        _showSnackBar('Login successful!');
      } else {
        _showSnackBar('Incorrect ID or password. Please try again.');
      }
    } catch (e) {
      _showSnackBar('Error occurred while logging in. Please try again later.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 100.0, horizontal: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              TextField(
                controller: _idxController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: _selectedUserType == 'Student'
                      ? 'Enter Student ID'
                      : 'Enter Employee ID',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Enter Password',
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: [
                      Radio(
                        value: 'Student',
                        groupValue: _selectedUserType,
                        onChanged: (value) {
                          setState(() {
                            _selectedUserType = value.toString();
                          });
                        },
                      ),
                      Text('Student'),
                    ],
                  ),
                  Column(
                    children: [
                      Radio(
                        value: 'Employee',
                        groupValue: _selectedUserType,
                        onChanged: (value) {
                          setState(() {
                            _selectedUserType = value.toString();
                          });
                        },
                      ),
                      Text('Employee'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _performLogin,
                  child: Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}