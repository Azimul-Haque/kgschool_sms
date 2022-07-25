import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

const String tableName = "contacts";
const String columnId = "id";
final String columnName = "name";
final String columnContactNumber = "contactnumber";

class ExamModel {
  int id;
  final String name;
  final String contactnumber;

  ExamModel(
      {this.id,
      this.totalqstn,
      this.duration,
      this.rightanswer,
      this.wronganswer,
      this.createdat});

  Map<String, dynamic> toMap() {
    return {
      // columnId: this.id,
      columnTotalQstn: this.totalqstn,
      columnDuration: this.duration,
      columnRightAnswer: this.rightanswer,
      columnWrongAnswer: this.wronganswer,
      columnCreatedAt: this.createdat,
    };
  }
}

class ExamHelper {
  Database db;

  ExamHelper() {
    initDatabase();
  }

  Future<Database> get database async {
    if (null != database) {
      return db;
    }
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

  Future<void> insertExam(ExamModel exam) async {
    try {
      db.insert(tableName, exam.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (_) {
      // print(_);
    }
  }

  Future<List<ExamModel>> getAllExams() async {
    List<Map<String, dynamic>> exams = await db.query(tableName);
    return List.generate(exams.length, (i) {
      return ExamModel(
          id: exams[i][columnId],
          totalqstn: exams[i][columnTotalQstn],
          duration: exams[i][columnDuration],
          rightanswer: exams[i][columnRightAnswer],
          wronganswer: exams[i][columnWrongAnswer],
          createdat: exams[i][columnCreatedAt]);
    });
  }

  // Future<List<ExamModel>> getSomeQuestions (String amount) async{
  //   List<Map<String, dynamic>> questions = await db.rawQuery("SELECT * FROM " + tableName + " ORDER BY RANDOM() LIMIT " + amount, null);
  //   return List.generate(questions.length, (i){
  //     return ExamModel(id: questions[i][columnId], question: questions[i][columnQuestion], answer: questions[i][columnAnswer], incanswer: questions[i][columnIncAnswers]);
  //   });
  // }
}
