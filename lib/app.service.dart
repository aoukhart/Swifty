import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swifty_companion/models/user.dart';
// import 'package:shared_preferences/shared_preferences.dart';

String url = dotenv.get("API_URL");
String client_id = dotenv.get("CLIENT_ID");
String client_secret = dotenv.get("CLIENT_SECRET");
String auth_url = dotenv.get("AUTH_URL");
String token_url = dotenv.get("TOKEN_URL");

class Api42Service{
  late AccessTokenResponse accessToken;
  // late SharedPreferences? prefs;
  late OAuth2Client client;
  String token = "";
  //  = SharedPreferences.getInstance();

  get localToken => getTokenCache();

  Api42Service() {
    print("42api init starting >>>>>>>>>>>>>");
    _init42Service();
    print("42api init finished >>>>>>>>>>>>>");

  }

  getTokenCache(){
    var cached;
    SharedPreferencesAsync().getString("accessToken").then((rsp){cached = rsp;});
    if (cached == null){

      return "";
    }
     print("frm cache >> ${cached}");
    return cached.toString();
  }

  _init42Service() async {
    
    client = OAuth2Client(
      authorizeUrl: auth_url,
      tokenUrl: token_url,
      redirectUri: 'my.swifty.app://oauth2redirect',
      customUriScheme: 'my.swifty.app'
    );
    // prefs = await SharedPreferences.getInstance();
  }

  // get localToken async => await prefs.getString("accessToken"); 


  getToken() async {
     print("Getting Token");
     final rsp = await client.getTokenWithAuthCodeFlow(
      clientId: client_id,
      clientSecret: client_secret,
      scopes: ["public", "profile"],
    );
     print("rqst rsp: $rsp");
    if (rsp.httpStatusCode == 200 && rsp.accessToken != null){
      
      accessToken = rsp;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("accessToken",rsp.accessToken!);
      var expirationDate = rsp.expirationDate.toString();
      await prefs.setString("expirationDate", expirationDate);
      token = rsp.accessToken!;
      print("DONE >>>>> $token ${rsp.expirationDate?.day} ${rsp.expirationDate?.hour} ${rsp.expirationDate?.minute} ${rsp.expirationDate?.second}");
      return token;
    }
  }

  Future<bool> logout()async{
    token = "";
    final prefs = await SharedPreferences.getInstance();
    bool removed = await prefs.remove("accessToken");
    bool removed1 = await prefs.remove("expirationDate");
    return removed && removed1;
  }

  Future getLoggedUserInfo() async {

    final prefs = await SharedPreferences.getInstance();
    if (token == ""){
      token = prefs.getString("accessToken")!;
    }
    var time = prefs.getString("expirationDate");
    if (time != ""){
      if (DateTime.now().isBefore(DateTime.parse(time!)) == true){
        //
      }else{
        logout();
        await prefs.remove("expirationDate");
        await prefs.remove("accessToken");
        Restart.restartApp(notificationBody: "Your session has expired", notificationTitle: "Your Session has expired");
      };
    }
    final res = await http.get(Uri.parse("$url/v2/me"), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (res.statusCode == 200){

      return await getCoalition(User.fromJson(jsonDecode(res.body)));
    }else{
      throw Exception("Failed to load logged user data");
    }
  }

  Future<User> getCoalition(User user) async {
    final res = await http.get(Uri.parse("$url/v2/users/${user.id.toString()}/coalitions"), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (res.statusCode == 200){
      List<dynamic> body = jsonDecode(res.body);      
      user.coalition = body[0]["name"];
      user.coalBanner = body[0]["cover_url"];
    }
    
    return user;
  }

  Future<User> getUserWithLogin(String login) async {

    // print("looking for user");
    final res = await http.get(Uri.parse("$url/v2/users/$login"), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (res.statusCode == 200){
      // print("called ${res.body}");
      return await getCoalition(User.fromJson(jsonDecode(res.body)));
    }else{
      // print("EGHOOOOOGH");
      throw HttpException("User not Found");
    }
  }

}
