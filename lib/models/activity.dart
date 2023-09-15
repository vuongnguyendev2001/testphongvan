import 'dart:convert';

class ApiResponse {
  final int statusCode;
  final String requestResult;
  final List<Activity> data;

  ApiResponse({
    required this.statusCode,
    required this.requestResult,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> jsonDataList = json['data'];

    return ApiResponse(
      statusCode: json['status_code'],
      requestResult: json['request_result'],
      data: jsonDataList.map((item) => Activity.fromJson(item)).toList(),
    );
  }
}

class Activity {
  final String id;
  final String activity;
  final double metValue;
  final String description;
  final int intensityLevel;

  Activity({
    required this.id,
    required this.activity,
    required this.metValue,
    required this.description,
    required this.intensityLevel,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      activity: json['activity'],
      metValue: double.parse(json['metValue'].toString()),
      description: json['description'],
      intensityLevel: json['intensityLevel'],
    );
  }
}
