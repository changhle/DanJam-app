import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data_manager.dart';
import 'sleep_duration_chart.dart';


class SleepDurationWidget extends StatelessWidget {
  final SleepData sleepData;

  SleepDurationWidget(this.sleepData);

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
            Text('Sleep Duration:', style: TextStyle(fontWeight: FontWeight.bold)),
            if (sleepData.items.isNotEmpty)
              Container(
                width: 200,
                height: 180,
                margin: EdgeInsets.symmetric(vertical: 0),
                child: SleepDurationChart(sleepData: sleepData),
              ),
          ],
        ),
      ),
    );
  }
}