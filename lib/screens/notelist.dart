import 'package:flutter/material.dart';
import 'package:notes/screens/addnote.dart';
import 'dart:async';
import 'package:notes/models/note.dart';
import 'package:notes/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notes/utils/snack_bar.dart';
import 'package:notes/utils/color_scheme.dart';
import 'package:notes/screens/expandnote.dart';

class NoteList extends StatefulWidget {
  final String category;
  NoteList(this.category);

  @override
  _NoteListState createState() => _NoteListState(this.category);
}

class _NoteListState extends State<NoteList> {
  final category;
  _NoteListState(this.category);
  DatabaseHelper dbHelper = DatabaseHelper();
  List<Note> noteList;
  int notesCount = 0;

  void afterDeleteSnackBar(BuildContext context, String message, Note note) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'UNDO',
        onPressed: () async {
          DatabaseHelper dbHelper = DatabaseHelper();
          int result = await dbHelper.insertNote(note);
          if (result != 0) {
            updateListView();
          } else {
            showSnackBar(context, "Something went wrong");
          }
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _delete(BuildContext context, Note note) async {
    await dbHelper.deleteNote(note);
    updateListView();
    afterDeleteSnackBar(context, 'Note deleted successfully', note);
  }

  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture =
          dbHelper.getNoteListForCategory(this.category);
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.notesCount = noteList.length;
        });
      });
    });
  }

  String trimTitle(String title) {
    if (title.contains('\n')) {
      return (title.substring(0, title.indexOf('\n')) + "...");
    } else if (title.length > 15)
      return (title.substring(0, 15) + "...");
    else
      return title.toString();
  }

  String trimText(String text) {
    if (text.contains('\n') && text.indexOf('\n') <= 35) {
      return (text.substring(0, text.indexOf('\n')) + "...");
    } else if (text.length > 35)
      return (text.substring(0, 35) + "...");
    else
      return text.toString();
  }

  TextDecoration getTextDecoration(int index) {
    if (this.noteList[index].done == 1)
      return TextDecoration.lineThrough;
    else
      return TextDecoration.none;
  }

  void updateCheckBox(Note note) async {
    await dbHelper.updateNote(note);
    updateListView();
  }

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    return Container(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        backgroundColor: palette.primary,
      ),
      body: Container(
        child: ListView.builder(
          itemCount: notesCount,
          itemBuilder: (context, index) {
            return Dismissible(
              key: Key(noteList[index].id.toString()),
              background: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Icon(
                        Icons.delete,
                        color: palette.onWarn,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 15.0),
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.delete,
                        color: palette.onWarn,
                      ),
                    )
                  ],
                ),
                color: palette.warn,
                alignment: Alignment.centerLeft,
              ),
              onDismissed: (dir) {
                _delete(context, noteList[index]);
              },
              child: Card(
                margin: EdgeInsets.all(3.0),
                elevation: 5.0,
                color: palette.surface,
                shadowColor: palette.primary,
                child: ListTile(
                  contentPadding: EdgeInsets.all(0.0),
                  horizontalTitleGap: 0,
                  isThreeLine: true,
                  leading: Checkbox(
                    value: this.noteList[index].done == 0 ? false : true,
                    onChanged: (value) {
                      this.noteList[index].done =
                          this.noteList[index].done == 0 ? 1 : 0;
                      updateCheckBox(this.noteList[index]);
                    },
                  ),
                  title: Text(
                    trimTitle(this.noteList[index].title),
                    style: TextStyle(
                        fontSize: 20.0,
                        decoration: getTextDecoration(index),
                        decorationThickness: 2),
                  ),
                  subtitle: Text(trimText(this.noteList[index].text) +
                      '\n\n' +
                      this.noteList[index].date.toString()),
                  trailing: IconButton(
                    highlightColor: palette.primary,
                    icon: Icon(
                      Icons.edit,
                      color: palette.primary,
                    ),
                    onPressed: () async {
                      final result = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AddNote(Note.withId(
                            noteList[index].id,
                            noteList[index].category,
                            noteList[index].title,
                            noteList[index].text,
                            noteList[index].date,
                            noteList[index].done));
                      }));
                      if (result != null) {
                        updateListView();
                      }
                    },
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ExpandNote(Note(
                          noteList[index].category,
                          noteList[index].title,
                          noteList[index].text,
                          noteList[index].date));
                    }));
                  },
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton(
          backgroundColor: palette.primary,
          onPressed: () async {
            final result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) {
              return AddNote(Note.withId(null, this.category, '', '', ''));
            }));
            if (result != null) {
              updateListView();
            }
          },
          child: Icon(Icons.add),
        ),
      ),
    ));
  }
}
