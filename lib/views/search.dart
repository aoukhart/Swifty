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
            onPressed: () {
              print(_controller.text);
                Navigator.push(context, MaterialPageRoute(builder: 
                  (context) => SearchedProfile(
                    api: widget.api,
                    user: widget.api.getUserWithLogin(_controller.text))));
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

