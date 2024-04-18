import 'dart:io';
import 'dart:typed_data';

import 'package:blood_bank/hivedonor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsController extends GetxController {
  RxString? url = ''.obs;
  RxString selectedBloodGroup = 'A+'.obs;
  RxBool isLoading = false.obs;
  final selectedImage = Rxn<File>();
  RxString contacts = ''.obs;
  File? get selectedProfile => selectedImage.value;

  Future<File?> pickProfileImage() async {
    final profilePic = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 200,
      maxHeight: 200,
      imageQuality: 100,
    );

    if (profilePic != null) {
      selectedImage.value = File(profilePic.path);
      return selectedImage.value;
    }
  }

  Future<void> uploadImage(File? imageFile) async {
    url = null;
    try {
      if (imageFile == null) {
        // Handle the case where imageFile is null
        return null;
      }
      FirebaseStorage storage = FirebaseStorage.instance;

      Reference ref =
          storage.ref().child("images/${DateTime.now().toString()}");
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      final bytes = await ref.getData();
      print('byte image ${bytes}');
      url = RxString(downloadUrl); // Convert String to RxString
      print(url?.value); // Accessing the value of RxString
    } catch (e) {
      print(e.toString());
    }
  }

  void clearUrl() {
    url = null;
  }

  Future<Uint8List> getImageBytes(String imagePath) async {
    ByteData data = await rootBundle.load(imagePath);
    return data.buffer.asUint8List();
  }

  Future<void> getDataFromFirebaseAndSaveToHive() async {
    print('reach here');
    try {
      // Retrieve data from Firebase Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('donor_details').get();
      // String imagePath = 'assets/images/avatar.png';
      // Uint8List? defaultBytes = await getImageBytes(imagePath);
      // Open Hive box
      var box = await Hive.openBox<Donor>('donorbox');
      await box.clear();
      // Convert Firestore data to Hive objects and save to Hive
      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in querySnapshot.docs) {
        try {
          // Extract data from Firestore document
          try {
            String name = document['name'];
            String group = document['group'];
            String phone = document['phone'];
            String? image = document['image'];
            String id = document.id;
            Uint8List? bytes;
            // Check if image field exists and if it contains a valid URL
            if (image != null &&
                (image.startsWith('gs://') || image.startsWith('http'))) {
              final FirebaseStorage storage = FirebaseStorage.instance;
              final Reference ref = storage.refFromURL(image);
              bytes = await ref.getData();
            } else {
              // bytes = defaultBytes;
            }
            // Create Donor object
            Donor myData = Donor(
              // id: id,
              name: name,
              group: group,
              phone: phone,
              imageData: bytes,
            );
            // Add Donor object to Hive box
            await box.add(myData);
          } catch (e) {
            String name = document['name'];
            String group = document['group'];
            String phone = document['phone'];
            String id = document.id;
            // String? image = document['image'];
            // // Uint8List? bytes;
            // // Check if image field exists and if it contains a valid URL
            // if (image != null &&
            //     (image.startsWith('gs://') || image.startsWith('http'))) {
            //   final FirebaseStorage storage = FirebaseStorage.instance;
            //   final Reference ref = storage.refFromURL(image);
            //   bytes = await ref.getData();
            // } else {
            //   // bytes = defaultBytes;
            // }
            // Create Donor object
            Donor myData = Donor(
              // id: id,
              name: name,
              group: group,
              phone: phone,
              // imageData: bytes,
            );
            // Add Donor object to Hive box
            await box.add(myData);
          }
        } catch (error) {
          print('Error processing document: $error');
          // Handle error for individual document processing, e.g., skip document
        }
      }
    } catch (error) {
      print('Error fetching data from Firebase and saving to Hive: $error');
      // Handle error appropriately, e.g., show error message to user
    }
  }
}
