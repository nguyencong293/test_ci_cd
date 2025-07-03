/// Utility functions for validation
class Validators {
  /// Validate student ID
  static String? validateStudentId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mã sinh viên không được để trống';
    }

    if (value.trim().length < 3) {
      return 'Mã sinh viên phải có ít nhất 3 ký tự';
    }

    if (value.trim().length > 10) {
      return 'Mã sinh viên không được quá 10 ký tự';
    }

    // Basic pattern check (letters and numbers only)
    final pattern = RegExp(r'^[A-Za-z0-9]+$');
    if (!pattern.hasMatch(value.trim())) {
      return 'Mã sinh viên chỉ được chứa chữ cái và số';
    }

    return null;
  }

  /// Validate student name
  static String? validateStudentName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tên sinh viên không được để trống';
    }

    if (value.trim().length < 2) {
      return 'Tên sinh viên phải có ít nhất 2 ký tự';
    }

    if (value.trim().length > 100) {
      return 'Tên sinh viên không được quá 100 ký tự';
    }

    return null;
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
    if (value == null || value.trim().isEmpty) {
      return 'Mã môn học không được để trống';
    }

    if (value.trim().length < 3) {
      return 'Mã môn học phải có ít nhất 3 ký tự';
    }

    if (value.trim().length > 10) {
      return 'Mã môn học không được quá 10 ký tự';
    }

    // Basic pattern check (letters and numbers only)
    final pattern = RegExp(r'^[A-Za-z0-9]+$');
    if (!pattern.hasMatch(value.trim())) {
      return 'Mã môn học chỉ được chứa chữ cái và số';
    }

    return null;
  }

  /// Validate subject name
  static String? validateSubjectName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tên môn học không được để trống';
    }

    if (value.trim().length < 2) {
      return 'Tên môn học phải có ít nhất 2 ký tự';
    }

    if (value.trim().length > 100) {
      return 'Tên môn học không được quá 100 ký tự';
    }

    return null;
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
