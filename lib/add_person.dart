import 'dart:io';

import 'package:blood_bank/controller.dart';
import 'package:blood_bank/internetCheckController.dart';
import 'package:blood_bank/listController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Person extends StatelessWidget {
  Person({Key? key}) : super(key: key);
  DetailsController controller = Get.put(DetailsController());
  ListController listController = Get.put(ListController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController groupController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final InternetCheck internetCheck = Get.put(InternetCheck());
  final FlutterContactPicker _contactPicker = FlutterContactPicker();

  final List<String> bloodGroups = [
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
    "O+",
    "O-",
  ];

  File? imageFile;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text('Enter Details'),
        ),
        body: controller.isLoading.value
            ? Center(
                child: LoadingAnimationWidget.dotsTriangle(
                  color: Colors.red,
                  size: 200,
                ),
              )
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
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
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
                          decoration: InputDecoration(
                            labelText: 'Blood Group',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Blood Group';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: controller.selectedBloodGroup.value,
                          decoration: InputDecoration(
                            labelText: 'Select Blood Group',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (String? newBloodGroup) {
                            controller.selectedBloodGroup.value =
                                newBloodGroup!;
                            groupController.text = newBloodGroup;
                          },
                          items: bloodGroups
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                        TextButton(
                          onPressed: () async {
                            List<String>? _contacts;
                            Contact? contact =
                                await _contactPicker.selectContact();
                            _contacts =
                                contact == null ? null : contact.phoneNumbers;
                            if (_contacts != null) {
                              phoneController.text = _contacts[0].toString();
                            }
                          },
                          child: Text('Pick Contact'),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            ClipOval(
                              child: SizedBox(
                                width: 120,
                                height: 120,
                                child: FittedBox(
                                  fit: BoxFit.cover,
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
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("NO Internet!..."),
                                      backgroundColor: Colors.red,
                                    ),
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
