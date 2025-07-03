package com.company.student_backend.service;

import com.company.student_backend.dto.SubjectDTO;
import com.company.student_backend.exception.DuplicateResourceException;
import com.company.student_backend.exception.ResourceNotFoundException;
import com.company.student_backend.model.Subject;
import com.company.student_backend.repository.SubjectRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class SubjectServiceTest {

    @Mock
    private SubjectRepository subjectRepository;

    @InjectMocks
    private SubjectService subjectService;

    private Subject subject;
    private SubjectDTO subjectDTO;

    @BeforeEach
    void setUp() {
        subject = new Subject();
        subject.setSubjectId("MH001");
        subject.setSubjectName("Mathematics");

        subjectDTO = new SubjectDTO();
        subjectDTO.setSubjectId("MH001");
        subjectDTO.setSubjectName("Mathematics");
    }

    @Test
    void getAllSubjects_ShouldReturnAllSubjects() {
        List<Subject> subjects = Arrays.asList(subject);
        when(subjectRepository.findAll()).thenReturn(subjects);

        List<SubjectDTO> result = subjectService.getAllSubjects();

        assertEquals(1, result.size());
        assertEquals("MH001", result.get(0).getSubjectId());
        assertEquals("Mathematics", result.get(0).getSubjectName());
    }

    @Test
    void getSubjectById_WhenSubjectExists_ShouldReturnSubject() {
        when(subjectRepository.findById("MH001")).thenReturn(Optional.of(subject));

        SubjectDTO result = subjectService.getSubjectById("MH001");

        assertEquals("MH001", result.getSubjectId());
        assertEquals("Mathematics", result.getSubjectName());
    }

    @Test
    void getSubjectById_WhenSubjectNotExists_ShouldThrowException() {
        when(subjectRepository.findById("MH999")).thenReturn(Optional.empty());

        assertThrows(ResourceNotFoundException.class,
                () -> subjectService.getSubjectById("MH999"));
    }

    @Test
    void createSubject_WhenSubjectNotExists_ShouldCreateSubject() {
        when(subjectRepository.existsBySubjectId("MH001")).thenReturn(false);
        when(subjectRepository.save(any(Subject.class))).thenReturn(subject);

        SubjectDTO result = subjectService.createSubject(subjectDTO);

        assertEquals("MH001", result.getSubjectId());
        assertEquals("Mathematics", result.getSubjectName());
        verify(subjectRepository).existsBySubjectId("MH001");
        verify(subjectRepository).save(any(Subject.class));
    }

    @Test
    void createSubject_WhenSubjectExists_ShouldThrowException() {
        when(subjectRepository.existsBySubjectId("MH001")).thenReturn(true);

        assertThrows(DuplicateResourceException.class,
                () -> subjectService.createSubject(subjectDTO));
    }

    @Test
    void updateSubject_WhenSubjectExists_ShouldUpdateSubject() {
        when(subjectRepository.findById("MH001")).thenReturn(Optional.of(subject));
        when(subjectRepository.save(any(Subject.class))).thenReturn(subject);

        SubjectDTO result = subjectService.updateSubject("MH001", subjectDTO);

        assertEquals("MH001", result.getSubjectId());
        assertEquals("Mathematics", result.getSubjectName());
        verify(subjectRepository).save(any(Subject.class));
    }

    @Test
    void deleteSubject_WhenSubjectExists_ShouldDeleteSubject() {
        when(subjectRepository.existsById("MH001")).thenReturn(true);
        doNothing().when(subjectRepository).deleteById("MH001");

        assertDoesNotThrow(() -> subjectService.deleteSubject("MH001"));
        verify(subjectRepository).deleteById("MH001");
    }

    @Test
    void searchSubjectsByName_ShouldReturnMatchingSubjects() {
        List<Subject> subjects = Arrays.asList(subject);
        when(subjectRepository.findBySubjectNameContainingIgnoreCase("Math"))
                .thenReturn(subjects);

        List<SubjectDTO> result = subjectService.searchSubjectsByName("Math");

        assertEquals(1, result.size());
        assertEquals("Mathematics", result.get(0).getSubjectName());
    }
}
