  import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:swifty_companion/app.service.dart';
import 'package:swifty_companion/models/state.dart';
import 'package:swifty_companion/models/user.dart';
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
  LoadingState state = LoadingState.Loading;
  StreamSubscription? internetCheck;

 _initAuth() async {
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
        internetCheck= Connectivity().onConnectivityChanged.listen((connectivity){
      if (connectivity.contains(ConnectivityResult.none)){
        setState(() {
          state = LoadingState.no_network;
          
        });
      }else if (connectivity.contains(ConnectivityResult.mobile) || 
          connectivity.contains(ConnectivityResult.wifi)){
        setState(() {
          state = LoadingState.Loading;
        });
      }
    });
    super.initState();
    // _initAuth();
  }
  
  @override
  Widget build(BuildContext _context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: (){
            print(state);
            if (state == LoadingState.no_network){
              final snackBar = SnackBar(content: Container(
                  height: MediaQuery.sizeOf(context).height*0.05,
                  child: Center(child: Text("No Internet Connection"))),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                padding: EdgeInsets.all(5),
                
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }else 
              _initAuth();
          } 
          ,
          child: Text("LOGIN WITH 42")),
      ),
    );
  }
}
