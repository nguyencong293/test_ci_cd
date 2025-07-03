import 'package:flutter/material.dart';
import '../../controllers/controllers.dart';
import '../../models/models.dart';
import '../../utils/utils.dart';
import '../../views/widgets/widgets.dart' as widgets;

/// Screen for displaying and managing students
class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  late final StudentController _studentController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _studentController = StudentController();
    _loadStudents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _studentController.dispose();
    super.dispose();
  }

  Future<void> _loadStudents() async {
    await _studentController.loadStudents();
  }

  void _showAddStudentDialog() {
    showDialog(
      context: context,
      builder: (context) => _AddStudentDialog(
        onAdd: (student) async {
          final success = await _studentController.createStudent(student);
          if (success) {
            Navigator.of(context).pop();
            DialogUtils.showSnackbar(context, 'Thêm sinh viên thành công');
          } else {
            DialogUtils.showSnackbar(
              context,
              'Thêm sinh viên thất bại',
              isError: true,
            );
          }
        },
      ),
    );
  }

  void _showEditStudentDialog(Student student) {
    showDialog(
      context: context,
      builder: (context) => _EditStudentDialog(
        student: student,
        onEdit: (updatedStudent) async {
          final success = await _studentController.updateStudent(
            student.studentId,
            updatedStudent,
          );
          if (success) {
            Navigator.of(context).pop();
            DialogUtils.showSnackbar(context, 'Cập nhật sinh viên thành công');
          } else {
            DialogUtils.showSnackbar(
              context,
              'Cập nhật sinh viên thất bại',
              isError: true,
            );
          }
        },
      ),
    );
  }

  void _deleteStudent(Student student) async {
    final confirmed = await DialogUtils.showConfirmationDialog(
      context,
      'Xóa sinh viên',
      'Bạn có chắc chắn muốn xóa sinh viên ${student.studentName}?',
    );

    if (confirmed) {
      final success = await _studentController.deleteStudent(student.studentId);
      if (success) {
        DialogUtils.showSnackbar(context, 'Xóa sinh viên thành công');
      } else {
        DialogUtils.showSnackbar(
          context,
          'Xóa sinh viên thất bại',
          isError: true,
        );
      }
    }
  }

  void _searchStudents(String query) {
    if (query.trim().isEmpty) {
      _loadStudents();
    } else {
      _studentController.searchStudents(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sinh viên'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadStudents),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddStudentDialog,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Tìm kiếm sinh viên',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _searchStudents,
            ),
          ),

          // Students list
          Expanded(
            child: ListenableBuilder(
              listenable: _studentController,
              builder: (context, child) {
                if (_studentController.isLoading) {
                  return const widgets.LoadingWidget(
                    message: 'Đang tải danh sách sinh viên...',
                  );
                }

                if (_studentController.error != null) {
                  return widgets.ErrorWidget(
                    message: _studentController.error!,
                    onRetry: _loadStudents,
                  );
                }

                final students = _studentController.students;

                if (students.isEmpty) {
                  return const widgets.EmptyStateWidget(
                    message: 'Không có sinh viên nào',
                    icon: Icons.people,
                  );
                }

                return ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return widgets.StudentCard(
                      student: student,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/students/${student.studentId}',
                        );
                      },
                      onEdit: () => _showEditStudentDialog(student),
                      onDelete: () => _deleteStudent(student),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Dialog for adding new student
class _AddStudentDialog extends StatefulWidget {
  final Function(Student) onAdd;

  const _AddStudentDialog({required this.onAdd});

  @override
  State<_AddStudentDialog> createState() => _AddStudentDialogState();
}

class _AddStudentDialogState extends State<_AddStudentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _studentIdController = TextEditingController();
  final _studentNameController = TextEditingController();
  final _birthYearController = TextEditingController();

  @override
  void dispose() {
    _studentIdController.dispose();
    _studentNameController.dispose();
    _birthYearController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final student = Student(
        studentId: _studentIdController.text.trim(),
        studentName: _studentNameController.text.trim(),
        birthYear: int.parse(_birthYearController.text.trim()),
      );
      widget.onAdd(student);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Thêm sinh viên'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _studentIdController,
              decoration: const InputDecoration(
                labelText: 'Mã sinh viên',
                border: OutlineInputBorder(),
              ),
              validator: Validators.validateStudentId,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _studentNameController,
              decoration: const InputDecoration(
                labelText: 'Tên sinh viên',
                border: OutlineInputBorder(),
              ),
              validator: Validators.validateStudentName,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _birthYearController,
              decoration: const InputDecoration(
                labelText: 'Năm sinh',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: Validators.validateBirthYear,
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

/// Dialog for editing student
class _EditStudentDialog extends StatefulWidget {
  final Student student;
  final Function(Student) onEdit;

  const _EditStudentDialog({required this.student, required this.onEdit});

  @override
  State<_EditStudentDialog> createState() => _EditStudentDialogState();
}

class _EditStudentDialogState extends State<_EditStudentDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _studentIdController;
  late final TextEditingController _studentNameController;
  late final TextEditingController _birthYearController;

  @override
  void initState() {
    super.initState();
    _studentIdController = TextEditingController(
      text: widget.student.studentId,
    );
    _studentNameController = TextEditingController(
      text: widget.student.studentName,
    );
    _birthYearController = TextEditingController(
      text: widget.student.birthYear.toString(),
    );
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _studentNameController.dispose();
    _birthYearController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final student = Student(
        studentId: _studentIdController.text.trim(),
        studentName: _studentNameController.text.trim(),
        birthYear: int.parse(_birthYearController.text.trim()),
      );
      widget.onEdit(student);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sửa sinh viên'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _studentIdController,
              decoration: const InputDecoration(
                labelText: 'Mã sinh viên',
                border: OutlineInputBorder(),
              ),
              enabled: false, // Don't allow editing student ID
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _studentNameController,
              decoration: const InputDecoration(
                labelText: 'Tên sinh viên',
                border: OutlineInputBorder(),
              ),
              validator: Validators.validateStudentName,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _birthYearController,
              decoration: const InputDecoration(
                labelText: 'Năm sinh',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: Validators.validateBirthYear,
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
