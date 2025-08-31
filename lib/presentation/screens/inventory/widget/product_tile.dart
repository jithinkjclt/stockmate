import 'package:flutter/material.dart';
import 'package:stockmate/core/constants/colors.dart';
import 'package:stockmate/presentation/widgets/custom_apptext.dart';

class ProductTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String productId;
  final bool isInStock;
  final String? addedTime; // optional
  final ValueChanged<String> onOptionSelected;

  const ProductTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.productId,
    required this.isInStock,
    this.addedTime, // optional param
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageUrl.isEmpty
                ? Container(
              width: 60,
              height: 60,
              color: Colors.grey[200],
              child: const Icon(Icons.broken_image, color: Colors.grey),
            )
                : Image.network(
              imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(title, size: 16, weight: FontWeight.w700),
                const SizedBox(height: 4),
                AppText("ID: $productId", size: 13, color: Colors.grey[600]),
                const SizedBox(height: 4),
                AppText(
                  isInStock ? "In Stock" : "Out of Stock",
                  size: 12,
                  color: isInStock ? Colors.green : Colors.red,
                  weight: FontWeight.w600,
                ),
                if (addedTime != null) ...[
                  const SizedBox(height: 4),
                  AppText(
                    "Added: $addedTime",
                    size: 12,
                    color: Colors.blueGrey,
                  ),
                ],
              ],
            ),
          ),
          PopupMenuButton<String>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 6,
            icon: const Icon(Icons.more_vert, color: Colors.black54),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "edit",
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 18, color: primaryColor),
                    SizedBox(width: 8),
                    Text("Edit"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: "delete",
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text("Delete"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: isInStock ? "out_of_stock" : "in_stock",
                child: Row(
                  children: [
                    Icon(
                      isInStock ? Icons.remove_circle : Icons.add_circle,
                      size: 18,
                      color: isInStock ? Colors.orange : Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Text(isInStock ? "Mark Out of Stock" : "Mark In Stock"),
                  ],
                ),
              ),
            ],
            onSelected: onOptionSelected,
          ),
        ],
      ),
    );
  }
}
