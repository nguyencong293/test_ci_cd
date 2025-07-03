import React, { useState } from "react";
import Button from "../Button/Button";
import type { Subject } from "../../types";
import { validateSubjectId } from "../../utils";

interface SubjectFormProps {
  subject?: Subject;
  onSubmit: (subject: Omit<Subject, "id">) => Promise<void>;
  onCancel: () => void;
  isLoading?: boolean;
}

const SubjectForm: React.FC<SubjectFormProps> = ({
  subject,
  onSubmit,
  onCancel,
  isLoading = false,
}) => {
  const [formData, setFormData] = useState({
    subjectId: subject?.subjectId || "",
    subjectName: subject?.subjectName || "",
  });

  const [errors, setErrors] = useState<Record<string, string>>({});

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    const newErrors: Record<string, string> = {};

    if (!formData.subjectId.trim()) {
      newErrors.subjectId = "Mã môn học là bắt buộc";
    } else if (!validateSubjectId(formData.subjectId)) {
      newErrors.subjectId = "Mã môn học không hợp lệ (ví dụ: MH001)";
    }

    if (!formData.subjectName.trim()) {
      newErrors.subjectName = "Tên môn học là bắt buộc";
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

  const handleChange = (field: string, value: string) => {
    setFormData((prev) => ({ ...prev, [field]: value }));
    if (errors[field]) {
      setErrors((prev) => ({ ...prev, [field]: "" }));
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div>
        <label
          htmlFor="subjectId"
          className="block text-sm font-medium text-gray-700 mb-1"
        >
          Mã môn học
        </label>
        <input
          type="text"
          id="subjectId"
          value={formData.subjectId}
          onChange={(e) => handleChange("subjectId", e.target.value)}
          className={`input-field ${errors.subjectId ? "border-red-500" : ""}`}
          placeholder="VD: MH001"
          disabled={!!subject} // Disable editing ID for existing subjects
        />
        {errors.subjectId && (
          <p className="mt-1 text-sm text-red-600">{errors.subjectId}</p>
        )}
      </div>

      <div>
        <label
          htmlFor="subjectName"
          className="block text-sm font-medium text-gray-700 mb-1"
        >
          Tên môn học
        </label>
        <input
          type="text"
          id="subjectName"
          value={formData.subjectName}
          onChange={(e) => handleChange("subjectName", e.target.value)}
          className={`input-field ${
            errors.subjectName ? "border-red-500" : ""
          }`}
          placeholder="Nhập tên môn học"
        />
        {errors.subjectName && (
          <p className="mt-1 text-sm text-red-600">{errors.subjectName}</p>
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
          {subject ? "Cập nhật" : "Thêm mới"}
        </Button>
      </div>
    </form>
  );
};

export default SubjectForm;
