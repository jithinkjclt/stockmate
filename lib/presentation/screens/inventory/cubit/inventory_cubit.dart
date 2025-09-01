import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import '../../../../data/models/product_modal.dart';

part 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  InventoryCubit() : super(InventoryInitial());

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

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
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection("users")
        .doc(uid)
        .collection("products")
        .snapshots()
        .map((snapshot) {
      final allProducts = snapshot.docs
          .map((doc) => Product.fromMap(doc.data(), documentId: doc.id))
          .toList();

      allProducts.sort((a, b) => b.dateTime.compareTo(a.dateTime));

      List<Product> filtered = allProducts;
      if (isSelected == "In") {
        filtered = filtered.where((p) => p.isInStock).toList();
      }
      if (isSelected == "Out") {
        filtered = filtered.where((p) => !p.isInStock).toList();
      }
      if (searchQuery.isNotEmpty) {
        filtered = filtered
            .where((p) => p.title.toLowerCase().contains(searchQuery))
            .toList();
      }

      return filtered;
    });
  }

  Future<void> deleteProduct(String documentId) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw Exception("No user logged in");

      await _firestore
          .collection("users")
          .doc(uid)
          .collection("products")
          .doc(documentId)
          .delete();

      emit(InventoryFilterChanged());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateStockStatus(String documentId, bool newStatus) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw Exception("No user logged in");

      await _firestore
          .collection("users")
          .doc(uid)
          .collection("products")
          .doc(documentId)
          .update({'isInStock': newStatus});

      emit(InventoryFilterChanged());
    } catch (e) {
      rethrow;
    }
  }
}
