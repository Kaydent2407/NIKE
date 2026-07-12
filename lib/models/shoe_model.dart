class Shoe {
  final String id;
  final String title;
  final String subtitle;
  final String price;
  final String imageUrl;
  final String productUrl;
  final String gender;
  final String createdAt;
  final String target;

  Shoe({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imageUrl,
    required this.productUrl,
    required this.gender,
    required this.createdAt,
    required this.target,
  });

  factory Shoe.fromJson(Map<String, dynamic> json) {
    return Shoe(
      id: json["group_key"] ?? "",
      title: json["title"] ?? "",
      subtitle: json["subtitle"] ?? "",
      price: json["price"] ?? "",
      imageUrl: json["image_url"] ?? "",
      productUrl: json["product_url"] ?? "",
      gender: json["gender"] ?? "",
      createdAt: json["created_at"] ?? "",
      target: json["target"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "group_key": id,
      "title": title,
      "subtitle": subtitle,
      "price": price,
      "image_url": imageUrl,
      "product_url": productUrl,
      "gender": gender,
      "created_at": createdAt,
      "target": target,
    };
  }
}