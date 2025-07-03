package com.company.student_backend.controller;

import com.company.student_backend.dto.StudentDTO;
import com.company.student_backend.service.StudentService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/students")
@RequiredArgsConstructor
@Slf4j
@CrossOrigin(origins = "*")
public class StudentController {

    private final StudentService studentService;

    @GetMapping
    public ResponseEntity<List<StudentDTO>> getAllStudents() {
        log.info("GET /api/students - Getting all students");
        List<StudentDTO> students = studentService.getAllStudents();
        return ResponseEntity.ok(students);
    }

    @GetMapping("/{studentId}")
    public ResponseEntity<StudentDTO> getStudentById(@PathVariable String studentId) {
        log.info("GET /api/students/{} - Getting student by ID", studentId);
        StudentDTO student = studentService.getStudentById(studentId);
        return ResponseEntity.ok(student);
    }

    @PostMapping
    public ResponseEntity<StudentDTO> createStudent(@Valid @RequestBody StudentDTO studentDTO) {
        log.info("POST /api/students - Creating new student: {}", studentDTO.getStudentId());
        StudentDTO createdStudent = studentService.createStudent(studentDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdStudent);
    }

    @PutMapping("/{studentId}")
    public ResponseEntity<StudentDTO> updateStudent(
            @PathVariable String studentId,
            @Valid @RequestBody StudentDTO studentDTO) {
        log.info("PUT /api/students/{} - Updating student", studentId);
        StudentDTO updatedStudent = studentService.updateStudent(studentId, studentDTO);
        return ResponseEntity.ok(updatedStudent);
    }

    @DeleteMapping("/{studentId}")
    public ResponseEntity<Void> deleteStudent(@PathVariable String studentId) {
        log.info("DELETE /api/students/{} - Deleting student", studentId);
        studentService.deleteStudent(studentId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/search")
    public ResponseEntity<List<StudentDTO>> searchStudentsByName(@RequestParam String name) {
        log.info("GET /api/students/search?name={} - Searching students by name", name);
        List<StudentDTO> students = studentService.searchStudentsByName(name);
        return ResponseEntity.ok(students);
    }

    @GetMapping("/birth-year/{year}")
    public ResponseEntity<List<StudentDTO>> getStudentsByBirthYear(@PathVariable Integer year) {
        log.info("GET /api/students/birth-year/{} - Getting students by birth year", year);
        List<StudentDTO> students = studentService.getStudentsByBirthYear(year);
        return ResponseEntity.ok(students);
    }
}
