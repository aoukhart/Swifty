
import 'package:swifty_companion/models/achievement.dart';
import 'package:swifty_companion/models/project.dart';
import 'package:swifty_companion/models/skills.dart';

class User{
  int     id;
  String  name;
  String  login;
  String  image;
  String? location;
  String? coalition;
  String? coalBanner;
  int     corrPts;
  int     wallet;
  double level;
  List<Project>     projects;
  List<Achievement> achievement;
  List<Skill>       skills;

  User({
    required this.id,
    required this.login,
    required this.name,
    required this.image,
    this.location,
    this.coalition,
    this.coalBanner,
    required this.corrPts,
    required this.wallet,
    required this.level,
    required this.projects,
    required this.achievement,
    required this.skills
  });

  factory User.fromJson(Map<String, dynamic> json){
    List<dynamic> projectsJson = json['projects_users'];
    List<dynamic> achievementsJson = json['achievements'];
    List<dynamic> cursus_users = json['cursus_users'];
    
    List<Skill> skills = [];
    List<Project> projects = [];
    List<Achievement> achievements = [];
    // print(json);
    projectsJson.forEach((element) {
     if (element['project']['parent_id'] == null && element['status'] == "finished"){
      projects.add(Project.fromJson(element));
      // print(">>>> $element");
     }
    });
    
      // print("Done");
    achievementsJson.forEach((element) {
      achievements.add(
        Achievement.fromJson(element)
      );
    },);

    cursus_users[1]['skills'].forEach((element) {
          skills.add(Skill.fromJson(element));
    },);

    // print(json['location']);
    return User(
      id: json['id'],
      login: json['login'],
      name: json['displayname'],
      corrPts: json['correction_point'],
      image: json['image']['versions']["medium"],
      wallet: json['wallet'],
      location: json["location"],
      projects: projects,
      level: json["cursus_users"][1]["level"],
      achievement: achievements,
      skills: skills
    );
  }
}