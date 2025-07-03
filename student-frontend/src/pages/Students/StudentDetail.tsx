import React, { useState, useEffect } from "react";
import { useParams, Link, useNavigate } from "react-router-dom";
import { studentApi, gradeApi } from "../../services/api";
import type { Student, GradeDetail } from "../../types";
import { calculateAge, formatScore, getScoreColor } from "../../utils";
import Button from "../../components/Button/Button";
import Modal from "../../components/Modal/Modal";

const StudentDetailPage: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();

  const [student, setStudent] = useState<Student | null>(null);
  const [grades, setGrades] = useState<GradeDetail[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(false);
  const [averageScore, setAverageScore] = useState<number | null>(null);

  useEffect(() => {
    const fetchStudentData = async () => {
      if (!id) return;

      setLoading(true);
      try {
        const [studentRes, gradesRes] = await Promise.all([
          studentApi.getStudentById(id),
          gradeApi.getGradesByStudentId(id),
        ]);

        setStudent(studentRes.data);

        // Fetch subject names for each grade
        const gradesWithSubjects = await Promise.all(
          gradesRes.data.map(async (grade) => {
            try {
              const subjectRes = await fetch(
                `http://localhost:8080/api/subjects/${grade.subjectId}`
              );
              const subject = await subjectRes.json();
              return {
                ...grade,
                subjectName: subject.subjectName,
              };
            } catch {
              return {
                ...grade,
                subjectName: "Unknown Subject",
              };
            }
          })
        );

        setGrades(gradesWithSubjects);

        // Calculate average score
        if (gradesWithSubjects.length > 0) {
          const avg =
            gradesWithSubjects.reduce((sum, g) => sum + g.averageScore, 0) /
            gradesWithSubjects.length;
          setAverageScore(avg);
        }
      } catch (err) {
        setError("Không thể tải thông tin sinh viên");
        console.error("Error fetching student details:", err);
      } finally {
        setLoading(false);
      }
    };

    fetchStudentData();
  }, [id]);

  const handleDelete = async () => {
    if (!student) return;

    try {
      await studentApi.deleteStudent(student.studentId);
      navigate("/students");
    } catch (err) {
      setError("Không thể xóa sinh viên");
      console.error("Error deleting student:", err);
    }
  };

  if (loading) {
    return (
      <div className="flex justify-center items-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
      </div>
    );
  }

  if (error || !student) {
    return (
      <div className="bg-red-50 p-6 rounded-lg">
        <h2 className="text-red-800 text-lg font-medium">Đã xảy ra lỗi</h2>
        <p className="text-red-700 mt-1">
          {error || "Không tìm thấy sinh viên"}
        </p>
        <Link
          to="/students"
          className="mt-4 inline-block text-blue-600 hover:underline"
        >
          Quay lại danh sách sinh viên
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
              to="/students"
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
              Chi tiết sinh viên
            </h1>
          </div>
          <p className="mt-1 text-gray-500">Thông tin chi tiết về sinh viên</p>
        </div>
        <div className="flex space-x-2">
          <Link to={`/students/edit/${student.studentId}`}>
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
        {/* Student Info Card */}
        <div className="lg:col-span-1">
          <div className="bg-white shadow rounded-lg overflow-hidden">
            <div className="p-6 bg-primary-600 text-white">
              <div className="flex items-center">
                <div className="h-16 w-16 rounded-full bg-white text-primary-600 flex items-center justify-center text-2xl font-bold">
                  {student.studentName.charAt(0)}
                </div>
                <div className="ml-4">
                  <h2 className="text-xl font-semibold">
                    {student.studentName}
                  </h2>
                  <p className="text-primary-100">{student.studentId}</p>
                </div>
              </div>
            </div>

            <div className="p-6 space-y-4">
              <div>
                <h3 className="text-sm font-medium text-gray-500">
                  Thông tin sinh viên
                </h3>
                <div className="mt-2 grid grid-cols-1 gap-4">
                  <div>
                    <p className="text-sm font-medium text-gray-500">
                      Mã sinh viên
                    </p>
                    <p className="mt-1 text-base font-semibold">
                      {student.studentId}
                    </p>
                  </div>
                  <div>
                    <p className="text-sm font-medium text-gray-500">
                      Họ và tên
                    </p>
                    <p className="mt-1 text-base font-semibold">
                      {student.studentName}
                    </p>
                  </div>
                  <div>
                    <p className="text-sm font-medium text-gray-500">
                      Năm sinh
                    </p>
                    <p className="mt-1 text-base font-semibold">
                      {student.birthYear} (Tuổi:{" "}
                      {calculateAge(student.birthYear)})
                    </p>
                  </div>
                  <div>
                    <p className="text-sm font-medium text-gray-500">
                      Điểm trung bình
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
                <Link to={`/grades/add?studentId=${student.studentId}`}>
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
                    Sinh viên chưa có điểm số nào.
                  </p>
                </div>
              ) : (
                <div className="overflow-x-auto">
                  <table className="min-w-full divide-y divide-gray-200">
                    <thead className="bg-gray-50">
                      <tr>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                          Môn học
                        </th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                          Mã môn học
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
                            {grade.subjectName}
                          </td>
                          <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                            {grade.subjectId}
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
        title="Xác nhận xóa sinh viên"
        size="sm"
      >
        <div className="space-y-4">
          <p>
            Bạn có chắc chắn muốn xóa sinh viên{" "}
            <span className="font-semibold">{student.studentName}</span>? Tất cả
            điểm số liên quan đến sinh viên này sẽ bị xóa. Hành động này không
            thể hoàn tác.
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

export default StudentDetailPage;
