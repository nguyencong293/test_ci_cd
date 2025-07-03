package com.company.student_backend.service;

import com.company.student_backend.dto.GradeDTO;
import com.company.student_backend.model.Grade;
import com.company.student_backend.model.Student;
import com.company.student_backend.model.Subject;
import com.company.student_backend.repository.GradeRepository;
import com.company.student_backend.repository.StudentRepository;
import com.company.student_backend.repository.SubjectRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class GradeServiceTest {

    @Mock
    private GradeRepository gradeRepository;

    @Mock
    private StudentRepository studentRepository;

    @Mock
    private SubjectRepository subjectRepository;

    @InjectMocks
    private GradeService gradeService;

    private Grade grade;
    private GradeDTO gradeDTO;
    private Student student;
    private Subject subject;

    @BeforeEach
    void setUp() {
        student = new Student();
        student.setStudentId("SV001");
        student.setStudentName("Test Student");

        subject = new Subject();
        subject.setSubjectId("MH001");
        subject.setSubjectName("Mathematics");

        grade = new Grade();
        grade.setId(1L);
        grade.setStudent(student);
        grade.setSubject(subject);
        grade.setAverageScore(new BigDecimal("8.5"));

        gradeDTO = new GradeDTO();
        gradeDTO.setId(1L);
        gradeDTO.setStudentId("SV001");
        gradeDTO.setSubjectId("MH001");
        gradeDTO.setAverageScore(new BigDecimal("8.5"));
    }

    @Test
    void createGrade_WhenValidData_ShouldCreateGrade() {
        when(studentRepository.findById("SV001")).thenReturn(Optional.of(student));
        when(subjectRepository.findById("MH001")).thenReturn(Optional.of(subject));
        when(gradeRepository.save(any(Grade.class))).thenReturn(grade);

        GradeDTO result = gradeService.createGrade(gradeDTO);

        assertEquals(1L, result.getId());
        assertEquals("SV001", result.getStudentId());
        assertEquals("MH001", result.getSubjectId());
        assertEquals(new BigDecimal("8.5"), result.getAverageScore());
        verify(gradeRepository).save(any(Grade.class));
    }

    @Test
    void getGradesByStudentId_ShouldReturnStudentGrades() {
        List<Grade> grades = Arrays.asList(grade);
        when(gradeRepository.findByStudentStudentId("SV001")).thenReturn(grades);

        List<GradeDTO> result = gradeService.getGradesByStudentId("SV001");

        assertEquals(1, result.size());
        assertEquals("SV001", result.get(0).getStudentId());
    }

    @Test
    void getAverageScoreByStudentId_ShouldReturnAverageScore() {
        when(gradeRepository.findAverageScoreByStudentId("SV001"))
                .thenReturn(new BigDecimal("8.5"));

        BigDecimal result = gradeService.getAverageScoreByStudentId("SV001");

        assertEquals(new BigDecimal("8.5"), result);
    }

    @Test
    void updateGrade_WhenGradeExists_ShouldUpdateGrade() {
        when(gradeRepository.findById(1L)).thenReturn(Optional.of(grade));
        when(gradeRepository.save(any(Grade.class))).thenReturn(grade);

        GradeDTO result = gradeService.updateGrade(1L, gradeDTO);

        assertEquals(1L, result.getId());
        verify(gradeRepository).save(any(Grade.class));
    }

    @Test
    void deleteGrade_WhenGradeExists_ShouldDeleteGrade() {
        when(gradeRepository.existsById(1L)).thenReturn(true);
        doNothing().when(gradeRepository).deleteById(1L);

        assertDoesNotThrow(() -> gradeService.deleteGrade(1L));
        verify(gradeRepository).deleteById(1L);
    }
}
