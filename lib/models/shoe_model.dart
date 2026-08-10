class Shoe {
  final int id;
  final String title;
  final String description;
  final double price;
  final String brand;
  final String category;
  final String gender;
  final String imageUrl;
  final List<String> images;

  Shoe({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.brand,
    required this.category,
    this.gender = 'Men',
    required this.imageUrl,
    required this.images,
  });


  factory Shoe.fromJson(Map<String, dynamic> json) {

    return Shoe(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      price: (json['price'] ?? 0).toDouble(),
      brand: json['brand'] ?? "",
      category: json['category'] ?? "",
      gender: json['gender'] ?? 'Men',
      imageUrl: json['thumbnail'] ?? "",
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : [],
    );

  }


  Map<String, dynamic> toJson(){

    return {
      "id": id,
      "title": title,
      "description": description,
      "price": price,
      "brand": brand,
      "category": category,
      "gender": gender,
      "thumbnail": imageUrl,
      "images": images,
    };

  }
}