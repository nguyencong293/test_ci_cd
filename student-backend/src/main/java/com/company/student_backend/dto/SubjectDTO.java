package com.company.student_backend.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SubjectDTO {

    @NotBlank(message = "Mã môn học không được để trống")
    private String subjectId;

    @NotBlank(message = "Tên môn học không được để trống")
    private String subjectName;
}

// Request DTO for creating/updating
@Data
@NoArgsConstructor
@AllArgsConstructor
class SubjectRequestDTO {

    @NotBlank(message = "Tên môn học không được để trống")
    private String subjectName;
}
