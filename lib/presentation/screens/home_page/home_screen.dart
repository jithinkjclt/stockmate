import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stockmate/core/utils/margin_text.dart';
import 'package:stockmate/presentation/screens/home_page/widget/order_tile.dart';
import 'package:stockmate/presentation/widgets/custom_apptext.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../../core/constants/colors.dart';
import '../../../data/models/product_modal.dart';
import '../inventory/widget/product_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
    ];

    final int inStock = 70;
    final int outOfStock = 30;

    final Map<String, double> dataMap = {
      "In Stock": inStock.toDouble(),
      "Out of Stock": outOfStock.toDouble(),
    };

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText("Welcome to User", size: 18, weight: FontWeight.bold),
          25.hBox,

          Stack(
            children: [
              Center(
                child: Container(
                  height: 200,
                  child: PieChart(
                    dataMap: dataMap,
                    chartType: ChartType.disc,
                    baseChartColor: Colors.grey[200]!,
                    colorList: [
                      const Color(0xff6dbaf2), // Blue
                      const Color(0xffff8a8a), // Red
                    ],
                    chartValuesOptions: const ChartValuesOptions(

                      showChartValuesInPercentage: true,
                      showChartValuesOutside: true,
                      chartValueStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    legendOptions: const LegendOptions(
                      legendPosition: LegendPosition.right,
                      showLegends: true,
                      legendTextStyle: TextStyle(fontSize: 14),
                    ),
                    chartRadius: MediaQuery.of(context).size.width / 2.5,
                    ringStrokeWidth: 30,
                  ),
                ),
              ),
              Positioned(
                left: 100,
                top: 130,
                child: Row(
                  children: [
                    75.wBox,
                    OrderTile(
                      boxShadow: const Color(0xFF3bc288),
                      backGroundColor: const Color(0xFFF4FFFA),
                      text: "Total Products",
                      count: inStock + outOfStock,
                      icon: Icons.sell,
                    ),
                  ],
                ),
              ),

            ],
          ),
          25.hBox,
          Row(
            children: [
              OrderTile(
                icon: Icons.list_alt,
                count: inStock,
                text: "In Stock",
                backGroundColor: const Color(0xfff7fbff),
                boxShadow: const Color(0xff6dbaf2),
              ),
              const Spacer(),
              OrderTile(
                icon: Icons.inventory_2,
                count: outOfStock,
                text: "Out of Stock",
                backGroundColor: const Color(0xfffef6f6),
                boxShadow: const Color(0xffff8a8a),
              ),
            ],
          ),

          25.hBox,

          AppText("Recenlty added", color: greyFormColor, size: 15),

          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
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
        ],
      ),
    );
  }
}
