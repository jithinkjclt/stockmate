import 'package:flutter/material.dart';
import 'package:stockmate/presentation/screens/detail_page/widget/product_image.dart';
import 'package:stockmate/presentation/screens/detail_page/widget/product_stock_badge.dart';
import '../../../core/utils/export_service.dart';
import '../../../data/models/product_modal.dart';
import '../../../core/constants/colors.dart';
import '../../widgets/custom_apptext.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _exporting = false;

  Future<void> _showExportOptions() async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(title: Text('Export Report')),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: const Text('Generate PDF'),
                onTap: () async {
                  Navigator.pop(context);
                  setState(() => _exporting = true);
                  await ExportService.exportPdf(widget.product);
                  setState(() => _exporting = false);
                },
              ),
              ListTile(
                leading: const Icon(Icons.table_chart),
                title: const Text('Generate CSV'),
                onTap: () async {
                  Navigator.pop(context);
                  setState(() => _exporting = true);
                  await ExportService.exportCsv(widget.product);
                  setState(() => _exporting = false);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

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
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: lightBlackColor),
            onPressed: _showExportOptions,
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductImage(imageUrl: product.imageUrl),
                const SizedBox(height: 16),
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
                ProductStockBadge(isInStock: product.isInStock),
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
          if (_exporting)
            Container(
              color: Colors.black.withOpacity(0.15),
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text('Generating…'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
