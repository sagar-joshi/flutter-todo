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
  NoteList({Key key}) : super(key: key);

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper dbHelper = DatabaseHelper();
  List<Note> noteList;
  int notesCount = 0;

  void afterDeleteSnackBar(
      BuildContext context, String message, Note note) async {
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
      Future<List<Note>> noteListFuture = dbHelper.getNoteList();
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
    if (text.contains('\n')) {
      return (text.substring(0, text.indexOf('\n')) + "...");
    } else if (text.length > 25)
      return (text.substring(0, 25) + "...");
    else
      return text.toString();
  }

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    return Container(
        child: Scaffold(
      appBar: AppBar(title: Text("Notes")),
      body: Container(
        child: ListView.builder(
          itemCount: notesCount,
          itemBuilder: (context, index) {
            return Card(
              color: secondaryColor,
              child: ListTile(
                horizontalTitleGap: 2.0,
                isThreeLine: true,
                leading: Icon(
                  Icons.note,
                  color: Colors.amber,
                ),
                title: Text(
                  trimTitle(this.noteList[index].title),
                  style: TextStyle(fontSize: 20.0),
                ),
                subtitle: Text(trimText(this.noteList[index].text) +
                    '\n\n' +
                    this.noteList[index].date.toString()),
                trailing: Wrap(
                  children: [
                    IconButton(
                      highlightColor: primaryColor,
                      icon: Icon(
                        Icons.edit,
                        color: primaryColor,
                      ),
                      onPressed: () async {
                        final bool result = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return AddNote(Note.withId(
                              noteList[index].id,
                              noteList[index].title,
                              noteList[index].text,
                              noteList[index].date));
                        }));
                        if (result) {
                          updateListView();
                        }
                      },
                    ),
                    IconButton(
                      highlightColor: warnColor,
                      icon: Icon(
                        Icons.delete,
                        color: warnColor,
                      ),
                      onPressed: () {
                        _delete(context, noteList[index]);
                      },
                    )
                  ],
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ExpandNote(Note(noteList[index].title,
                        noteList[index].text, noteList[index].date));
                  }));
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final bool result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) {
            return AddNote(Note.withId(null, '', '', ''));
          }));
          if (result) {
            updateListView();
          }
        },
        child: Icon(Icons.add),
      ),
    ));
  }
}
