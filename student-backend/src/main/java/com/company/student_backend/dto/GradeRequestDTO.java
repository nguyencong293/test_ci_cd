package com.company.student_backend.dto;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GradeRequestDTO {

    @NotBlank(message = "Mã học sinh không được để trống")
    private String studentId;

    @NotBlank(message = "Mã môn học không được để trống")
    private String subjectId;

    @NotNull(message = "Điểm trung bình không được để trống")
    @DecimalMin(value = "0.0", message = "Điểm không được nhỏ hơn 0")
    @DecimalMax(value = "10.0", message = "Điểm không được lớn hơn 10")
    private BigDecimal averageScore;
}
