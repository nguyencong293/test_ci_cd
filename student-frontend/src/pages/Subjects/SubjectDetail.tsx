import React, { useState, useEffect } from "react";
import { useParams, Link, useNavigate } from "react-router-dom";
import { subjectApi, gradeApi } from "../../services/api";
import type { Subject, GradeDetail } from "../../types";
import { formatScore, getScoreColor } from "../../utils";
import Button from "../../components/Button/Button";
import Modal from "../../components/Modal/Modal";

const SubjectDetailPage: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();

  const [subject, setSubject] = useState<Subject | null>(null);
  const [grades, setGrades] = useState<GradeDetail[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(false);
  const [averageScore, setAverageScore] = useState<number | null>(null);

  useEffect(() => {
    const fetchSubjectData = async () => {
      if (!id) return;

      setLoading(true);
      try {
        const [subjectRes, gradesRes] = await Promise.all([
          subjectApi.getSubjectById(id),
          gradeApi.getGradesBySubjectId(id),
        ]);

        setSubject(subjectRes.data);

        // Fetch student names for each grade
        const gradesWithStudents = await Promise.all(
          gradesRes.data.map(async (grade) => {
            try {
              const studentRes = await fetch(
                `http://localhost:8080/api/students/${grade.studentId}`
              );
              const student = await studentRes.json();
              return {
                ...grade,
                studentName: student.studentName,
              };
            } catch {
              return {
                ...grade,
                studentName: "Unknown Student",
              };
            }
          })
        );

        setGrades(gradesWithStudents);

        // Calculate average score
        if (gradesWithStudents.length > 0) {
          const avg =
            gradesWithStudents.reduce((sum, g) => sum + g.averageScore, 0) /
            gradesWithStudents.length;
          setAverageScore(avg);
        }
      } catch (err) {
        setError("Không thể tải thông tin môn học");
        console.error("Error fetching subject details:", err);
      } finally {
        setLoading(false);
      }
    };

    fetchSubjectData();
  }, [id]);

  const handleDelete = async () => {
    if (!subject) return;

    try {
      await subjectApi.deleteSubject(subject.subjectId);
      navigate("/subjects");
    } catch (err) {
      setError("Không thể xóa môn học");
      console.error("Error deleting subject:", err);
    }
  };

  if (loading) {
    return (
      <div className="flex justify-center items-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
      </div>
    );
  }

  if (error || !subject) {
    return (
      <div className="bg-red-50 p-6 rounded-lg">
        <h2 className="text-red-800 text-lg font-medium">Đã xảy ra lỗi</h2>
        <p className="text-red-700 mt-1">{error || "Không tìm thấy môn học"}</p>
        <Link
          to="/subjects"
          className="mt-4 inline-block text-blue-600 hover:underline"
        >
          Quay lại danh sách môn học
        </Link>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <div className="flex items-center">
            <Link
              to="/subjects"
              className="text-blue-600 hover:text-blue-800 mr-2"
            >
              <svg
                className="h-5 w-5"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M10 19l-7-7m0 0l7-7m-7 7h18"
                />
              </svg>
            </Link>
            <h1 className="text-2xl font-bold text-gray-900">
              Chi tiết môn học
            </h1>
          </div>
          <p className="mt-1 text-gray-500">Thông tin chi tiết về môn học</p>
        </div>
        <div className="flex space-x-2">
          <Link to={`/subjects/edit/${subject.subjectId}`}>
            <Button>
              <svg
                className="h-5 w-5 mr-2"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
                />
              </svg>
              Chỉnh sửa
            </Button>
          </Link>
          <Button variant="danger" onClick={() => setIsDeleteModalOpen(true)}>
            <svg
              className="h-5 w-5 mr-2"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
              />
            </svg>
            Xóa
          </Button>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Subject Info Card */}
        <div className="lg:col-span-1">
          <div className="bg-white shadow rounded-lg overflow-hidden">
            <div className="p-6 bg-yellow-600 text-white">
              <div className="flex items-center">
                <div className="h-16 w-16 rounded-full bg-white text-yellow-600 flex items-center justify-center text-2xl font-bold">
                  {subject.subjectName.charAt(0)}
                </div>
                <div className="ml-4">
                  <h2 className="text-xl font-semibold">
                    {subject.subjectName}
                  </h2>
                  <p className="text-yellow-100">{subject.subjectId}</p>
                </div>
              </div>
            </div>

            <div className="p-6 space-y-4">
              <div>
                <h3 className="text-sm font-medium text-gray-500">
                  Thông tin môn học
                </h3>
                <div className="mt-2 grid grid-cols-1 gap-4">
                  <div>
                    <p className="text-sm font-medium text-gray-500">
                      Mã môn học
                    </p>
                    <p className="mt-1 text-base font-semibold">
                      {subject.subjectId}
                    </p>
                  </div>
                  <div>
                    <p className="text-sm font-medium text-gray-500">
                      Tên môn học
                    </p>
                    <p className="mt-1 text-base font-semibold">
                      {subject.subjectName}
                    </p>
                  </div>
                  <div>
                    <p className="text-sm font-medium text-gray-500">
                      Số lượng sinh viên đã học
                    </p>
                    <p className="mt-1 text-base font-semibold">
                      {grades.length}
                    </p>
                  </div>
                  <div>
                    <p className="text-sm font-medium text-gray-500">
                      Điểm trung bình môn học
                    </p>
                    <p
                      className={`mt-1 text-base font-semibold ${
                        averageScore !== null ? getScoreColor(averageScore) : ""
                      }`}
                    >
                      {averageScore !== null
                        ? formatScore(averageScore)
                        : "Chưa có điểm"}
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Grades Card */}
        <div className="lg:col-span-2">
          <div className="bg-white shadow rounded-lg overflow-hidden">
            <div className="px-6 py-4 border-b border-gray-200">
              <div className="flex justify-between items-center">
                <h2 className="text-lg font-semibold text-gray-900">
                  Bảng điểm
                </h2>
                <Link to={`/grades/add?subjectId=${subject.subjectId}`}>
                  <Button size="sm">
                    <svg
                      className="h-4 w-4 mr-1"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth={2}
                        d="M12 6v6m0 0v6m0-6h6m-6 0H6"
                      />
                    </svg>
                    Thêm điểm
                  </Button>
                </Link>
              </div>
            </div>

            <div className="p-6">
              {grades.length === 0 ? (
                <div className="text-center py-6">
                  <svg
                    className="mx-auto h-12 w-12 text-gray-400"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"
                    />
                  </svg>
                  <h3 className="mt-2 text-sm font-medium text-gray-900">
                    Không có điểm
                  </h3>
                  <p className="mt-1 text-sm text-gray-500">
                    Chưa có sinh viên nào học môn này.
                  </p>
                </div>
              ) : (
                <div className="overflow-x-auto">
                  <table className="min-w-full divide-y divide-gray-200">
                    <thead className="bg-gray-50">
                      <tr>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                          Sinh viên
                        </th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                          Mã sinh viên
                        </th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                          Điểm
                        </th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                          Thao tác
                        </th>
                      </tr>
                    </thead>
                    <tbody className="bg-white divide-y divide-gray-200">
                      {grades.map((grade) => (
                        <tr key={grade.id} className="hover:bg-gray-50">
                          <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                            {grade.studentName}
                          </td>
                          <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                            {grade.studentId}
                          </td>
                          <td className="px-6 py-4 whitespace-nowrap">
                            <span
                              className={`font-medium ${getScoreColor(
                                grade.averageScore
                              )}`}
                            >
                              {formatScore(grade.averageScore)}
                            </span>
                          </td>
                          <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                            <Link
                              to={`/grades/edit/${grade.id}`}
                              className="text-indigo-600 hover:text-indigo-900 mr-4"
                            >
                              Sửa
                            </Link>
                            <button
                              className="text-red-600 hover:text-red-900"
                              onClick={() => {
                                /* Handle delete grade */
                              }}
                            >
                              Xóa
                            </button>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>

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
            <span className="font-semibold">{subject.subjectName}</span>? Tất cả
            điểm số liên quan đến môn học này sẽ bị xóa. Hành động này không thể
            hoàn tác.
          </p>
          <div className="flex justify-end space-x-3 pt-4">
            <Button
              type="button"
              variant="secondary"
              onClick={() => setIsDeleteModalOpen(false)}
            >
              Hủy
            </Button>
            <Button type="button" variant="danger" onClick={handleDelete}>
              Xóa
            </Button>
          </div>
        </div>
      </Modal>
    </div>
  );
};

export default SubjectDetailPage;
