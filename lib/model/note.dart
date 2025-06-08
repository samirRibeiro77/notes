import 'package:intl/intl.dart';
import 'package:notes/helper/notesHelper.dart';

class Note {
  int? id;
  late String title, description;
  late DateTime _createOn;

  Note(this.title, this.description) {
    _createOn = DateTime.now();
  }

  Note.fromMap(Map map) {
    id = map[NotesHelper.columnId];
    title = map[NotesHelper.columnTitle];
    description = map[NotesHelper.columnDescription];
    _createOn = DateTime.parse(map[NotesHelper.columnCreatedOn]);
  }

  String get createOn => DateFormat("dd/MM/y H:m").format(_createOn);

  void update({String? title, String? description}) {
    if (title != null) this.title = title;
    if (description != null) this.description = description;
    _createOn = DateTime.now();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      NotesHelper.columnTitle: title,
      NotesHelper.columnDescription: description,
      NotesHelper.columnCreatedOn: _createOn.toString(),
    };

    if (id != null) {
      map[NotesHelper.columnId] = id;
    }

    return map;
  }
}
