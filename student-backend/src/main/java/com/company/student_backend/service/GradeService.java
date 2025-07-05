package com.company.student_backend.service;

import com.company.student_backend.dto.GradeDTO;
import com.company.student_backend.exception.DuplicateResourceException;
import com.company.student_backend.exception.ResourceNotFoundException;
import com.company.student_backend.model.Grade;
import com.company.student_backend.model.Student;
import com.company.student_backend.model.Subject;
import com.company.student_backend.repository.GradeRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class GradeService {

    private final GradeRepository gradeRepository;
    private final ValidationService validationService;

    public List<GradeDTO> getAllGrades() {
        log.debug("Fetching all grades");
        return gradeRepository.findAllWithStudentAndSubject().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public GradeDTO getGradeById(Long id) {
        log.debug("Fetching grade with ID: {}", id);
        Grade grade = gradeRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy điểm với ID: " + id));
        return convertToDTO(grade);
    }

    public GradeDTO createGrade(GradeDTO gradeDTO) {
        log.debug("Creating new grade: {}", gradeDTO);

        // Validate student and subject exist using ValidationService
        Student student = validationService.validateAndGetStudent(gradeDTO.getStudentId());
        Subject subject = validationService.validateAndGetSubject(gradeDTO.getSubjectId());

        // Check if grade already exists for this student-subject combination
        if (gradeRepository.existsByStudentStudentIdAndSubjectSubjectId(gradeDTO.getStudentId(), gradeDTO.getSubjectId())) {
            throw new DuplicateResourceException("Điểm đã tồn tại cho học sinh " + gradeDTO.getStudentId() + " và môn học " + gradeDTO.getSubjectId());
        }

        Grade grade = new Grade();
        grade.setStudent(student);
        grade.setSubject(subject);
        grade.setAverageScore(gradeDTO.getAverageScore());

        Grade savedGrade = gradeRepository.save(grade);
        log.info("Created grade with ID: {}", savedGrade.getId());

        return convertToDTO(savedGrade);
    }

    public GradeDTO updateGrade(Long id, GradeDTO gradeDTO) {
        log.debug("Updating grade with ID: {}", id);

        Grade existingGrade = gradeRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy điểm với ID: " + id));

        existingGrade.setAverageScore(gradeDTO.getAverageScore());

        Grade updatedGrade = gradeRepository.save(existingGrade);
        log.info("Updated grade with ID: {}", updatedGrade.getId());

        return convertToDTO(updatedGrade);
    }

    public void deleteGrade(Long id) {
        log.debug("Deleting grade with ID: {}", id);

        if (!gradeRepository.existsById(id)) {
            throw new ResourceNotFoundException("Không tìm thấy điểm với ID: " + id);
        }

        gradeRepository.deleteById(id);
        log.info("Deleted grade with ID: {}", id);
    }

    public List<GradeDTO> getGradesByStudentId(String studentId) {
        log.debug("Fetching grades for student ID: {}", studentId);
        return gradeRepository.findByStudentStudentId(studentId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public List<GradeDTO> getGradesBySubjectId(String subjectId) {
        log.debug("Fetching grades for subject ID: {}", subjectId);
        return gradeRepository.findBySubjectSubjectId(subjectId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public BigDecimal getAverageScoreByStudentId(String studentId) {
        log.debug("Calculating average score for student ID: {}", studentId);
        return gradeRepository.findAverageScoreByStudentId(studentId);
    }

    public BigDecimal getAverageScoreBySubjectId(String subjectId) {
        log.debug("Calculating average score for subject ID: {}", subjectId);
        return gradeRepository.findAverageScoreBySubjectId(subjectId);
    }

    private GradeDTO convertToDTO(Grade grade) {
        GradeDTO dto = new GradeDTO();
        dto.setId(grade.getId());
        dto.setStudentId(grade.getStudent().getStudentId());
        dto.setSubjectId(grade.getSubject().getSubjectId());
        dto.setAverageScore(grade.getAverageScore());
        dto.setStudentName(grade.getStudent().getStudentName());
        dto.setSubjectName(grade.getSubject().getSubjectName());
        return dto;
    }
}
