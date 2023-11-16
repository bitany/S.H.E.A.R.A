import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
//import 'mapScreen.dart';
import 'homepage.dart';
import 'registration.dart';
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
      _showSnackBar('Please fill out all the fields.');
      return;
    }

    int? idNumber;
    idNumber = int.tryParse(idx);

    if (idNumber == null || idNumber <= 0) {
      _showSnackBar('Invalid ID number. Please try again.');
      return;
    }

    bool isStudent = _selectedUserType == 'Student';

    account? existingAccount = await accountsDatabase.instance.getAccount(idNumber, isStudent, password);

    if (existingAccount != null) {
      _showSnackBar('Login successful! Welcome, ${existingAccount.dispname}!');
      Navigator.pushReplacement(
        context,
        //MaterialPageRoute(builder: (context) => MapScreen(currentUser: existingAccount)),
        MaterialPageRoute(builder: (context) => HomePage(currentUser: existingAccount)),
      );
    } else {
      _showSnackBar('Invalid credentials. Please try again.');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          // Wrap the Column with a SingleChildScrollView
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/girl.png'),
              Container(
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.blueGrey,
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "Hi, I'm SHEARA!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _idxController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        hintText: _selectedUserType == 'Student'
                            ? 'Student ID'
                            : 'Employee ID',
                      ),
                    ),
                    /*const SizedBox(height: 10.0),
                    TextFormField(

                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        hintText: 'Enter Username',
                      ),
                    ), will update login page to include username sa credentials check*/
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        hintText: 'Enter Password',
                      ),
                    ),
                    const SizedBox(height: 10.0),
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
                    ElevatedButton(
                      onPressed: _performLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Log in'),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Don't have an account? ", style: TextStyle(color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RegistrationScreen()),
                              );
                            },
                            child: Text("Register",style: TextStyle(color: Colors.blue,),),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}