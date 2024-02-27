import 'dart:convert';
import 'package:http_interceptor/http/intercepted_http.dart';
import 'interceptor_service.dart';
import 'log_service.dart';

class NetworkService {
  // baseUrl
  static const isTester = true;

  static const DEVELOPMENT_SERVER = "0b13-217-30-163-29.in.ngrok.io";
  static const DEPLOYMENT_SERVER = "0b13-217-30-163-29.in.ngrok.io";

  static String get BASEURL {
    if (isTester) {
      return DEVELOPMENT_SERVER;
    } else {
      return DEPLOYMENT_SERVER;
    }
  }

  // apis
  static const API_SIGN_UP = "/api/login/sign-up";
  static const API_SIGN_IN = "/api/login/sign-in";
  static const API_EMAIL_VERIFY = "/api/login/email-verify";


  // headers
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  // interceptor
  static final http = InterceptedHttp.build(interceptors: [
    InterceptorService(),
  ]);

  // params
  static Map<String, dynamic> paramsEmpty() => <String, dynamic>{};

  // methods
  static Future<Map<String, dynamic>> GET(String api, String uId) async {
    Map<String, dynamic> response = {};
    // try {
    //   await FirebaseFirestore.instance.collection(api).doc(uId).get().then((value) => response = value.data()!);
    //   return response;
    // } catch (e) {
    //   return {'error': e.toString()};
    // }
    return response;
  }

  static Future<String?> POST(String api, String uId, Map<String, dynamic> body) async {
    // try {
    //   final response = FirebaseFirestore.instance.collection('users').doc(uId);
    //   response.set(body);
    // } catch (e) {
    //   return e.toString();
    // }
    return null;
  }

  static Future<String?> PUT(String api, Map<String, dynamic> params, Map<String, dynamic> body) async {
    Uri url = Uri.https(BASEURL, api, params);
    final response =
    await http.put(url, headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return null;
  }

  static Future<String?> PATCH(String api, Map<String, dynamic> params, Map<String, dynamic> body) async {
    Uri url = Uri.https(BASEURL, api, params);
    final response =
    await http.patch(url, headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return null;
  }

  static Future<String?> DELETE(String api, Map<String, dynamic> params) async {
    Uri url = Uri.https(BASEURL, api, params);
    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return null;
  }

}
