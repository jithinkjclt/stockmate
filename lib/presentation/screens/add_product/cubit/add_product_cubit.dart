import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../data/models/product_modal.dart';

part 'add_product_state.dart';

class AddOrEditProductCubit extends Cubit<AddProductState> {
  final Product? product;

  AddOrEditProductCubit({this.product}) : super(AddProductInitial()) {
    if (product != null) {
      _initializeForEdit();
    }
  }

  final titleController = TextEditingController();
  final idController = TextEditingController();
  final descriptionController = TextEditingController();

  String? stockStatus;
  File? imageFile;
  String? existingImageUrl;
  String? documentId;

  void _initializeForEdit() {
    idController.text = product!.id;
    titleController.text = product!.title;
    descriptionController.text = product!.description;
    stockStatus = product!.isInStock ? "in stock" : "out of stock";
    existingImageUrl = product!.imageUrl;
    documentId = product!.documentId;
  }

  void stockStatusChanged(String value) {
    stockStatus = value;
    emit(AddProductInitial());
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      emit(AddProductInitial());
    }
  }

  Future<void> saveOrUpdateProduct() async {
    try {
      emit(AddProductLoading());

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(AddProductError("User not logged in"));
        return;
      }

      String? imageUrl = existingImageUrl;

      if (imageFile != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child("product_images")
            .child("${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg");

        await ref.putFile(imageFile!);
        imageUrl = await ref.getDownloadURL();
      }

      final newProduct = Product(
        id: idController.text.trim(),
        title: titleController.text.trim(),
        isInStock: stockStatus == "in stock",
        dateTime: documentId != null ? product!.dateTime : DateTime.now(),
        description: descriptionController.text.trim(),
        imageUrl: imageUrl ?? "",
        documentId: documentId,
      );

      final productsCollection = FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("products");

      if (documentId != null) {
        await productsCollection.doc(documentId).set(newProduct.toMap(), SetOptions(merge: true));
      } else {
        final docRef = await productsCollection.add(newProduct.toMap());
        documentId = docRef.id;
      }

      emit(AddProductSuccess());
    } catch (e) {
      emit(AddProductError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    titleController.dispose();
    idController.dispose();
    descriptionController.dispose();
    return super.close();
  }
}
