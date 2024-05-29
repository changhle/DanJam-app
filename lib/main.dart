import 'package:flutter/material.dart';

import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import 'dart:convert';
import 'package:flutter/services.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'env/env.dart';
import 'open_ai/open_ai_analysis_service.dart';
import 'data_manager.dart';
import 'sleep_analysis_screen.dart';
import 'open_ai/open_ai_chat_bot_service.dart';
import 'sleep_stage_widget/sleep_stage_time_line.dart';
import 'sleep_duration_widget/sleep_duration_chart.dart';
import 'heart_rate_widget/heart_rate_bar_painter.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;




void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '단잠',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SleepAnalysisScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}










//채팅

