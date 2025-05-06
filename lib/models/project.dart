class Project {

  int mark;
  String name;

  Project({
    required this.mark,
    required this.name
  });

  factory Project.fromJson(Map<String, dynamic> json){

    return Project(mark: json['final_mark'], name: json['project']['name']);

  }
}