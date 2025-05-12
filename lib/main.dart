import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swifty_companion/app.service.dart';
import 'package:swifty_companion/views/Home.dart';
import 'package:swifty_companion/views/Login.dart';
import 'package:swifty_companion/views/myProfile.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("accessToken");
  final expDate = prefs.getString("expirationDate");
  var isExpired = false;
  // print("=>" + expDate );
  final String expirationDate = expDate.toString();
  if (expirationDate != 'null'){
  print("...=>" + expirationDate);
    isExpired = DateTime.now().isAfter(DateTime.parse(expirationDate));
  print("is expired ? =>" + isExpired.toString());
      print("= >>> $expirationDate");
    if (isExpired){
      await prefs.remove("accessToken");
      await prefs.remove("expirationDate");
      isExpired = true;
    }
  }
  print("local token : $token");
  print("= = > ${isExpired.toString()}");
  print("local expDate : $expirationDate");
  runApp(MyApp(isLogged:  (token != null) && (!isExpired)));
}

class MyApp extends StatelessWidget {
  final bool isLogged;

  const MyApp({super.key, required this.isLogged});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Api42Service _api = Api42Service();
    return MaterialApp(
      // initialRoute: isLogged ? "/Profile" : "/",
      routes: {
        "/login" : (context) => LoginPage(api: _api),
        "/home" : (context) => MyHomePage(api: _api),
      },
      home: isLogged ? MyHomePage(api: _api) : LoginPage(api: _api),
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}

