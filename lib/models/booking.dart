import 'package:hive/hive.dart';

part 'booking.g.dart';

@HiveType(typeId: 0)
class Booking extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String contact;

  @HiveField(2)
  DateTime startDate;

  @HiveField(3)
  DateTime endDate;

  @HiveField(4)
  List<String> venues;

  @HiveField(5)
  String advance;

  Booking({
    required this.name,
    required this.contact,
    required this.startDate,
    required this.endDate,
    required this.venues,
    required this.advance,
  });
}
