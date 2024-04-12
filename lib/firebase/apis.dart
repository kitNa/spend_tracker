import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spend_tracker/models/security/login_response.dart';

class Apis {
  static const String server =
      'https://spendtracker-9b479-default-rtdb.firebaseio.com/';
  static const String key = 'AIzaSyBO7aJibxV4cL8nf7GvIPOOtsd-8b4__gs';
  static const String projectID = 'spendtracker-9b479';
  static const String url =
  'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$key';
  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json',
  };

  late String _securityToken;

  Future login(String email, String password) async {
    var response = await http.post(
      Uri.parse(url),
      headers: _jsonHeaders,
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Login failed');
    }

    var map = json.decode(response.body);
    _securityToken = LoginResponse.fromMap(map).idToken;
  }

  // Map<String, String> _createHeader() {
  //   var header = {
  //       "authorasation": "Bearer $_securityToken",
  //       //"authorasation": url,
  //       "Content-Type": "application/json"
  //     };
  //   return header;
  // }
}
