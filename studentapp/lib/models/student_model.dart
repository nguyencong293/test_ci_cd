/// Student model class
class Student {
  final String studentId;
  final String studentName;
  final int birthYear;

  Student({
    required this.studentId,
    required this.studentName,
    required this.birthYear,
  });

  /// Calculate age from birth year
  int get age {
    final currentYear = DateTime.now().year;
    return currentYear - birthYear;
  }

  /// Factory constructor for creating Student from JSON
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String,
      birthYear: json['birthYear'] as int,
    );
  }

  /// Convert Student to JSON
  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'birthYear': birthYear,
    };
  }

  /// Create a copy of this student with some fields updated
  Student copyWith({String? studentId, String? studentName, int? birthYear}) {
    return Student(
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      birthYear: birthYear ?? this.birthYear,
    );
  }

  @override
  String toString() {
    return 'Student(studentId: $studentId, studentName: $studentName, birthYear: $birthYear)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Student && other.studentId == studentId;
  }

  @override
  int get hashCode => studentId.hashCode;
}
