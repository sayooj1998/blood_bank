import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:blood_bank/hivedonor.dart';
import 'package:url_launcher/url_launcher.dart'; // Import your Donor model

class ListController extends GetxController {
  RxList<Donor> donorList = <Donor>[].obs;
  RxString filterGroup = 'All'.obs;
  @override
  void onInit() async {
    super.onInit();
    await getDataFromHive();
  }

  Future<void> getDataFromHive() async {
    try {
      // Open Hive box
      var box = Hive.box<Donor>('donorbox');
      // Retrieve all items from the box
      List<dynamic> items = box.values.toList();

      // Convert items to List<Donor>
      List<Donor> fetchedDonorList = items.cast<Donor>();

      // Update donorList with fetched data

      donorList.assignAll(fetchedDonorList);

// Add debugging statements to check the length of donorList after the operation
      print("donorList length: ${donorList.length}");

      // Close the box
    } catch (error) {
      print('Error retrieving data from Hive: $error');
      // Handle error appropriately, e.g., show error message to user
    }
  }

  Future<void> filterDonorListByBloodGroup(String bloodGroup) async {
    // Implement asynchronous filtering logic based on blood group
    await getDataFromHive();
    List<Donor> filteredList =
        donorList.where((donor) => donor.group == bloodGroup).toList();

    // Simulate an asynchronous operation (e.g., fetching data from an API)
    // await Future.delayed(Duration(seconds: 1));

    // Assign filtered list to the original donorList
    donorList.clear();
    donorList.addAll(filteredList);
    print('success');
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> launchWhatsApp(String phoneNumber) async {
    try {
      String url = "whatsapp://send?phone=" + phoneNumber + "&text='Hello'";
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      // Handle any errors here
      print('Error launching WhatsApp: $e');
    }
  }
}
