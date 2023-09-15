class ApiGetCaloResponse {
  final int statusCode;
  final String requestResult;
  final BurnedCalorieData data;

  ApiGetCaloResponse({
    required this.statusCode,
    required this.requestResult,
    required this.data,
  });

  factory ApiGetCaloResponse.fromJson(Map<String, dynamic> json) {
    return ApiGetCaloResponse(
      statusCode: json['status_code'],
      requestResult: json['request_result'],
      data: BurnedCalorieData.fromJson(json['data']),
    );
  }
}

class BurnedCalorieData {
  final double burnedCalorie;
  final String unit;

  BurnedCalorieData({
    required this.burnedCalorie,
    required this.unit,
  });

  factory BurnedCalorieData.fromJson(Map<String, dynamic> json) {
    return BurnedCalorieData(
      burnedCalorie: double.parse(json['burnedCalorie'].toString()),
      unit: json['unit'],
    );
  }
}
