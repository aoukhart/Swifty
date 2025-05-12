import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:swifty_companion/app.service.dart';
import 'package:swifty_companion/models/state.dart';
import 'package:swifty_companion/models/user.dart';
import 'package:swifty_companion/views/myProfile.dart';
import 'package:swifty_companion/views/search.dart';
import 'package:restart_app/restart_app.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.api});

  final Api42Service api;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


late final List<Widget> _views = <Widget>[
  ProfilePage(api: widget.api, user: user),
  SearchPage(api: widget.api),
  ];

  int _selectedView = 0;
  LoadingState state = LoadingState.Loading;
  StreamSubscription? internetCheck;
  late Future<User> user;

  Future<User> _getUserInfo()async {
    final rsp = await widget.api.getLoggedUserInfo();
    return rsp;
    // print(jsonEncode(user));
  }

  _setView(value){
    setState(() {
      _selectedView = value;
    });
  }

  logout() async {
    bool removed = await widget.api.logout();
    if (removed == true){
     Restart.restartApp(); 
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
          if (state == LoadingState.no_network)
            // ignore: curly_braces_in_flow_control_structures
            user.then((User value ) {
              if(value.login.isEmpty == false){
                state = LoadingState.loaded;
              }else{
                state= LoadingState.Loading;
              }
            });
        });
      }
    });
    // if (user.toString().isEmpty == true)
      // return;
    print(">>>>>>>>>>>>>> $state");
    setState(() {
      if (state != LoadingState.no_network){

      user = _getUserInfo();
      state = LoadingState.loaded;
      }
      
    });
    print(">>>>>>>>>>>>>> $state");
    super.initState();
  }

  Future<void> onRefresh() async {
    // if (state == LoadingState.no_network)
    //   return;
    setState(() {
      state = LoadingState.Loading;
      user = _getUserInfo();
    });
     await Future.delayed(Duration(milliseconds: 500));
      setState(() {
      state = LoadingState.loaded;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: ()=> logout(), icon: Icon(Icons.logout_outlined))
          
        ],

        title: Text("SwIFtY"),
        centerTitle: true,
      ),
      body: 
         RefreshIndicator(
          onRefresh: onRefresh,
           child: FutureBuilder(
             future: user,
             builder: (context, snapshot){
              if (state == LoadingState.no_network){
                return Center(child: Container(
                    height: MediaQuery.sizeOf(context).height*0.3,
                    child: Column(
                      children: [
                        Text("NO INTERNET"),
                        Text("Check your network and refresh"),
                        Icon(Icons.error_outline)
                  
                      ],
                    ),
                  ),);
                
              }
              else if (snapshot.hasData == true
              && state == LoadingState.loaded){
           
              return 
              // state == LoadingState.loaded ? 
              _views.elementAt(_selectedView);
              //  : Center(
                // child: CircularProgressIndicator(),
              // ),
                     
             }else if (snapshot.connectionState.index == ConnectionState.waiting.index
              || state == LoadingState.Loading){
                // print("======> $state");
                // print("======> ${snapshot.connectionState}");
              return 
                Center(
                  child: CircularProgressIndicator(),
                );
             }
           
              return Center(child: Column(children: [
               Text("SOMETHING WENT WRONG !!!!!!!"),
               Icon(Icons.error_outline)
              ],),);
             
              }
           ),
         )
      ,
      bottomNavigationBar: BottomNavigationBar(

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_4),
            label: "PROFILE"),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "SEARCH"),
   
        ],
        onTap: (value) => _setView(value),
        currentIndex: _selectedView,
        selectedItemColor: Colors.deepPurple[500],
        selectedFontSize: 15,
        ),
        
        


    );
  }
}
