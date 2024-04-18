import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'hivedonor.g.dart'; // This should point to the generated part file

@HiveType(typeId: 0)
class Donor {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String group;

  @HiveField(2)
  late String phone;

  @HiveField(3)
  late Uint8List? imageData;

  @HiveField(4)
  late String? date;
  // @HiveField(5)
  // late String id;
  Donor({
    required this.name,
    required this.group,
    required this.phone,
    // required this.id,
    this.date,
    this.imageData,
  });
}
