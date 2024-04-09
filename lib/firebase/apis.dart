import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spend_tracker/models/security/login_response.dart';

class Apis {
  static const String server =
      'https://spendtracker-9b479-default-rtdb.firebaseio.com/';
  static const String key = 'AIzaSyBO7aJibxV4cL8nf7GvIPOOtsd-8b4__gs';
  static const String projectID = 'spendtracker-9b479';

  late String _securityToken;

  Future login(String email, String password) async {
    final String url =
        'https://spendtracker-9b479-default-rtdb.firebaseio.com/.json';
    var response = await http.post(
      url as Uri,
      headers: _createHeader(),
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

  Map<String, String> _createHeader() {
    if(_securityToken != null) {
      var header = {
        "authorasation": "Bearer $_securityToken",
        "Content-Type": "application/json"
      };
      return header;
    }
    return {"Content-Type": "application/json"};
  }
}
