import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/student_service.dart';

/// Controller for managing student data and operations
class StudentController extends ChangeNotifier {
  List<Student> _students = [];
  Student? _selectedStudent;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Student> get students => _students;
  Student? get selectedStudent => _selectedStudent;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load all students
  Future<void> loadStudents() async {
    _setLoading(true);
    _setError(null);

    try {
      _students = await StudentService.getAllStudents();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Load student by ID
  Future<void> loadStudentById(String id) async {
    _setLoading(true);
    _setError(null);

    try {
      _selectedStudent = await StudentService.getStudentById(id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Create new student
  Future<bool> createStudent(Student student) async {
    _setLoading(true);
    _setError(null);

    try {
      final newStudent = await StudentService.createStudent(student);
      _students.add(newStudent);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update existing student
  Future<bool> updateStudent(String id, Student student) async {
    _setLoading(true);
    _setError(null);

    try {
      final updatedStudent = await StudentService.updateStudent(id, student);
      final index = _students.indexWhere((s) => s.studentId == id);
      if (index != -1) {
        _students[index] = updatedStudent;
      }
      if (_selectedStudent?.studentId == id) {
        _selectedStudent = updatedStudent;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Delete student
  Future<bool> deleteStudent(String id) async {
    _setLoading(true);
    _setError(null);

    try {
      await StudentService.deleteStudent(id);
      _students.removeWhere((s) => s.studentId == id);
      if (_selectedStudent?.studentId == id) {
        _selectedStudent = null;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Search students by name
  Future<void> searchStudents(String name) async {
    if (name.trim().isEmpty) {
      await loadStudents();
      return;
    }

    _setLoading(true);
    _setError(null);

    try {
      _students = await StudentService.searchStudentsByName(name);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Filter students by birth year
  Future<void> filterStudentsByBirthYear(int year) async {
    _setLoading(true);
    _setError(null);

    try {
      _students = await StudentService.getStudentsByBirthYear(year);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Clear selected student
  void clearSelectedStudent() {
    _selectedStudent = null;
    notifyListeners();
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error state
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
