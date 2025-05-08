
import 'dart:io';

import 'package:cached_network_svg_image/cached_network_svg_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swifty_companion/app.service.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:swifty_companion/models/achievement.dart';
import 'package:swifty_companion/models/skills.dart';
import '../models/user.dart';
import '../packages/modified/spider_chart.dart';

class ProfilePage extends StatefulWidget {
  final Api42Service api;
  final Future<User> user;
  const ProfilePage({super.key, required this.api, required this.user});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
   




  @override
  Widget build(BuildContext context) {
    print(widget.user);
    return FutureBuilder(
      future: widget.user,
      builder: (context, snapshot) {
        if (snapshot.hasData){
          return  ProfileWidget(context, snapshot.data!);
        }else if (snapshot.hasError){
          print(">>>>"+snapshot.error.toString());
          print(">>>> ${snapshot.hasData}");
          return Text("Something went wrong");
        }
        return Center(
          child: CircularProgressIndicator()
        );
      });

  }
}



Widget ProfileWidget(BuildContext context,User user){
  
  return SingleChildScrollView(
    child: 
      Column(
        children: [
          ProfileHeader(context, user),
          SizedBox(height: 20,),
          ProjectSlider(context, user),
          SizedBox(height: 25,),
          SkillsAchievementsCarousel( context , user),
          SizedBox(height: 15,),
        ],
      ),
    
  );
}


Widget ProfileHeader(BuildContext context, User user){
  return Container(
        height: MediaQuery.sizeOf(context).height*0.3,
        width: MediaQuery.sizeOf(context).width,
        color: Color.fromARGB(255, 0, 0, 0),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.sizeOf(context).height*0.18,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(image: DecorationImage(
                fit: BoxFit.fitHeight
                ,image: 
              NetworkImage(user.coalBanner!))),
            ),
            Positioned(
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.image),
                radius: MediaQuery.sizeOf(context).width*0.2,),
              left: MediaQuery.sizeOf(context).width*0.55,
              top: MediaQuery.sizeOf(context).height*0.03,
            ),
            if (user.location != null)
              Positioned(
                height: MediaQuery.sizeOf(context).height*0.18,
                width: MediaQuery.sizeOf(context).width*0.5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(25)
                  ),
                  child: Text(user.location!, style: TextStyle(color: Colors.white),),
              ))
            
              
            ,
            Positioned(
              top: MediaQuery.sizeOf(context).height*0.06,
              left: MediaQuery.sizeOf(context).width*0.07,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20)
                ),child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(user.name, style: TextStyle(color: Colors.white, fontSize: 18),),
                    Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                    Text(user.login, style: TextStyle(color: Colors.white),),
                  ],),
                ),
              )

            ),Positioned(
              top: MediaQuery.sizeOf(context).height*0.2,
              left: MediaQuery.sizeOf(context).width*0.07,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center
                ,
              children: [
                Text("Ev.P  ${user.corrPts}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                SizedBox(width: MediaQuery.sizeOf(context).width*0.12),
                Text("Wallet", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
                Text("  ${user.wallet}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15)),
                // Text("${user.level}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                
              ]),
              ),
              Positioned(
                left: MediaQuery.sizeOf(context).width*0.07,
                top: MediaQuery.sizeOf(context).height*0.23
                ,child: Row(
                children: [
                  Text("${user.level.toString().split(".")[0]}", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900),),
                Column(
                  children: [
                    SizedBox(width: MediaQuery.sizeOf(context).width*0.05),
                  ],
                ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${user.level.toString().split(".")[1]}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
                        Padding(padding: EdgeInsets.all(3)),
                        Container(
                          height: 10,
                          width: MediaQuery.sizeOf(context).width*0.7,
                          color: Colors.grey,
                          child: Stack(
                            children: [
                              Container(
                                height: 10,
                                width: (MediaQuery.sizeOf(context).width*0.7/100) * int.parse(user.level.toString().split(".")[1]),
                                color: Colors.green,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ))
          
            // Text("${user.login}"),
            // Text("${user.wallet}"),
          ],
        ),
      );
}

Widget ProjectSlider(BuildContext context, User user){
  return Container(      
    padding: EdgeInsets.symmetric(horizontal: 0),
    height: MediaQuery.sizeOf(context).height*0.4,
    width: MediaQuery.sizeOf(context).width*0.9,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      color: Colors.grey
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 9),
          child: Text("Projects", style: TextStyle(color: Colors.white, fontSize: 22,fontWeight: FontWeight.w700),),
        ),
        Container(
          height: MediaQuery.sizeOf(context).height*0.3,
          width: MediaQuery.sizeOf(context).width*0.8,
          child: Scrollable(
              viewportBuilder: (context, position) => 
              ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 14,),
                itemCount: user.projects.length,
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 190, 189, 189),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  height: 55,
                  // margin: EdgeInsets.only(bottom: 4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(user.projects[index].name,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),),
                        Text(user.projects[index].mark.toString(),
                          style: TextStyle(color: 
                            user.projects[index].mark <= 0 ? 
                              const Color.fromARGB(255, 211, 15, 1) : (  user.projects[index].mark <= 100 ? const Color.fromARGB(255, 6, 131, 10): const Color.fromARGB(255, 85, 151, 88))
                          , fontWeight: FontWeight.w800, fontSize: 18),),
                        
                      ],
                    ),
                  ),
                ),),
            ),
        ),
      ],
    ));
}

class SkillsAndAchievements extends StatefulWidget {
  const SkillsAndAchievements({super.key, required this.user, required this.context});
  final User user;
  final BuildContext context;
  @override
  State<SkillsAndAchievements> createState() => _SkillsAndAchievementsState();
}

class _SkillsAndAchievementsState extends State<SkillsAndAchievements> {
  
  
  int index = 0;
  ScrollController _scrollController = ScrollController();
  late List<Widget> pages = [
    AchievementsSlider(widget.context, widget.user),
    ProfileSkills(widget.context, widget.user)
  ]; 

  @override
  Widget build(BuildContext context) {
    return Container(      
    padding: EdgeInsets.symmetric(horizontal: 0),
    height: MediaQuery.sizeOf(context).height*0.55,
    width: MediaQuery.sizeOf(context).width*0.9,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
    ),
    child: 
    // Stack(
      // children: [

        Scrollable(
          
          axisDirection: AxisDirection.down,
          viewportBuilder: 

          (context, position) {
            return ListView.separated(
            controller: _scrollController,
            separatorBuilder: (context, index) => SizedBox(width: MediaQuery.sizeOf(context).width*0.05,),
            scrollDirection: Axis.horizontal,
            itemBuilder: 
              (context, ind)
              {
                // setState(() {
                  index = ind;
                // });
                return Stack(
                  children: [
                    pages[index],
                    Positioned(
                    top: 5, left: 15,
                      child: IconButton(icon: Icon(Icons.arrow_back_ios_new),
                        color: const Color.fromARGB(255, 96, 96, 96),
                        onPressed: (){
                          if (ind > 0){
                            setState(() {
                              index = ind;
                              index--;
                              _scrollController.animateTo(0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                            });
                            print(index);
                            print(ind);
                          }
                          // ind > 0 ? index-- : ind;
                        },
                      )
                    ),Positioned(
                    top: 5, right: 15,
                      child: IconButton(icon: Icon(Icons.arrow_forward_ios),
                        color: const Color.fromARGB(255, 96, 96, 96),
                        onPressed: (){
                          if (ind < 1){
                            setState(() {
                              index = ind;
                              index++;
                              _scrollController.animateTo(MediaQuery.sizeOf(context).width*0.95,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                            });
                            print(index);
                            print(ind);
                          }
                          // ind > 0 ? index-- : ind;
                        },
                      ))
                    

                  ],
                );
              },
            itemCount: 2);}
      // ],
    ),
    // CarouselView(

    //   itemExtent: MediaQuery.sizeOf(context).width*0.9,
    //   shrinkExtent: MediaQuery.sizeOf(context).width*0.5,
    //     scrollDirection: Axis.horizontal,
          
    //      children: [
    //     AchievementsSlider(context, user),  
    //     ProfileSkills(context, user)
    //   ]),
    );
  }
}

Widget SkillsAchievementsCarousel(BuildContext context, User user){
  int index = 0;
  ScrollController _scrollController = ScrollController();

  final pages = [AchievementsSlider(context, user), ProfileSkills(context, user)]; 
return Container(      
    padding: EdgeInsets.symmetric(horizontal: 0),
    height: MediaQuery.sizeOf(context).height*0.55,
    width: MediaQuery.sizeOf(context).width*0.9,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
    ),
    child: 
    // Stack(
      // children: [

        Scrollable(
          
          axisDirection: AxisDirection.down,
          viewportBuilder: 

          (context, position) {
            return ListView.separated(
            controller: _scrollController,
            separatorBuilder: (context, index) => SizedBox(width: MediaQuery.sizeOf(context).width*0.05,),
            scrollDirection: Axis.horizontal,
            itemBuilder: 
              (context, ind)
              {
                // setState(() {
                  index = ind;
                // });
                return Stack(
                  children: [
                    pages[index],
                    Positioned(
                    top: 5, left: 15,
                      child: IconButton(icon: Icon(Icons.arrow_back_ios_new),
                        color: const Color.fromARGB(255, 96, 96, 96),
                        onPressed: (){
                          if (ind > 0){
                              index = ind;
                              index--;
                              _scrollController.animateTo(0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                            print(index);
                            print(ind);
                          }
                          // ind > 0 ? index-- : ind;
                        },
                      )
                    ),Positioned(
                    top: 5, right: 15,
                      child: IconButton(icon: Icon(Icons.arrow_forward_ios),
                        color: const Color.fromARGB(255, 96, 96, 96),
                        onPressed: (){
                          if (ind < 1){
                              index = ind;
                              index++;
                              _scrollController.animateTo(MediaQuery.sizeOf(context).width*0.95,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                            };
                            print(index);
                            print(ind);
                          }))
                          // ind > 0 ? index-- : ind;
               

                  ],
                );
              },
            itemCount: 2);}
      // ],
    ),
    // CarouselView(

    //   itemExtent: MediaQuery.sizeOf(context).width*0.9,
    //   shrinkExtent: MediaQuery.sizeOf(context).width*0.5,
    //     scrollDirection: Axis.horizontal,
          
    //      children: [
    //     AchievementsSlider(context, user),  
    //     ProfileSkills(context, user)
    //   ]),
    );
}

Widget AchievementsSlider(BuildContext context, User user){
  return Container(      
    padding: EdgeInsets.symmetric(horizontal: 0),
    height: MediaQuery.sizeOf(context).height*0.5,
    width: MediaQuery.sizeOf(context).width*0.9,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      color: Colors.grey
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 9),
          child: Text("Achievements", style: TextStyle(
            color: Colors.white, fontSize: 22,fontWeight: FontWeight.w700),),
        ),
        Container(
          height: MediaQuery.sizeOf(context).height*0.41,
          width: MediaQuery.sizeOf(context).width*0.8,
          child: Scrollable(

              viewportBuilder: (context, position) => 
              ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 14,),
                itemCount: user.achievement.length,
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 190, 189, 189),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  height: 85,
                  // margin: EdgeInsets.only(bottom: 4),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),

                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width*0.55,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 3,
                            children: [
                              Text(user.achievement[index].name, 
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15), softWrap: true, ),
                              Text(user.achievement[index].description,
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 10), softWrap: true, maxLines: 2,overflow: TextOverflow.ellipsis,),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.sizeOf(context).width*0.15,
                          height: 40,
                          child: 

                          FutureBuilder(future: svgHasStyleTag(user.achievement[index].image),
                             builder: (context, snapshot){
                              if (snapshot.hasData){
                                return snapshot.data!;
                              }else if(snapshot.connectionState == ConnectionState.waiting){
                                return Center(child: CircularProgressIndicator(padding: EdgeInsets.all(15),));
                              }

                              return Icon(Icons.error_outline);
                             },)
                        )
                      ],
                    ),
                  ),
                ),),
            ),
        ),
      ],
    ));
}

Widget ProfileSkills(BuildContext context, User user){
  List skills = [
// , , , , , "\n\nDb & Data", "\n\nBasics", "\n\nGraphics", "\nGroup &\ninterpersonal", "\n\nImperative\nprogramming", "Network\n& system\nadministration", "\n\nObject oriented\nprogramming", "\n\nOrganization", "\nParallel\ncomputing", "Rigor", "Ruby", "Security", "Shell", "Technology\nintegration", "Unix"],
              user.skills.where((skill)=>skill.name == "Web").isEmpty ? 0 : user.skills.where((skill)=>skill.name == "Web").last ,
              user.skills.where((skill)=>skill.name == "Adaptation & creativity").isEmpty ? 0 : user.skills.where((skill)=>skill.name == "Adaptation & creativity").last ,
              user.skills.where((skill)=>skill.name == "Algorithms & AI").isEmpty ? 0 : user.skills.where((skill)=>skill.name == "Algorithms & AI").last,
              user.skills.where((skill)=>skill.name == "Functional programming").isEmpty ? 0 : user.skills.where((skill)=>skill.name == "Functional programming").last,
              user.skills.where((skill)=>skill.name == "Company experience").isEmpty ? 0 : user.skills.where((skill)=>skill.name == "Company experience").last,
              user.skills.where((skill)=>skill.name == "Db & Data").isEmpty ? 0 : user.skills.where((skill)=>skill.name == "Db & Data").last,
              user.skills.where((skill)=>skill.name == "Basics").isEmpty ? 0 : user.skills.where((skill)=>skill.name == "Basics").last,
              user.skills.where((skill)=>skill.name == "Graphics").isEmpty ? 0 : user.skills.where((skill)=>skill.name == "Graphics").last,
              user.skills.where((skill)=>skill.name == "Group & interpersonal").isEmpty ? 0 : user.skills.where((skill)=>skill.name == "Group & interpersonal").last,
              user.skills.where((skill)=>skill.name == "Imperative programming").isEmpty ? 0 : user.skills.where((skill)=>skill.name == "Imperative programming").last,
              user.skills.where((skill)=>skill.name == "Network & system administration").isEmpty ? 0 : user.skills.where((skill)=>skill.name == "Network & system administration").last,
              user.skills.where((skill)=>skill.name == "Object-oriented programming").isEmpty ? 0 : user.skills.where((skill)=>skill.name == "Object-oriented programming").last,
              user.skills.where((skill)=>skill.name == "Organization").isEmpty ? 0 : user.skills.where((skill)=>skill.name == "Organization").last,
              user.skills.where((skill)=>skill.name == "Parallel computing").isEmpty ? 0 : user.skills.where((skill)=>skill.name == "Parallel computing").last,
              user.skills.where((skill)=>skill.name == "Rigor").isEmpty ? 0 : user.skills.where((skill)=>skill.name == "Rigor").last,
              user.skills.where((skill)=>skill.name == "Ruby").isEmpty ? 0 : user.skills.where((skill)=>skill.name == "Ruby").last,
              user.skills.where((skill)=>skill.name == "Security").isEmpty ? 0 : user.skills.where((skill)=>skill.name == "Security").last,
              user.skills.where((skill)=>skill.name == "Shell").isEmpty ? 0 : user.skills.where((skill)=>skill.name == "Shell").last,
              user.skills.where((skill)=>skill.name == "Shell").isEmpty ? 0 : user.skills.where((skill)=>skill.name == "Technology integration").last,
              user.skills.where((skill)=>skill.name == "Unix").isEmpty ? 0 : user.skills.where((skill)=>skill.name == "Unix").last,

    
    ];
    skills.forEach((element) {
      if(element != 0){
      print("${element.name} ${element.level}");
      }else 
      print (element);

    });
  return Container(      
    padding: EdgeInsets.symmetric(horizontal: 0),
    height: MediaQuery.sizeOf(context).height*0.5,
    width: MediaQuery.sizeOf(context).width*0.9,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      color: Colors.grey
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 9),
          child: Text("Skills", style: TextStyle(color: Colors.white, fontSize: 22,fontWeight: FontWeight.w700),),
        ),
        SizedBox(height: 30,),
        Padding(
          padding: const EdgeInsets.only(right: 1),
          child: Container(
            height: MediaQuery.sizeOf(context).height*0.32,
            child: SpiderChart(data:skills.map((e){
              if (e != 0){
                return e.level as double;
              }
              return 0.0;
            },).toList(),
            decimalPrecision: 1,

            maxValue: 20,
            labels: ["Web", "Adaptation\n& creativity\n", "Algo & AI",
             "Functional\nprogramming", "\nCompany\n  Exp.", "\n\nDb & Data",
             "\n\nBasics", "\n\nGraphics", "\nGroup &\ninterpersonal", "\n\nImperative\nprogramming", "Network\n& system\nadministration", "\n\nObject oriented\nprogramming", "\n\nOrganization",
              "\nParallel\ncomputing", "Rigor", "Ruby", "Security", "Shell", "Technology\nintegration", "Unix"],
            )

              // ticks: [5,10,15,20].toList(),
              // features: ["Web", "Adaptation & creativity", "Algo & AI", "Basics", "Company Exp", "Db & Data", "Functional programming", "Graphics","Group & interpersonal", "Imperative programming", "Network & system administration", "Objectoriented programming", "Organization", "Parallel computing", "Rigor", "Ruby", "Security", "Shell", "Technology integration", "Unix"].toList(),
              // data: [[6.2, 0, 3.74, 0, 10.99, 0,0 ,3.18, 6.96,4.87,  7.24, 5.67, 0, 0 ,7.76, 0,0,0,0, 4.34].toList()], 
              // axisColor: Colors.black12,
              // graphColors: [const Color.fromARGB(255, 0, 109, 4)],
              // sides: 20,
              // outlineColor: const Color.fromARGB(255, 188, 188, 188),
              // featuresTextStyle: TextStyle(fontSize: 8, overflow: TextOverflow.fade),
          
              
              ),
        ),
          SizedBox(
            height: 0,
          )
      ]));
}

Future<Widget?> svgHasStyleTag(String path) async {
  final resp = await http.get(Uri.parse(path));
  if (resp.statusCode == 200){
    final svgData = resp.body;
    if (RegExp(r'<style[^>]*>', caseSensitive: false).hasMatch(svgData) == true){
      print("fiiiiih");
      // await precachePicture()
      return ScalableImageWidget(           
        si: ScalableImage.fromSvgString(
          svgData, 
        ),
        // cache: ScalableImageCache(size: 100),
      );
    }
    print("mafiiiiihch");
    return  CachedNetworkSVGImage(
      path,
      placeholder: CircularProgressIndicator(),
      fit: BoxFit.fitHeight,
    );
  }
}