import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data_manager.dart';

class SleepStageTimeLine extends StatelessWidget {
  final List<SleepItem> sleepItems;

  const SleepStageTimeLine({Key? key, required this.sleepItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalDuration = sleepItems.last.endTime - sleepItems.first.startTime;
        final double scaleFactor = constraints.maxWidth / totalDuration;
        final double barHeight = constraints.maxHeight / 14; // 줄의 두께 변경
        final double canvasHeight = constraints.maxHeight;

        List<Widget> bars = [];

        for (var i = 0; i < sleepItems.length; i++) {
          var item = sleepItems[i];
          final startTime = (item.startTime - sleepItems.first.startTime) * scaleFactor;
          final endTime = (item.endTime - sleepItems.first.startTime) * scaleFactor;
          final top = getTopPositionForState(item.state, canvasHeight) + barHeight * 2;

          var currentWidget = Positioned(
            left: startTime,
            top: top,
            child: Tooltip(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(4),
              ),
              message: '${stateToString(item.state)} from ${DateTime.fromMillisecondsSinceEpoch(item.startTime * 1000).hour}:${DateTime.fromMillisecondsSinceEpoch(item.startTime * 1000).minute} to ${DateTime.fromMillisecondsSinceEpoch(item.endTime * 1000).hour}:${DateTime.fromMillisecondsSinceEpoch(item.endTime * 1000).minute}',
              child: Container(
                width: endTime - startTime,
                height: barHeight,
                decoration: BoxDecoration(
                  color: getColorForState(item.state),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          );
          bars.add(currentWidget);
        }

        return Stack(
          children: [
            CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: BackgroundGridPainter(canvasHeight: canvasHeight),
            ),
            ...bars,
          ],
        );
      },
    );
  }

  double getTopPositionForState(int state, double canvasHeight) {
    switch (state) {
      case 2: return 3 * canvasHeight / 6 - 2;  // deep Sleep
      case 3: return 2 * canvasHeight / 6 - 2;  // light Sleep
      case 4: return 1 * canvasHeight / 6 - 2;  // REM Sleep
      case 5: return 0 * canvasHeight / 6 - 2;  // Awake
      default: return canvasHeight;  // Default position
    }
  }

  Color getColorForState(int state) {
    switch (state) {
      case 2: return Colors.blue.shade900; // deep Sleep
      case 3: return Colors.blue; // light Sleep
      case 4: return Colors.blue.shade200; // REM Sleep
      case 5: return Colors.orange.shade200; // Awake
      default: return Colors.grey;
    }
  }

  String stateToString(int state) {
    switch (state) {
      case 1: return 'Awake';
      case 2: return 'Deep Sleep';
      case 3: return 'Light Sleep';
      case 4: return 'REM Sleep';
      case 5: return 'Awake';
      default: return 'Unknown';
    }
  }
}

class BackgroundGridPainter extends CustomPainter {
  final double canvasHeight;

  BackgroundGridPainter({required this.canvasHeight});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black12
      ..strokeWidth = 1.0;

    double step = canvasHeight / 6;
    for (double i = step; i < canvasHeight; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}