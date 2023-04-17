import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

class Room extends StatefulWidget {
  final int id;
  final int xAxis;
  final int yAxis;
  final bool hasSensor;
  final String sensorId;

  const Room({
    Key? key,
    required this.id,
    required this.xAxis,
    required this.yAxis,
    this.hasSensor = false,
    required this.sensorId,
  }) : super(key: key);

  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
  double _temperature = 0.0;
  static const List<Map<String, dynamic>> _colors = [
    {'min': -100, 'max': 10, 'color': '#0072C6'},
    {'min': 10, 'max': 15, 'color': '#2EB8C0'},
    {'min': 15, 'max': 18, 'color': '#6DBC49'},
    {'min': 18, 'max': 20, 'color': '#E6D43F'},
    {'min': 20, 'max': 23, 'color': '#F7941E'},
    {'min': 23, 'max': 27, 'color': '#ED1C24'},
    {'min': 27, 'max': 30, 'color': '#B9121B'},
    {'min': 30, 'max': 100, 'color': '#0072C6'},
  ];

  Color _getBackgroundColor(double temperature) {
    for (final colorRange in _colors) {
      if (temperature >= colorRange['min'] && temperature < colorRange['max']) {
        return Color(int.parse(colorRange['color'].substring(1, 7), radix: 16) +
            0xFF000000);
      }
    }
    return Colors.grey;
  }

  @override
  void initState() {
    super.initState();
    _initSignalRConnection();
  }

  Future<void> _initSignalRConnection() async {
    try {
      const serverUrl = "http://localhost:5164/temperatureHub";
      final hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();
      await hubConnection.start();
      print("SignalR connection started");

      hubConnection.on("TemperatureUpdate", (_value) {
        List<dynamic> values = _value as List<dynamic>;
        if (values?.isNotEmpty == true) {
          for (var value in values) {
            final Map<String, dynamic> data = value as Map<String, dynamic>;
            if (data['id'] as String == widget.sensorId as String) {
              Future.microtask(() => setState(() {
                    _temperature = (data?['value'] as int).toDouble();
                    print("Temperature updated: $_temperature");
                  }));
            }
          }
        }
      });
    } catch (e) {
      print("Error initializing SignalR connection: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getBackgroundColor(_temperature);
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      width: widget.xAxis * 1.0,
      height: widget.yAxis * 1.0,
      color: backgroundColor,
      child: Center(
        child: Text(
          _temperature.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // hubConnection.stop();
    super.dispose();
  }
}
