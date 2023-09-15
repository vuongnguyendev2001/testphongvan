import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:test_app_project/models/tinhchiso.dart';

class Screen3 extends StatefulWidget {
  const Screen3({super.key});

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  late Future<TinhChiSoResponse> apiGetChiSoResponse;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiGetChiSoResponse = fetchApiChiSo(
      ageController.text,
      heightController.text,
      weightController.text,
    );
  }

  @override
  Future<TinhChiSoResponse> fetchApiChiSo(
    String? age,
    String? height,
    String? weight,
  ) async {
    final dio = Dio();
    dio.options.headers['X-RapidAPI-Key'] =
        '235cc78a3amshf3d2575cef0c6ffp163219jsnd73c7623ede3';
    dio.options.headers['X-RapidAPI-Host'] =
        'fitness-calculator.p.rapidapi.com';
    final response = await dio.get(
      'https://fitness-calculator.p.rapidapi.com/bmi',
      queryParameters: {
        'age': age, // Truyền tuổi của bản thân
        'weight': height, // Cân nặng
        'height': weight // Chiều cao,
      },
    );
    if (response.statusCode == 200) {
      print(response.data);
      return TinhChiSoResponse.fromJson(response.data);
    } else {
      throw Exception('Lỗi khi lấy dữ liệu từ API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Chỉ số BMI',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20),
                height: 45,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: HexColor('#F3F6F9'),
                ),
                child: TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Nhập vào tuổi',
                    // prefixIcon: Image.asset(
                    //   'assets/images/search.png',
                    //   height: 14,
                    //   width: 13,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(left: 20),
                height: 45,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: HexColor('#F3F6F9'),
                ),
                child: TextFormField(
                  controller: heightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Nhập vào chiều cao',
                    // prefixIcon: Image.asset(
                    //   'assets/images/search.png',
                    //   height: 14,
                    //   width: 13,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(left: 20),
                height: 45,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: HexColor('#F3F6F9'),
                ),
                child: TextFormField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Nhập vào cân nặng',
                    // prefixIcon: Image.asset(
                    //   'assets/images/search.png',
                    //   height: 14,
                    //   width: 13,
                  ),
                ),
              ),
              SizedBox(height: 30),
              InkWell(
                onTap: () {
                  setState(() {
                    apiGetChiSoResponse = fetchApiChiSo(
                      ageController.text,
                      heightController.text,
                      weightController.text,
                    );
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 42,
                  width: 193,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment(1, 1),
                      colors: <Color>[
                        HexColor('#D9291D'),
                        HexColor('#F05A69')
                      ], // Gradient from https://learnui.design/tools/gradient-generator.html
                      tileMode: TileMode.mirror,
                    ),
                  ),
                  child: const Text(
                    'Xác nhận',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              FutureBuilder<TinhChiSoResponse>(
                future: apiGetChiSoResponse,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Hiển thị CircularProgressIndicator khi đang tải dữ liệu.
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    // Xử lý trường hợp có lỗi.
                    return Center(
                      child: Text(''),
                    );
                  } else if (!snapshot.hasData) {
                    // Xử lý trường hợp không có dữ liệu.
                    return Center(
                      child: Text('Không có dữ liệu.'),
                    );
                  }
                  final apigetChiSoResponse =
                      snapshot.data as TinhChiSoResponse;
                  final bmi = apigetChiSoResponse.data.bmi;
                  final health = apigetChiSoResponse.data.health;
                  final healthyBmiRange =
                      apigetChiSoResponse.data.healthyBmiRange;
                  if (snapshot.hasData) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      height: 131,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: HexColor('#F3F6F9'),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Text(
                            'Xác nhận',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: HexColor('#DC2F26')),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Chỉ số BMI: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                bmi.toString() ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: HexColor('#FF0000')),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Sức khỏe: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                health.toString() ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: HexColor('#FF0000')),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Chỉ số BMI: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                healthyBmiRange.toString() ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: HexColor('#FF0000')),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
