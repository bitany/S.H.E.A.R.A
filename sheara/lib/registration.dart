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
  String _selectedUserType = 'Student'; // Default user type

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
                  labelText: _selectedUserType == 'Student'
                      ? 'Enter Student ID'
                      : 'Enter Employee ID',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _displayNameController,
                decoration: InputDecoration(
                  labelText: 'Enter Name',
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
                  onPressed: () async {
                    String idx = _idxController.text;
                    String displayName = _displayNameController.text;
                    String password = _passwordController.text;
                    String confirmPassword = _confirmPasswordController.text;

                    if (idx.isEmpty || displayName.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill out all the required fields.')));
                      return;
                    }

                    if (password != confirmPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sorry, the two passwords you entered do not match.')));
                      return;
                    }

                    int? sidNumber;
                    int? eidNumber;
                    if (_selectedUserType == 'Student') {
                      sidNumber = int.parse(idx);
                    } else if (_selectedUserType == 'Employee') {
                      eidNumber = int.parse(idx);
                    }

                    if ((sidNumber == null && eidNumber == null) || (sidNumber != null && sidNumber <= 0) || (eidNumber != null && eidNumber <= 0)) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sorry, your ID number is invalid.')));
                      return;
                    }

                    account newAccount = account(
                      sidnumber: sidNumber,
                      eidnumber: eidNumber,
                      dispname: displayName,
                      password: password,
                      isAuthenticated: false,
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