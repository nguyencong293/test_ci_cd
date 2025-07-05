import { studentApi, subjectApi, gradeApi } from './api';
import type { Student, Subject, Grade, GradeDetail } from '../types';

/**
 * Enhanced API service với helper methods để tránh code lặp lại
 */
export class EnhancedApiService {
  
  /**
   * Lấy grades của student với thông tin subject đầy đủ
   * Thay thế cho việc gọi nhiều API riêng lẻ
   */
  static async getStudentGradesWithSubjects(studentId: string): Promise<GradeDetail[]> {
    try {
      const [gradesRes, subjectsRes] = await Promise.all([
        gradeApi.getGradesByStudentId(studentId),
        subjectApi.getAllSubjects(),
      ]);

      const grades = gradesRes.data;
      const subjects = subjectsRes.data;

      // Map grades với subject names
      return grades.map(grade => {
        const subject = subjects.find(s => s.subjectId === grade.subjectId);
        return {
          ...grade,
          subjectName: subject?.subjectName || 'Unknown Subject',
        };
      });
    } catch (error) {
      console.error('Error fetching student grades with subjects:', error);
      throw error;
    }
  }

  /**
   * Lấy grades của subject với thông tin student đầy đủ
   */
  static async getSubjectGradesWithStudents(subjectId: string): Promise<GradeDetail[]> {
    try {
      const [gradesRes, studentsRes] = await Promise.all([
        gradeApi.getGradesBySubjectId(subjectId),
        studentApi.getAllStudents(),
      ]);

      const grades = gradesRes.data;
      const students = studentsRes.data;

      // Map grades với student names
      return grades.map(grade => {
        const student = students.find(s => s.studentId === grade.studentId);
        return {
          ...grade,
          studentName: student?.studentName || 'Unknown Student',
        };
      });
    } catch (error) {
      console.error('Error fetching subject grades with students:', error);
      throw error;
    }
  }

  /**
   * Lấy tất cả grades với thông tin student và subject đầy đủ
   */
  static async getAllGradesWithDetails(): Promise<GradeDetail[]> {
    try {
      const [gradesRes, studentsRes, subjectsRes] = await Promise.all([
        gradeApi.getAllGrades(),
        studentApi.getAllStudents(),
        subjectApi.getAllSubjects(),
      ]);

      const grades = gradesRes.data;
      const students = studentsRes.data;
      const subjects = subjectsRes.data;

      // Map grades với student và subject names
      return grades.map(grade => {
        const student = students.find(s => s.studentId === grade.studentId);
        const subject = subjects.find(s => s.subjectId === grade.subjectId);
        
        return {
          ...grade,
          studentName: student?.studentName || 'Unknown Student',
          subjectName: subject?.subjectName || 'Unknown Subject',
        };
      });
    } catch (error) {
      console.error('Error fetching all grades with details:', error);
      throw error;
    }
  }

  /**
   * Tính điểm trung bình của student
   */
  static async getStudentAverageScore(studentId: string): Promise<number> {
    try {
      const gradesRes = await gradeApi.getGradesByStudentId(studentId);
      const grades = gradesRes.data;
      
      if (grades.length === 0) return 0;
      
      const total = grades.reduce((sum, grade) => sum + grade.averageScore, 0);
      return total / grades.length;
    } catch (error) {
      console.error('Error calculating student average score:', error);
      return 0;
    }
  }

  /**
   * Tính điểm trung bình của subject
   */
  static async getSubjectAverageScore(subjectId: string): Promise<number> {
    try {
      const gradesRes = await gradeApi.getGradesBySubjectId(subjectId);
      const grades = gradesRes.data;
      
      if (grades.length === 0) return 0;
      
      const total = grades.reduce((sum, grade) => sum + grade.averageScore, 0);
      return total / grades.length;
    } catch (error) {
      console.error('Error calculating subject average score:', error);
      return 0;
    }
  }

  /**
   * Lấy thông tin student với grades đầy đủ
   */
  static async getStudentWithGrades(studentId: string): Promise<{
    student: Student;
    grades: GradeDetail[];
    averageScore: number;
  }> {
    try {
      const [studentRes, grades] = await Promise.all([
        studentApi.getStudentById(studentId),
        this.getStudentGradesWithSubjects(studentId),
      ]);

      const averageScore = grades.length > 0
        ? grades.reduce((sum, g) => sum + g.averageScore, 0) / grades.length
        : 0;

      return {
        student: studentRes.data,
        grades,
        averageScore,
      };
    } catch (error) {
      console.error('Error fetching student with grades:', error);
      throw error;
    }
  }

  /**
   * Lấy thông tin subject với grades đầy đủ
   */
  static async getSubjectWithGrades(subjectId: string): Promise<{
    subject: Subject;
    grades: GradeDetail[];
    averageScore: number;
  }> {
    try {
      const [subjectRes, grades] = await Promise.all([
        subjectApi.getSubjectById(subjectId),
        this.getSubjectGradesWithStudents(subjectId),
      ]);

      const averageScore = grades.length > 0
        ? grades.reduce((sum, g) => sum + g.averageScore, 0) / grades.length
        : 0;

      return {
        subject: subjectRes.data,
        grades,
        averageScore,
      };
    } catch (error) {
      console.error('Error fetching subject with grades:', error);
      throw error;
    }
  }

  /**
   * Enrich grades array with student and subject names
   * Utility để tránh code lặp lại trong components
   */
  static enrichGradesWithDetails(
    grades: Grade[], 
    students: Student[], 
    subjects: Subject[]
  ): GradeDetail[] {
    return grades.map(grade => {
      const student = students.find(s => s.studentId === grade.studentId);
      const subject = subjects.find(s => s.subjectId === grade.subjectId);
      return {
        ...grade,
        studentName: student?.studentName,
        subjectName: subject?.subjectName,
      };
    });
  }
}

export default EnhancedApiService;
