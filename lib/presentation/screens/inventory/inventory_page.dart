import 'package:flutter/material.dart';
import 'package:stockmate/core/utils/margin_text.dart';
import 'package:stockmate/presentation/screens/inventory/widget/filter_tile.dart';
import 'package:stockmate/presentation/screens/inventory/widget/product_tile.dart';
import '../../../data/models/product_modal.dart';
import '../../widgets/search_fild.dart';

// Product Model

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Product> products = [
      Product(
        id: "P12345",
        title: "Sneakers",
        isInStock: true,
        dateTime: DateTime.now().subtract(const Duration(days: 1)),
        description: "Comfortable sneakers",
        imageUrl: "https://via.placeholder.com/150",
      ),
      Product(
        id: "P12346",
        title: "T-Shirt",
        isInStock: false,
        dateTime: DateTime.now().subtract(const Duration(days: 2)),
        description: "Cotton T-shirt",
        imageUrl: "https://via.placeholder.com/150",
      ),
      Product(
        id: "P12347",
        title: "Jeans",
        isInStock: true,
        dateTime: DateTime.now().subtract(const Duration(hours: 5)),
        description: "Blue denim jeans",
        imageUrl: "https://via.placeholder.com/150",
      ),
      Product(
        id: "P12348",
        title: "Watch",
        isInStock: true,
        dateTime: DateTime.now(),
        description: "Stylish wristwatch",
        imageUrl: "https://via.placeholder.com/150",
      ),
      Product(
        id: "P12348",
        title: "Watch",
        isInStock: true,
        dateTime: DateTime.now(),
        description: "Stylish wristwatch",
        imageUrl: "https://via.placeholder.com/150",
      ),
      Product(
        id: "P12348",
        title: "Watch",
        isInStock: true,
        dateTime: DateTime.now(),
        description: "Stylish wristwatch",
        imageUrl: "https://via.placeholder.com/150",
      ),
      Product(
        id: "P12348",
        title: "Watch",
        isInStock: true,
        dateTime: DateTime.now(),
        description: "Stylish wristwatch",
        imageUrl: "https://via.placeholder.com/150",
      ),
    ];
    return Column(
      children: [
        SearchField(
          width: context.deviceSize.width / 1.1,
          height: context.deviceSize.height / 15,
          hintText: 'Search Product',
          suffixIcon: Icons.search,
        ),
        15.hBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            FilterTile(isSelected: true, label: "All Products"),
            FilterTile(label: "In Stock", isSelected: false),
            FilterTile(label: "Out of Stock", isSelected: false),
          ],
        ),
        15.hBox,
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductTile(
                addedTime: "${product.dateTime}",
                imageUrl: product.imageUrl,
                title: product.title,
                productId: product.id,
                isInStock: product.isInStock,
                onOptionSelected: (value) {
                  if (value == "edit") {
                    print("Edit ${product.title}");
                  } else if (value == "delete") {
                    print("Delete ${product.title}");
                  } else if (value == "out_of_stock") {
                    print("${product.title} marked as Out of Stock");
                  } else if (value == "in_stock") {
                    print("${product.title} marked as In Stock");
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
