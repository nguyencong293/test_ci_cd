/// Subject model class
class Subject {
  final String subjectId;
  final String subjectName;

  Subject({required this.subjectId, required this.subjectName});

  /// Factory constructor for creating Subject from JSON
  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      subjectId: json['subjectId'] as String,
      subjectName: json['subjectName'] as String,
    );
  }

  /// Convert Subject to JSON
  Map<String, dynamic> toJson() {
    return {'subjectId': subjectId, 'subjectName': subjectName};
  }

  /// Create a copy of this subject with some fields updated
  Subject copyWith({String? subjectId, String? subjectName}) {
    return Subject(
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
    );
  }

  @override
  String toString() {
    return 'Subject(subjectId: $subjectId, subjectName: $subjectName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Subject && other.subjectId == subjectId;
  }

  @override
  int get hashCode => subjectId.hashCode;
}
