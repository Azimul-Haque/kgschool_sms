import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

const String tableName = "contacts";
const String columnId = "id";
final String columnName = "name";
final String columnContactNumber = "contactnumber";

class ContactModel {
  int id;
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
  Database db;

  ContactHelper() {
    initDatabase();
  }

  Future<Database> get database async {
    // if (null != database) {
    //   return db;
    // }
    db = await initDatabase();
    return db;
  }

  initDatabase() async {
    db = await openDatabase(join(await getDatabasesPath(), "exams.db"),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnTotalQstn INTEGER, $columnDuration INTEGER, $columnRightAnswer INTEGER, $columnWrongAnswer INTEGER, $columnCreatedAt TEXT)");
    }, version: 1);
  }

  Future<void> insertExam(ContactModel exam) async {
    try {
      db.insert(tableName, exam.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (_) {
      // print(_);
    }
  }

  Future<List<ContactModel>> getAllExams() async {
    List<Map<String, dynamic>> exams = await db.query(tableName);
    return List.generate(exams.length, (i) {
      return ContactModel(
          id: exams[i][columnId],
          totalqstn: exams[i][columnTotalQstn],
          duration: exams[i][columnDuration],
          rightanswer: exams[i][columnRightAnswer],
          wronganswer: exams[i][columnWrongAnswer],
          createdat: exams[i][columnCreatedAt]);
    });
  }

  // Future<List<ContactModel>> getSomeQuestions (String amount) async{
  //   List<Map<String, dynamic>> questions = await db.rawQuery("SELECT * FROM " + tableName + " ORDER BY RANDOM() LIMIT " + amount, null);
  //   return List.generate(questions.length, (i){
  //     return ContactModel(id: questions[i][columnId], question: questions[i][columnQuestion], answer: questions[i][columnAnswer], incanswer: questions[i][columnIncAnswers]);
  //   });
  // }
}
