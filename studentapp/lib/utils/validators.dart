/// Utility functions for validation
class Validators {
  // Common patterns
  static final _alphanumericPattern = RegExp(r'^[A-Za-z0-9]+$');

  /// Generic validator for ID fields (student ID, subject ID)
  static String? _validateId(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName không được để trống';
    }

    final trimmed = value.trim();
    
    if (trimmed.length < 3) {
      return '$fieldName phải có ít nhất 3 ký tự';
    }

    if (trimmed.length > 10) {
      return '$fieldName không được quá 10 ký tự';
    }

    if (!_alphanumericPattern.hasMatch(trimmed)) {
      return '$fieldName chỉ được chứa chữ cái và số';
    }

    return null;
  }

  /// Generic validator for name fields
  static String? _validateName(String? value, String fieldName, {int minLength = 2, int maxLength = 100}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName không được để trống';
    }

    final trimmed = value.trim();
    
    if (trimmed.length < minLength) {
      return '$fieldName phải có ít nhất $minLength ký tự';
    }

    if (trimmed.length > maxLength) {
      return '$fieldName không được quá $maxLength ký tự';
    }

    return null;
  }

  /// Validate student ID
  static String? validateStudentId(String? value) {
    return _validateId(value, 'Mã sinh viên');
  }

  /// Validate student name
  static String? validateStudentName(String? value) {
    return _validateName(value, 'Tên sinh viên');
  }

  /// Validate birth year
  static String? validateBirthYear(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Năm sinh không được để trống';
    }

    final year = int.tryParse(value.trim());
    if (year == null) {
      return 'Năm sinh phải là một số';
    }

    final currentYear = DateTime.now().year;
    if (year < 1900 || year > currentYear) {
      return 'Năm sinh phải từ 1900 đến $currentYear';
    }

    return null;
  }

  /// Validate subject ID
  static String? validateSubjectId(String? value) {
    return _validateId(value, 'Mã môn học');
  }

  /// Validate subject name
  static String? validateSubjectName(String? value) {
    return _validateName(value, 'Tên môn học');
  }

  /// Validate grade score
  static String? validateGradeScore(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Điểm không được để trống';
    }

    final score = double.tryParse(value.trim());
    if (score == null) {
      return 'Điểm phải là một số';
    }

    if (score < 0 || score > 10) {
      return 'Điểm phải từ 0 đến 10';
    }

    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName không được để trống';
    }
    return null;
  }
}
