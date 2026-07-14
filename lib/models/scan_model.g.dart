// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScanModelAdapter extends TypeAdapter<ScanModel> {
  @override
  final int typeId = 0;

  @override
  ScanModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScanModel(
      barcode: fields[0] as String,
      productName: fields[1] as String?,
      supermarket: fields[2] as String?,
      price: fields[3] as double?,
      createdAt: fields[4] as DateTime?,
      synced: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ScanModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.barcode)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.supermarket)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.synced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScanModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
