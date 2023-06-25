import 'dart:convert';

import 'package:animephilic/helpers/pkce.dart';
import 'package:animephilic/secrets/secret.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {
  final String _authCodeBaseURL = "https://myanimelist.net/v1/oauth2/authorize";
  final String _authTokenBaseURL = "https://myanimelist.net/v1/oauth2/token";
  final String _clientID = Secret().cliendId;
  final String _redirectURL = "https://com.heckcodes.animephilic/getcode";
  final PkcePair pkcePair = PkcePair.generate();

  String _state = "animephilicstate";
  String _code = "";

  String _tokenType = "";
  int _expiresIn = 0;
  String _accessToken = "";
  String _refreshToken = "";

  get tokenType => _tokenType;
  get expiresIn => _expiresIn;
  get accessToken => _accessToken;
  get refreshToken => _refreshToken;

  bool _isLoggedIn = false;

  get isLoggedIn => _isLoggedIn;

  static Authentication? _instance;
  Authentication._internal() {
    SharedPreferences.getInstance().then((prefs) {
      _isLoggedIn = prefs.getBool("loggedIn") ?? false;
    });
  }

  factory Authentication() => _instance ??= Authentication._internal();

  get getAuthCodeBaseURL => _authCodeBaseURL;
  get clientID => _clientID;
  get redirectURL => _redirectURL;
  get state => _state;
  get authCodeURL => Uri.parse(
      "$_authCodeBaseURL?response_type=code&client_id=$_clientID&code_challenge=${pkcePair.codeChallenge}&state=$_state");

  bool handleCodeFetch(String? code, String? state) {
    _code = code ?? _code;
    if (_code == "" || state != _state) return false;
    return true;
  }

  Future<bool> handleAccessTokenFetch() async {
    bool passed = false;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await http
        .post(
      Uri.parse(_authTokenBaseURL),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        "client_id": _clientID,
        "grant_type": 'authorization_code',
        "code": _code,
        "code_verifier": pkcePair.codeChallenge,
        "client_secret": ""
      },
      encoding: Encoding.getByName('utf-8'),
    )
        .then((response) {
      dynamic json = jsonDecode(response.body);

      _tokenType = json['token_type'];
      preferences.setString("token_type", _tokenType);

      _expiresIn = json['expires_in'];
      preferences.setInt("expires_in", _expiresIn);

      _accessToken = json['access_token'];
      preferences.setString("access_token", _accessToken);

      _refreshToken = json['refresh_token'];
      preferences.setString("refresh_token", _refreshToken);

      passed = true;
    });

    if (passed) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setBool("loggedIn", passed);
      _isLoggedIn = passed;
    }

    return passed;
  }
}
