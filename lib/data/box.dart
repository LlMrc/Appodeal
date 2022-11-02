import 'package:hive/hive.dart';

import 'datahelper.dart';

class NoteBoxes {
  static Box<Note> getNotes() => Hive.box<Note>('notes');
}



class FavoriteBoxes {
  static Box<Favorite> getFav() => Hive.box<Favorite>('favorite');
}