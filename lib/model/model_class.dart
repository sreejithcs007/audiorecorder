import 'package:hive/hive.dart';
part 'model_class.g.dart';

@HiveType(typeId: 1)
class Modelclasss{
  @HiveField(0)
  final String? name;
  @HiveField(1)
  final String? location;
  @HiveField(2)
  final String? date;


  Modelclasss({required this.name,required this.location,required this.date, });
}