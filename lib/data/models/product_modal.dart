import 'package:intl/intl.dart';

class Product {
  final String id;
  final String title;
  final bool isInStock;
  final DateTime dateTime;
  final String description;
  final String imageUrl;
  final String? path; // 👈 optional

  Product({
    required this.id,
    required this.title,
    required this.isInStock,
    required this.dateTime,
    required this.description,
    required this.imageUrl,
    this.path, // 👈 optional
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isInStock': isInStock,
      'dateTime': dateTime.toIso8601String(),
      'description': description,
      'imageUrl': imageUrl,
      if (path != null) 'path': path, // 👈 only add if not null
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      isInStock: map['isInStock'] ?? false,
      dateTime: DateTime.tryParse(map['dateTime'] ?? '') ?? DateTime.now(),
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      path: map['path'], // 👈 safe, will be null if not present
    );
  }

  String get formattedDate => DateFormat('dd/MM/yyyy').format(dateTime);

  String get formattedTime => DateFormat('hh:mm a').format(dateTime);

  String get formattedDateTime =>
      DateFormat('dd/MM/yyyy hh:mm a').format(dateTime);
}
