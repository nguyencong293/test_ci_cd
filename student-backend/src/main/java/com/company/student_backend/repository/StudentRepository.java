package com.company.student_backend.repository;

import com.company.student_backend.model.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface StudentRepository extends JpaRepository<Student, String> {

    List<Student> findByStudentNameContainingIgnoreCase(String name);

    List<Student> findByBirthYear(Integer birthYear);

    @Query("SELECT s FROM Student s LEFT JOIN FETCH s.grades g LEFT JOIN FETCH g.subject WHERE s.studentId = :studentId")
    Optional<Student> findByIdWithGrades(@Param("studentId") String studentId);

    @Query("SELECT s FROM Student s WHERE s.birthYear BETWEEN :startYear AND :endYear")
    List<Student> findByBirthYearBetween(@Param("startYear") Integer startYear, @Param("endYear") Integer endYear);

    boolean existsByStudentId(String studentId);
}
