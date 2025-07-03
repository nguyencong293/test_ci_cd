import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/services.dart';

/// Controller for managing subject data and operations
class SubjectController extends ChangeNotifier {
  List<Subject> _subjects = [];
  Subject? _selectedSubject;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Subject> get subjects => _subjects;
  Subject? get selectedSubject => _selectedSubject;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load all subjects
  Future<void> loadSubjects() async {
    _setLoading(true);
    _setError(null);

    try {
      _subjects = await SubjectService.getAllSubjects();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Load subject by ID
  Future<void> loadSubjectById(String id) async {
    _setLoading(true);
    _setError(null);

    try {
      _selectedSubject = await SubjectService.getSubjectById(id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Create new subject
  Future<bool> createSubject(Subject subject) async {
    _setLoading(true);
    _setError(null);

    try {
      final newSubject = await SubjectService.createSubject(subject);
      _subjects.add(newSubject);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update existing subject
  Future<bool> updateSubject(String id, Subject subject) async {
    _setLoading(true);
    _setError(null);

    try {
      final updatedSubject = await SubjectService.updateSubject(id, subject);
      final index = _subjects.indexWhere((s) => s.subjectId == id);
      if (index != -1) {
        _subjects[index] = updatedSubject;
      }
      if (_selectedSubject?.subjectId == id) {
        _selectedSubject = updatedSubject;
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

  /// Delete subject
  Future<bool> deleteSubject(String id) async {
    _setLoading(true);
    _setError(null);

    try {
      await SubjectService.deleteSubject(id);
      _subjects.removeWhere((s) => s.subjectId == id);
      if (_selectedSubject?.subjectId == id) {
        _selectedSubject = null;
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

  /// Search subjects by name
  Future<void> searchSubjects(String name) async {
    if (name.trim().isEmpty) {
      await loadSubjects();
      return;
    }

    _setLoading(true);
    _setError(null);

    try {
      _subjects = await SubjectService.searchSubjectsByName(name);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Clear selected subject
  void clearSelectedSubject() {
    _selectedSubject = null;
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
