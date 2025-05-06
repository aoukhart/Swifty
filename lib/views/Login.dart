  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:swifty_companion/app.service.dart';
import 'package:swifty_companion/views/Home.dart';
import 'package:swifty_companion/views/myProfile.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.api});
  final Api42Service api;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  late String tkn;
  // = widget.api.localToken;

 _initAuth() async {
    // if (tkn == "" || widget.api.accessToken!.isExpired() == true){
    final tmp = await widget.api.getToken();
    print("1>>>>>>>> ${tmp}");
    setState((){
    if (tmp != null)
        tkn = tmp;
    });
    
    if (tkn != ""){
    print("moving to homepage");
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context)=>MyHomePage(api: widget.api)));
    }
    
  }

  @override
  void initState(){
    super.initState();
    // _initAuth();
  }
  
  @override
  Widget build(BuildContext _context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: _initAuth,
          child: Text("LOGIN WITH 42")),
      ),
    );
  }
}
