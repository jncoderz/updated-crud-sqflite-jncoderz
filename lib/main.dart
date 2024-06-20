import 'package:flutter/material.dart';
import 'package:sqflite_crud/screens/home_screen.dart';


void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,home: HomeScreen(),);
  }
}