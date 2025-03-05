class Category {
  Category({
    required this.id,
    required this.name,
    required this.description,
  });

  final int? id;
  final String? name;
  final String? description;

  factory Category.fromJson(Map<String, dynamic> json){
    return Category(
      id: json["id"],
      name: json["name"],
      description: json["description"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
  };

}
