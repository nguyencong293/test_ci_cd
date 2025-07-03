package com.company.student_backend.controller;

import com.company.student_backend.dto.SubjectDTO;
import com.company.student_backend.service.SubjectService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/subjects")
@RequiredArgsConstructor
@Slf4j
@CrossOrigin(origins = "*")
public class SubjectController {

    private final SubjectService subjectService;

    @GetMapping
    public ResponseEntity<List<SubjectDTO>> getAllSubjects() {
        log.info("GET /api/subjects - Getting all subjects");
        List<SubjectDTO> subjects = subjectService.getAllSubjects();
        return ResponseEntity.ok(subjects);
    }

    @GetMapping("/{subjectId}")
    public ResponseEntity<SubjectDTO> getSubjectById(@PathVariable String subjectId) {
        log.info("GET /api/subjects/{} - Getting subject by ID", subjectId);
        SubjectDTO subject = subjectService.getSubjectById(subjectId);
        return ResponseEntity.ok(subject);
    }

    @PostMapping
    public ResponseEntity<SubjectDTO> createSubject(@Valid @RequestBody SubjectDTO subjectDTO) {
        log.info("POST /api/subjects - Creating new subject: {}", subjectDTO.getSubjectId());
        SubjectDTO createdSubject = subjectService.createSubject(subjectDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdSubject);
    }

    @PutMapping("/{subjectId}")
    public ResponseEntity<SubjectDTO> updateSubject(
            @PathVariable String subjectId,
            @Valid @RequestBody SubjectDTO subjectDTO) {
        log.info("PUT /api/subjects/{} - Updating subject", subjectId);
        SubjectDTO updatedSubject = subjectService.updateSubject(subjectId, subjectDTO);
        return ResponseEntity.ok(updatedSubject);
    }

    @DeleteMapping("/{subjectId}")
    public ResponseEntity<Void> deleteSubject(@PathVariable String subjectId) {
        log.info("DELETE /api/subjects/{} - Deleting subject", subjectId);
        subjectService.deleteSubject(subjectId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/search")
    public ResponseEntity<List<SubjectDTO>> searchSubjectsByName(@RequestParam String name) {
        log.info("GET /api/subjects/search?name={} - Searching subjects by name", name);
        List<SubjectDTO> subjects = subjectService.searchSubjectsByName(name);
        return ResponseEntity.ok(subjects);
    }
}
