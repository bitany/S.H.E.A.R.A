import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responder App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ResponderPage(),
    );
  }
}

class ResponderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 176, 53, 0),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Handle settings button press
            },
            color: Color.fromARGB(
                255, 199, 199, 199), // Replace with your custom color
          ),
        ],
      ),
      body: Center(),
    );
  }
}
