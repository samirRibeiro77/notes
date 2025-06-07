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

  _showDialogNotes() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Create a new note"),
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
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _saveNote();
                Navigator.pop(context);
              },
              child: Text("Save"),
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

  _saveNote() async {
    var note = Note(_titleController.text, _descriptionController.text);
    await _db.saveNote(note);

    _titleController.text = "";
    _descriptionController.text = "";

    _readNotes();
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
                  child: ListTile(
                    title: Text(note.title),
                    subtitle: Text("${note.createOn} - ${note.description}"),
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
