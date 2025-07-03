import 'package:flutter/material.dart';

/// Utility functions for UI formatting
class Formatters {
  /// Format grade score to display
  static String formatGrade(double score) {
    return score.toStringAsFixed(1);
  }

  /// Get grade color based on score
  static Color getGradeColor(double score) {
    if (score >= 8.5) return Colors.green;
    if (score >= 7.0) return Colors.blue;
    if (score >= 5.5) return Colors.orange;
    if (score >= 4.0) return Colors.red.shade300;
    return Colors.red;
  }

  /// Format age display
  static String formatAge(int age) {
    return '$age tuổi';
  }

  /// Format student year display
  static String formatStudentYear(int birthYear) {
    final currentYear = DateTime.now().year;
    final age = currentYear - birthYear;
    return 'Sinh năm $birthYear ($age tuổi)';
  }

  /// Capitalize first letter of each word
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;

    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  /// Format date for display
  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Format time for display
  static String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Format datetime for display
  static String formatDateTime(DateTime dateTime) {
    return '${formatDate(dateTime)} ${formatTime(dateTime)}';
  }
}
