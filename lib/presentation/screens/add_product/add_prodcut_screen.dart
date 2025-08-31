import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockmate/core/constants/colors.dart';
import 'package:stockmate/core/utils/margin_text.dart';
import 'package:stockmate/data/models/product_modal.dart'; // Import your Product model
import 'package:stockmate/presentation/screens/add_product/cubit/add_product_cubit.dart';
import 'package:stockmate/presentation/widgets/custom_apptext.dart';
import 'package:stockmate/presentation/widgets/custom_textfield.dart';
import 'package:stockmate/presentation/widgets/custom_button.dart';
import '../../widgets/snackbar.dart';

class AddOrEditProductScreen extends StatelessWidget {
  final Product? product;
  final String? documentId;

  const AddOrEditProductScreen({
    super.key,
    this.product,
    this.documentId,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEditMode = product != null;
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        backgroundColor: colorWhite,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: lightBlackColor,
          ),
        ),
        title: AppText(
          isEditMode ? 'Edit Product' : 'Add Product',
          size: 18,
          weight: FontWeight.w700,
          color: blackText,
        ),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => AddOrEditProductCubit(product: product),
        child: BlocConsumer<AddOrEditProductCubit, AddProductState>(
          listener: (context, state) {
            if (state is AddProductError) {
              ShowCustomSnackbar.error(context, message: state.message);
            } else if (state is AddProductSuccess) {
              ShowCustomSnackbar.success(
                context,
                // Dynamic success message
                message: isEditMode
                    ? "Product updated successfully"
                    : "Product added successfully",
              );
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            final cubit = context.read<AddOrEditProductCubit>();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppText(
                      'Product Details',
                      size: 16,
                      weight: FontWeight.w500,
                    ),
                    12.hBox,
                    CustomTextField(
                      controller: cubit.idController,
                      width: double.infinity,
                      boxname: 'Product ID',
                      hintText: 'Enter Product ID',
                    ),
                    10.hBox,
                    CustomTextField(
                      controller: cubit.titleController,
                      width: double.infinity,
                      boxname: 'Product Title',
                      hintText: 'Enter Product Title',
                    ),
                    10.hBox,
                    CustomTextField(
                      controller: cubit.descriptionController,
                      width: double.infinity,
                      boxname: 'Description',
                      hintText: 'Enter Description',
                    ),
                    10.hBox,
                    const AppText(
                      'Stock Status',
                      size: 12,
                      weight: FontWeight.w500,
                      color: greyFormColor,
                    ),
                    6.hBox,
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          // Use cubit's value directly
                          value: cubit.stockStatus,
                          hint: const AppText("Select Stock Status", size: 12),
                          items: const [
                            DropdownMenuItem(
                              value: "in stock",
                              child: Row(
                                children: [
                                  Icon(Icons.check, size: 16, color: Colors.green),
                                  SizedBox(width: 6),
                                  AppText("In Stock", size: 12),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: "out of stock",
                              child: Row(
                                children: [
                                  Icon(Icons.close, size: 16, color: Colors.red),
                                  SizedBox(width: 6),
                                  AppText("Out of Stock", size: 12),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              cubit.stockStatusChanged(value);
                            }
                          },
                          isExpanded: true,
                        ),
                      ),
                    ),
                    15.hBox,
                    const AppText(
                      ' Choose Image (optional)',
                      size: 12,
                      weight: FontWeight.w500,
                      color: greyFormColor,
                    ),
                    6.hBox,
                    InkWell(
                      onTap: () {
                        cubit.pickImage();
                      },
                      child: Container(
                        height: 200, // Increased height for better view
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: cubit.imageFile != null
                              ? Image.file(
                            cubit.imageFile!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                              : (cubit.existingImageUrl != null &&
                              cubit.existingImageUrl!.isNotEmpty)
                              ? Image.network(
                            cubit.existingImageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                              : const Icon(
                            Icons.add_a_photo,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    25.hBox,
                    CustomButton(
                      isLoading: state is AddProductLoading,
                      onTap: () {
                        if (cubit.idController.text.trim().isEmpty) {
                          ShowCustomSnackbar.warning(context, message: "Product ID is required");
                          return;
                        }
                        if (cubit.titleController.text.trim().isEmpty) {
                          ShowCustomSnackbar.warning(context, message: "Product Title is required");
                          return;
                        }
                        if (cubit.descriptionController.text.trim().isEmpty) {
                          ShowCustomSnackbar.warning(context, message: "Description is required");
                          return;
                        }
                        if (cubit.stockStatus == null) {
                          ShowCustomSnackbar.warning(context, message: "Please select Stock Status");
                          return;
                        }
                        cubit.saveOrUpdateProduct(
                          isEdit: isEditMode,
                          documentId: documentId,
                        );
                      },
                      text: isEditMode ? "Update Product" : "Save Product",
                      boxColor: primaryColor,
                      borderRadius: 10,
                      width: double.infinity,
                      height: 50,
                      fontSize: 14,
                      weight: FontWeight.w600,
                    ),
                    20.hBox,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}