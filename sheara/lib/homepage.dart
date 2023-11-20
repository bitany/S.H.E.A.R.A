import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import '../database/accountsDatabase.dart';
import '../model/account.dart';
import 'about_page.dart';
import 'guide.dart';
import 'send_sos.dart';
import 'settings.dart';

class HomePage extends StatefulWidget {
  @override
  final account currentUser;
  HomePage({required this.currentUser});

  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late MapController _mapController;
  late LocationData _currentLocation;
  double _zoomLevel = 16;
  late Location _location;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _location = Location();
    _currentLocation =
        LocationData.fromMap({'latitude': 10.640960, 'longitude': 122.237747});

    _location.onLocationChanged.listen((LocationData locationData) {
      setState(() {
        _currentLocation = locationData;
      });
    });
  }

  void _zoomIn() {
    double currentZoom = _mapController.zoom;
    _mapController.move(
        LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
        currentZoom + 0.5);
  }

  void _zoomOut() {
    double currentZoom = _mapController.zoom;
    _mapController.move(
        LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
        currentZoom - 0.5);
  }

  void _centerOnMarker() {
    _mapController.move(
        LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
        _zoomLevel);
  }

  void _toggleHelpStatus() async {
    bool newHelpStatus = !widget.currentUser.needsHelp;
    widget.currentUser.needsHelp = newHelpStatus;

    try {
      await accountsDatabase.instance.update(widget.currentUser);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Help status updated!'),
      ));
    } catch (e) {
      print('Error updating help status: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update help status. Please try again.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    String uColor1 = widget.currentUser.favColor;
    String remove1 = 'Color(';
    String uColor2 = uColor1.replaceAll(remove1, '');
    String remove2 = ')';
    String navColor = uColor2.replaceAll(remove2, '');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(int.parse(navColor)),
        centerTitle: true,
        title: Text(widget
            .currentUser.dispname), // Replace with the user's actual username
        leading: IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Settings()),
            );
          },
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'preference') {
                // Handle preference
              } else if (value == 'guide') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GuidePage()),
                );
              } else if (value == 'about') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'preference',
                  child: Text('Preference'),
                ),
                PopupMenuItem(
                  value: 'guide',
                  child: Text('Guide'),
                ),
                PopupMenuItem(
                  value: 'about',
                  child: Text('About the Developer'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/home_bg.png', // Replace with your image file path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SquareButton(imageAsset: 'assets/camera.png'),
                      SquareButton(imageAsset: 'assets/video.png'),
                    ],
                  ),
                  GestureDetector(
                    onLongPress: () {
                      showColorCircles(context);
                    },
                    child: Transform.scale(
                      scale: 1.5,
                      child: Image.asset(
                        'assets/snake_button.png',
                        width: 150,
                        height: 150,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SquareButton(imageAsset: 'assets/microphone.png'),
                      SquareButton(imageAsset: 'assets/chat.png'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showColorCircles(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleButton(
                color: Color.fromARGB(255, 10, 10, 10),
                onTap: () => navigateToSendSOSPage(context),
                onToggleHelpStatus: _toggleHelpStatus,
                buttonText: 'Critical',
              ),
              // Add other colored buttons here with their respective logic
              CircleButton(
                color: Color.fromARGB(255, 42, 42, 42),
                onTap: () => navigateToSendSOSPage(context),
                onToggleHelpStatus: _toggleHelpStatus,
                buttonText: 'High',
              ),
              CircleButton(
                color: Color.fromARGB(255, 115, 115, 115),
                onTap: () => navigateToSendSOSPage(context),
                onToggleHelpStatus: _toggleHelpStatus,
                buttonText: 'Medium',
              ),
              CircleButton(
                color: Color.fromARGB(255, 153, 153, 153),
                onTap: () => navigateToSendSOSPage(context),
                onToggleHelpStatus: _toggleHelpStatus,
                buttonText: 'Low',
              ),
              CircleButton(
                color: const Color.fromARGB(255, 190, 190, 190),
                onTap: () => navigateToSendSOSPage(context),
                onToggleHelpStatus: _toggleHelpStatus,
                buttonText: 'Advisory',
              ),
            ],
          ),
        );
      },
    );
  }

  void navigateToSendSOSPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SendSOSPage(currentUser: widget.currentUser),
      ),
    );
  }
}

class SquareButton extends StatelessWidget {
  final String imageAsset;

  SquareButton({required this.imageAsset});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        imageAsset,
        width: 100, // Adjust the width as needed
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  final Color color;
  final String buttonText;
  final Function()? onTap;
  final Function()? onToggleHelpStatus;

  CircleButton(
      {required this.color,
      this.onTap,
      this.onToggleHelpStatus,
      required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
        onToggleHelpStatus?.call();
      },
      child: Container(
          width: 72,
          height: 70,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.rectangle,
          ),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(2),
              child: Text(
                buttonText,
                style: TextStyle(
                  color: const Color.fromARGB(255, 223, 28, 14), // Text color
                  fontWeight: FontWeight.bold,
                  fontSize: 16, // Text font size
                ),
              ),
            ),
          )),
    );
  }
}
