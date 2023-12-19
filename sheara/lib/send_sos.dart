import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import '../database/accountsDatabase.dart';
import '../database/signalsDatabase.dart';
import '../model/account.dart';
import '../model/helpSignal.dart';

class SendSOSPage extends StatefulWidget {
  final account currentUser;
  final helpSignal? newHelpSignal;

  SendSOSPage({required this.currentUser, this.newHelpSignal});

  @override
  _SendSOSPageState createState() => _SendSOSPageState();
}

class _SendSOSPageState extends State<SendSOSPage> {
  late MapController _mapController;
  late LocationData _currentLocation;
  double _zoomLevel = 16;
  late Location _location;
  List<Marker> _mapMarkers = [];

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

    _loadHelpSignals(_mapMarkers);
  }

  void _centerOnMarker() {
    _mapController.move(LatLng(_currentLocation.latitude!, _currentLocation.longitude!), _zoomLevel);
  }

  Future<void> _loadHelpSignals(List<Marker> _mapMarkers) async {
    List<Marker> markers = [];
    try {
      markers.add(
        Marker(
          width: 50.0,
          height: 50.0,
          point: LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
          child: Icon(
            Icons.location_pin,
            color: Colors.black,
          ),
        ),
      );

      List<helpSignal> helpSignals = await helpSignalsDatabase.instance.getAllHelpSignals();
      for (var signal in helpSignals) {
        Color markerColor;

        switch (signal.urgencyLevel) {
          case UrgencyLevel.Advisory:
            markerColor = Colors.blue;
            break;
          case UrgencyLevel.Low:
            markerColor = Color.fromARGB(255, 59, 200, 8);
            break;
          case UrgencyLevel.Medium:
            markerColor = Color.fromARGB(255, 224, 192, 8);
            break;
          case UrgencyLevel.High:
            markerColor = Color.fromARGB(255, 226, 105, 5);
            break;
          case UrgencyLevel.Critical:
            markerColor = Color.fromARGB(255, 222, 11, 11);
            break;
        }

        List<String> coordinates = signal.lastSeenLocation.split(', ');
        double latitude = double.parse(coordinates[0]);
        double longitude = double.parse(coordinates[1]);

        if (coordinates.length == 2) {
          markers.add(
            Marker(
              width: 40.0,
              height: 40.0,
              point: LatLng(latitude, longitude),
              child: Icon(
                Icons.location_pin,
                color: markerColor,
              ),
            ),
          );
        }
        else {
          throw ArgumentError('Invalid coordinates format: $coordinates');
        }
      }



    } catch (e) {
      print('Error loading help signals: $e');
    }

    setState(() {
      _mapMarkers = markers;
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _centerOnMarker,
            child: Icon(Icons.my_location),
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
                markers: //_mapMarkers,
                [
                  Marker(
                    width: 40.0,
                    height: 40.0,
                    point: LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
                    child: Icon(
                      Icons.location_pin,
                      color: Colors.black,
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
