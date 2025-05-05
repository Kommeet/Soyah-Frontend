import 'package:hive/hive.dart';

part 'cash_model.g.dart';
@HiveType(typeId: 0)
class CashData {
  @HiveField(1)
  final String key;
  @HiveField(2)
  final Object object;

  CashData({required this.key, required this.object});
}
