import 'package:flutter/material.dart';
import 'package:notes/utils/color_scheme.dart';
import 'package:notes/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notes/screens/addnote.dart';
import 'package:notes/models/note.dart';
import 'package:notes/screens/notelist.dart';

class CategoryGridView extends StatefulWidget {
  CategoryGridView({Key key}) : super(key: key);

  @override
  _CategoryGridViewState createState() => _CategoryGridViewState();
}

class _CategoryGridViewState extends State<CategoryGridView> {
  DatabaseHelper dbHelper = DatabaseHelper();
  List<String> categoryList;
  int categoryCount = 0;

  void updateGridView() {
    final Future<Database> dbFuture = dbHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<String>> categoryListFuture = dbHelper.getCategoryList();
      categoryListFuture.then((categoryList) {
        setState(() {
          this.categoryList = categoryList;
          this.categoryCount = categoryList.length;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (categoryList == null) {
      updateGridView();
    }
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text("Categories")),
        body: Container(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
            itemCount: this.categoryCount,
            padding: EdgeInsets.all(10.0),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: Card(
                  elevation: 10,
                  color: palette.surface,
                  shadowColor: palette.primary,
                  child: ListTile(
                    title: Text(this.categoryList[index]),
                    onTap: () async {
                      final result = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return NoteList(this.categoryList[index]);
                      }));
                      if (result != null) {
                        //updateGridView();
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            final result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) {
              return AddNote(Note.withId(null, '', '', '', ''));
            }));
            if (result != null) {
              updateGridView();
            }
          },
        ),
      ),
    );
  }
}
