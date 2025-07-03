import React, { useState } from "react";
import { useSubjects } from "../../hooks";
import type { Subject } from "../../types";
import Table from "../../components/Table/Table";
import Button from "../../components/Button/Button";
import Modal from "../../components/Modal/Modal";
import SubjectForm from "../../components/Form/SubjectForm";
import { Link } from "react-router-dom";

const SubjectsPage: React.FC = () => {
  const {
    subjects,
    loading,
    error,
    createSubject,
    updateSubject,
    deleteSubject,
  } = useSubjects();

  const [isAddModalOpen, setIsAddModalOpen] = useState(false);
  const [isEditModalOpen, setIsEditModalOpen] = useState(false);
  const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(false);
  const [currentSubject, setCurrentSubject] = useState<Subject | undefined>(
    undefined
  );
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [searchTerm, setSearchTerm] = useState("");

  const handleAddSubject = async (subject: Omit<Subject, "id">) => {
    setIsSubmitting(true);
    try {
      await createSubject(subject);
      setIsAddModalOpen(false);
    } catch (err) {
      console.error("Failed to add subject:", err);
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleEditSubject = async (subject: Omit<Subject, "id">) => {
    if (!currentSubject) return;
    setIsSubmitting(true);
    try {
      await updateSubject(currentSubject.subjectId, subject);
      setIsEditModalOpen(false);
    } catch (err) {
      console.error("Failed to update subject:", err);
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleDeleteConfirm = async () => {
    if (!currentSubject) return;
    setIsSubmitting(true);
    try {
      await deleteSubject(currentSubject.subjectId);
      setIsDeleteModalOpen(false);
    } catch (err) {
      console.error("Failed to delete subject:", err);
    } finally {
      setIsSubmitting(false);
    }
  };

  const openEditModal = (subject: Subject) => {
    setCurrentSubject(subject);
    setIsEditModalOpen(true);
  };

  const openDeleteModal = (subject: Subject) => {
    setCurrentSubject(subject);
    setIsDeleteModalOpen(true);
  };

  const filteredSubjects = subjects.filter(
    (subject) =>
      subject.subjectId.toLowerCase().includes(searchTerm.toLowerCase()) ||
      subject.subjectName.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const columns = [
    { key: "subjectId", title: "Mã môn học", width: "20%" },
    { key: "subjectName", title: "Tên môn học", width: "50%" },
    {
      key: "actions",
      title: "Thao tác",
      width: "30%",
      render: (_: unknown, record: Record<string, unknown>) => {
        const subject = record as unknown as Subject;
        return (
          <div className="flex space-x-2">
            <Link to={`/subjects/${subject.subjectId}`}>
              <Button size="sm" variant="secondary">
                Chi tiết
              </Button>
            </Link>
            <Button size="sm" onClick={() => openEditModal(subject)}>
              Sửa
            </Button>
            <Button
              size="sm"
              variant="danger"
              onClick={() => openDeleteModal(subject)}
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
            Danh sách môn học
          </h1>
          <p className="mt-1 text-gray-500">
            Quản lý thông tin môn học trong hệ thống
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
          Thêm môn học
        </Button>
      </div>

      <div className="bg-white shadow rounded-lg p-6">
        <div className="mb-6">
          <div className="relative">
            <input
              type="text"
              placeholder="Tìm kiếm môn học..."
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
          data={filteredSubjects as unknown as Record<string, unknown>[]}
          loading={loading}
          className="mt-4"
        />

        {/* Add Subject Modal */}
        <Modal
          isOpen={isAddModalOpen}
          onClose={() => setIsAddModalOpen(false)}
          title="Thêm môn học mới"
        >
          <SubjectForm
            onSubmit={handleAddSubject}
            onCancel={() => setIsAddModalOpen(false)}
            isLoading={isSubmitting}
          />
        </Modal>

        {/* Edit Subject Modal */}
        <Modal
          isOpen={isEditModalOpen}
          onClose={() => setIsEditModalOpen(false)}
          title="Chỉnh sửa môn học"
        >
          {currentSubject && (
            <SubjectForm
              subject={currentSubject}
              onSubmit={handleEditSubject}
              onCancel={() => setIsEditModalOpen(false)}
              isLoading={isSubmitting}
            />
          )}
        </Modal>

        {/* Delete Confirmation Modal */}
        <Modal
          isOpen={isDeleteModalOpen}
          onClose={() => setIsDeleteModalOpen(false)}
          title="Xác nhận xóa môn học"
          size="sm"
        >
          <div className="space-y-4">
            <p>
              Bạn có chắc chắn muốn xóa môn học{" "}
              <span className="font-semibold">
                {currentSubject?.subjectName}
              </span>
              ? Hành động này không thể hoàn tác và sẽ xóa tất cả điểm số liên
              quan đến môn học này.
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

export default SubjectsPage;
