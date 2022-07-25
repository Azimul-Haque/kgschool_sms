import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

const String tableName = "contacts";
const String columnId = "id";
const String columnName = "name";
const String columnContactNumber = "contactnumber";

class ContactModel {
  final int id;
  final String name;
  final String contactnumber;

  ContactModel(
      {required this.id, required this.name, required this.contactnumber});

  Map<String, dynamic> toMap() {
    return {
      // columnId: this.id,
      columnName: name,
      columnContactNumber: contactnumber,
    };
  }
}

class ContactHelper {
  late Database db;

  ContactHelper() {
    initDatabase();
  }

  Future<Database?> get database async {
    // if (null != database) {
    //   return db;
    // }
    db = await initDatabase();
    return db;
  }

  initDatabase() async {
    db = await openDatabase(join(await getDatabasesPath(), "contacts.db"),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnName TEXT, $columnContactNumber TEXT)");
    }, version: 1);
  }

  Future<List<ContactModel>> getAllContacts() async {
    List<Map<String, dynamic>> contacts = await db.query(tableName);
    return List.generate(contacts.length, (i) {
      return ContactModel(
        id: contacts[i][columnId],
        name: contacts[i][columnName],
        contactnumber: contacts[i][columnContactNumber],
      );
    });
  }

  Future<void> insertContact(ContactModel contact) async {
    try {
      db.insert(tableName, contact.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      // print("Kaaj e porjonto");
    } catch (_) {
      // print(_);
    }
  }

  Future<void> updateContact(ContactModel contact) async {
    try {
      await db.update(
        tableName,
        contact.toMap(),
        where: 'id = ?',
        whereArgs: [contact.id],
      );
      print('kaaj hoy to');
    } catch (_) {
      print(_);
    }
  }

  Future<void> deleteContact(int id) async {
    await db.delete(
      'dogs',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  // Future<List<ContactModel>> getSomeQuestions (String amount) async{
  //   List<Map<String, dynamic>> questions = await db.rawQuery("SELECT * FROM " + tableName + " ORDER BY RANDOM() LIMIT " + amount, null);
  //   return List.generate(questions.length, (i){
  //     return ContactModel(id: questions[i][columnId], question: questions[i][columnQuestion], answer: questions[i][columnAnswer], incanswer: questions[i][columnIncAnswers]);
  //   });
  // }
}
