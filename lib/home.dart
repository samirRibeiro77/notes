import 'package:flutter/material.dart';
import 'package:notes/helper/notesHelper.dart';
import 'package:notes/model/note.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.appName});

  final String appName;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  var _db = NotesHelper();
  List<Note> _notes = [];

  _showDialogNotes({Note? note}) {
    var title = "Create a new note";
    var button = "Save";
    if(note != null){
      title = "Update note";
      button = "Update";
      _titleController.text = note.title;
      _descriptionController.text = note.description;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Title",
                  hintText: "Type the title...",
                ),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  hintText: "Type the description...",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: (){
                _clearTextfields();
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _saveNote(note: note);
                Navigator.pop(context);
              },
              child: Text(button),
            ),
          ],
        );
      },
    );
  }

  _readNotes() async {
    var dbNotes = await _db.readNotes();
    List<Note> tempList = [];

    for (var item in dbNotes) {
      tempList.add(Note.fromMap(item));
    }

    setState(() {
      _notes = tempList;
    });

    tempList = [];
  }

  _saveNote({Note? note}) async {
    if(note != null) {
      note.update(
        title: _titleController.text,
        description: _descriptionController.text
      );
      await _db.updateNote(note);
    }
    else {
      note = Note(_titleController.text, _descriptionController.text);
      await _db.saveNote(note);
    }

    _clearTextfields();
    _readNotes();
  }

  _clearTextfields() {
    _titleController.text = "";
    _descriptionController.text = "";
  }

  @override
  void initState() {
    super.initState();
    _readNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appName, style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];

                return Card(
                  child: Dismissible(
                    key: Key(note.id.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      padding: EdgeInsets.only(right: 20),
                      color: Colors.redAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.delete_forever, color: Colors.white),
                        ],
                      ),
                    ),
                    child: ListTile(
                      title: Text(note.title),
                      subtitle: Text("${note.createOn} - ${note.description}"),
                      trailing: IconButton(
                          onPressed: () => _showDialogNotes(note: note),
                          icon: Icon(
                              Icons.edit,
                            color: Colors.green,
                          )
                      )
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialogNotes,
        child: Icon(Icons.note_add_outlined),
      ),
    );
  }
}
