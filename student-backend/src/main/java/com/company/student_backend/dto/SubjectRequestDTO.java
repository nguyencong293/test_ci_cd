package com.company.student_backend.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SubjectRequestDTO {

    @NotBlank(message = "Tên môn học không được để trống")
    private String subjectName;
}
