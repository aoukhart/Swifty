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
  final token = await prefs.getString("accessToken");
  print("local token : $token");
  runApp(MyApp(isLogged:  token != null));
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

