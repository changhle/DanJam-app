import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data_manager.dart';
import 'heart_rate_bar_painter.dart';


class HeartRateWidget extends StatelessWidget {
  final SleepData sleepData;

  HeartRateWidget(this.sleepData);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Heart Rate:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Center(
              child: Text(
                '❤️ ${sleepData.avgHr} bpm',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            if (sleepData.items.isNotEmpty)
              Container(
                width: 200,
                height: 40,
                margin: EdgeInsets.symmetric(vertical: 0),
                child: CustomPaint(
                  painter: HeartRateBarPainter(sleepData),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
