import 'package:flutter/material.dart';
import 'package:notes/screens/categorygrid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Notes",
          home: CategoryGridView()),
    );
  }
}
