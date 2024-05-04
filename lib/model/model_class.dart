import 'package:hive/hive.dart';
part 'model_class.g.dart';

@HiveType(typeId: 1)
class Modelclasss{
  @HiveField(0)
  String key;
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final String? location;
  @HiveField(3)
  final String? date;


  Modelclasss({required this.name,required this.location,required this.date,required this.key });
}