import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data_manager.dart';

class SleepInfoWidget extends StatelessWidget {
  final SleepData sleepData;

  SleepInfoWidget(this.sleepData);

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
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  '         Breath Quality:',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  '         ${sleepData.breathQuality}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  '         Awake Time:',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  '            ${sleepData.awakeCount}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
