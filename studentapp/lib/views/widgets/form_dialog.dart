import 'package:flutter/material.dart';

/// Generic reusable form dialog
class FormDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final VoidCallback onSubmit;
  final VoidCallback? onCancel;
  final String submitText;
  final String cancelText;
  final bool isValid;

  const FormDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onSubmit,
    this.onCancel,
    this.submitText = 'Xác nhận',
    this.cancelText = 'Hủy',
    this.isValid = true,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(child: content),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(),
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: isValid ? onSubmit : null,
          child: Text(submitText),
        ),
      ],
    );
  }
}

/// Specific form dialog for students
class StudentFormDialog extends StatefulWidget {
  final String title;
  final String? initialStudentId;
  final String? initialStudentName;
  final int? initialBirthYear;
  final Function(String studentId, String studentName, int birthYear) onSubmit;
  final bool readOnlyId;

  const StudentFormDialog({
    super.key,
    required this.title,
    required this.onSubmit,
    this.initialStudentId,
    this.initialStudentName,
    this.initialBirthYear,
    this.readOnlyId = false,
  });

  @override
  State<StudentFormDialog> createState() => _StudentFormDialogState();
}

class _StudentFormDialogState extends State<StudentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _studentIdController;
  late final TextEditingController _studentNameController;
  late final TextEditingController _birthYearController;

  @override
  void initState() {
    super.initState();
    _studentIdController = TextEditingController(
      text: widget.initialStudentId ?? '',
    );
    _studentNameController = TextEditingController(
      text: widget.initialStudentName ?? '',
    );
    _birthYearController = TextEditingController(
      text: widget.initialBirthYear?.toString() ?? '',
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
      widget.onSubmit(
        _studentIdController.text.trim(),
        _studentNameController.text.trim(),
        int.parse(_birthYearController.text.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormDialog(
      title: widget.title,
      onSubmit: _submit,
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
              enabled: !widget.readOnlyId,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập mã sinh viên';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _studentNameController,
              decoration: const InputDecoration(
                labelText: 'Tên sinh viên',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập tên sinh viên';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _birthYearController,
              decoration: const InputDecoration(
                labelText: 'Năm sinh',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập năm sinh';
                }
                final year = int.tryParse(value.trim());
                if (year == null || year < 1900 || year > DateTime.now().year) {
                  return 'Năm sinh không hợp lệ';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Specific form dialog for subjects
class SubjectFormDialog extends StatefulWidget {
  final String title;
  final String? initialSubjectId;
  final String? initialSubjectName;
  final Function(String subjectId, String subjectName) onSubmit;
  final bool readOnlyId;

  const SubjectFormDialog({
    super.key,
    required this.title,
    required this.onSubmit,
    this.initialSubjectId,
    this.initialSubjectName,
    this.readOnlyId = false,
  });

  @override
  State<SubjectFormDialog> createState() => _SubjectFormDialogState();
}

class _SubjectFormDialogState extends State<SubjectFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _subjectIdController;
  late final TextEditingController _subjectNameController;

  @override
  void initState() {
    super.initState();
    _subjectIdController = TextEditingController(
      text: widget.initialSubjectId ?? '',
    );
    _subjectNameController = TextEditingController(
      text: widget.initialSubjectName ?? '',
    );
  }

  @override
  void dispose() {
    _subjectIdController.dispose();
    _subjectNameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        _subjectIdController.text.trim(),
        _subjectNameController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormDialog(
      title: widget.title,
      onSubmit: _submit,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _subjectIdController,
              decoration: const InputDecoration(
                labelText: 'Mã môn học',
                border: OutlineInputBorder(),
              ),
              enabled: !widget.readOnlyId,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập mã môn học';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _subjectNameController,
              decoration: const InputDecoration(
                labelText: 'Tên môn học',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập tên môn học';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
