import 'package:hive/hive.dart';

part 'scan_model.g.dart';

@HiveType(typeId: 0)
class ScanModel extends HiveObject {
  @HiveField(0)
  late String barcode;

  @HiveField(1)
  late String? productName;

  @HiveField(2)
  late String? supermarket;

  @HiveField(3)
  late double? price;

  @HiveField(4)
  late DateTime createdAt;

  @HiveField(5)
  late bool synced;

  ScanModel({
    required this.barcode,
    this.productName,
    this.supermarket,
    this.price,
    DateTime? createdAt,
    this.synced = false,
  }) : createdAt = createdAt ?? DateTime.now();
}
