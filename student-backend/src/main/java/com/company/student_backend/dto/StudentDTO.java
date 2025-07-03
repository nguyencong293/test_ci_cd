package com.company.student_backend.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class StudentDTO {

    @NotBlank(message = "Mã học sinh không được để trống")
    private String studentId;

    @NotBlank(message = "Tên học sinh không được để trống")
    private String studentName;

    @NotNull(message = "Năm sinh không được để trống")
    private Integer birthYear;
}

// Request DTO for creating/updating
@Data
@NoArgsConstructor
@AllArgsConstructor
class StudentRequestDTO {

    @NotBlank(message = "Tên học sinh không được để trống")
    private String studentName;

    @NotNull(message = "Năm sinh không được để trống")
    private Integer birthYear;
}

// Response DTO with grades
@Data
@NoArgsConstructor
@AllArgsConstructor
class StudentResponseDTO {
    private String studentId;
    private String studentName;
    private Integer birthYear;
    private java.util.List<GradeDTO> grades;
}
