// signals_master_list.dart

import 'package:flutter/material.dart';
import '../database/signalsDatabase.dart';
import '../model/helpSignal.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignalsMasterList(),
    );
  }
}

class SignalsMasterList extends StatefulWidget {
  @override
  _SignalsMasterListState createState() => _SignalsMasterListState();
}

class _SignalsMasterListState extends State<SignalsMasterList> {
  late List<helpSignal> _signals;

  @override
  void initState() {
    super.initState();
    _loadSignals();
  }

  Future<void> _loadSignals() async {
    try {
      List<helpSignal> signals = await helpSignalsDatabase.instance.getAllHelpSignals();
      setState(() {
        _signals = signals;
      });
    } catch (e) {
      print('Error loading signals: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signals Master List'),
      ),
      body: _signals != null
          ? ListView.builder(
        itemCount: _signals.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Victim: ${_signals[index].victimName}'),
            subtitle: Text('Urgency Level: ${_signals[index].urgencyLevel.toString()}'),
            onTap: () {
              // Add any action you want when a signal is tapped
            },
          );
        },
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
