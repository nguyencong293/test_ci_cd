import 'package:flutter/material.dart';
import '../../controllers/controllers.dart';
import '../../models/models.dart';
import '../../utils/utils.dart';
import '../../views/widgets/widgets.dart' as widgets;

/// Screen for displaying and managing subjects
class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  late final SubjectController _subjectController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _subjectController = SubjectController();
    _loadSubjects();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  Future<void> _loadSubjects() async {
    await _subjectController.loadSubjects();
  }

  void _showAddSubjectDialog() {
    showDialog(
      context: context,
      builder: (context) => _AddSubjectDialog(
        onAdd: (subject) async {
          final success = await _subjectController.createSubject(subject);
          if (success) {
            Navigator.of(context).pop();
            DialogUtils.showSnackbar(context, 'Thêm môn học thành công');
          } else {
            DialogUtils.showSnackbar(
              context,
              'Thêm môn học thất bại',
              isError: true,
            );
          }
        },
      ),
    );
  }

  void _showEditSubjectDialog(Subject subject) {
    showDialog(
      context: context,
      builder: (context) => _EditSubjectDialog(
        subject: subject,
        onEdit: (updatedSubject) async {
          final success = await _subjectController.updateSubject(
            subject.subjectId,
            updatedSubject,
          );
          if (success) {
            Navigator.of(context).pop();
            DialogUtils.showSnackbar(context, 'Cập nhật môn học thành công');
          } else {
            DialogUtils.showSnackbar(
              context,
              'Cập nhật môn học thất bại',
              isError: true,
            );
          }
        },
      ),
    );
  }

  void _deleteSubject(Subject subject) async {
    final confirmed = await DialogUtils.showConfirmationDialog(
      context,
      'Xóa môn học',
      'Bạn có chắc chắn muốn xóa môn học ${subject.subjectName}?',
    );

    if (confirmed) {
      final success = await _subjectController.deleteSubject(subject.subjectId);
      if (success) {
        DialogUtils.showSnackbar(context, 'Xóa môn học thành công');
      } else {
        DialogUtils.showSnackbar(
          context,
          'Xóa môn học thất bại',
          isError: true,
        );
      }
    }
  }

  void _searchSubjects(String query) {
    if (query.trim().isEmpty) {
      _loadSubjects();
    } else {
      _subjectController.searchSubjects(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Môn học'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadSubjects),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSubjectDialog,
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
                labelText: 'Tìm kiếm môn học',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _searchSubjects,
            ),
          ),

          // Subjects list
          Expanded(
            child: ListenableBuilder(
              listenable: _subjectController,
              builder: (context, child) {
                if (_subjectController.isLoading) {
                  return const widgets.LoadingWidget(
                    message: 'Đang tải danh sách môn học...',
                  );
                }

                if (_subjectController.error != null) {
                  return widgets.ErrorWidget(
                    message: _subjectController.error!,
                    onRetry: _loadSubjects,
                  );
                }

                final subjects = _subjectController.subjects;

                if (subjects.isEmpty) {
                  return const widgets.EmptyStateWidget(
                    message: 'Không có môn học nào',
                    icon: Icons.book,
                  );
                }

                return ListView.builder(
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    final subject = subjects[index];
                    return widgets.SubjectCard(
                      subject: subject,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/subjects/${subject.subjectId}',
                        );
                      },
                      onEdit: () => _showEditSubjectDialog(subject),
                      onDelete: () => _deleteSubject(subject),
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

/// Dialog for adding new subject
class _AddSubjectDialog extends StatefulWidget {
  final Function(Subject) onAdd;

  const _AddSubjectDialog({required this.onAdd});

  @override
  State<_AddSubjectDialog> createState() => _AddSubjectDialogState();
}

class _AddSubjectDialogState extends State<_AddSubjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _subjectIdController = TextEditingController();
  final _subjectNameController = TextEditingController();

  @override
  void dispose() {
    _subjectIdController.dispose();
    _subjectNameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final subject = Subject(
        subjectId: _subjectIdController.text.trim(),
        subjectName: _subjectNameController.text.trim(),
      );
      widget.onAdd(subject);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Thêm môn học'),
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
              validator: Validators.validateSubjectId,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _subjectNameController,
              decoration: const InputDecoration(
                labelText: 'Tên môn học',
                border: OutlineInputBorder(),
              ),
              validator: Validators.validateSubjectName,
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

/// Dialog for editing subject
class _EditSubjectDialog extends StatefulWidget {
  final Subject subject;
  final Function(Subject) onEdit;

  const _EditSubjectDialog({required this.subject, required this.onEdit});

  @override
  State<_EditSubjectDialog> createState() => _EditSubjectDialogState();
}

class _EditSubjectDialogState extends State<_EditSubjectDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _subjectIdController;
  late final TextEditingController _subjectNameController;

  @override
  void initState() {
    super.initState();
    _subjectIdController = TextEditingController(
      text: widget.subject.subjectId,
    );
    _subjectNameController = TextEditingController(
      text: widget.subject.subjectName,
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
      final subject = Subject(
        subjectId: _subjectIdController.text.trim(),
        subjectName: _subjectNameController.text.trim(),
      );
      widget.onEdit(subject);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sửa môn học'),
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
              enabled: false, // Don't allow editing subject ID
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _subjectNameController,
              decoration: const InputDecoration(
                labelText: 'Tên môn học',
                border: OutlineInputBorder(),
              ),
              validator: Validators.validateSubjectName,
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
