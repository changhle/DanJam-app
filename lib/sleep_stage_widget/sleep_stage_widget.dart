import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data_manager.dart';
import 'sleep_stage_time_line.dart';

class SleepStageWidget extends StatelessWidget {
  final SleepData sleepData;

  SleepStageWidget(this.sleepData);

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
            Text('Sleep Stages:', style: TextStyle(fontWeight: FontWeight.bold)),
            if (sleepData.items.isNotEmpty)
              Container(
                height: 200,
                margin: EdgeInsets.symmetric(vertical: 0),
                child: SleepStageTimeLine(sleepItems: sleepData.items),
              ),
          ],
        ),
      ),
    );
  }

  String stateToString(int state) {
    switch (state) {
      case 2: return 'Light Sleep';
      case 3: return 'Deep Sleep';
      case 4: return 'REM Sleep';
      case 5: return 'Awake';
      default: return 'Unknown';
    }
  }
}
