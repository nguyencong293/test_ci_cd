package com.company.student_backend.service;

import com.company.student_backend.exception.ResourceNotFoundException;
import com.company.student_backend.model.Student;
import com.company.student_backend.model.Subject;
import com.company.student_backend.repository.StudentRepository;
import com.company.student_backend.repository.SubjectRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

/**
 * Validation service to handle common validation logic
 * Tránh lặp lại code validation trong các service khác
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class ValidationService {

    private final StudentRepository studentRepository;
    private final SubjectRepository subjectRepository;

    /**
     * Validate and get student by ID
     * @param studentId ID của sinh viên
     * @return Student entity
     * @throws ResourceNotFoundException nếu không tìm thấy sinh viên
     */
    public Student validateAndGetStudent(String studentId) {
        log.debug("Validating student with ID: {}", studentId);
        return studentRepository.findById(studentId)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy học sinh với mã: " + studentId));
    }

    /**
     * Validate and get subject by ID
     * @param subjectId ID của môn học
     * @return Subject entity
     * @throws ResourceNotFoundException nếu không tìm thấy môn học
     */
    public Subject validateAndGetSubject(String subjectId) {
        log.debug("Validating subject with ID: {}", subjectId);
        return subjectRepository.findById(subjectId)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy môn học với mã: " + subjectId));
    }

    /**
     * Check if student exists
     * @param studentId ID của sinh viên
     * @return true nếu tồn tại, false nếu không
     */
    public boolean isStudentExists(String studentId) {
        return studentRepository.existsById(studentId);
    }

    /**
     * Check if subject exists
     * @param subjectId ID của môn học
     * @return true nếu tồn tại, false nếu không
     */
    public boolean isSubjectExists(String subjectId) {
        return subjectRepository.existsById(subjectId);
    }
}
