import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swifty_companion/models/user.dart';
// import 'package:shared_preferences/shared_preferences.dart';

String url = dotenv.get("API_URL");

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
     print(">>>>> ${cached}");
    return cached.toString();
  }

  _init42Service() async {
    
    client = OAuth2Client(
      authorizeUrl: 'https://api.intra.42.fr/oauth/authorize',
      tokenUrl: 'https://api.intra.42.fr/oauth/token',
      redirectUri: 'my.swifty.app://oauth2redirect',
      customUriScheme: 'my.swifty.app'
    );
    // prefs = await SharedPreferences.getInstance();
  }

  // get localToken async => await prefs.getString("accessToken"); 


  getToken() async {
     print("Getting Token");
     final rsp = await client.getTokenWithAuthCodeFlow(
      clientId: "u-s4t2ud-ce2186eb256232005ab650c3d34eb0dfc72f1b248070d5e662722dc0d9b7f587",
      clientSecret: "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",
      scopes: ["public", "profile"],
    );
     print("rqst rsp: $rsp");
    if (rsp.httpStatusCode == 200 && rsp.accessToken != null){
      
      // print( await SharedPreferencesAsync().getString("accessToken") );
      accessToken = rsp;
      print("DONE >>>>> $token");
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("accessToken",rsp.accessToken!);
      token = rsp.accessToken!;
      return token;
    }
  }

  Future<bool> logout()async{
    token = "";
    final prefs = await SharedPreferences.getInstance();
    bool removed = await prefs.remove("accessToken");
    return removed;
  }

  Future<User> getLoggedUserInfo() async {

    if (token == ""){
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString("accessToken")!;
      
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
    print("looking for user");
    final res = await http.get(Uri.parse("$url/v2/users/$login"), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (res.statusCode == 200){
      print("called ${res.body}");
      return await getCoalition(User.fromJson(jsonDecode(res.body)));
    }else{
      throw HttpException("User not Found");
    }
  }

}
