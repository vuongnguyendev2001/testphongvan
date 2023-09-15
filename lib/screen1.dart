import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:dio/dio.dart';
import 'package:test_app_project/models/activity.dart';
import 'package:test_app_project/screen2.dart';
import 'package:test_app_project/screen3.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  final TextEditingController _search = TextEditingController();
  late Future<ApiResponse> apiResponse;
  late Future<Activity> activity;
  List<Activity> activityList = [];
  List<Activity> filteredActivities = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiResponse = fetchApiData();
  }

  Future<ApiResponse> fetchApiData() async {
    final dio = Dio();
    dio.options.headers['X-RapidAPI-Key'] =
        '235cc78a3amshf3d2575cef0c6ffp163219jsnd73c7623ede3';
    dio.options.headers['X-RapidAPI-Host'] =
        'fitness-calculator.p.rapidapi.com';
    final response = await dio.get(
        'https://fitness-calculator.p.rapidapi.com/activities?intensitylevel=1');
    if (response.statusCode == 200) {
      final apiResponse = ApiResponse.fromJson(response.data);
      activityList = apiResponse.data;
      return apiResponse;
    } else {
      throw Exception('Lỗi khi lấy dữ liệu từ API');
    }
  }

  void filterActivities(String query) {
    if (query.isNotEmpty) {
      filteredActivities = activityList.where((activity) {
        return activity.activity.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } else {
      filteredActivities = List.from(activityList);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Danh sách hoạt động',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Screen3()));
            },
            child: Image.asset('assets/images/iconfill.png'),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 45,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: HexColor('#F3F6F9'),
              ),
              child: TextFormField(
                controller: _search,
                onChanged: (query) {
                  print(query);
                  filterActivities(query);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Tìm kiếm',
                  prefixIcon: Icon(Icons.search_outlined),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<ApiResponse>(
                future:
                    apiResponse, // Đảm bảo fetchApiData() trả về một Future<ApiResponse>
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Hiển thị CircularProgressIndicator khi đang tải dữ liệu.
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    // Xử lý trường hợp có lỗi.
                    return Center(
                      child: Text('Đã xảy ra lỗi: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData) {
                    // Xử lý trường hợp không có dữ liệu.
                    return Center(
                      child: Image.asset(
                          'assets/images/undraw_online_connection_6778 1.png'),
                    );
                  } else if (filteredActivities.isEmpty) {
                    final apiResponse = snapshot.data as ApiResponse;
                    final activityList = apiResponse.data;
                    return ListView.builder(
                      itemCount: activityList.length,
                      itemBuilder: (context, index) {
                        final activity = activityList[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Screen2(
                                          activityId: activity.id,
                                        )));
                          },
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 10, bottom: 20),
                                  height: 120,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(
                                            0.5), // Màu và độ trong suốt của shadow
                                        spreadRadius:
                                            5, // Bán kính mở rộng của shadow
                                        blurRadius: 7, // Độ mờ của shadow
                                        offset: Offset(
                                            0, 3), // Độ dịch chuyển của shadow
                                      ),
                                    ],
                                    color: HexColor('#F3F6F9'),
                                    // borderRadius: BorderRadius.circular(10),
                                    border: Border(
                                      left: BorderSide(
                                        color: HexColor('#FF6B00'),
                                        width: 4,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            activity.activity,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_right_outlined,
                                            color: HexColor('#F05A69'),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Value: ',
                                                style: TextStyle(),
                                              ),
                                              Text(
                                                '${activity.metValue}',
                                                style: TextStyle(
                                                    color: HexColor('#F05A69')),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'IntentsityLevel: ',
                                                style: TextStyle(),
                                              ),
                                              Text(
                                                '${activity.intensityLevel}',
                                                style: TextStyle(
                                                    color: HexColor('#F05A69')),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 35,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Desciption:'),
                                            SizedBox(
                                              width: 290,
                                              child: Text(
                                                activity.description,
                                                maxLines: 2,
                                                style: TextStyle(
                                                  color: HexColor('#F05A69'),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return ListView.builder(
                    itemCount: filteredActivities.length,
                    itemBuilder: (context, index) {
                      final activity = filteredActivities[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Screen2(
                                        activityId: activity.id,
                                      )));
                        },
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 10, bottom: 20),
                                height: 120,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(
                                          0.5), // Màu và độ trong suốt của shadow
                                      spreadRadius:
                                          5, // Bán kính mở rộng của shadow
                                      blurRadius: 7, // Độ mờ của shadow
                                      offset: Offset(
                                          0, 3), // Độ dịch chuyển của shadow
                                    ),
                                  ],
                                  color: HexColor('#F3F6F9'),
                                  // borderRadius: BorderRadius.circular(10),
                                  border: Border(
                                    left: BorderSide(
                                      color: HexColor('#FF6B00'),
                                      width: 4,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          activity.activity,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_right_outlined,
                                          color: HexColor('#F05A69'),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Value: ',
                                              style: TextStyle(),
                                            ),
                                            Text(
                                              '${activity.metValue}',
                                              style: TextStyle(
                                                  color: HexColor('#F05A69')),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'IntentsityLevel: ',
                                              style: TextStyle(),
                                            ),
                                            Text(
                                              '${activity.intensityLevel}',
                                              style: TextStyle(
                                                  color: HexColor('#F05A69')),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 35,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Desciption:'),
                                          SizedBox(
                                            width: 290,
                                            child: Text(
                                              activity.description,
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: HexColor('#F05A69'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
