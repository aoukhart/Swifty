import 'package:flutter/material.dart';
import 'package:swifty_companion/app.service.dart';
import 'package:swifty_companion/models/user.dart';
import 'package:swifty_companion/views/myProfile.dart';

class SearchedProfile extends StatefulWidget {
  const SearchedProfile({super.key, required this.user, required this.api});

  final Future<User> user;
  final Api42Service api;

  @override
  State<SearchedProfile> createState() => _SearchedProfileState();
}

class _SearchedProfileState extends State<SearchedProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("SwIFtY"),
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new) ),
      ),
      body: ProfilePage(api: widget.api, user: widget.user),
    );
  }
}