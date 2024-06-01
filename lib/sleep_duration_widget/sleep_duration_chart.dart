import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../data_manager.dart';

class SleepDurationChart extends StatelessWidget {
  final SleepData sleepData;

  const SleepDurationChart({Key? key, required this.sleepData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      Colors.blue.shade900, // Deep Sleep
      Colors.blue, // Light Sleep
      Colors.blue.shade200, // REM Sleep
      Colors.orange.shade200, // Awake
    ];
    final List<String> stages = ["Deep Sleep", "Light Sleep", "REM Sleep", "Awake"];

    double previousDuration = 0;
    final double totalDuration = sleepData.duration.toDouble();
    final List<BarChartRodStackItem> stackItems = [];

    List<double> durations = [
      sleepData.sleepDeepDuration.toDouble(),
      sleepData.sleepLightDuration.toDouble(),
      sleepData.sleepRemDuration.toDouble(),
      sleepData.sleepAwakeDuration.toDouble(),
    ];

    for (int i = 0; i < durations.length; i++) {
      final duration = durations[i];
      final percentage = (duration / totalDuration) * 100;
      stackItems.add(BarChartRodStackItem(previousDuration, previousDuration + percentage, colors[i]));
      previousDuration += percentage;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double chartHeight = constraints.maxHeight;
        double maxY = chartHeight * 0.55; // 총 수면 시간의 110%로 maxY 설정

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 0.55,
                child: BarChart(
                  BarChartData(
                    maxY: maxY,
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            y: previousDuration,
                            colors: [Colors.transparent],
                            width: 40,
                            rodStackItems: stackItems,
                          ),
                        ],
                      ),
                    ],
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    alignment: BarChartAlignment.spaceAround,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.blueGrey,
                        tooltipPadding: EdgeInsets.all(2),
                        tooltipMargin: 10,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            '${stages[rodIndex]}: ${durations[rodIndex]} mins',
                            TextStyle(color: Colors.white, fontSize: 11),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 35.0, left: 8.0, right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List<Widget>.generate(stages.length, (index) => _buildLegendItem(stages[index], colors[index])),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.stop, color: color, size: 16),
          SizedBox(width: 4),
          Text(text),
        ],
      ),
    );
  }
}
