import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import '../data_manager.dart';

class HeartRateBarPainter extends CustomPainter {
  final SleepData sleepData;

  HeartRateBarPainter(this.sleepData);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint barPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;

    final Paint rangePaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

    final Paint avgLinePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final barRect = Rect.fromLTWH(5, 1, size.width, 35);
    canvas.drawRect(barRect, barPaint);

    final double minPos = (sleepData.minHr - 40) / (140 - 40) * size.width + 5;
    final double maxPos = (sleepData.maxHr - 40) / (140 - 40) * size.width + 5;
    final double avgPos = (sleepData.avgHr - 40) / (140 - 40) * size.width + 5;

    final rangeRect = Rect.fromLTWH(minPos, 1, maxPos - minPos, 35);
    canvas.drawRect(rangeRect, rangePaint);

    const double dashHeight = 1;
    const double dashSpace = 2;
    double startY = 1;
    final double endY = startY + 35;
    while (startY < endY) {
      canvas.drawLine(
        Offset(avgPos, startY),
        Offset(avgPos, startY + dashHeight),
        avgLinePaint,
      );
      startY += dashHeight + dashSpace;
    }

    _drawText(
      canvas,
      '${sleepData.minHr}',
      minPos + 3,
      24,
      TextStyle(fontSize: 10, color: Colors.white),
    );
    _drawText(
      canvas,
      'Min',
      minPos - 6,
      40,
      TextStyle(fontSize: 8, color: Colors.black),
    );

    _drawText(
      canvas,
      '${sleepData.maxHr}',
      maxPos - 3,
      24,
      TextStyle(fontSize: 10, color: Colors.white),
      alignRight: true,
    );
    _drawText(
      canvas,
      'Max',
      maxPos - 6,
      40,
      TextStyle(fontSize: 8, color: Colors.black),
    );

    _drawText(
      canvas,
      'Avg',
      avgPos - 6,
      40,
      TextStyle(fontSize: 8, color: Colors.black),
    );
  }

  void _drawText(Canvas canvas, String text, double x, double y, TextStyle style, {bool alignRight = false}) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textAlign: TextAlign.center,
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.layout();
    if (alignRight) {
      textPainter.paint(canvas, Offset(x - textPainter.width, y));
    } else {
      textPainter.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
