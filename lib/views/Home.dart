import 'package:flutter/material.dart';
import 'package:swifty_companion/app.service.dart';
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
    super.initState();
    // if (user.toString().isEmpty == true)
      // return;
    // print(user.toString());
    user = _getUserInfo();
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
         _views.elementAt(_selectedView)
      ,
      bottomNavigationBar: BottomNavigationBar(

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_4),
            label: "PROFILE"),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "SEARCH"),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: "EVENTS"),
        ],
        onTap: (value) => _setView(value),
        currentIndex: _selectedView,
        selectedItemColor: Colors.deepPurple[500],
        selectedFontSize: 15,
        ),
        
        


    );
  }
}
