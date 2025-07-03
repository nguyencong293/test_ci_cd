import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/services.dart';

/// Controller for managing grade data and operations
class GradeController extends ChangeNotifier {
  List<Grade> _grades = [];
  Grade? _selectedGrade;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Grade> get grades => _grades;
  Grade? get selectedGrade => _selectedGrade;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load all grades
  Future<void> loadGrades() async {
    _setLoading(true);
    _setError(null);

    try {
      _grades = await GradeService.getAllGrades();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Load grade by ID
  Future<void> loadGradeById(int id) async {
    _setLoading(true);
    _setError(null);

    try {
      _selectedGrade = await GradeService.getGradeById(id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Create new grade
  Future<bool> createGrade(Grade grade) async {
    _setLoading(true);
    _setError(null);

    try {
      final newGrade = await GradeService.createGrade(grade);
      _grades.add(newGrade);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update existing grade
  Future<bool> updateGrade(int id, Grade grade) async {
    _setLoading(true);
    _setError(null);

    try {
      final updatedGrade = await GradeService.updateGrade(id, grade);
      final index = _grades.indexWhere((g) => g.id == id);
      if (index != -1) {
        _grades[index] = updatedGrade;
      }
      if (_selectedGrade?.id == id) {
        _selectedGrade = updatedGrade;
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

  /// Delete grade
  Future<bool> deleteGrade(int id) async {
    _setLoading(true);
    _setError(null);

    try {
      await GradeService.deleteGrade(id);
      _grades.removeWhere((g) => g.id == id);
      if (_selectedGrade?.id == id) {
        _selectedGrade = null;
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

  /// Load grades by student ID
  Future<void> loadGradesByStudentId(String studentId) async {
    _setLoading(true);
    _setError(null);

    try {
      _grades = await GradeService.getGradesByStudentId(studentId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Load grades by subject ID
  Future<void> loadGradesBySubjectId(String subjectId) async {
    _setLoading(true);
    _setError(null);

    try {
      _grades = await GradeService.getGradesBySubjectId(subjectId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Get average score by student ID
  Future<double?> getAverageScoreByStudentId(String studentId) async {
    try {
      return await GradeService.getAverageScoreByStudentId(studentId);
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  /// Get average score by subject ID
  Future<double?> getAverageScoreBySubjectId(String subjectId) async {
    try {
      return await GradeService.getAverageScoreBySubjectId(subjectId);
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  /// Clear selected grade
  void clearSelectedGrade() {
    _selectedGrade = null;
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
