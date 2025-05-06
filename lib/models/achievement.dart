class Achievement{
  String name;
  String description;
  String image;

  Achievement({
    required this.name,
    required this.description,
    required this.image,
  });

  factory Achievement.fromJson(Map<String, dynamic> json){
    print(">>>> ${json['image']}");
    return Achievement(
      name: json['name'],
      description: json['description'],
      image: "http://cdn.intra.42.fr"+json['image'].toString().substring(8)
    );
  }
}