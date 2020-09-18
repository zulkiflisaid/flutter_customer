import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:pelanggan/model/movie_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_base_helper.dart';
import 'api_exceptions.dart';

class CallApi {
  static String url = "http://192.168.1.44:8080/";
  static String keyApi = 'AIzaSyA706610W0aD4w2ueNR6seGrlHj5SpYOyM';
  static String keyApi1 = 'AIzaSyBTokiA2EScfsUgZeuTcsTdpcrV11qAw8E';
  static String token = '';

  Future<http.Response> postData(data, apiUrl) async {
    var localStorage = await SharedPreferences.getInstance();
    token = localStorage.getString('token');
    var fullUrl =
        apiUrl == 'gcm' ? 'https://fcm.googleapis.com/fcm/send' : url + apiUrl;

    return await http.post(fullUrl,
        body: jsonEncode(data),
        headers: apiUrl == 'gcm' ? _setHeadersGcm() : _setHeaders());
  }

  Future<http.Response> getData(apiUrl) async {
    var localStorage = await SharedPreferences.getInstance();
    token = localStorage.getString('token');
    var fullUrl =
        apiUrl == 'gcm' ? 'https://fcm.googleapis.com/fcm/send' : url + apiUrl;

    return await http.get(fullUrl,
        headers: apiUrl == 'gcm' ? _setHeadersGcm() : _setHeaders());
  }

  Future<String> getDistance(String origin, String destination) async {
    // var origin =  '${asal.latitude},${asal.longitude}';
    // var destination='${tujuan.latitude},${tujuan.longitude}';
    // final response = await http.get(stringUrl);

    final response = await http.get(
      Uri.encodeFull(
          'https://maps.googleapis.com/maps/api/directions/json?mode=driving&key=$keyApi&origin=$origin&destination=$destination'),
      headers: {
        //if your api require key then pass your key here as well e.g 'key': 'my-long-key'
        'Accept': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      var body = response.body;
      var receivedJson = '[$body]';
      List data = json.decode(receivedJson);
      if (data[0]['status'] == 'OK') {
        int meter = data[0]['routes'][0]['legs'][0]['distance']['value'];
        double km = meter / 1000;
        int fac = pow(10, 2);
        km = (km * fac).round() / fac;
        return km.toString();
      } else {
        return '0';
      }
    } else
      return '0'; //jika langsung kembalikan dengan string error sebenarnya tapi 0 aja

    //jika berada didalam widgt conth dalam listview
    //else throw Exception('Failed');
  }

  Map<String, String> _setHeaders() => {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "$token",
      };

  Map<String, String> _setHeadersGcm() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
            'key=AAAAqb3QmLo:APA91bGYHDpiqCE__s7kOJud_mScdRynRzZEGj_usgg6N4yZ1nDY3RNwBWVbxzYSzTxhbixR3zT3h84CbVOO1ISV3RUwMAls42K5iDmS9cyFaTrA1QpNgKKuM2SfRSbzG_R-y8iN4ksk',
      };
}
