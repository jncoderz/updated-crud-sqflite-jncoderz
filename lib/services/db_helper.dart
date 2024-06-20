import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
// single instance
  static final DatabaseHelper instance = DatabaseHelper._instance();
  Database? _db;
// private constructor
  DatabaseHelper._instance();

// student table and column

  final String studentTable = "student_table";
  final String sId = "id";
  final String sName = "name";
  final String sAge = "age";

// create database
  Future<Database?> get db async {
    _db ??= await _initDb();
    return _db;
  }

// initialize database

  Future<Database?> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "student.db");
   //await
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
            "CREATE TABLE $studentTable($sId INTEGER PRIMARY KEY AUTOINCREMENT,$sName TEXT, $sAge INTEGER)");
      },
    );
  }

// retrieve all student record as a map list

  Future<List<Map<String, dynamic>>> getStudentMapList() async {
    Database? db = await this.db;
    final List<Map<String, dynamic>> result = await db!.query(studentTable);
    return result;
  }

// insert new student record
  Future<int> insertStudent(Map<String, dynamic> student) async {
    Database? db = await this.db;
    final int result = await db!.insert(studentTable, student);
    return result;
  }

// upadate existing student record
  Future<int> updateStudent(Map<String, dynamic> student) async {
    Database? db = await this.db;
    final int result = await db!.update(studentTable, student,
        where: "$sId=?", whereArgs: [student[sId]]);
    return result;
  }

// delete student data
  Future<int> deleteStudent(int id) async {
    Database? db = await this.db;
    final int result =
        await db!.delete(studentTable, where: "$sId=?", whereArgs: [id]);
    return result;
  }
}
