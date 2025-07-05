package com.company.student_backend.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class StudentRequestDTO {

    @NotBlank(message = "Tên học sinh không được để trống")
    private String studentName;

    @NotNull(message = "Năm sinh không được để trống")
    private Integer birthYear;
}
