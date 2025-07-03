/// Grade model class
class Grade {
  final int? id;
  final String studentId;
  final String subjectId;
  final double averageScore;

  Grade({
    this.id,
    required this.studentId,
    required this.subjectId,
    required this.averageScore,
  });

  /// Factory constructor for creating Grade from JSON
  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      id: json['id'] as int?,
      studentId: json['studentId'] as String,
      subjectId: json['subjectId'] as String,
      averageScore: (json['averageScore'] as num).toDouble(),
    );
  }

  /// Convert Grade to JSON
  Map<String, dynamic> toJson() {
    final json = {
      'studentId': studentId,
      'subjectId': subjectId,
      'averageScore': averageScore,
    };

    if (id != null) {
      json['id'] = id!;
    }

    return json;
  }

  /// Create a copy of this grade with some fields updated
  Grade copyWith({
    int? id,
    String? studentId,
    String? subjectId,
    double? averageScore,
  }) {
    return Grade(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      subjectId: subjectId ?? this.subjectId,
      averageScore: averageScore ?? this.averageScore,
    );
  }

  /// Get letter grade based on score
  String get letterGrade {
    if (averageScore >= 9.0) return 'A+';
    if (averageScore >= 8.5) return 'A';
    if (averageScore >= 8.0) return 'B+';
    if (averageScore >= 7.0) return 'B';
    if (averageScore >= 6.5) return 'C+';
    if (averageScore >= 5.0) return 'C';
    if (averageScore >= 4.0) return 'D';
    return 'F';
  }

  /// Check if grade is passing
  bool get isPassing => averageScore >= 5.0;

  @override
  String toString() {
    return 'Grade(id: $id, studentId: $studentId, subjectId: $subjectId, averageScore: $averageScore)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Grade &&
        other.id == id &&
        other.studentId == studentId &&
        other.subjectId == subjectId;
  }

  @override
  int get hashCode => Object.hash(id, studentId, subjectId);
}
