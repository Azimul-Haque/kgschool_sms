import 'package:flutter/material.dart';
import 'package:kgschool_sms/globals.dart';
import 'package:kgschool_sms/home.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await db!.execute("DROP TABLE IF EXISTS tableName");
  db = await openDatabase(join(await getDatabasesPath(), "contacts.db"),
      onCreate: (db, version) {
    return db.execute(
        "CREATE TABLE contacts(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, contactnumber TEXT)");
  }, version: 1);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
