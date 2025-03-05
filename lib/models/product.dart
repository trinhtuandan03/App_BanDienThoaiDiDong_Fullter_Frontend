import 'category.dart';
class Product {
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image1,
    required this.image2,
    required this.description,
    required this.categoryId,
    //required this.category,
  });

  final int? id;
  final String? name;
  final double? price;
  final String? image1;
  final String? image2;
  final String? description;
  final int? categoryId;
  //final Category? category;

  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
      id: json["id"],
      name: json["name"],
      price: json["price"],
      image1: json["image1"],
      image2: json["image2"],
      description: json["description"],
      categoryId: json["categoryId"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "image1": image1,
    "image2": image2,
    "description": description,
    "categoryId": categoryId,
  };

}
