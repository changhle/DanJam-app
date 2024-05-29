import 'open_ai/open_ai_analysis_service.dart';

class SleepData {
  final int avgHr;
  final int bedtime;
  final int breathQuality;
  final int sleepDeepDuration;
  final int deviceBedtime;
  final int deviceWakeUpTime;
  final int wakeUpTime;
  final int sleepLightDuration;
  final int maxHr;
  final int minHr;
  final int sleepRemDuration;
  final int duration;
  final int awakeCount;
  final int sleepAwakeDuration;
  final String name;
  final String sex;
  final String birth;
  final int height;
  final int weight;

  final Future<String> analysis;
  final List<SleepItem> items; // Add this line to include items in SleepData

  SleepData({
    required this.avgHr,
    required this.bedtime,
    required this.breathQuality,
    required this.sleepDeepDuration,
    required this.deviceBedtime,
    required this.deviceWakeUpTime,
    required this.wakeUpTime,
    required this.sleepLightDuration,
    required this.maxHr,
    required this.minHr,
    required this.sleepRemDuration,
    required this.duration,
    required this.awakeCount,
    required this.sleepAwakeDuration,
    required this.name,
    required this.sex,
    required this.birth,
    required this.height,
    required this.weight,
    required this.analysis,
    required this.items, // Add this line to include items in constructor
  });
}

class SleepItem {
  final int endTime;
  final int state;
  final int startTime;

  SleepItem({
    required this.endTime,
    required this.state,
    required this.startTime,
  });

  factory SleepItem.fromJson(Map<String, dynamic> json) {
    return SleepItem(
      endTime: json['end_time'],
      state: json['state'],
      startTime: json['start_time'],
    );
  }
}

List<SleepData> mergeSleepDataByDate(List<SleepData> sleepList) {
  final OpenAIAnalysisService _openAIAnalysisService = OpenAIAnalysisService();
  Map<String, SleepData> mergedDataMap = {};

  for (var sleepData in sleepList) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(sleepData.wakeUpTime * 1000);
    String dateKey = "${date.year}-${date.month}-${date.day}";

    if (mergedDataMap.containsKey(dateKey)) {
      // 병합 로직 적용
      var existingData = mergedDataMap[dateKey]!;

      int newDuration = existingData.duration + sleepData.duration;
      int newDeepDuration = existingData.sleepDeepDuration + sleepData.sleepDeepDuration;
      int newLightDuration = existingData.sleepLightDuration + sleepData.sleepLightDuration;
      int newRemDuration = existingData.sleepRemDuration + sleepData.sleepRemDuration;
      int newAwakeDuration = existingData.sleepAwakeDuration + sleepData.sleepAwakeDuration;
      int newMinHr = existingData.minHr < sleepData.minHr ? existingData.minHr : sleepData.minHr;
      int newMaxHr = existingData.maxHr > sleepData.maxHr ? existingData.maxHr : sleepData.maxHr;
      int newAvgHr = ((existingData.avgHr + sleepData.avgHr) / 2).round();
      int newAwakeCount = existingData.awakeCount + sleepData.awakeCount + 1;
      int newBreathQuality = ((existingData.breathQuality + sleepData.breathQuality) / 2).round();
      // List<SleepItem> newItems = [...existingData.items, ...sleepData.items];

      List<SleepItem> newItems = [];
      newItems.addAll(sleepData.items);
      newItems.add(SleepItem(
        startTime: sleepData.wakeUpTime,
        endTime: existingData.bedtime,
        state: 5,
      ));
      newItems.addAll(existingData.items);

      final text = "duration: ${newDuration}, sleep_rem_duration: ${newRemDuration},"
          "sleep_light_duration: ${newLightDuration}, device_bedtime: ${sleepData.deviceBedtime},"
          "min_hr: ${newMinHr}, awake_count: ${newAwakeCount}, wake_up_time: ${existingData.wakeUpTime},"
          "bedtime: ${sleepData.bedtime}, avg_hr: ${newAvgHr}, sleep_awake_duration: ${newAwakeDuration},"
          "device_wake_up_time: ${existingData.deviceWakeUpTime}, max_hr: ${newMaxHr},"
          "sleep_deep_duration: ${newDeepDuration}, breath_quality: ${newBreathQuality}";
      final Future<String> response = _openAIAnalysisService.createModel(text);

      mergedDataMap[dateKey] = SleepData(
        bedtime: sleepData.bedtime,
        breathQuality: newBreathQuality,
        sleepDeepDuration: newDeepDuration,
        deviceBedtime: sleepData.deviceBedtime,
        deviceWakeUpTime: existingData.deviceWakeUpTime,
        wakeUpTime: existingData.wakeUpTime,
        sleepLightDuration: newLightDuration,
        maxHr: newMaxHr,
        minHr: newMinHr,
        avgHr: newAvgHr,
        sleepRemDuration: newRemDuration,
        duration: newDuration,
        awakeCount: newAwakeCount,
        sleepAwakeDuration: newAwakeDuration,
        name: existingData.name,
        sex: existingData.sex,
        birth: existingData.birth,
        height: existingData.height,
        weight: existingData.weight,
        items: newItems,
        analysis: response,
      );
    } else {
      // 새 항목 추가
      mergedDataMap[dateKey] = SleepData(
        bedtime: sleepData.bedtime,
        breathQuality: sleepData.breathQuality,
        sleepDeepDuration: sleepData.sleepDeepDuration,
        deviceBedtime: sleepData.deviceBedtime,
        deviceWakeUpTime: sleepData.deviceWakeUpTime,
        wakeUpTime: sleepData.wakeUpTime,
        sleepLightDuration: sleepData.sleepLightDuration,
        maxHr: sleepData.maxHr,
        minHr: sleepData.minHr,
        avgHr: sleepData.avgHr,
        sleepRemDuration: sleepData.sleepRemDuration,
        duration: sleepData.duration,
        awakeCount: sleepData.awakeCount,
        sleepAwakeDuration: sleepData.sleepAwakeDuration,
        name: sleepData.name,
        sex: sleepData.sex,
        birth: sleepData.birth,
        height: sleepData.height,
        weight: sleepData.weight,
        items: sleepData.items,
        analysis: sleepData.analysis,
      );
    }
  }

  return mergedDataMap.values.toList();
}




SleepData parseSleepData(Map<String, dynamic> json) {
  final OpenAIAnalysisService _openAIAnalysisService = OpenAIAnalysisService();
  final awakeDuration = List<SleepItem>.from(json['items'].map((item) => SleepItem.fromJson(item)))
      .where((item) => item.state == 5)
      .fold(0, (sum, item) => sum + ((item.endTime - item.startTime) / 60).round());
  final text = "duration: ${json['duration']}, sleep_rem_duration: ${json['sleep_rem_duration']},"
      "sleep_light_duration: ${json['sleep_light_duration']}, device_bedtime: ${json['device_bedtime']},"
      "min_hr: ${json['min_hr']}, awake_count: ${json['awake_count']}, wake_up_time: ${json['wake_up_time']},"
      "bedtime: ${json['bedtime']}, avg_hr: ${json['avg_hr']}, sleep_awake_duration: ${awakeDuration},"
      "device_wake_up_time: ${json['device_wake_up_time']},max_hr: ${json['max_hr']},"
      "sleep_deep_duration: ${json['sleep_deep_duration']}";
  final Future<String> response = _openAIAnalysisService.createModel(text);
  return SleepData(
    avgHr: json['avg_hr'],
    bedtime: json['bedtime'],
    breathQuality: json['breath_quality'] != null ? json['breath_quality'] : 0,
    sleepDeepDuration: json['sleep_deep_duration'],
    deviceBedtime: json['device_bedtime'],
    deviceWakeUpTime: json['device_wake_up_time'],
    wakeUpTime: json['wake_up_time'],
    sleepLightDuration: json['sleep_light_duration'],
    maxHr: json['max_hr'],
    minHr: json['min_hr'],
    sleepRemDuration: json['sleep_rem_duration'],
    duration: json['duration'],
    items: json['items'] != null ? List<SleepItem>.from(json['items'].map((item) => SleepItem.fromJson(item))) : [], // Handle null items
    awakeCount: json['awake_count'],
    sleepAwakeDuration: awakeDuration,
    name: json['name'] != null ? json['name'] : "",
    sex: json['sex'] != null ? json['sex'] : "",
    birth: json['birth'] != null ? json['birth'] : "",
    height: json['height'] != null ? int.parse(json['height']) : 0,
    weight: json['weight'] != null ? int.parse(json['weight']) : 0,
    analysis: response,
  );
}
