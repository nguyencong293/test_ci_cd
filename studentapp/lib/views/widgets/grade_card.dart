import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../utils/utils.dart';

/// Card widget for displaying grade information
class GradeCard extends StatelessWidget {
  final Grade grade;
  final String? studentName;
  final String? subjectName;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const GradeCard({
    super.key,
    required this.grade,
    this.studentName,
    this.subjectName,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final gradeColor = Formatters.getGradeColor(grade.averageScore);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: gradeColor,
          child: Text(
            grade.letterGrade,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        title: Text(
          studentName ?? 'Student ${grade.studentId}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Môn: ${subjectName ?? grade.subjectId}'),
            Text(
              'Điểm: ${Formatters.formatGrade(grade.averageScore)}',
              style: TextStyle(color: gradeColor, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        trailing: onEdit != null || onDelete != null
            ? PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit' && onEdit != null) {
                    onEdit!();
                  } else if (value == 'delete' && onDelete != null) {
                    onDelete!();
                  }
                },
                itemBuilder: (context) => [
                  if (onEdit != null)
                    const PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Sửa'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  if (onDelete != null)
                    const PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete, color: Colors.red),
                        title: Text('Xóa', style: TextStyle(color: Colors.red)),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                ],
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
