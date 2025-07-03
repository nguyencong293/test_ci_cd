import React from "react";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import App from "../App";
import HomePage from "../pages/Home/Home";
import StudentsPage from "../pages/Students/Students";
import StudentDetailPage from "../pages/Students/StudentDetail";
import SubjectsPage from "../pages/Subjects/Subjects";
import SubjectDetailPage from "../pages/Subjects/SubjectDetail";
import GradesPage from "../pages/Grades/Grades";
import NotFoundPage from "../pages/NotFound";

const AppRoutes: React.FC = () => {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<App />}>
          <Route index element={<HomePage />} />
          <Route path="students" element={<StudentsPage />} />
          <Route path="students/:id" element={<StudentDetailPage />} />
          <Route path="subjects" element={<SubjectsPage />} />
          <Route path="subjects/:id" element={<SubjectDetailPage />} />
          <Route path="grades" element={<GradesPage />} />
        </Route>
        <Route path="*" element={<NotFoundPage />} />
      </Routes>
    </BrowserRouter>
  );
};

export default AppRoutes;
