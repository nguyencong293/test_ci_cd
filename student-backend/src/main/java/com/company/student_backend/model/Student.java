package com.company.student_backend.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Table(name = "students")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Student {

    @Id
    @Column(name = "student_id", length = 10)
    private String studentId;

    @NotBlank(message = "Tên học sinh không được để trống")
    @Column(name = "student_name", nullable = false, length = 100)
    private String studentName;

    @NotNull(message = "Năm sinh không được để trống")
    @Column(name = "birth_year", nullable = false)
    private Integer birthYear;

    @OneToMany(mappedBy = "student", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Grade> grades;
}
