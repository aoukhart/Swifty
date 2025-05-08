class Skill{
  double level = 0;
  String  name;

  Skill({
    required this.level,
    required this.name
  });

  factory Skill.fromJson(Map<String, dynamic> json){
    return Skill(level: json['level'], name: json['name']);
  }

}