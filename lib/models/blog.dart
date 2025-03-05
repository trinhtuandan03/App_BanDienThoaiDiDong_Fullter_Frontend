class Blog {
  Blog({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.imageUrl,
    required this.category,
  });

  final int? id;
  final String? title;
  final String? content;
  final String? authorId;
  final String? imageUrl;
  final String? category;

  factory Blog.fromJson(Map<String, dynamic> json){
    return Blog(
      id: json["id"],
      title: json["title"],
      content: json["content"],
      authorId: json["authorId"],
      imageUrl: json["imageUrl"],
      category: json["category"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "content": content,
    "authorId": authorId,
    "imageUrl": imageUrl,
    "category": category,
  };

}
