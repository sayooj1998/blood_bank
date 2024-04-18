import 'package:blood_bank/add_person.dart';
import 'package:blood_bank/listController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ListController listController = Get.put(ListController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Center(child: const Text("Blood Donors")),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Person()),
          );
        },
      ),
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      InputChip(
                        label: const Text('All'),
                        onPressed: () async {
                          listController.filterGroup.value = 'All';
                          await listController.getDataFromHive();
                        },
                        backgroundColor:
                            listController.filterGroup.value == 'All'
                                ? Colors.blue
                                : Colors.grey[300],
                      ),
                      const SizedBox(width: 5),
                      InputChip(
                        label: const Text('A+'),
                        onPressed: () async {
                          listController.filterGroup.value = 'A+';
                          await listController.filterDonorListByBloodGroup(
                              listController.filterGroup.value);
                        },
                        backgroundColor:
                            listController.filterGroup.value == 'A+'
                                ? Colors.blue
                                : Colors.grey[300],
                      ),
                      const SizedBox(width: 5),
                      InputChip(
                        label: const Text('B+'),
                        onPressed: () async {
                          listController.filterGroup.value = 'B+';
                          await listController.filterDonorListByBloodGroup(
                              listController.filterGroup.value);
                        },
                        backgroundColor:
                            listController.filterGroup.value == 'B+'
                                ? Colors.blue
                                : Colors.grey[300],
                      ),
                      const SizedBox(width: 5),
                      InputChip(
                        label: const Text('AB+'),
                        onPressed: () async {
                          listController.filterGroup.value = 'AB+';
                          await listController.filterDonorListByBloodGroup(
                              listController.filterGroup.value);
                        },
                        backgroundColor:
                            listController.filterGroup.value == 'AB+'
                                ? Colors.blue
                                : Colors.grey[300],
                      ),
                      const SizedBox(width: 5),
                      InputChip(
                        label: const Text('O+'),
                        onPressed: () async {
                          listController.filterGroup.value = 'O+';
                          await listController.filterDonorListByBloodGroup(
                              listController.filterGroup.value);
                        },
                        backgroundColor:
                            listController.filterGroup.value == 'O+'
                                ? Colors.blue
                                : Colors.grey[300],
                      ),
                      const SizedBox(width: 5),
                      InputChip(
                        label: const Text('A-'),
                        onPressed: () async {
                          listController.filterGroup.value = 'A-';
                          await listController.filterDonorListByBloodGroup(
                              listController.filterGroup.value);
                        },
                        backgroundColor:
                            listController.filterGroup.value == 'A-'
                                ? Colors.blue
                                : Colors.grey[300],
                      ),
                      const SizedBox(width: 5),
                      InputChip(
                        label: const Text('B-'),
                        onPressed: () async {
                          listController.filterGroup.value = 'B-';
                          await listController.filterDonorListByBloodGroup(
                              listController.filterGroup.value);
                        },
                        backgroundColor:
                            listController.filterGroup.value == 'B-'
                                ? Colors.blue
                                : Colors.grey[300],
                      ),
                      const SizedBox(width: 5),
                      InputChip(
                        label: const Text('AB-'),
                        onPressed: () async {
                          listController.filterGroup.value = 'AB-';
                          await listController.filterDonorListByBloodGroup(
                              listController.filterGroup.value);
                        },
                        backgroundColor:
                            listController.filterGroup.value == 'AB-'
                                ? Colors.blue
                                : Colors.grey[300],
                      ),
                      const SizedBox(width: 5),
                      InputChip(
                        label: const Text('O-'),
                        onPressed: () async {
                          listController.filterGroup.value = 'O-';
                          await listController.filterDonorListByBloodGroup(
                              listController.filterGroup.value);
                        },
                        backgroundColor:
                            listController.filterGroup.value == 'O-'
                                ? Colors.blue
                                : Colors.grey[300],
                      ),
                    ],
                  )),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 15),
                itemCount: listController.donorList.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = listController.donorList[index];
                  print('item.imageData ${item.imageData}');
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: screenWidth * 0.9,
                    // color: Colors.red[200],
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.red[200]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            item.imageData?.isNotEmpty == true
                                ? CircleAvatar(
                                    radius: 43, // half of the diameter
                                    backgroundImage:
                                        MemoryImage(item.imageData!),
                                  )
                                : CircleAvatar(
                                    radius: 43, // half of the diameter
                                    backgroundImage:
                                        AssetImage('assets/images/avatar.png'),
                                  ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SelectableText(
                              item.name.capitalize!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 15),
                            SelectableText(item.phone)
                          ],
                        ),
                        Column(
                          children: [
                            Text(item.group.capitalize!,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            IconButton(
                                onPressed: () async {
                                  await listController
                                      .makePhoneCall(item.phone);
                                },
                                icon: const Icon(Icons.call)),
                            // IconButton(
                            //     onPressed: () async {
                            //       await listController
                            //           .launchWhatsApp(item.phone);
                            //     },
                            //     icon: Icon(Icons.message))
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
