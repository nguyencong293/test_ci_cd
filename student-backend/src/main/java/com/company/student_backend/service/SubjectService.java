package com.company.student_backend.service;

import com.company.student_backend.dto.SubjectDTO;
import com.company.student_backend.exception.DuplicateResourceException;
import com.company.student_backend.exception.ResourceNotFoundException;
import com.company.student_backend.model.Subject;
import com.company.student_backend.repository.SubjectRepository;
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
public class SubjectService {

    private final SubjectRepository subjectRepository;

    public List<SubjectDTO> getAllSubjects() {
        log.debug("Fetching all subjects");
        return subjectRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public SubjectDTO getSubjectById(String subjectId) {
        log.debug("Fetching subject with ID: {}", subjectId);
        Subject subject = subjectRepository.findById(subjectId)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy môn học với mã: " + subjectId));
        return convertToDTO(subject);
    }

    public SubjectDTO createSubject(SubjectDTO subjectDTO) {
        log.debug("Creating new subject: {}", subjectDTO);

        if (subjectRepository.existsBySubjectId(subjectDTO.getSubjectId())) {
            throw new DuplicateResourceException("Mã môn học đã tồn tại: " + subjectDTO.getSubjectId());
        }

        Subject subject = convertToEntity(subjectDTO);
        Subject savedSubject = subjectRepository.save(subject);
        log.info("Created subject with ID: {}", savedSubject.getSubjectId());

        return convertToDTO(savedSubject);
    }

    public SubjectDTO updateSubject(String subjectId, SubjectDTO subjectDTO) {
        log.debug("Updating subject with ID: {}", subjectId);

        Subject existingSubject = subjectRepository.findById(subjectId)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy môn học với mã: " + subjectId));

        existingSubject.setSubjectName(subjectDTO.getSubjectName());

        Subject updatedSubject = subjectRepository.save(existingSubject);
        log.info("Updated subject with ID: {}", updatedSubject.getSubjectId());

        return convertToDTO(updatedSubject);
    }

    public void deleteSubject(String subjectId) {
        log.debug("Deleting subject with ID: {}", subjectId);

        if (!subjectRepository.existsById(subjectId)) {
            throw new ResourceNotFoundException("Không tìm thấy môn học với mã: " + subjectId);
        }

        subjectRepository.deleteById(subjectId);
        log.info("Deleted subject with ID: {}", subjectId);
    }

    public List<SubjectDTO> searchSubjectsByName(String name) {
        log.debug("Searching subjects by name: {}", name);
        return subjectRepository.findBySubjectNameContainingIgnoreCase(name).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    private SubjectDTO convertToDTO(Subject subject) {
        return new SubjectDTO(
                subject.getSubjectId(),
                subject.getSubjectName()
        );
    }

    private Subject convertToEntity(SubjectDTO subjectDTO) {
        return new Subject(
                subjectDTO.getSubjectId(),
                subjectDTO.getSubjectName(),
                null
        );
    }
}
