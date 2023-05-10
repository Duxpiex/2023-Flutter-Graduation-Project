import 'dart:convert';
import 'dart:async';
import 'package:Aily/utils/ShowDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../class/UserData.dart';
import '../class/URLs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late double screenWidth = 0.0;
  late double screenHeight = 0.0;
  late String? username;
  late int? userpoint;
  Color myColor = const Color(0xFFF8B195);
  var user = UserData();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _getScreenSize();
    _getUser();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) => pointUser(user.phonenumber.toString()));
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  void _getScreenSize() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        screenWidth = MediaQuery
            .of(context)
            .size
            .width;
        screenHeight = MediaQuery
            .of(context)
            .size
            .height;
      });
    });
  }

  Future<void> pointUser(String phonenumber) async {
    var response =
    await http.post(Uri.parse(URL().pointURL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phonenumber': phonenumber,
        }));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      userpoint = jsonResponse[0]['phonenumber'];
      setState(() {});
    }
  }

  void _getUser() {
    setState(() {
      username = user.nickname;
      userpoint = user.point;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Color backColor = const Color(0xFFF6F1F6);
    Color backColor = Colors.white;
    return Scaffold(
      body: HomeWidget(username!, context),
    );
  }

  Widget HomeWidget(String username, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(height: screenHeight * 0.045),
        Expanded(
          child: Container(
              width: screenWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.only(left: 40),
              child: Row(
                children: [
                  Text("AILY", style: TextStyle(fontSize: 35,
                      fontFamily: 'Waiting for the Sunrise',
                      fontWeight: FontWeight.bold,
                      color: myColor)),
                  SizedBox(width: screenWidth * 0.60),
                  GestureDetector(
                    onTap: () {
                      // 클릭 시 실행될 코드
                      showMsg(context, "테스트", "테스트");
                    },
                    child: SvgPicture.asset(
                      'assets/images/icons/notification_line_icon.svg',
                      width: 24, // 이미지 크기
                      height: 24,
                    ),
                  ),
                ],
              )
          ),
        ),
        const SizedBox(height: 5),
        Container(
            width: screenWidth * 0.95,
            height: screenHeight * 0.16,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xffF8B195).withOpacity(0.25),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xffF8B195).withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 10),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/icons/wallet.png',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        '님의 포인트',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.023),
                Text(
                  '${NumberFormat('#,###').format(userpoint)}원',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
        ),
        const SizedBox(height: 5),
        Container(
          width: screenWidth * 0.95,
          height: screenHeight * 0.6,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xffF8B195).withOpacity(0.25),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xffF8B195).withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('포인트 적립내역', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ListTile(context, '페트', '2023-05-06', 100, 7700),
                        _ListTile(context, '캔', '2023-05-05', 100, 7600),
                        _ListTile(context, '캔', '2023-05-04', 100, 7500),
                        _ListTile(context, '페트', '2023-05-03', 100, 7400),
                        _ListTile(context, '캔', '2023-05-02', 100, 7300),
                        _ListTile(context, '페트', '2023-05-01', 100, 7200),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget _ListTile(BuildContext context, String title, String date, int incPoint, totPoint) {
  Color myColor = const Color(0xFFF8B195);
  var user = UserData();

  return Column(
    children: [
      Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: myColor.withOpacity(0.3)
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Theme(
          data: ThemeData().copyWith(
              dividerColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent
          ),
          child: ListTile(
            horizontalTitleGap: 0,
            contentPadding: const EdgeInsets.symmetric(horizontal: 25),
            title: Text(title, style: const TextStyle(fontSize: 18)),
            subtitle: Text(date),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('+${user.formatInt(incPoint)}', style: const TextStyle(fontSize: 17, color: Colors.red)),
                    Text('${user.formatInt(totPoint)}원', style: const TextStyle(fontSize: 15)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 10),
    ],
  );
}