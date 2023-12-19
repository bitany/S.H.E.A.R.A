  import 'package:flutter_colorpicker/flutter_colorpicker.dart';
  import 'package:flutter/gestures.dart';
  import 'package:flutter/material.dart';
  import 'package:location/location.dart';
  import 'package:sqflite/sqflite.dart';
  import 'login.dart';
  import '../database/accountsDatabase.dart';
  import '../model/account.dart';
  
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
    Color pickerColor = Color(0xff443a49);
    Color currentColor = Color(0xff443a49);
  
    void changeColor(Color color) {
      setState(() => pickerColor = color);
    }
  
    Future<void> _showColorPicker() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Pick your preferred color!'),
            content: SingleChildScrollView(
  
              child: ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: changeColor,
                showLabel: true,
              ),
  
              /*
              child: SlidePicker(
                pickerColor: pickerColor,
                onColorChanged: changeColor,
                colorModel: ColorModel.rgb,
                enableAlpha: false,
                displayThumbColor:true,
                showParams: true,
                showIndicator: true,
                indicatorBorderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
              )
              */
              /*
              child: HueRingPicker(
                pickerColor: pickerColor,
                onColorChanged: changeColor,
                enableAlpha: false,
                displayThumbColor: true,
              ),
              */
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Submit color'),
                onPressed: () {
                  setState(() => currentColor = pickerColor);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return Future.value();
    }
  
    void _navigateToLoginScreen() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icon.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
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
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          hintText: _isStudent ? 'Student ID' : 'Employee ID',
                        ),
                        textAlign: TextAlign.center, // Center-align the text
                      ),
                      const SizedBox(height: 5.0),
                      TextFormField(
                        controller: _displayNameController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          hintText: 'Enter Username',
                        ),
                        textAlign: TextAlign.center, // Center-align the text
                      ),
                      const SizedBox(height: 5.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          hintText: 'Create Password',
                        ),
                        textAlign: TextAlign.center, // Center-align the text
                      ),
                      const SizedBox(height: 5.0),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          hintText: 'Confirm Password',
                        ),
                        textAlign: TextAlign.center, // Center-align the text
                      ),
                      const SizedBox(height: 5.0),
                      GestureDetector(
                        onTap: () async {
                          await _showColorPicker();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 50.0),
                              child: Text(
                                'Pick a Color',
                              ),
                            ),
                            Container(
                              width: 100,
                              height: 50,
                              color: currentColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5.0),
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
                      ElevatedButton(
                        onPressed: () async {
                          String idx = _idxController.text;
                          String displayName = _displayNameController.text;
                          String password = _passwordController.text;
                          String confirmPassword =
                              _confirmPasswordController.text;
                          int? idNumber;
                          idNumber = int.parse(idx);
  
                          if (idx.isEmpty ||
                              displayName.isEmpty ||
                              password.isEmpty ||
                              confirmPassword.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text('Please fill out all the fields.')));
                            return;
                          }
  
                          if ((idNumber == null) || (idNumber <= 0)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Invalid ID number.')));
                            return;
                          }
  
                          if (password != confirmPassword) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'The passwords do not match. Please try again.')));
                            return;
                          }
  
                          Location location = Location();
                          LocationData? userLocation =
                              await location.getLocation();
  
                          account newAccount = account(
                            idNumber: idNumber,
                            dispname: displayName,
                            favColor: currentColor.toString(),
                            password: password,
                            isAuthenticated: false,
                            isStudent: _isStudent,
                            timeCreated: DateTime.now(),
                            lastSeenLocation:
                                "${userLocation.latitude}, ${userLocation.longitude}",
                            lastSeenTime: DateTime.now(),
                            needsHelp: false,
                          );
  
                          try {
                            await accountsDatabase.instance.create(newAccount);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Account created successfully!')));
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          }
                          catch (e) {
                            if (e is DatabaseException &&
                                e.isUniqueConstraintError()) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Sorry, this ID number is already registered.')));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Sorry, something went wrong while creating your account. Error: $e')));
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Register'),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/login'); // Added / to the route name
                          print('Login');
                        },
                        child: const Text.rich(
                          TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Already have an account? ',
                                style: TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text: 'Log in',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
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
