import 'package:blood_bank/controller.dart';
import 'package:blood_bank/firebase_options.dart';
import 'package:blood_bank/hivedonor.dart';
import 'package:blood_bank/home.dart';
import 'package:blood_bank/internetCheckController.dart';
import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(DonorAdapter());
  await Hive.openBox<Donor>('donorbox');
  final DetailsController detailsController = Get.put(DetailsController());
  final InternetCheck internetCheck = Get.put(InternetCheck());

  if (await ConnectivityWrapper.instance.isConnected) {
    await detailsController.getDataFromFirebaseAndSaveToHive();
  } else {
    internetCheck.noInternetSnackbar();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
