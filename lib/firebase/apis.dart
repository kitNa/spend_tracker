import 'dart:convert';

//import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:spend_tracker/models/account.dart';
import 'package:spend_tracker/models/item_type.dart';
import 'package:spend_tracker/models/security/login_response.dart';

import '../models/item.dart';

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
  static String database =
      'https://spendtracker-9b479-default-rtdb.firebaseio.com';
  static const String requestType = '.json';
  late String _securityToken;

  Future deleteItem(Item item) async {
    String params = '?auth=$_securityToken';
    final url = Uri.parse('$database/items/${item.urlId}$requestType$params');
    var response = await http.delete(url, headers: _jsonHeaders);
    _checkStatus(response);
  }

  Future<List<Item>> getItems() async {
    String params = '?auth=$_securityToken';
    final url = Uri.parse('$database/items$requestType$params');
    var response = await http.get(url, headers: _jsonHeaders);
    _checkStatus(response);
    return Item.fromJson(response.body);
  }

  Future createItem(Item item) async {
    String params = '?auth=$_securityToken';
    final url = Uri.parse('$database/items$requestType$params');
    var response = await http.post(
      url,
      headers: _jsonHeaders,
      body: item.toJson(),
    );
    _checkStatus(response);
  }

  Future<List<Account>> getAccounts() async {
    String params = '?auth=$_securityToken';
    final url = Uri.parse('$database/accounts$requestType$params');
    var response = await http.get(url, headers: _jsonHeaders);
    _checkStatus(response);
    return Account.fromJson(response.body);
  }

  Future createAccount(Account account) async {
    String params = '?auth=$_securityToken';
    final url = Uri.parse('$database/accounts/$requestType$params');
    var response = await http.post(
      url,
      headers: _jsonHeaders,
      body: account.toJson(),
    );
    _checkStatus(response);
  }

  Future updateAccount(Account account) async {
    String params = '?auth=$_securityToken';
    final url = Uri.parse('$database/accounts/${account.urlId}$requestType$params');
    var response = await http.patch(
      url,
      headers: _jsonHeaders,
      body: account.toJson(),
    );
    _checkStatus(response);
  }

  Future<List<ItemType>> getTypes() async {
    String params = '?auth=$_securityToken';
    final url = Uri.parse('$database/types$requestType$params');
    var response = await http.get(url, headers: _jsonHeaders);
    _checkStatus(response);
    return ItemType.fromJson(response.body);
  }

  Future createType(ItemType type) async {
    String params = '?auth=$_securityToken';
    final url = Uri.parse('$database/types$requestType$params');
    var response = await http.post(
      url,
      headers: _jsonHeaders,
      body: type.toJson(),
    );
    _checkStatus(response);
  }

  Future updateType(ItemType type) async {
    String params = '?auth=$_securityToken';
    final url = Uri.parse('$database/types/${type.urlId}$requestType$params');
    var response = await http.patch(
      url,
      headers: _jsonHeaders,
      body: type.toJson(),
    );
    _checkStatus(response);
  }

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
      print('Login failed: code=${response.statusCode}, body=${response.body}');
      throw Exception('Login failed: code =${response.statusCode}');
    }

    _checkStatus(response);

    var map = json.decode(response.body);
    _securityToken = LoginResponse.fromMap(map).idToken;
  }

  void _checkStatus(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception('Error: ${response.statusCode} ${response.body}');
    }
  }
}
