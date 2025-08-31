import 'package:flutter/material.dart';
import 'package:stockmate/core/constants/colors.dart';
import 'package:stockmate/core/utils/margin_text.dart';
import 'package:stockmate/presentation/widgets/custom_apptext.dart';
import 'package:stockmate/presentation/widgets/custom_textfield.dart';
import 'package:stockmate/presentation/widgets/custom_button.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        title: const AppText(
          'Add Product',
          size: 18,
          weight: FontWeight.w700,
          color: blackText,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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

              const CustomTextField(
                width: double.infinity,
                boxname: 'Product ID',
                hintText: 'Enter Product ID',
              ),

              10.hBox,

              const CustomTextField(
                width: double.infinity,
                boxname: 'Product Title',
                hintText: 'Enter Product Title',
              ),

              10.hBox,

              const CustomTextField(
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
                    value: null,
                    hint: const AppText("Select Stock Status", size: 12),
                    items: const [
                      DropdownMenuItem(
                        value: "in",
                        child: Row(
                          children: [
                            Icon(Icons.check, size: 16, color: Colors.green),
                            SizedBox(width: 6),
                            AppText("In Stock", size: 12),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: "out",
                        child: Row(
                          children: [
                            Icon(Icons.close, size: 16, color: Colors.red),
                            SizedBox(width: 6),
                            AppText("Out of Stock", size: 12),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (_) {},
                    isExpanded: true,
                  ),
                ),
              ),
              15.hBox,

              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                ),
              ),

              25.hBox,

              CustomButton(
                onTap: () {},
                text: "Save Product",
                boxColor: primaryColor,
                borderRadius: 10,
                width: double.infinity,
                height: 50,
                fontSize: 14,
                weight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
