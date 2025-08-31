import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../../../../data/models/product_modal.dart';

part 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  InventoryCubit() : super(InventoryInitial());

  final _firestore = FirebaseFirestore.instance;

  String isSelected = "All";
  String searchQuery = "";

  void changeSelected(String value) {
    isSelected = value;
    emit(InventoryFilterChanged());
  }

  void changeSearchQuery(String query) {
    searchQuery = query.toLowerCase();
    emit(InventoryFilterChanged());
  }

  Stream<List<Product>> getProductsStream() {
    return _firestore.collectionGroup("products").snapshots().map((snapshot) {
      final allProducts = snapshot.docs
          .map((doc) => Product.fromMap(doc.data()))
          .toList();

      // Sort by dateTime descending
      allProducts.sort((a, b) => b.dateTime.compareTo(a.dateTime));

      List<Product> filtered = allProducts;
      if (isSelected == "In")
        filtered = filtered.where((p) => p.isInStock).toList();
      if (isSelected == "Out")
        filtered = filtered.where((p) => !p.isInStock).toList();
      if (searchQuery.isNotEmpty) {
        filtered = filtered
            .where((p) => p.title.toLowerCase().contains(searchQuery))
            .toList();
      }

      return filtered;
    });
  }

  Future<void> deleteProduct(String productId) async {
    try {
      final querySnapshot = await _firestore
          .collectionGroup("products")
          .where('id', isEqualTo: productId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();
        emit(InventoryFilterChanged()); // triggers UI rebuild
        print("Deleted product: $productId");
      } else {
        throw Exception("Product with ID $productId not found.");
      }
    } catch (e) {
      print("Delete failed: $e");
      rethrow;
    }
  }

  Future<void> updateStockStatus(String productId, bool newStatus) async {
    try {
      final querySnapshot = await _firestore
          .collectionGroup("products")
          .where('id', isEqualTo: productId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.update({
          'isInStock': newStatus,
        });
        emit(InventoryFilterChanged()); // triggers UI rebuild
        print("Updated stock for $productId → $newStatus");
      } else {
        throw Exception("Product with ID $productId not found.");
      }
    } catch (e) {
      print("Update stock failed: $e");
      rethrow;
    }
  }
}
