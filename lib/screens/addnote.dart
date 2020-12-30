import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/utils/color_scheme.dart';
import 'package:notes/utils/database_helper.dart';
import 'package:notes/utils/snack_bar.dart';

class AddNote extends StatefulWidget {
  final Note note;
  AddNote(this.note);

  @override
  _AddNoteState createState() => _AddNoteState(this.note);
}

class _AddNoteState extends State<AddNote> {
  Note newNote;
  _AddNoteState(this.newNote);
  final _formKey = GlobalKey<FormState>();
  DatabaseHelper dbHelper = DatabaseHelper();

  void updateTitle(String title) {
    newNote.title = title;
  }

  void updateText(String text) {
    newNote.text = text;
  }

  saveNote(BuildContext context) async {
    Navigator.pop(context, true);
    int result;
    if (newNote.id == null) {
      String date = DateTime.now().toString();
      newNote.date = date.substring(0, date.indexOf("."));
      result = await dbHelper.insertNote(newNote);
    } else {
      result = await dbHelper.updateNote(newNote);
    }
    if (result != 0) {
      showSnackBar(context, "Note saved successfully");
    } else {
      showSnackBar(context, "Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Note"),
      ),
      body: Container(
        child: Card(
          color: palette.surface,
          shadowColor: palette.primary,
          elevation: 5.0,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: newNote.title,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter title here',
                      labelStyle: TextStyle(color: palette.primary),
                      hintStyle: TextStyle(color: palette.primary),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'This field can not be empty';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      updateTitle(value);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: newNote.text,
                    keyboardType: TextInputType.multiline,
                    maxLines: 6,
                    decoration: InputDecoration(
                      labelText: 'Text',
                      labelStyle: TextStyle(color: palette.primary),
                      hintStyle: TextStyle(color: palette.primary),
                      hintText: 'Enter text here',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'This field can not be empty';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      updateText(value);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await saveNote(context);
                      }
                    },
                    child: Text('Save'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
