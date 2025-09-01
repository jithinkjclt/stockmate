import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockmate/core/utils/margin_text.dart';
import 'package:stockmate/presentation/screens/detail_page/detail_page.dart';
import 'package:stockmate/presentation/screens/inventory/cubit/inventory_cubit.dart';
import 'package:stockmate/presentation/screens/inventory/widget/filter_tile.dart';
import 'package:stockmate/presentation/screens/inventory/widget/product_tile.dart';
import 'package:stockmate/presentation/screens/inventory/widget/shimmer.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/page_navigation.dart';
import '../../../data/models/product_modal.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/search_fild.dart';
import '../../widgets/snackbar.dart';
import '../add_product/add_prodcut_screen.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InventoryCubit(),
      child: BlocBuilder<InventoryCubit, InventoryState>(
        builder: (context, state) {
          final cubit = context.read<InventoryCubit>();

          return Column(
            children: [
              SearchField(
                width: context.deviceSize.width / 1.1,
                height: context.deviceSize.height / 15,
                hintText: 'Search Product',
                suffixIcon: Icons.search,
                onChanged: (value) {
                  cubit.changeSearchQuery(value);
                },
              ),
              15.hBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FilterTile(
                    isSelected: cubit.isSelected == "All",
                    label: "All Products",
                    onTap: () => cubit.changeSelected('All'),
                  ),
                  FilterTile(
                    label: "In Stock",
                    isSelected: cubit.isSelected == "In",
                    onTap: () => cubit.changeSelected('In'),
                  ),
                  FilterTile(
                    label: "Out of Stock",
                    isSelected: cubit.isSelected == "Out",
                    onTap: () => cubit.changeSelected('Out'),
                  ),
                ],
              ),
              15.hBox,
              Expanded(
                child: StreamBuilder<List<Product>>(
                  stream: cubit.getProductsStream(),
                  builder: (context, snapshot) {
                    final products = snapshot.data ?? [];

                    if (snapshot.connectionState == ConnectionState.waiting &&
                        products.isEmpty) {
                      return ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) =>
                            const ProductTileSkeleton(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    }

                    if (products.isEmpty) {
                      return const Center(child: Text("No products found"));
                    }

                    return ListView.builder(
                      itemCount: products.length,
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
                                      message: "${product.title} → In Stock",
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
                    );
                  },
                ),
              ),
              25.hBox,
              CustomButton(
                width: double.infinity,
                boxColor: primaryColor,
                onTap: () {
                  Screen.open(
                    context,
                    AddOrEditProductScreen(),
                    begin: const Offset(0, 1),
                    curve: Curves.easeInOutCirc,
                  );
                },
                text: 'Add Product',
              ),
            ],
          );
        },
      ),
    );
  }
}
