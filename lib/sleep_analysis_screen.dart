import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'open_ai/open_ai_chat_bot_service.dart';
import 'data_manager.dart';
import 'sleep_stage_widget/sleep_stage_widget.dart';
import 'sleep_duration_widget/sleep_duration_widget.dart';
import 'heart_rate_widget/heart_rate_widget.dart';
import 'sleep_info_widget/sleep_info_widget.dart';
import 'sleep_analysis_widget/sleep_analysis_widget.dart';
import 'chat_page.dart';

class SleepAnalysisScreen extends StatefulWidget {
  @override
  _SleepAnalysisScreenState createState() => _SleepAnalysisScreenState();
}


class _SleepAnalysisScreenState extends State<SleepAnalysisScreen> {
  Map<DateTime, List<SleepData>> sleepDataMap = {};
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.month;
  final OpenAIChatBotService _openAIChatBotService = OpenAIChatBotService();
  Future<String>? res;

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    loadSleepData(); // 비동기 데이터 로딩 함수 호출
  }

  Future<void> loadSleepData() async {
    final String response = await rootBundle.loadString('assets/sleep_data.json');
    final data = await json.decode(response);
    List<SleepData> sleepList = List<SleepData>.from(data.map((item) => parseSleepData(item)));

    List<SleepData> mergedSleepList = mergeSleepDataByDate(sleepList);

    setState(() {
      sleepDataMap = groupSleepDataByDate(mergedSleepList);
    });
    DateTime today = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    final sleepData = sleepDataMap[today]?.first;
    if (sleepData != null) {
      String text = "duration: ${sleepData.duration}, sleep_rem_duration: ${sleepData.sleepRemDuration},"
          "sleep_light_duration: ${sleepData.sleepLightDuration}, device_bedtime: ${sleepData.deviceBedtime},"
          "min_hr: ${sleepData.minHr}, awake_count: ${sleepData.awakeCount}, wake_up_time: ${sleepData.wakeUpTime},"
          "bedtime: ${sleepData.bedtime}, avg_hr: ${sleepData.avgHr}, sleep_awake_duration: ${sleepData.sleepAwakeDuration},"
          "device_wake_up_time: ${sleepData.deviceWakeUpTime}, max_hr: ${sleepData.maxHr},"
          "sleep_deep_duration: ${sleepData.sleepDeepDuration}, breath_quality: ${sleepData.breathQuality}";
      res = _openAIChatBotService.createModel(text);
    }
  }

  Map<DateTime, List<SleepData>> groupSleepDataByDate(List<SleepData> sleepList) {
    Map<DateTime, List<SleepData>> groupedData = {};
    for (var sleepData in sleepList) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(sleepData.wakeUpTime * 1000);
      date = DateTime(date.year, date.month, date.day);
      if (!groupedData.containsKey(date)) {
        groupedData[date] = [];
      }
      groupedData[date]!.add(sleepData);
    }
    return groupedData;
  }

  @override
  Widget build(BuildContext context) {
    if (sleepDataMap.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('단잠'),
          scrolledUnderElevation: 0,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          setState(() {});
          return true;
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              scrolledUnderElevation: 0,
              expandedHeight: 200.0,
              pinned: true,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  var top = constraints.biggest.height;
                  var opacity = (top - kToolbarHeight) / (top - 55);
                  var centralOpacity = 1.0 - opacity;

                  return FlexibleSpaceBar(
                    titlePadding: EdgeInsets.only(left: 10, bottom: 10),
                    title: Stack(
                      children: [
                        Opacity(
                          opacity: opacity,
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              '단잠',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: centralOpacity,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '단잠',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    background: Container(
                      color: top > 55.0 ? Colors.grey : Colors.white,
                    ),
                  );
                },
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Card(
                    color: Colors.white,
                    elevation: 0,
                    margin: EdgeInsets.all(10.0),
                    child: TableCalendar(
                      focusedDay: focusedDay,
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      calendarFormat: calendarFormat,
                      availableGestures: AvailableGestures.none,
                      onFormatChanged: (format) {
                        setState(() {
                          calendarFormat = format;
                        });
                      },
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        leftChevronIcon: Icon(Icons.chevron_left),
                        rightChevronIcon: Icon(Icons.chevron_right),
                      ),
                      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          DateTime d = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
                          this.selectedDay = d;
                          this.focusedDay = focusedDay;
                        });
                      },
                      onPageChanged: (focusedDay) {
                        setState(() {
                          this.focusedDay = focusedDay;
                        });
                      },
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          DateTime dateOnly = DateTime(day.year, day.month, day.day);
                          final sleepData = sleepDataMap[dateOnly];
                          if (sleepData != null) {
                            final totalDuration = sleepData.fold<int>(0, (sum, data) => sum + data.duration);
                            return Center(
                              child: Container(
                                width: 35.0,
                                height: 35.0,
                                decoration: BoxDecoration(
                                  color: getColorForDuration(totalDuration),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(child: Text('${day.day}')),
                              ),
                            );
                          }
                          return Center(
                            child: Text('${day.day}'),
                          );
                        },
                      ),
                    ),
                  ),
                  if (sleepDataMap[selectedDay] != null)
                    ...sleepDataMap[selectedDay]!.map((sleepData) => SleepStageWidget(sleepData)).toList(),
                  if (sleepDataMap[selectedDay] != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: sleepDataMap[selectedDay]!.map((sleepData) => SleepDurationWidget(sleepData)).first,
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 140,
                                child: Center(
                                  child: sleepDataMap[selectedDay]!.map((sleepData) => HeartRateWidget(sleepData)).first,
                                )
                              ),
                              Container(
                                width: double.infinity,
                                height: 97,
                                child: Center(
                                  child: sleepDataMap[selectedDay]!.map((sleepData) => SleepInfoWidget(sleepData)).first,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  if (sleepDataMap[selectedDay] != null)
                    ...sleepDataMap[selectedDay]!.map((sleepData) => SleepAnalysisWidget(sleepData)).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 45.0,
        height: 45.0,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ChatPage(res)),
            );
          },
          child: Icon(Icons.message, size: 20,),
        ),
      ),
    );
  }

  Color getColorForDuration(int duration) {
    Color color;
    if (duration < 240) {
      color = Colors.red.shade400;
    } else if (duration < 450) {
      color = Colors.yellow.shade400;
    } else {
      color = Colors.green.shade400;
    }
    return color;
  }
}