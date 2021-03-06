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

  void updateCategory(String category) {
    newNote.category = category;
  }

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
      backgroundColor: palette.background,
      appBar: AppBar(
        title: Text("Add Note"),
        backgroundColor: palette.bars,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                newNote.category != ""
                    ? Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "${newNote.category}",
                          style:
                              TextStyle(color: palette.primary, fontSize: 20.0),
                        ),
                      )
                    : Container(
                        color: palette.surface,
                        padding: const EdgeInsets.all(8.0),
                        margin: EdgeInsets.all(8.0),
                        child: TextFormField(
                          style: TextStyle(color: palette.onSurface),
                          initialValue: newNote.category,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Category',
                            hintText: 'Enter category here',
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
                            updateCategory(value);
                          },
                        ),
                      ),
                Container(
                  color: palette.surface,
                  padding: const EdgeInsets.all(8.0),
                  margin: EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(color: palette.onSurface),
                    minLines: 1,
                    maxLines: 2,
                    initialValue: newNote.title,
                    keyboardType: TextInputType.multiline,
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
                Container(
                  color: palette.surface,
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(color: palette.onSurface),
                    minLines: 1,
                    maxLines: 5,
                    initialValue: newNote.text,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: 'Text',
                      labelStyle: TextStyle(color: palette.primary),
                      hintStyle: TextStyle(color: palette.primary),
                      hintText: 'Enter text here',
                    ),
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
