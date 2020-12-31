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
  bool darkThemeState = false;

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
        appBar: AppBar(
          backgroundColor: palette.bars,
          elevation: 20,
          title: Text(
            "Categories",
            style: TextStyle(color: palette.onBars),
          ),
        ),
        drawer: Drawer(
          child: Container(
            color: palette.surface,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  child: Text(
                    "Todo",
                    style: TextStyle(color: palette.onBars, fontSize: 30),
                  ),
                  decoration: BoxDecoration(color: palette.bars),
                ),
                ListTile(
                  title: Text(
                    'Dark Theme',
                    style: TextStyle(color: palette.onSurface, fontSize: 15),
                  ),
                  trailing: Switch(
                    onChanged: (bool value) {
                      setState(() {
                        darkThemeState = !darkThemeState;
                        palette = darkThemeState ? dark : light;
                      });
                    },
                    value: darkThemeState,
                  ),
                )
              ],
            ),
          ),
        ),
        body: Container(
          color: palette.background,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 10),
            itemCount: this.categoryCount,
            padding: EdgeInsets.all(10.0),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.only(top: 20),
                child: Card(
                  elevation: 10,
                  color: palette.surface,
                  shadowColor: palette.primary,
                  child: ListTile(
                    title: Text(
                      this.categoryList[index],
                      style: TextStyle(color: palette.onSurface),
                    ),
                    trailing: Icon(
                      Icons.rule,
                      color: palette.secondary,
                    ),
                    onTap: () async {
                      await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return NoteList(this.categoryList[index]);
                      })).then((value) => updateGridView());
                    },
                  ),
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: palette.bars,
          child: Icon(
            Icons.add,
            color: palette.onBars,
          ),
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
