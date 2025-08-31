class Product {
  final String id;
  final String title;
  final bool isInStock;
  final DateTime dateTime;
  final String description;
  final String imageUrl;

  Product({
    required this.id,
    required this.title,
    required this.isInStock,
    required this.dateTime,
    required this.description,
    required this.imageUrl,
  });

  // Convert Product -> Map (for API or local storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isInStock': isInStock,
      'dateTime': dateTime.toIso8601String(),
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  // Convert Map -> Product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      isInStock: map['isInStock'] ?? false,
      dateTime: DateTime.tryParse(map['dateTime'] ?? '') ?? DateTime.now(),
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
