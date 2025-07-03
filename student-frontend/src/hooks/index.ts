import { useState, useEffect } from 'react';
import { studentApi, subjectApi, gradeApi } from '../services/api';
import type { Student, Subject, Grade } from '../types';

export const useStudents = () => {
  const [students, setStudents] = useState<Student[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const fetchStudents = async () => {
    try {
      setLoading(true);
      setError(null);
      const response = await studentApi.getAllStudents();
      setStudents(response.data);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred');
    } finally {
      setLoading(false);
    }
  };

  const createStudent = async (student: Omit<Student, 'id'>) => {
    try {
      setLoading(true);
      const response = await studentApi.createStudent(student);
      setStudents(prev => [...prev, response.data]);
      return response.data;
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred');
      throw err;
    } finally {
      setLoading(false);
    }
  };

  const updateStudent = async (id: string, student: Omit<Student, 'id'>) => {
    try {
      setLoading(true);
      const response = await studentApi.updateStudent(id, student);
      setStudents(prev => prev.map(s => s.studentId === id ? response.data : s));
      return response.data;
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred');
      throw err;
    } finally {
      setLoading(false);
    }
  };

  const deleteStudent = async (id: string) => {
    try {
      setLoading(true);
      await studentApi.deleteStudent(id);
      setStudents(prev => prev.filter(s => s.studentId !== id));
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred');
      throw err;
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchStudents();
  }, []);

  return {
    students,
    loading,
    error,
    fetchStudents,
    createStudent,
    updateStudent,
    deleteStudent,
  };
};

export const useSubjects = () => {
  const [subjects, setSubjects] = useState<Subject[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const fetchSubjects = async () => {
    try {
      setLoading(true);
      setError(null);
      const response = await subjectApi.getAllSubjects();
      setSubjects(response.data);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred');
    } finally {
      setLoading(false);
    }
  };

  const createSubject = async (subject: Omit<Subject, 'id'>) => {
    try {
      setLoading(true);
      const response = await subjectApi.createSubject(subject);
      setSubjects(prev => [...prev, response.data]);
      return response.data;
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred');
      throw err;
    } finally {
      setLoading(false);
    }
  };

  const updateSubject = async (id: string, subject: Omit<Subject, 'id'>) => {
    try {
      setLoading(true);
      const response = await subjectApi.updateSubject(id, subject);
      setSubjects(prev => prev.map(s => s.subjectId === id ? response.data : s));
      return response.data;
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred');
      throw err;
    } finally {
      setLoading(false);
    }
  };

  const deleteSubject = async (id: string) => {
    try {
      setLoading(true);
      await subjectApi.deleteSubject(id);
      setSubjects(prev => prev.filter(s => s.subjectId !== id));
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred');
      throw err;
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchSubjects();
  }, []);

  return {
    subjects,
    loading,
    error,
    fetchSubjects,
    createSubject,
    updateSubject,
    deleteSubject,
  };
};

export const useGrades = () => {
  const [grades, setGrades] = useState<Grade[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const fetchGrades = async () => {
    try {
      setLoading(true);
      setError(null);
      const response = await gradeApi.getAllGrades();
      setGrades(response.data);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred');
    } finally {
      setLoading(false);
    }
  };

  const createGrade = async (grade: Omit<Grade, 'id'>) => {
    try {
      setLoading(true);
      const response = await gradeApi.createGrade(grade);
      setGrades(prev => [...prev, response.data]);
      return response.data;
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred');
      throw err;
    } finally {
      setLoading(false);
    }
  };

  const updateGrade = async (id: number, grade: Omit<Grade, 'id'>) => {
    try {
      setLoading(true);
      const response = await gradeApi.updateGrade(id, grade);
      setGrades(prev => prev.map(g => g.id === id ? response.data : g));
      return response.data;
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred');
      throw err;
    } finally {
      setLoading(false);
    }
  };

  const deleteGrade = async (id: number) => {
    try {
      setLoading(true);
      await gradeApi.deleteGrade(id);
      setGrades(prev => prev.filter(g => g.id !== id));
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred');
      throw err;
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchGrades();
  }, []);

  return {
    grades,
    loading,
    error,
    fetchGrades,
    createGrade,
    updateGrade,
    deleteGrade,
  };
};
