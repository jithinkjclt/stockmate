import 'package:flutter/material.dart';
import '../../../data/models/product_modal.dart';
import '../../../core/constants/colors.dart'; // adjust path where your colors are
import '../../widgets/custom_apptext.dart'; // adjust path where AppText is

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorWhite,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: lightBlackColor,
          ),
        ),
        title: const AppText(
          'Product Detail',
          size: 18,
          weight: FontWeight.w700,
          color: blackText,
        ),
        centerTitle: true,
        actions: const [
          Icon(Icons.more_vert, color: lightBlackColor),
          SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.broken_image,
                      size: 60,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Product ID
            AppText(
              "ID: ${product.id}",
              weight: FontWeight.w500,
              color: blackText,
            ),
            const SizedBox(height: 8),
            AppText(
              product.title,
              size: 20,
              weight: FontWeight.bold,
              color: blackText,
            ),

            const SizedBox(height: 8),
            AppText(product.description, color: lightBlackColor),

            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: product.isInStock
                    ? Colors.green.shade100
                    : Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: AppText(
                product.isInStock ? "In Stock" : "Out of Stock",
                color: product.isInStock ? Colors.green : Colors.red,
                weight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  "Date: ${product.formattedDate}",
                  color: lightBlackColor,
                ),
                AppText(
                  "Time: ${product.formattedTime}",
                  color: lightBlackColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
