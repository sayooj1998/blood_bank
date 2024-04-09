// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hivedonor.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DonorAdapter extends TypeAdapter<Donor> {
  @override
  final int typeId = 0;

  @override
  Donor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Donor(
      name: fields[0] as String,
      group: fields[1] as String,
      phone: fields[2] as String,
      date: fields[4] as String?,
      imageData: fields[3] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, Donor obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.group)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.imageData)
      ..writeByte(4)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DonorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
