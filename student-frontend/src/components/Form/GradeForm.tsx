import React, { useState, useEffect } from "react";
import Button from "../Button/Button";
import type { Grade, Student, Subject } from "../../types";
import { validateScore } from "../../utils";
import { studentApi, subjectApi } from "../../services/api";

interface GradeFormProps {
  grade?: Grade;
  onSubmit: (grade: Omit<Grade, "id">) => Promise<void>;
  onCancel: () => void;
  isLoading?: boolean;
}

const GradeForm: React.FC<GradeFormProps> = ({
  grade,
  onSubmit,
  onCancel,
  isLoading = false,
}) => {
  const [formData, setFormData] = useState({
    studentId: grade?.studentId || "",
    subjectId: grade?.subjectId || "",
    averageScore: grade?.averageScore || 0,
  });

  const [students, setStudents] = useState<Student[]>([]);
  const [subjects, setSubjects] = useState<Subject[]>([]);
  const [loadingData, setLoadingData] = useState(true);
  const [errors, setErrors] = useState<Record<string, string>>({});

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [studentsRes, subjectsRes] = await Promise.all([
          studentApi.getAllStudents(),
          subjectApi.getAllSubjects(),
        ]);
        setStudents(studentsRes.data);
        setSubjects(subjectsRes.data);
      } catch (error) {
        console.error("Error fetching data:", error);
      } finally {
        setLoadingData(false);
      }
    };

    fetchData();
  }, []);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    const newErrors: Record<string, string> = {};

    if (!formData.studentId) {
      newErrors.studentId = "Vui lòng chọn sinh viên";
    }

    if (!formData.subjectId) {
      newErrors.subjectId = "Vui lòng chọn môn học";
    }

    if (!validateScore(formData.averageScore)) {
      newErrors.averageScore = "Điểm phải từ 0 đến 10";
    }

    setErrors(newErrors);

    if (Object.keys(newErrors).length === 0) {
      try {
        await onSubmit(formData);
      } catch {
        // Error handling is done in the parent component
      }
    }
  };

  const handleChange = (field: string, value: string | number) => {
    setFormData((prev) => ({ ...prev, [field]: value }));
    if (errors[field]) {
      setErrors((prev) => ({ ...prev, [field]: "" }));
    }
  };

  if (loadingData) {
    return (
      <div className="flex items-center justify-center py-8">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-600"></div>
      </div>
    );
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div>
        <label
          htmlFor="studentId"
          className="block text-sm font-medium text-gray-700 mb-1"
        >
          Sinh viên
        </label>
        <select
          id="studentId"
          value={formData.studentId}
          onChange={(e) => handleChange("studentId", e.target.value)}
          className={`input-field ${errors.studentId ? "border-red-500" : ""}`}
          disabled={!!grade} // Disable editing for existing grades
        >
          <option value="">Chọn sinh viên</option>
          {students.map((student) => (
            <option key={student.studentId} value={student.studentId}>
              {student.studentId} - {student.studentName}
            </option>
          ))}
        </select>
        {errors.studentId && (
          <p className="mt-1 text-sm text-red-600">{errors.studentId}</p>
        )}
      </div>

      <div>
        <label
          htmlFor="subjectId"
          className="block text-sm font-medium text-gray-700 mb-1"
        >
          Môn học
        </label>
        <select
          id="subjectId"
          value={formData.subjectId}
          onChange={(e) => handleChange("subjectId", e.target.value)}
          className={`input-field ${errors.subjectId ? "border-red-500" : ""}`}
          disabled={!!grade} // Disable editing for existing grades
        >
          <option value="">Chọn môn học</option>
          {subjects.map((subject) => (
            <option key={subject.subjectId} value={subject.subjectId}>
              {subject.subjectId} - {subject.subjectName}
            </option>
          ))}
        </select>
        {errors.subjectId && (
          <p className="mt-1 text-sm text-red-600">{errors.subjectId}</p>
        )}
      </div>

      <div>
        <label
          htmlFor="averageScore"
          className="block text-sm font-medium text-gray-700 mb-1"
        >
          Điểm trung bình
        </label>
        <input
          type="number"
          id="averageScore"
          value={formData.averageScore}
          onChange={(e) =>
            handleChange("averageScore", parseFloat(e.target.value))
          }
          className={`input-field ${
            errors.averageScore ? "border-red-500" : ""
          }`}
          min="0"
          max="10"
          step="0.1"
          placeholder="0.0"
        />
        {errors.averageScore && (
          <p className="mt-1 text-sm text-red-600">{errors.averageScore}</p>
        )}
      </div>

      <div className="flex justify-end space-x-3 pt-4">
        <Button
          type="button"
          variant="secondary"
          onClick={onCancel}
          disabled={isLoading}
        >
          Hủy
        </Button>
        <Button type="submit" variant="primary" isLoading={isLoading}>
          {grade ? "Cập nhật" : "Thêm mới"}
        </Button>
      </div>
    </form>
  );
};

export default GradeForm;
