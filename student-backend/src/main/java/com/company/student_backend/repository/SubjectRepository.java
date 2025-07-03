package com.company.student_backend.repository;

import com.company.student_backend.model.Subject;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SubjectRepository extends JpaRepository<Subject, String> {

    List<Subject> findBySubjectNameContainingIgnoreCase(String name);

    boolean existsBySubjectId(String subjectId);
}
