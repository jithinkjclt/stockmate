import 'package:intl/intl.dart';

class Product {
  final String id;
  final String title;
  final bool isInStock;
  final DateTime dateTime;
  final String description;
  final String imageUrl;
  final String? documentId;

  Product({
    required this.id,
    required this.title,
    required this.isInStock,
    required this.dateTime,
    required this.description,
    required this.imageUrl,
    this.documentId,
  });

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

  factory Product.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return Product(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      isInStock: map['isInStock'] ?? false,
      dateTime: DateTime.tryParse(map['dateTime'] ?? '') ?? DateTime.now(),
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      documentId: documentId,
    );
  }

  String get formattedDate => DateFormat('dd/MM/yyyy').format(dateTime);

  String get formattedTime => DateFormat('hh:mm a').format(dateTime);

  String get formattedDateTime =>
      DateFormat('dd/MM/yyyy hh:mm a').format(dateTime);
}
