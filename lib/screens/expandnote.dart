import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/utils/color_scheme.dart';

class ExpandNote extends StatelessWidget {
  final Note note;
  ExpandNote(this.note);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Note'),
        ),
        body: Card(
          shadowColor: primaryColor,
          color: secondaryColor,
          child: Center(
            child: SingleChildScrollView(
              child: Card(
                  elevation: 5,
                  shadowColor: primaryColor,
                  color: secondaryColor,
                  child: ListTile(
                    title: Text(note.title,
                        style: TextStyle(
                            fontSize: 25,
                            decoration: TextDecoration.underline)),
                    subtitle: Text(
                      ('\n' + note.text + '\n\n' + note.date),
                      style: TextStyle(fontSize: 18),
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
