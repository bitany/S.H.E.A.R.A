import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'database/accountsDatabase.dart';
import 'database/signalsDatabase.dart';
import 'model/account.dart';
import 'model/helpSignal.dart';
import 'login.dart';
import 'registration.dart';
import 'mapScreen.dart';

//hello
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isDatabaseEmpty = await accountsDatabase.instance.isDatabaseEmpty();

  // If the database is empty, add dummy accounts
  if (isDatabaseEmpty) {
    List<account> dummyAccounts = [
      account(
        idNumber: 2019,
        dispname: "Hadjie",
        favColor: "Color(0xFFFF0000)",
        password: "1111",
        isAuthenticated: false,
        isStudent: true,
        timeCreated: DateTime.now(),
        lastSeenLocation:
        "${10.6407}, ${122.2274}",
        lastSeenTime: DateTime.now(),
        needsHelp: false,
      ),
      account(
        idNumber: 2020,
        dispname: "Lamao",
        favColor: "Color(0xFFFF1111)",
        password: "1111",
        isAuthenticated: false,
        isStudent: true,
        timeCreated: DateTime.now(),
        lastSeenLocation:
        "${10.6407}, ${122.2330}",
        lastSeenTime: DateTime.now(),
        needsHelp: false,
      ),
    ];

    for (var dummyAccount in dummyAccounts) {
      await accountsDatabase.instance.create(dummyAccount);
    }
  }
  // Dummy accounts


  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyAppHomePage(),
      routes: {
        '/login': (context) => LoginScreen(),
        //'/send_sos': (context) => SendSOSPage(),
        '/register': (context) =>
            RegistrationScreen(), // Add registration route
      },
    );
  }
}

class MyAppHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 60, 74),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Upper Section: Dark Gray Background after the image
          Container(
            color: Color.fromARGB(255, 135, 155, 175),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'Hi, I am SHEARA!',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Transform.scale(
                  scale: 1.5,
                  child: Image.asset(
                    'assets/animal.gif',
                    width: 300,
                    height: 300,
                  ),
                ),
              ],
            ),
          ),

          // Middle Section: Send SOS Button
          Container(
            color: Color.fromARGB(255, 216, 227, 238),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    'You need help right now?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, '/send_sos'); // Navigate to Send SOS page
                  },
                  child: Text('Send SOS'),
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                ),
                SizedBox(height: 20), // Add space below the button
              ],
            ),
          ),

          // Lower Section: Registration Button
          Container(
            color: Color.fromARGB(255, 0, 60, 74),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20), // Add space above the button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the registration page
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text('Register'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    foregroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 52, 51, 54),
                    ),
                  ),
                ),

                SizedBox(height: 10), // Add space below the button
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                    print('Login');
                  },
                  child: Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: Colors.yellow,
                          ),
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
    );
  }
}
