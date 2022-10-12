import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MyHome extends StatelessWidget {
  MyHome({super.key});
  TextEditingController inputController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Title'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ElevatedButton(
              onPressed: _launchUrl,
              child: Text('인증코드 받기'),
            ),
            SizedBox(
              // width: Get.width*1/9,
              height: Get.height * 1 / 9,
            ),
            Row(
              children: [
                SizedBox(
                  // height: Get.height,
                  width: Get.width * 1 / 2,
                  child: TextField(
                    controller: inputController,
                    decoration: const InputDecoration(
                      labelText: 'Input',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    var auth = inputController.text;
                    var authCode =
                        auth.split('?')[1].split('&')[0].split('=')[1];

                    var url = 'http://127.0.0.1:3000/oauth/access';
                    var body = <String, String>{
                      "auth_tokens": authCode,
                      'mallId': 'dlsxjznf12',
                      'encodeRedirectUri': 'https://dlsxjznf12.cafe24.com/'
                    };

                    var response = await http.post(Uri.parse(url), body: body);
                    print(response.statusCode);
                    if (response.statusCode == 200) {
                      var jsonResponse = convert.jsonDecode(response.body)
                          as Map<String, dynamic>;

                      print('Number of books about http: $jsonResponse.');
                    } else {
                      print(
                          'Request failed with status: ${response.statusCode}.');
                    }
                  },
                  child: const Text('엑세스 코드 받기'),
                ),
              ],
            ),
            SizedBox(
              // width: Get.width*1/9,
              height: Get.height * 1 / 9,
            ),
            ElevatedButton(
              onPressed: () async {
                var url = 'http://127.0.0.1:3000/market/order';
                var response = await http.get(Uri.parse(url));

                if (response.statusCode == 200) {
                  var jsonResponse =
                      convert.jsonDecode(response.body) as Map<String, dynamic>;

                  print('Number of books about http: $jsonResponse.');
                } else {
                  print('Request failed with status: ${response.statusCode}.');
                }
              },
              child: const Text('주문건 확인'),
            ),
            SizedBox(
              // width: Get.width*1/9,
              height: Get.height * 1 / 9,
            ),
            ElevatedButton(
              onPressed: () async {
                var url = 'http://127.0.0.1:3000/market/gsheet';
                var response = await http.get(Uri.parse(url));

                if (response.statusCode == 200) {
                  // var jsonResponse =
                  //     convert.jsonDecode(response.body) as Map<String, dynamic>;

                  print('Number of books about http: ${response.body}.');
                } else {
                  print('Request failed with status: ${response.statusCode}.');
                }
              },
              child: const Text('구글시트 확인'),
            ),
          ],
        ));
  }
}

var mallId = 'dlsxjznf12';
var encodeRedirectUri = 'https://dlsxjznf12.cafe24.com/';
Future<void> _launchUrl() async {
  final Uri _url = Uri.parse(
      'http://127.0.0.1:3000/oauth/oauth?mall_id=${mallId}&encode_redirect_uri=${encodeRedirectUri}');
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}

// 127.0.0.1