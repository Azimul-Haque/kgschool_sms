import 'package:sqflite/sqlite_api.dart';

late Database? db;

void createSnackBar(String message) {
  final snackBar = new SnackBar(content: new Text(message));

  // Find the Scaffold in the Widget tree and use it to show a SnackBar!
  Scaffold.of(scaffoldContext).showSnackBar(snackBar);
}
