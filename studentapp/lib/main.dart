import 'package:flutter/material.dart';
import 'config/app_theme.dart';
import 'views/screens/home_screen.dart';
import 'views/screens/students_screen.dart';
import 'views/screens/subjects_screen.dart';
import 'views/screens/grades_screen.dart';

void main() {
  runApp(const StudentManagerApp());
}

class StudentManagerApp extends StatelessWidget {
  const StudentManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Manager',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/students': (context) => const StudentsScreen(),
        '/subjects': (context) => const SubjectsScreen(),
        '/grades': (context) => const GradesScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
