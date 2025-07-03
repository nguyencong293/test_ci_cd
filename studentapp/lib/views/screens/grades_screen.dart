import 'package:flutter/material.dart';
import '../../controllers/controllers.dart';
import '../../models/models.dart';
import '../../utils/utils.dart';
import '../../views/widgets/widgets.dart' as widgets;

/// Screen for displaying and managing grades
class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key});

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  late final GradeController _gradeController;
  late final StudentController _studentController;
  late final SubjectController _subjectController;

  @override
  void initState() {
    super.initState();
    _gradeController = GradeController();
    _studentController = StudentController();
    _subjectController = SubjectController();
    _loadData();
  }

  @override
  void dispose() {
    _gradeController.dispose();
    _studentController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _gradeController.loadGrades(),
      _studentController.loadStudents(),
      _subjectController.loadSubjects(),
    ]);
  }

  void _showAddGradeDialog() {
    showDialog(
      context: context,
      builder: (context) => _AddGradeDialog(
        students: _studentController.students,
        subjects: _subjectController.subjects,
        onAdd: (grade) async {
          final success = await _gradeController.createGrade(grade);
          if (success) {
            Navigator.of(context).pop();
            DialogUtils.showSnackbar(context, 'Thêm điểm thành công');
          } else {
            DialogUtils.showSnackbar(
              context,
              'Thêm điểm thất bại',
              isError: true,
            );
          }
        },
      ),
    );
  }

  void _showEditGradeDialog(Grade grade) {
    showDialog(
      context: context,
      builder: (context) => _EditGradeDialog(
        grade: grade,
        students: _studentController.students,
        subjects: _subjectController.subjects,
        onEdit: (updatedGrade) async {
          final success = await _gradeController.updateGrade(
            grade.id!,
            updatedGrade,
          );
          if (success) {
            Navigator.of(context).pop();
            DialogUtils.showSnackbar(context, 'Cập nhật điểm thành công');
          } else {
            DialogUtils.showSnackbar(
              context,
              'Cập nhật điểm thất bại',
              isError: true,
            );
          }
        },
      ),
    );
  }

  void _deleteGrade(Grade grade) async {
    final confirmed = await DialogUtils.showConfirmationDialog(
      context,
      'Xóa điểm',
      'Bạn có chắc chắn muốn xóa điểm này?',
    );

    if (confirmed) {
      final success = await _gradeController.deleteGrade(grade.id!);
      if (success) {
        DialogUtils.showSnackbar(context, 'Xóa điểm thành công');
      } else {
        DialogUtils.showSnackbar(context, 'Xóa điểm thất bại', isError: true);
      }
    }
  }

  String _getStudentName(String studentId) {
    final student = _studentController.students.firstWhere(
      (s) => s.studentId == studentId,
      orElse: () => Student(
        studentId: studentId,
        studentName: 'Unknown',
        birthYear: 2000,
      ),
    );
    return student.studentName;
  }

  String _getSubjectName(String subjectId) {
    final subject = _subjectController.subjects.firstWhere(
      (s) => s.subjectId == subjectId,
      orElse: () => Subject(subjectId: subjectId, subjectName: 'Unknown'),
    );
    return subject.subjectName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Điểm số'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddGradeDialog,
        child: const Icon(Icons.add),
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          _gradeController,
          _studentController,
          _subjectController,
        ]),
        builder: (context, child) {
          if (_gradeController.isLoading ||
              _studentController.isLoading ||
              _subjectController.isLoading) {
            return const widgets.LoadingWidget(message: 'Đang tải dữ liệu...');
          }

          if (_gradeController.error != null) {
            return widgets.ErrorWidget(
              message: _gradeController.error!,
              onRetry: _loadData,
            );
          }

          final grades = _gradeController.grades;

          if (grades.isEmpty) {
            return const widgets.EmptyStateWidget(
              message: 'Không có điểm nào',
              icon: Icons.grade,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: grades.length,
            itemBuilder: (context, index) {
              final grade = grades[index];
              return widgets.GradeCard(
                grade: grade,
                studentName: _getStudentName(grade.studentId),
                subjectName: _getSubjectName(grade.subjectId),
                onEdit: () => _showEditGradeDialog(grade),
                onDelete: () => _deleteGrade(grade),
              );
            },
          );
        },
      ),
    );
  }
}

/// Dialog for adding new grade
class _AddGradeDialog extends StatefulWidget {
  final List<Student> students;
  final List<Subject> subjects;
  final Function(Grade) onAdd;

  const _AddGradeDialog({
    required this.students,
    required this.subjects,
    required this.onAdd,
  });

  @override
  State<_AddGradeDialog> createState() => _AddGradeDialogState();
}

class _AddGradeDialogState extends State<_AddGradeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _scoreController = TextEditingController();

  String? _selectedStudentId;
  String? _selectedSubjectId;

  @override
  void dispose() {
    _scoreController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate() &&
        _selectedStudentId != null &&
        _selectedSubjectId != null) {
      final grade = Grade(
        studentId: _selectedStudentId!,
        subjectId: _selectedSubjectId!,
        averageScore: double.parse(_scoreController.text.trim()),
      );
      widget.onAdd(grade);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Thêm điểm'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedStudentId,
              decoration: const InputDecoration(
                labelText: 'Sinh viên',
                border: OutlineInputBorder(),
              ),
              items: widget.students.map((student) {
                return DropdownMenuItem(
                  value: student.studentId,
                  child: Text('${student.studentName} (${student.studentId})'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStudentId = value;
                });
              },
              validator: (value) =>
                  value == null ? 'Vui lòng chọn sinh viên' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedSubjectId,
              decoration: const InputDecoration(
                labelText: 'Môn học',
                border: OutlineInputBorder(),
              ),
              items: widget.subjects.map((subject) {
                return DropdownMenuItem(
                  value: subject.subjectId,
                  child: Text('${subject.subjectName} (${subject.subjectId})'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSubjectId = value;
                });
              },
              validator: (value) =>
                  value == null ? 'Vui lòng chọn môn học' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _scoreController,
              decoration: const InputDecoration(
                labelText: 'Điểm',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: Validators.validateGradeScore,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Thêm')),
      ],
    );
  }
}

/// Dialog for editing grade
class _EditGradeDialog extends StatefulWidget {
  final Grade grade;
  final List<Student> students;
  final List<Subject> subjects;
  final Function(Grade) onEdit;

  const _EditGradeDialog({
    required this.grade,
    required this.students,
    required this.subjects,
    required this.onEdit,
  });

  @override
  State<_EditGradeDialog> createState() => _EditGradeDialogState();
}

class _EditGradeDialogState extends State<_EditGradeDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _scoreController;

  late String _selectedStudentId;
  late String _selectedSubjectId;

  @override
  void initState() {
    super.initState();
    _scoreController = TextEditingController(
      text: widget.grade.averageScore.toString(),
    );
    _selectedStudentId = widget.grade.studentId;
    _selectedSubjectId = widget.grade.subjectId;
  }

  @override
  void dispose() {
    _scoreController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final grade = Grade(
        id: widget.grade.id,
        studentId: _selectedStudentId,
        subjectId: _selectedSubjectId,
        averageScore: double.parse(_scoreController.text.trim()),
      );
      widget.onEdit(grade);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sửa điểm'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedStudentId,
              decoration: const InputDecoration(
                labelText: 'Sinh viên',
                border: OutlineInputBorder(),
              ),
              items: widget.students.map((student) {
                return DropdownMenuItem(
                  value: student.studentId,
                  child: Text('${student.studentName} (${student.studentId})'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStudentId = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedSubjectId,
              decoration: const InputDecoration(
                labelText: 'Môn học',
                border: OutlineInputBorder(),
              ),
              items: widget.subjects.map((subject) {
                return DropdownMenuItem(
                  value: subject.subjectId,
                  child: Text('${subject.subjectName} (${subject.subjectId})'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSubjectId = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _scoreController,
              decoration: const InputDecoration(
                labelText: 'Điểm',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: Validators.validateGradeScore,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Cập nhật')),
      ],
    );
  }
}
