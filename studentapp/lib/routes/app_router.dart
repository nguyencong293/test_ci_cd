import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/screens/onboarding_screen.dart';
import '../views/screens/home_screen.dart';
import '../views/screens/students_screen.dart';
import '../views/screens/subjects_screen.dart';
import '../views/screens/grades_screen.dart';

/// App router configuration and route constants
class AppRouter {
  // Private constructor để prevent instantiation
  AppRouter._();

  // ==================== Route Constants ====================
  static const String onboarding = '/onboarding';
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

  // ==================== Helper Methods ====================
  /// Generate student detail route with ID
  static String generateStudentDetailRoute(String id) =>
      studentDetail.replaceAll(':id', id);

  /// Generate subject detail route with ID
  static String generateSubjectDetailRoute(String id) =>
      subjectDetail.replaceAll(':id', id);

  /// Generate grade detail route with ID
  static String generateGradeDetailRoute(String id) =>
      gradeDetail.replaceAll(':id', id);

  /// Generate edit student route with ID
  static String generateEditStudentRoute(String id) =>
      editStudent.replaceAll(':id', id);

  /// Generate edit subject route with ID
  static String generateEditSubjectRoute(String id) =>
      editSubject.replaceAll(':id', id);

  /// Generate edit grade route with ID
  static String generateEditGradeRoute(String id) =>
      editGrade.replaceAll(':id', id);

  // ==================== Router Configuration ====================
  static late final GoRouter _router;

  static GoRouter get router => _router;

  /// Initialize the router configuration
  static void initialize() {
    _router = GoRouter(
      initialLocation: home,
      redirect: _handleRedirect,
      routes: _buildRoutes(),
      errorBuilder: _buildErrorPage,
    );
  }

  /// Build all routes
  static List<RouteBase> _buildRoutes() {
    return [
      GoRoute(
        path: onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: students,
        name: 'students',
        builder: (context, state) => const StudentsScreen(),
      ),
      GoRoute(
        path: subjects,
        name: 'subjects',
        builder: (context, state) => const SubjectsScreen(),
      ),
      GoRoute(
        path: grades,
        name: 'grades',
        builder: (context, state) => const GradesScreen(),
      ),
    ];
  }

  /// Build error page
  static Widget _buildErrorPage(BuildContext context, GoRouterState state) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Trang không tìm thấy',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Đường dẫn: ${state.uri}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(home),
              child: const Text('Về trang chủ'),
            ),
          ],
        ),
      ),
    );
  }

  /// Handle redirect logic for onboarding
  static Future<String?> _handleRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('onboarding_completed') ?? false;
    final currentPath = state.uri.toString();

    // Chưa xem onboarding → redirect to onboarding
    if (!hasSeenOnboarding && currentPath != onboarding) {
      return onboarding;
    }

    // Đã xem onboarding nhưng vẫn ở onboarding → redirect to home
    if (hasSeenOnboarding && currentPath == onboarding) {
      return home;
    }

    return null; // No redirect needed
  }
}
