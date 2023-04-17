import 'package:flutter/material.dart';

class Room extends StatelessWidget {
  final double temperature;
  final int xAxis;
  final int yAxis;

  const Room({
    Key? key,
    required this.temperature,
    required this.xAxis,
    required this.yAxis,
  }) : super(key: key);

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
  Widget build(BuildContext context) {
    final backgroundColor = _getBackgroundColor(temperature);
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      width: xAxis * 1.0,
      height: yAxis * 1.0,
      color: backgroundColor,
      child: Center(
        child: Text(
          temperature.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
