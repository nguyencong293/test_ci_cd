package com.company.student_backend.controller;

import com.company.student_backend.dto.GradeDTO;
import com.company.student_backend.service.GradeService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/api/grades")
@RequiredArgsConstructor
@Slf4j
@CrossOrigin(origins = "*")
public class GradeController {

    private final GradeService gradeService;

    @GetMapping
    public ResponseEntity<List<GradeDTO>> getAllGrades() {
        log.info("GET /api/grades - Getting all grades");
        List<GradeDTO> grades = gradeService.getAllGrades();
        return ResponseEntity.ok(grades);
    }

    @GetMapping("/{id}")
    public ResponseEntity<GradeDTO> getGradeById(@PathVariable Long id) {
        log.info("GET /api/grades/{} - Getting grade by ID", id);
        GradeDTO grade = gradeService.getGradeById(id);
        return ResponseEntity.ok(grade);
    }

    @PostMapping
    public ResponseEntity<GradeDTO> createGrade(@Valid @RequestBody GradeDTO gradeDTO) {
        log.info("POST /api/grades - Creating new grade for student: {} and subject: {}",
                gradeDTO.getStudentId(), gradeDTO.getSubjectId());
        GradeDTO createdGrade = gradeService.createGrade(gradeDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdGrade);
    }

    @PutMapping("/{id}")
    public ResponseEntity<GradeDTO> updateGrade(
            @PathVariable Long id,
            @Valid @RequestBody GradeDTO gradeDTO) {
        log.info("PUT /api/grades/{} - Updating grade", id);
        GradeDTO updatedGrade = gradeService.updateGrade(id, gradeDTO);
        return ResponseEntity.ok(updatedGrade);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteGrade(@PathVariable Long id) {
        log.info("DELETE /api/grades/{} - Deleting grade", id);
        gradeService.deleteGrade(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/student/{studentId}")
    public ResponseEntity<List<GradeDTO>> getGradesByStudentId(@PathVariable String studentId) {
        log.info("GET /api/grades/student/{} - Getting grades by student ID", studentId);
        List<GradeDTO> grades = gradeService.getGradesByStudentId(studentId);
        return ResponseEntity.ok(grades);
    }

    @GetMapping("/subject/{subjectId}")
    public ResponseEntity<List<GradeDTO>> getGradesBySubjectId(@PathVariable String subjectId) {
        log.info("GET /api/grades/subject/{} - Getting grades by subject ID", subjectId);
        List<GradeDTO> grades = gradeService.getGradesBySubjectId(subjectId);
        return ResponseEntity.ok(grades);
    }

    @GetMapping("/student/{studentId}/average")
    public ResponseEntity<BigDecimal> getAverageScoreByStudentId(@PathVariable String studentId) {
        log.info("GET /api/grades/student/{}/average - Getting average score by student ID", studentId);
        BigDecimal averageScore = gradeService.getAverageScoreByStudentId(studentId);
        return ResponseEntity.ok(averageScore);
    }

    @GetMapping("/subject/{subjectId}/average")
    public ResponseEntity<BigDecimal> getAverageScoreBySubjectId(@PathVariable String subjectId) {
        log.info("GET /api/grades/subject/{}/average - Getting average score by subject ID", subjectId);
        BigDecimal averageScore = gradeService.getAverageScoreBySubjectId(subjectId);
        return ResponseEntity.ok(averageScore);
    }
}
