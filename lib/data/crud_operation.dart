import 'package:odessa/data/box.dart';
import 'datahelper.dart';

Future addNoteToBox(String title, String description) async {
  final note = Note()
    ..createdDate = DateTime.now()
    ..description = description
    ..title = title;

  final box = NoteBoxes.getNotes();
  box.add(note);
}

Future addFavorite(String file) async {
  final note = Favorite()..favoriteFile = file;
  final box = FavoriteBoxes.getFav();
  box.add(note);
}

void editNote(Note note, String title, String desc) {
  note.description = desc;
  note.title = title;
  note.save();
}
