class TinhChiSoResponse {
  final int statusCode;
  final String requestResult;
  final BmiData data;

  TinhChiSoResponse({
    required this.statusCode,
    required this.requestResult,
    required this.data,
  });

  factory TinhChiSoResponse.fromJson(Map<String, dynamic> json) {
    return TinhChiSoResponse(
      statusCode: json['status_code'] as int,
      requestResult: json['request_result'] as String,
      data: BmiData.fromJson(json['data']),
    );
  }
}

class BmiData {
  final double bmi;
  final String health;
  final String healthyBmiRange;

  BmiData({
    required this.bmi,
    required this.health,
    required this.healthyBmiRange,
  });

  factory BmiData.fromJson(Map<String, dynamic> json) {
    return BmiData(
      bmi: (json['bmi'] as num).toDouble(),
      health: json['health'] as String,
      healthyBmiRange: json['healthy_bmi_range'] as String,
    );
  }
}
