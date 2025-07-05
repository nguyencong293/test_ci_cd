package com.company.student_backend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class StudentResponseDTO {
    private String studentId;
    private String studentName;
    private Integer birthYear;
    private List<GradeDTO> grades;
}
