import 'package:flutter/material.dart';
import 'package:sqflite_crud/models/student_model.dart';
import 'package:sqflite_crud/services/db_helper.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<StudentModel> students = [];
  final dbHelper = DatabaseHelper.instance;
  @override
  void initState() {
    _updateStudentList();
    super.initState();
  }

  _updateStudentList() async {
    final List<Map<String, dynamic>> studentMapList =
        await dbHelper.getStudentMapList();
    setState(() {
      students = studentMapList
          .map(
            (e) => StudentModel.fromMap(e),
          )
          .toList();
    });
  }

 void _showFormDialog(StudentModel? student) {
    final nameController = TextEditingController(text: student?.name ?? "");
    final ageController =
        TextEditingController(text: student?.age.toString() ?? "");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(student == null ? "Add Student" : "Edit Student"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: "Name"),
              ),
              TextField(
                controller: ageController,
                decoration: InputDecoration(hintText: "Age"),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text;
                final age = int.tryParse(ageController.text);
                if (name.isNotEmpty && age != null) {
                  if (student == null) {
                    await dbHelper.insertStudent({"name": name, "age": age});
                    _updateStudentList();
                  } else {
                    await dbHelper.updateStudent(
                        {"id": student.id, "name": name, "age": age});
                          _updateStudentList();
                  }
                
                  Navigator.pop(context);
                }
              },
              child: Text(student == null ? "Add" : "Update"),
            ),
          ],
        );
      },
    );
  }

  _deleteStudent(int id) async {
    await dbHelper.deleteStudent(id);
    _updateStudentList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Record List"),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(students[index].name),
            subtitle: Text(
              students[index].age.toString()),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        _showFormDialog(
                          students[index]);
                      },
                      icon: Icon(Icons.edit)),
                  IconButton(
                      onPressed: () {
                        _deleteStudent(students[index].id);
                      },
                      icon: Icon(Icons.delete)),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog(null);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
