import React, { useState } from "react";
import { useGrades, useStudents, useSubjects } from "../../hooks";
import type { Grade, GradeDetail } from "../../types";
import Table from "../../components/Table/Table";
import Button from "../../components/Button/Button";
import Modal from "../../components/Modal/Modal";
import GradeForm from "../../components/Form/GradeForm";
import { formatScore, getScoreColor } from "../../utils";

const GradesPage: React.FC = () => {
  const { grades, loading, error, createGrade, updateGrade, deleteGrade } =
    useGrades();
  const { students } = useStudents();
  const { subjects } = useSubjects();

  const [isAddModalOpen, setIsAddModalOpen] = useState(false);
  const [isEditModalOpen, setIsEditModalOpen] = useState(false);
  const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(false);
  const [currentGrade, setCurrentGrade] = useState<Grade | undefined>(
    undefined
  );
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [searchTerm, setSearchTerm] = useState("");

  const handleAddGrade = async (grade: Omit<Grade, "id">) => {
    setIsSubmitting(true);
    try {
      await createGrade(grade);
      setIsAddModalOpen(false);
    } catch (err) {
      console.error("Failed to add grade:", err);
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleEditGrade = async (grade: Omit<Grade, "id">) => {
    if (!currentGrade?.id) return;
    setIsSubmitting(true);
    try {
      await updateGrade(currentGrade.id, grade);
      setIsEditModalOpen(false);
    } catch (err) {
      console.error("Failed to update grade:", err);
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleDeleteConfirm = async () => {
    if (!currentGrade?.id) return;
    setIsSubmitting(true);
    try {
      await deleteGrade(currentGrade.id);
      setIsDeleteModalOpen(false);
    } catch (err) {
      console.error("Failed to delete grade:", err);
    } finally {
      setIsSubmitting(false);
    }
  };

  const openEditModal = (grade: Grade) => {
    setCurrentGrade(grade);
    setIsEditModalOpen(true);
  };

  const openDeleteModal = (grade: Grade) => {
    setCurrentGrade(grade);
    setIsDeleteModalOpen(true);
  };

  // Enrich grades with student and subject names
  const gradesWithDetails: GradeDetail[] = grades.map((grade) => {
    const student = students.find((s) => s.studentId === grade.studentId);
    const subject = subjects.find((s) => s.subjectId === grade.subjectId);
    return {
      ...grade,
      studentName: student?.studentName,
      subjectName: subject?.subjectName,
    };
  });

  const filteredGrades = gradesWithDetails.filter((grade) => {
    const studentName = grade.studentName || "";
    const subjectName = grade.subjectName || "";
    const searchTermLower = searchTerm.toLowerCase();

    return (
      grade.studentId.toLowerCase().includes(searchTermLower) ||
      studentName.toLowerCase().includes(searchTermLower) ||
      grade.subjectId.toLowerCase().includes(searchTermLower) ||
      subjectName.toLowerCase().includes(searchTermLower)
    );
  });

  const columns = [
    {
      key: "studentId",
      title: "Mã sinh viên",
      width: "15%",
    },
    {
      key: "studentName",
      title: "Tên sinh viên",
      width: "25%",
      render: (_: unknown, record: Record<string, unknown>) => {
        const grade = record as unknown as GradeDetail;
        return grade.studentName || "Unknown";
      },
    },
    {
      key: "subjectId",
      title: "Mã môn học",
      width: "15%",
    },
    {
      key: "subjectName",
      title: "Tên môn học",
      width: "20%",
      render: (_: unknown, record: Record<string, unknown>) => {
        const grade = record as unknown as GradeDetail;
        return grade.subjectName || "Unknown";
      },
    },
    {
      key: "averageScore",
      title: "Điểm",
      width: "10%",
      render: (_: unknown, record: Record<string, unknown>) => {
        const grade = record as unknown as Grade;
        return (
          <span className={`font-medium ${getScoreColor(grade.averageScore)}`}>
            {formatScore(grade.averageScore)}
          </span>
        );
      },
    },
    {
      key: "actions",
      title: "Thao tác",
      width: "15%",
      render: (_: unknown, record: Record<string, unknown>) => {
        const grade = record as unknown as Grade;
        return (
          <div className="flex space-x-2">
            <Button size="sm" onClick={() => openEditModal(grade)}>
              Sửa
            </Button>
            <Button
              size="sm"
              variant="danger"
              onClick={() => openDeleteModal(grade)}
            >
              Xóa
            </Button>
          </div>
        );
      },
    },
  ];

  if (error) {
    return (
      <div className="bg-red-50 p-4 rounded-md">
        <p className="text-red-700">Error: {error}</p>
      </div>
    );
  }

  const isDataLoading =
    loading || students.length === 0 || subjects.length === 0;

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Quản lý điểm số</h1>
          <p className="mt-1 text-gray-500">
            Quản lý điểm số của sinh viên theo từng môn học
          </p>
        </div>
        <Button onClick={() => setIsAddModalOpen(true)}>
          <svg
            className="h-5 w-5 mr-2"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth="2"
              d="M12 6v6m0 0v6m0-6h6m-6 0H6"
            />
          </svg>
          Thêm điểm
        </Button>
      </div>

      <div className="bg-white shadow rounded-lg p-6">
        <div className="mb-6">
          <div className="relative">
            <input
              type="text"
              placeholder="Tìm kiếm theo tên sinh viên, môn học..."
              className="input-field pl-10"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
            />
            <div className="absolute left-3 top-3 text-gray-400">
              <svg
                className="h-5 w-5"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth="2"
                  d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
                />
              </svg>
            </div>
          </div>
        </div>

        <Table
          columns={columns}
          data={filteredGrades as unknown as Record<string, unknown>[]}
          loading={isDataLoading}
          className="mt-4"
        />

        {/* Add Grade Modal */}
        <Modal
          isOpen={isAddModalOpen}
          onClose={() => setIsAddModalOpen(false)}
          title="Thêm điểm mới"
        >
          <GradeForm
            onSubmit={handleAddGrade}
            onCancel={() => setIsAddModalOpen(false)}
            isLoading={isSubmitting}
          />
        </Modal>

        {/* Edit Grade Modal */}
        <Modal
          isOpen={isEditModalOpen}
          onClose={() => setIsEditModalOpen(false)}
          title="Chỉnh sửa điểm"
        >
          {currentGrade && (
            <GradeForm
              grade={currentGrade}
              onSubmit={handleEditGrade}
              onCancel={() => setIsEditModalOpen(false)}
              isLoading={isSubmitting}
            />
          )}
        </Modal>

        {/* Delete Confirmation Modal */}
        <Modal
          isOpen={isDeleteModalOpen}
          onClose={() => setIsDeleteModalOpen(false)}
          title="Xác nhận xóa điểm"
          size="sm"
        >
          <div className="space-y-4">
            <p>
              Bạn có chắc chắn muốn xóa điểm này? Hành động này không thể hoàn
              tác.
            </p>
            <div className="flex justify-end space-x-3 pt-4">
              <Button
                type="button"
                variant="secondary"
                onClick={() => setIsDeleteModalOpen(false)}
                disabled={isSubmitting}
              >
                Hủy
              </Button>
              <Button
                type="button"
                variant="danger"
                onClick={handleDeleteConfirm}
                isLoading={isSubmitting}
              >
                Xóa
              </Button>
            </div>
          </div>
        </Modal>
      </div>
    </div>
  );
};

export default GradesPage;
