// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:test_app_project/models/get_calo.dart';

class Screen2 extends StatefulWidget {
  final String activityId;
  Screen2({required this.activityId});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  late Future<ApiGetCaloResponse> apiGetCaloResponse;
  late Future<BurnedCalorieData> clData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      apiGetCaloResponse = fetchApiData(widget.activityId);
    } catch (e) {
      print(e);
    }
    // print(fetchApiData(widget.activityId));
  }

  @override
  Future<ApiGetCaloResponse> fetchApiData(String? activityid) async {
    final dio = Dio();
    dio.options.headers['X-RapidAPI-Key'] =
        '235cc78a3amshf3d2575cef0c6ffp163219jsnd73c7623ede3';
    dio.options.headers['X-RapidAPI-Host'] =
        'fitness-calculator.p.rapidapi.com';
    final response = await dio.get(
      'https://fitness-calculator.p.rapidapi.com/burnedcalorie',
      queryParameters: {
        'activityid': activityid,
        'activitymin': '25',
        'weight': '75',
      },
    );
    if (response.statusCode == 200) {
      print(response.data);
      return ApiGetCaloResponse.fromJson(response.data);
    } else {
      throw Exception('Lỗi khi lấy dữ liệu từ API');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calorie',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 120),
          FutureBuilder<ApiGetCaloResponse>(
            future: apiGetCaloResponse,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child:
                        CircularProgressIndicator()); // Hiển thị tiến trình đợi
              } else if (snapshot.hasError) {
                return Text('Lỗi: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return Text('Không có dữ liệu');
              }
              final apigetCaloResponse = snapshot.data as ApiGetCaloResponse;
              final burnedCalorie = apigetCaloResponse.data.burnedCalorie;
              final unit = apigetCaloResponse.data.unit;
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Image.asset(
                      'assets/images/Frame.png',
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          burnedCalorie.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          ' ' + unit,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          )
        ],
      ),
    );
  }
}
