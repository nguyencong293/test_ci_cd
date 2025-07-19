package com.company.student_backend.service;

import com.company.student_backend.dto.StudentDTO;
import com.company.student_backend.exception.DuplicateResourceException;
import com.company.student_backend.model.Student;
import com.company.student_backend.repository.StudentRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class StudentService {

    private final StudentRepository studentRepository;
    private final ValidationService validationService;

    public List<StudentDTO> getAllStudents() {
        log.debug("Fetching all students");
        return studentRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public StudentDTO getStudentById(String studentId) {
        log.debug("Fetching student with ID: {}", studentId);
        Student student = validationService.validateAndGetStudent(studentId);
        return convertToDTO(student);
    }

    public StudentDTO createStudent(StudentDTO studentDTO) {
        log.debug("Creating new student: {}", studentDTO);

        if (studentRepository.existsByStudentId(studentDTO.getStudentId())) {
            throw new DuplicateResourceException("Mã học sinh đã tồn tại: " + studentDTO.getStudentId());
        }

        Student student = convertToEntity(studentDTO);
        Student savedStudent = studentRepository.save(student);
        log.info("Created student with ID: {}", savedStudent.getStudentId());

        return convertToDTO(savedStudent);
    }

    public StudentDTO updateStudent(String studentId, StudentDTO studentDTO) {
        log.debug("Updating student with ID: {}", studentId);

        Student existingStudent = validationService.validateAndGetStudent(studentId);

        existingStudent.setStudentName(studentDTO.getStudentName());
        existingStudent.setBirthYear(studentDTO.getBirthYear());

        Student updatedStudent = studentRepository.save(existingStudent);
        log.info("Updated student with ID: {}", updatedStudent.getStudentId());

        return convertToDTO(updatedStudent);
    }

    public void deleteStudent(String studentId) {
        log.debug("Deleting student with ID: {}", studentId);

        if (!validationService.isStudentExists(studentId)) {
            validationService.validateAndGetStudent(studentId); // Throws ResourceNotFoundException
        }

        studentRepository.deleteById(studentId);
        log.info("Deleted student with ID: {}", studentId);
    }

    public List<StudentDTO> searchStudentsByName(String name) {
        log.debug("Searching students by name: {}", name);
        return studentRepository.findByStudentNameContainingIgnoreCase(name).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public List<StudentDTO> getStudentsByBirthYear(Integer birthYear) {
        log.debug("Fetching students by birth year: {}", birthYear);
        return studentRepository.findByBirthYear(birthYear).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    private StudentDTO convertToDTO(Student student) {
        return new StudentDTO(
                student.getStudentId(),
                student.getStudentName(),
                student.getBirthYear());
    }

    private Student convertToEntity(StudentDTO studentDTO) {
        return new Student(
                studentDTO.getStudentId(),
                studentDTO.getStudentName(),
                studentDTO.getBirthYear(),
                null);
    }
}
