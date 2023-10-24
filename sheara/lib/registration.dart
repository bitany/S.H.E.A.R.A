import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'login.dart';
import '../model/account.dart';
import '../database/accountsDatabase.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _isStudent = true;
  TextEditingController _idxController = TextEditingController();
  TextEditingController _displayNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  void _navigateToLoginScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              TextField(
                controller: _idxController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: _isStudent ? 'Student ID' : 'Employee ID',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _displayNameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: [
                      Radio(
                        value: true,
                        groupValue: _isStudent,
                        onChanged: (value) {
                          setState(() {
                            _isStudent = value as bool;
                          });
                        },
                      ),
                      Text('Student'),
                    ],
                  ),
                  Column(
                    children: [
                      Radio(
                        value: false,
                        groupValue: _isStudent,
                        onChanged: (value) {
                          setState(() {
                            _isStudent = value as bool;
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
                  onPressed: () async {
                    String idx = _idxController.text;
                    String displayName = _displayNameController.text;
                    String password = _passwordController.text;
                    String confirmPassword = _confirmPasswordController.text;
                    int? idNumber;
                    idNumber = int.parse(idx);

                    if (idx.isEmpty || displayName.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill out all the fields.')));
                      return;
                    }

                    if ((idNumber == null) || (idNumber <= 0)) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid ID number.')));
                      return;
                    }

                    if (password != confirmPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('The passwords do not match. Please try again.')));
                      return;
                    }

                    account newAccount = account(
                      idNumber: idNumber,
                      dispname: displayName,
                      password: password,
                      isAuthenticated: false,
                      isStudent: _isStudent,
                      timeCreated: DateTime.now(),
                    );

                    try {
                      await accountsDatabase.instance.create(newAccount);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Account created successfully!')));
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    } catch (e) {
                      if (e is DatabaseException && e.isUniqueConstraintError()) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sorry, this ID number is already registered.')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sorry, something went wrong while creating your account. Error: $e')));
                      }
                    }
                  },
                  child: Text('Register'),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Log in',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = _navigateToLoginScreen,
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}