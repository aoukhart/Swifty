import 'package:flutter/material.dart';
import 'package:swifty_companion/app.service.dart';
import 'package:swifty_companion/models/user.dart';
import 'package:swifty_companion/views/Profile.dart';
import 'package:swifty_companion/views/myProfile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.api});
  final Api42Service api;

  @override
  State<SearchPage> createState() => _SearchPageState();
}



class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          Padding(
            padding: const EdgeInsets.all(35.0),
            child: 
                SearchBar(
                  controller: _controller,
                  hintText: "Search for a student.",
                ),
             
          ),
          TextButton(
            onPressed: ()async {
              try {
                Future<User> searchedUser = widget.api.getUserWithLogin(_controller.text);
                User user = await searchedUser;
                print(_controller.text);
                print(user.name);
                  Navigator.push(context, MaterialPageRoute(builder: 
                    (context) {
                    
                    return SearchedProfile(
                      api: widget.api,
                      user: searchedUser
                      );
                    }
                      ));
              } on Exception catch (e) {
                print("L EGHOOOOGH" + e.toString());
                final snackBar = SnackBar(content: Container(
                  height: MediaQuery.sizeOf(context).height*0.06,
                  child: Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("User not found.", style: TextStyle(fontWeight: FontWeight.w700),),
                      Text("Wrong login."),
                    ],
                  ))),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                padding: EdgeInsets.all(5),
                
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            style: ButtonStyle(
              backgroundColor:WidgetStateColor.resolveWith((states) => Colors.grey)
            )
            ,child: Text("Search 4 a Peer", style: TextStyle(
              color: Colors.white
            ),) 
          )
      ],
    );
    
  }
}

