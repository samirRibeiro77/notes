import 'package:notes/helper/notesHelper.dart';

class Note {
  int? id;
  late String title, description, createOn;

  Note(this.title, this.description) {
    createOn = DateTime.now().toString();
  }


  Note.fromMap(Map map) {
    id = map[NotesHelper.columnId];
    title = map[NotesHelper.columnTitle];
    description = map[NotesHelper.columnDescription];
    createOn = map[NotesHelper.columnCreatedOn];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      NotesHelper.columnTitle: title,
      NotesHelper.columnDescription: description,
      NotesHelper.columnCreatedOn: createOn
    };

    if(id != null) {
      map[NotesHelper.columnId] = id;
    }

    return map;
  }
}