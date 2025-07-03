import axios from 'axios';
import type { Student, Subject, Grade, SearchParams } from '../types';

const API_BASE_URL = 'http://localhost:8080/api';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor
api.interceptors.request.use(
  (config) => {
    // Add auth token if needed
    const token = localStorage.getItem('token');
    if (token) {
      config.headers = config.headers || {};
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor
api.interceptors.response.use(
  (response) => {
    return response;
  },
  (error) => {
    // Handle common errors
    if (error.response?.status === 401) {
      // Handle unauthorized
      localStorage.removeItem('token');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

// Student API
export const studentApi = {
  getAllStudents: () => api.get<Student[]>('/students'),
  getStudentById: (id: string) => api.get<Student>(`/students/${id}`),
  createStudent: (student: Omit<Student, 'id'>) => api.post<Student>('/students', student),
  updateStudent: (id: string, student: Omit<Student, 'id'>) => api.put<Student>(`/students/${id}`, student),
  deleteStudent: (id: string) => api.delete(`/students/${id}`),
  searchStudents: (params: SearchParams) => api.get<Student[]>('/students/search', { params }),
  getStudentsByBirthYear: (year: number) => api.get<Student[]>(`/students/birth-year/${year}`),
};

// Subject API
export const subjectApi = {
  getAllSubjects: () => api.get<Subject[]>('/subjects'),
  getSubjectById: (id: string) => api.get<Subject>(`/subjects/${id}`),
  createSubject: (subject: Omit<Subject, 'id'>) => api.post<Subject>('/subjects', subject),
  updateSubject: (id: string, subject: Omit<Subject, 'id'>) => api.put<Subject>(`/subjects/${id}`, subject),
  deleteSubject: (id: string) => api.delete(`/subjects/${id}`),
  searchSubjects: (params: SearchParams) => api.get<Subject[]>('/subjects/search', { params }),
};

// Grade API
export const gradeApi = {
  getAllGrades: () => api.get<Grade[]>('/grades'),
  getGradeById: (id: number) => api.get<Grade>(`/grades/${id}`),
  createGrade: (grade: Omit<Grade, 'id'>) => api.post<Grade>('/grades', grade),
  updateGrade: (id: number, grade: Omit<Grade, 'id'>) => api.put<Grade>(`/grades/${id}`, grade),
  deleteGrade: (id: number) => api.delete(`/grades/${id}`),
  getGradesByStudentId: (studentId: string) => api.get<Grade[]>(`/grades/student/${studentId}`),
  getGradesBySubjectId: (subjectId: string) => api.get<Grade[]>(`/grades/subject/${subjectId}`),
  getAverageScoreByStudentId: (studentId: string) => api.get<{ averageScore: number }>(`/grades/student/${studentId}/average`),
  getAverageScoreBySubjectId: (subjectId: string) => api.get<{ averageScore: number }>(`/grades/subject/${subjectId}/average`),
};

export default api;
