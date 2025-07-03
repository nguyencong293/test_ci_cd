/// Route constants
class AppRoutes {
  static const String home = '/';
  static const String students = '/students';
  static const String studentDetail = '/students/:id';
  static const String subjects = '/subjects';
  static const String subjectDetail = '/subjects/:id';
  static const String grades = '/grades';
  static const String gradeDetail = '/grades/:id';
  static const String addStudent = '/add-student';
  static const String editStudent = '/edit-student/:id';
  static const String addSubject = '/add-subject';
  static const String editSubject = '/edit-subject/:id';
  static const String addGrade = '/add-grade';
  static const String editGrade = '/edit-grade/:id';

  /// Generate student detail route
  static String generateStudentDetailRoute(String id) {
    return studentDetail.replaceAll(':id', id);
  }

  /// Generate subject detail route
  static String generateSubjectDetailRoute(String id) {
    return subjectDetail.replaceAll(':id', id);
  }

  /// Generate grade detail route
  static String generateGradeDetailRoute(String id) {
    return gradeDetail.replaceAll(':id', id);
  }

  /// Generate edit student route
  static String generateEditStudentRoute(String id) {
    return editStudent.replaceAll(':id', id);
  }

  /// Generate edit subject route
  static String generateEditSubjectRoute(String id) {
    return editSubject.replaceAll(':id', id);
  }

  /// Generate edit grade route
  static String generateEditGradeRoute(String id) {
    return editGrade.replaceAll(':id', id);
  }
}
