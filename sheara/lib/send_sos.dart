import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import '../database/accountsDatabase.dart';
import '../model/account.dart';

class SendSOSPage extends StatefulWidget {
  final account currentUser;
  SendSOSPage({required this.currentUser});

  @override
  _SendSOSPageState createState() => _SendSOSPageState();
}

class _SendSOSPageState extends State<SendSOSPage> {
  late MapController _mapController;
  late LocationData _currentLocation;
  double _zoomLevel = 16;
  late Location _location;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _location = Location();
    _currentLocation = LocationData.fromMap({'latitude': 10.640960, 'longitude': 122.237747});

    _location.onLocationChanged.listen((LocationData locationData) {
      setState(() {
        _currentLocation = locationData;
      });
    });
  }

  Widget build(BuildContext context) {
    String uColor1 = widget.currentUser.favColor;
    String remove1 = 'Color(';
    String uColor2 = uColor1.replaceAll(remove1, '');
    String remove2 = ')';
    String navColor = uColor2.replaceAll(remove2, '');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(int.parse(navColor)),
        automaticallyImplyLeading: false,
        title: Text('Send SOS'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Add action for the profile icon here
            },
          ),
          Expanded(
            child: Center(
              child: Text(
                widget.currentUser.dispname, // Replace with the actual username
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text('Preferences'),
                ),
                PopupMenuItem(
                  child: Text('Guide'),
                ),
                PopupMenuItem(
                  child: Text('About the Developer'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
              zoom: _zoomLevel,
              minZoom: 10.0,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                // urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                urlTemplate: 'https://tile-{s}.openstreetmap.fr/hot/{z}/{x}/{y}.png',
                // urlTemplate: 'http://tile.stamen.com/terrain/{z}/{x}/{y}.jpg',
                // urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                // urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 40.0,
                    height: 40.0,
                    point: LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
                    child: Icon(
                      Icons.location_pin,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red[300],
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam),
            label: 'Video',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'Microphone',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}
