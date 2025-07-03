import React, { useState } from "react";
import { useStudents } from "../../hooks";
import type { Student } from "../../types";
import Table from "../../components/Table/Table";
import Button from "../../components/Button/Button";
import Modal from "../../components/Modal/Modal";
import StudentForm from "../../components/Form/StudentForm";
import { calculateAge } from "../../utils";
import { Link } from "react-router-dom";

const StudentsPage: React.FC = () => {
  const {
    students,
    loading,
    error,
    createStudent,
    updateStudent,
    deleteStudent,
  } = useStudents();

  const [isAddModalOpen, setIsAddModalOpen] = useState(false);
  const [isEditModalOpen, setIsEditModalOpen] = useState(false);
  const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(false);
  const [currentStudent, setCurrentStudent] = useState<Student | undefined>(
    undefined
  );
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [searchTerm, setSearchTerm] = useState("");

  const handleAddStudent = async (student: Omit<Student, "id">) => {
    setIsSubmitting(true);
    try {
      await createStudent(student);
      setIsAddModalOpen(false);
    } catch (err) {
      console.error("Failed to add student:", err);
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleEditStudent = async (student: Omit<Student, "id">) => {
    if (!currentStudent) return;
    setIsSubmitting(true);
    try {
      await updateStudent(currentStudent.studentId, student);
      setIsEditModalOpen(false);
    } catch (err) {
      console.error("Failed to update student:", err);
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleDeleteConfirm = async () => {
    if (!currentStudent) return;
    setIsSubmitting(true);
    try {
      await deleteStudent(currentStudent.studentId);
      setIsDeleteModalOpen(false);
    } catch (err) {
      console.error("Failed to delete student:", err);
    } finally {
      setIsSubmitting(false);
    }
  };

  const openEditModal = (student: Student) => {
    setCurrentStudent(student);
    setIsEditModalOpen(true);
  };

  const openDeleteModal = (student: Student) => {
    setCurrentStudent(student);
    setIsDeleteModalOpen(true);
  };

  const filteredStudents = students.filter(
    (student) =>
      student.studentId.toLowerCase().includes(searchTerm.toLowerCase()) ||
      student.studentName.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const columns = [
    { key: "studentId", title: "Mã sinh viên", width: "15%" },
    { key: "studentName", title: "Họ và tên", width: "40%" },
    {
      key: "birthYear",
      title: "Tuổi",
      width: "15%",
      render: (_: unknown, record: Record<string, unknown>) => {
        const student = record as unknown as Student;
        return calculateAge(student.birthYear);
      },
    },
    {
      key: "actions",
      title: "Thao tác",
      width: "30%",
      render: (_: unknown, record: Record<string, unknown>) => {
        const student = record as unknown as Student;
        return (
          <div className="flex space-x-2">
            <Link to={`/students/${student.studentId}`}>
              <Button size="sm" variant="secondary">
                Chi tiết
              </Button>
            </Link>
            <Button size="sm" onClick={() => openEditModal(student)}>
              Sửa
            </Button>
            <Button
              size="sm"
              variant="danger"
              onClick={() => openDeleteModal(student)}
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

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">
            Danh sách sinh viên
          </h1>
          <p className="mt-1 text-gray-500">
            Quản lý thông tin sinh viên trong hệ thống
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
          Thêm sinh viên
        </Button>
      </div>

      <div className="bg-white shadow rounded-lg p-6">
        <div className="mb-6">
          <div className="relative">
            <input
              type="text"
              placeholder="Tìm kiếm sinh viên..."
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
          data={filteredStudents as unknown as Record<string, unknown>[]}
          loading={loading}
          className="mt-4"
        />

        {/* Add Student Modal */}
        <Modal
          isOpen={isAddModalOpen}
          onClose={() => setIsAddModalOpen(false)}
          title="Thêm sinh viên mới"
        >
          <StudentForm
            onSubmit={handleAddStudent}
            onCancel={() => setIsAddModalOpen(false)}
            isLoading={isSubmitting}
          />
        </Modal>

        {/* Edit Student Modal */}
        <Modal
          isOpen={isEditModalOpen}
          onClose={() => setIsEditModalOpen(false)}
          title="Chỉnh sửa sinh viên"
        >
          {currentStudent && (
            <StudentForm
              student={currentStudent}
              onSubmit={handleEditStudent}
              onCancel={() => setIsEditModalOpen(false)}
              isLoading={isSubmitting}
            />
          )}
        </Modal>

        {/* Delete Confirmation Modal */}
        <Modal
          isOpen={isDeleteModalOpen}
          onClose={() => setIsDeleteModalOpen(false)}
          title="Xác nhận xóa sinh viên"
          size="sm"
        >
          <div className="space-y-4">
            <p>
              Bạn có chắc chắn muốn xóa sinh viên{" "}
              <span className="font-semibold">
                {currentStudent?.studentName}
              </span>
              ? Hành động này không thể hoàn tác.
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

export default StudentsPage;
