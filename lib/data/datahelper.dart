import 'package:hive/hive.dart';
part 'datahelper.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject{
  @HiveField(0)
  late String title;
  @HiveField(1)
  late String description;
  @HiveField(2)
  late DateTime createdDate;
}

@HiveType(typeId: 1)
class Favorite extends HiveObject {

  @HiveField(0)
  late String favoriteFile;
}
