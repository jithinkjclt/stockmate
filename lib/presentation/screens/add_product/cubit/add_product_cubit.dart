import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../data/models/product_modal.dart';

part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit() : super(AddProductInitial());

  final titleController = TextEditingController();
  final idController = TextEditingController();
  final descriptionController = TextEditingController();

  String? stockStatus;
  File? imageFile;

  void stockStatusChanged(String value) {
    stockStatus = value;
    emit(AddProductInitial());
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      emit(AddProductInitial());
    }
  }

  Future<void> saveProduct() async {
    try {
      emit(AddProductLoading());

      if (idController.text.trim().isEmpty) {
        emit(AddProductError("Product ID cannot be empty"));
        return;
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(AddProductError("User not logged in"));
        return;
      }
      String? imageUrl = "";
      if (imageFile != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child("product_images")
            .child("${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg");

        await ref.putFile(imageFile!);
        imageUrl = await ref.getDownloadURL();
      }
      final product = Product(
        id: idController.text.trim(),
        title: titleController.text.trim(),
        isInStock: stockStatus == "in stock",
        dateTime: DateTime.now(),
        description: descriptionController.text.trim(),
        imageUrl: imageUrl,
      );
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("products")
          .add(product.toMap());

      emit(AddProductSuccess());
    } catch (e) {
      emit(AddProductError(e.toString()));
    }
  }
}
