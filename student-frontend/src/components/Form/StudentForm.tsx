import React, { useState } from "react";
import Button from "../Button/Button";
import type { Student } from "../../types";
import { validateStudentId } from "../../utils";

interface StudentFormProps {
  student?: Student;
  onSubmit: (student: Omit<Student, "id">) => Promise<void>;
  onCancel: () => void;
  isLoading?: boolean;
}

const StudentForm: React.FC<StudentFormProps> = ({
  student,
  onSubmit,
  onCancel,
  isLoading = false,
}) => {
  const [formData, setFormData] = useState({
    studentId: student?.studentId || "",
    studentName: student?.studentName || "",
    birthYear: student?.birthYear || new Date().getFullYear() - 18,
  });

  const [errors, setErrors] = useState<Record<string, string>>({});

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    const newErrors: Record<string, string> = {};

    if (!formData.studentId.trim()) {
      newErrors.studentId = "Mã sinh viên là bắt buộc";
    } else if (!validateStudentId(formData.studentId)) {
      newErrors.studentId = "Mã sinh viên không hợp lệ (ví dụ: SV001)";
    }

    if (!formData.studentName.trim()) {
      newErrors.studentName = "Tên sinh viên là bắt buộc";
    }

    const currentYear = new Date().getFullYear();
    if (formData.birthYear < 1900 || formData.birthYear > currentYear) {
      newErrors.birthYear = `Năm sinh phải từ 1900 đến ${currentYear}`;
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

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div>
        <label
          htmlFor="studentId"
          className="block text-sm font-medium text-gray-700 mb-1"
        >
          Mã sinh viên
        </label>
        <input
          type="text"
          id="studentId"
          value={formData.studentId}
          onChange={(e) => handleChange("studentId", e.target.value)}
          className={`input-field ${errors.studentId ? "border-red-500" : ""}`}
          placeholder="VD: SV001"
          disabled={!!student} // Disable editing ID for existing students
        />
        {errors.studentId && (
          <p className="mt-1 text-sm text-red-600">{errors.studentId}</p>
        )}
      </div>

      <div>
        <label
          htmlFor="studentName"
          className="block text-sm font-medium text-gray-700 mb-1"
        >
          Tên sinh viên
        </label>
        <input
          type="text"
          id="studentName"
          value={formData.studentName}
          onChange={(e) => handleChange("studentName", e.target.value)}
          className={`input-field ${
            errors.studentName ? "border-red-500" : ""
          }`}
          placeholder="Nhập tên sinh viên"
        />
        {errors.studentName && (
          <p className="mt-1 text-sm text-red-600">{errors.studentName}</p>
        )}
      </div>

      <div>
        <label
          htmlFor="birthYear"
          className="block text-sm font-medium text-gray-700 mb-1"
        >
          Năm sinh
        </label>
        <input
          type="number"
          id="birthYear"
          value={formData.birthYear}
          onChange={(e) => handleChange("birthYear", parseInt(e.target.value))}
          className={`input-field ${errors.birthYear ? "border-red-500" : ""}`}
          min="1900"
          max={new Date().getFullYear()}
        />
        {errors.birthYear && (
          <p className="mt-1 text-sm text-red-600">{errors.birthYear}</p>
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
          {student ? "Cập nhật" : "Thêm mới"}
        </Button>
      </div>
    </form>
  );
};

export default StudentForm;
