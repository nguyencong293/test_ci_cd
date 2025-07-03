package com.company.student_backend.controller;

import com.company.student_backend.dto.StudentDTO;
import com.company.student_backend.service.StudentService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Arrays;
import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(StudentController.class)
class StudentControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private StudentService studentService;

    @Autowired
    private ObjectMapper objectMapper;

    private StudentDTO studentDTO;
    private List<StudentDTO> studentList;

    @BeforeEach
    void setUp() {
        studentDTO = new StudentDTO();
        studentDTO.setStudentId("SV001");
        studentDTO.setStudentName("Nguyen Van A");
        studentDTO.setBirthYear(2000);

        StudentDTO studentDTO2 = new StudentDTO();
        studentDTO2.setStudentId("SV002");
        studentDTO2.setStudentName("Tran Thi B");
        studentDTO2.setBirthYear(2001);

        studentList = Arrays.asList(studentDTO, studentDTO2);
    }

    @Test
    void getAllStudents_ShouldReturnListOfStudents() throws Exception {
        when(studentService.getAllStudents()).thenReturn(studentList);

        mockMvc.perform(get("/api/students"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$.length()").value(2))
                .andExpect(jsonPath("$[0].studentId").value("SV001"))
                .andExpect(jsonPath("$[0].studentName").value("Nguyen Van A"))
                .andExpect(jsonPath("$[1].studentId").value("SV002"));
    }

    @Test
    void getStudentById_ShouldReturnStudent() throws Exception {
        when(studentService.getStudentById("SV001")).thenReturn(studentDTO);

        mockMvc.perform(get("/api/students/SV001"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.studentId").value("SV001"))
                .andExpect(jsonPath("$.studentName").value("Nguyen Van A"))
                .andExpect(jsonPath("$.birthYear").value(2000));
    }

    @Test
    void createStudent_ShouldReturnCreatedStudent() throws Exception {
        when(studentService.createStudent(any(StudentDTO.class))).thenReturn(studentDTO);

        mockMvc.perform(post("/api/students")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(studentDTO)))
                .andExpect(status().isCreated())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.studentId").value("SV001"))
                .andExpect(jsonPath("$.studentName").value("Nguyen Van A"));
    }

    @Test
    void updateStudent_ShouldReturnUpdatedStudent() throws Exception {
        when(studentService.updateStudent(eq("SV001"), any(StudentDTO.class))).thenReturn(studentDTO);

        mockMvc.perform(put("/api/students/SV001")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(studentDTO)))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.studentId").value("SV001"));
    }

    @Test
    void deleteStudent_ShouldReturnNoContent() throws Exception {
        doNothing().when(studentService).deleteStudent("SV001");

        mockMvc.perform(delete("/api/students/SV001"))
                .andExpect(status().isNoContent());
    }

    @Test
    void searchStudentsByName_ShouldReturnMatchingStudents() throws Exception {
        when(studentService.searchStudentsByName("Nguyen")).thenReturn(Arrays.asList(studentDTO));

        mockMvc.perform(get("/api/students/search")
                        .param("name", "Nguyen"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$.length()").value(1))
                .andExpect(jsonPath("$[0].studentName").value("Nguyen Van A"));
    }

    @Test
    void getStudentsByBirthYear_ShouldReturnStudentsWithMatchingYear() throws Exception {
        when(studentService.getStudentsByBirthYear(2000)).thenReturn(Arrays.asList(studentDTO));

        mockMvc.perform(get("/api/students/birth-year/2000"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$.length()").value(1))
                .andExpect(jsonPath("$[0].birthYear").value(2000));
    }
}