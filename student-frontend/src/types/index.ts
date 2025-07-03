export interface Student {
  studentId: string;
  studentName: string;
  birthYear: number;
}

export interface Subject {
  subjectId: string;
  subjectName: string;
}

export interface Grade {
  id?: number;
  studentId: string;
  subjectId: string;
  averageScore: number;
}

export interface StudentWithGrades extends Student {
  grades?: Grade[];
  averageScore?: number;
}

export interface SubjectWithGrades extends Subject {
  grades?: Grade[];
  averageScore?: number;
}

export interface GradeDetail extends Grade {
  studentName?: string;
  subjectName?: string;
}

export interface ApiResponse<T> {
  success: boolean;
  data: T;
  message?: string;
}

export interface PaginationParams {
  page?: number;
  size?: number;
  sort?: string;
}

export interface SearchParams {
  name?: string;
  year?: number;
}
