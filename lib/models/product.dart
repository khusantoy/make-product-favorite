class Product {
  final String id;
  String title;

  Product({required this.id, required this.title});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
    };
  }
}
