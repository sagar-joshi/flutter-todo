import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';

class ExpandNote extends StatelessWidget {
  final Note note;
  final Color cardColor;
  ExpandNote(this.note, this.cardColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Note'),
        ),
        body: SingleChildScrollView(
          child: Card(
              color: this.cardColor,
              child: ListTile(
                title: Text(note.title, style: TextStyle(fontSize: 25)),
                subtitle: Text(
                  ('\n' + note.text + '\n\n' + note.date),
                  style: TextStyle(fontSize: 18),
                ),
              )),
        ),
      ),
    );
  }
}
