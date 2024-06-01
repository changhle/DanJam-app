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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Heart Rate:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
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
              LayoutBuilder(
                builder: (context, constraints) {
                  return Align(
                    alignment: Alignment(-0.3, 0.0),
                    child: Container(
                      width: constraints.maxWidth * 0.9,
                      height: 40,
                      // padding: EdgeInsets.zero,
                      margin: EdgeInsets.symmetric(vertical: 0),
                      child: CustomPaint(
                        painter: HeartRateBarPainter(sleepData),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
