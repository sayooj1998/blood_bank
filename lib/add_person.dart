import 'dart:io';

import 'package:blood_bank/controller.dart';
import 'package:blood_bank/internetCheckController.dart';
import 'package:blood_bank/listController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Person extends StatelessWidget {
  Person({super.key});
  DetailsController controller = Get.put(DetailsController());
  ListController listController = Get.put(ListController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController groupController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final InternetCheck internetCheck = Get.put(InternetCheck());
  File? imageFile;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text('Enter Details'),
        ),
        body: controller.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                          // keyboardType: TextInputType.number, // Only numbers
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: groupController,
                          decoration:
                              const InputDecoration(labelText: 'Blood Group'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Blood Group';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: phoneController,
                          decoration: const InputDecoration(labelText: 'Phone'),
                          keyboardType: TextInputType.number, // Only numbers
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            ClipOval(
                              child: SizedBox(
                                width: 120,
                                height: 120,
                                child: FittedBox(
                                  fit: BoxFit
                                      .cover, // Choose your desired BoxFit
                                  child: controller.selectedImage?.value != null
                                      ? Image.file(
                                          controller.selectedImage!.value!)
                                      : Image.asset(
                                          'assets/images/avatar.png',
                                        ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                imageFile = await controller.pickProfileImage();
                              },
                              child: const Text("Upload Image"),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (await ConnectivityWrapper
                                    .instance.isConnected) {
                                  controller.isLoading.value = true;

                                  print('internet');
                                  await controller.uploadImage(imageFile);

                                  Map<String, dynamic> dataToSave;
                                  if (controller.url != null) {
                                    dataToSave = {
                                      "name": nameController.text,
                                      "phone": phoneController.text,
                                      "group":
                                          groupController.text.toUpperCase(),
                                      "image": controller.url!.value
                                    };
                                  } else {
                                    dataToSave = {
                                      "name": nameController.text,
                                      "phone": phoneController.text,
                                      "group":
                                          groupController.text.toUpperCase(),
                                    };
                                  }
                                  await FirebaseFirestore.instance
                                      .collection('donor_details')
                                      .add(dataToSave);
                                  await controller
                                      .getDataFromFirebaseAndSaveToHive();
                                  await listController.getDataFromHive();

                                  // internetCheck.newDonorAddSnackbar();
                                  controller.isLoading.value = false;
                                } else {
                                  print('no  internet');
                                  SnackBar(
                                    content: Text("NO Internet!..."),
                                    backgroundColor: Colors.red,
                                  );
                                }
                                // await controller.getDataFromFirebaseAndSaveToHive();
                                nameController.clear();
                                groupController.clear();
                                phoneController.clear();
                                controller.clearUrl();

                                controller.selectedImage.value = null;
                              }
                            },
                            child: const Text('Save'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
