package com.company.student_backend.repository;

import com.company.student_backend.model.Grade;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Repository
public interface GradeRepository extends JpaRepository<Grade, Long> {

    List<Grade> findByStudentStudentId(String studentId);

    List<Grade> findBySubjectSubjectId(String subjectId);

    Optional<Grade> findByStudentStudentIdAndSubjectSubjectId(String studentId, String subjectId);

    @Query("SELECT g FROM Grade g JOIN FETCH g.student JOIN FETCH g.subject")
    List<Grade> findAllWithStudentAndSubject();

    @Query("SELECT g FROM Grade g WHERE g.averageScore >= :minScore")
    List<Grade> findByAverageScoreGreaterThanEqual(@Param("minScore") BigDecimal minScore);

    @Query("SELECT AVG(g.averageScore) FROM Grade g WHERE g.student.studentId = :studentId")
    BigDecimal findAverageScoreByStudentId(@Param("studentId") String studentId);

    @Query("SELECT AVG(g.averageScore) FROM Grade g WHERE g.subject.subjectId = :subjectId")
    BigDecimal findAverageScoreBySubjectId(@Param("subjectId") String subjectId);

    boolean existsByStudentStudentIdAndSubjectSubjectId(String studentId, String subjectId);
}