import 'package:flutter/material.dart';
import '../../../widgets/custom_apptext.dart';

class ProductStockBadge extends StatelessWidget {
  final bool isInStock;
  const ProductStockBadge({super.key, required this.isInStock});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isInStock ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: AppText(
        isInStock ? "In Stock" : "Out of Stock",
        color: isInStock ? Colors.green : Colors.red,
        weight: FontWeight.bold,
      ),
    );
  }
}
