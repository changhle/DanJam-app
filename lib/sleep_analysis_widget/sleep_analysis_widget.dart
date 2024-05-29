import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data_manager.dart';

class SleepAnalysisWidget extends StatefulWidget {
  final SleepData sleepData;

  SleepAnalysisWidget(this.sleepData);

  @override
  _SleepDataWidget4State createState() => _SleepDataWidget4State();
}

class _SleepDataWidget4State extends State<SleepAnalysisWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 70),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sleep Analysis:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            FutureBuilder<String>(
              future: widget.sleepData.analysis,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Text(snapshot.data!);
                } else {
                  return Text('No data available.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
