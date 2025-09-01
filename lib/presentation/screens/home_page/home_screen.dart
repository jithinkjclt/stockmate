import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockmate/core/utils/margin_text.dart';
import 'package:stockmate/core/utils/page_navigation.dart';
import 'package:stockmate/presentation/screens/detail_page/detail_page.dart';
import 'package:stockmate/presentation/screens/home_page/widget/order_tile.dart';
import 'package:stockmate/presentation/screens/inventory/cubit/inventory_cubit.dart';
import 'package:stockmate/presentation/screens/inventory/widget/product_tile.dart';
import 'package:stockmate/presentation/widgets/custom_apptext.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/product_modal.dart';
import '../../widgets/snackbar.dart';
import '../add_product/add_prodcut_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InventoryCubit(),
      child: BlocBuilder<InventoryCubit, InventoryState>(
        builder: (context, state) {
          final cubit = context.read<InventoryCubit>();
          return StreamBuilder<List<Product>>(
            stream: cubit.getProductsStream(),
            builder: (context, snapshot) {
              final products = snapshot.data ?? [];
              final int inStock = products.where((p) => p.isInStock).length;
              final int outOfStock = products.where((p) => !p.isInStock).length;

              final Map<String, double> dataMap = {
                "In Stock": inStock.toDouble(),
                "Out of Stock": outOfStock.toDouble(),
              };

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      "Welcome to User",
                      size: 18,
                      weight: FontWeight.bold,
                    ),
                    25.hBox,
                    inStock + outOfStock <= 0
                        ? SizedBox()
                        : Center(
                            child: SizedBox(
                              height: 200,
                              child: PieChart(
                                dataMap: dataMap,
                                chartType: ChartType.disc,
                                baseChartColor: Colors.grey[200]!,
                                colorList: [
                                  primaryColor,
                                  const Color(0xffff8a8a),
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
                                chartRadius:
                                    MediaQuery.of(context).size.width / 2.5,
                                ringStrokeWidth: 30,
                              ),
                            ),
                          ),
                    Row(
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
                    25.hBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OrderTile(
                          icon: Icons.list_alt,
                          count: inStock,
                          text: "In Stock     ",
                          backGroundColor: const Color(0xfff7fbff),
                          boxShadow: const Color(0xff6dbaf2),
                        ),
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
                    Row(
                      children: [
                        AppText(
                          "Recently added",
                          color: greyFormColor,
                          size: 15,
                        ),
                        Spacer(),
                      ],
                    ),
                    products.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: AppText(
                                "No products available",
                                size: 16,
                                color: Colors.grey,
                                weight: FontWeight.w500,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: products.length > 3
                                ? 3
                                : products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return InkWell(
                                onTap: () {
                                  Screen.open(
                                    context,
                                    ProductDetailScreen(product: product),
                                  );
                                },
                                child: ProductTile(
                                  addedTime: product.formattedDateTime,
                                  imageUrl: product.imageUrl,
                                  title: product.title,
                                  productId: product.id,
                                  isInStock: product.isInStock,
                                  onOptionSelected: (value) async {
                                    try {
                                      switch (value) {
                                        case "edit":
                                          await Screen.open(
                                            context,
                                            AddOrEditProductScreen(
                                              product: product,
                                            ),
                                            begin: const Offset(1, 1),
                                            curve: Curves.easeInOutCirc,
                                          );
                                          break;
                                        case "delete":
                                          await cubit.deleteProduct(product.id);
                                          ShowCustomSnackbar.success(
                                            context,
                                            message: "${product.title} deleted",
                                          );
                                          break;
                                        case "out_of_stock":
                                          await cubit.updateStockStatus(
                                            product.id,
                                            false,
                                          );
                                          ShowCustomSnackbar.warning(
                                            context,
                                            message:
                                                "${product.title} → Out of Stock",
                                          );
                                          break;
                                        case "in_stock":
                                          await cubit.updateStockStatus(
                                            product.id,
                                            true,
                                          );
                                          ShowCustomSnackbar.success(
                                            context,
                                            message:
                                                "${product.title} → In Stock",
                                          );
                                          break;
                                      }
                                    } catch (e) {
                                      ShowCustomSnackbar.error(
                                        context,
                                        message: "Error: $e",
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
