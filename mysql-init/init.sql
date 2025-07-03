-- create database student_manager;

-- Create students table
CREATE TABLE students (
    student_id VARCHAR(10) PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    birth_year INTEGER NOT NULL
);

-- Create subjects table
CREATE TABLE subjects (
    subject_id VARCHAR(10) PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL
);

-- Create grades table
CREATE TABLE grades (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(10) NOT NULL,
    subject_id VARCHAR(10) NOT NULL,
    average_score DECIMAL(3,1) NOT NULL CHECK (average_score >= 0.0 AND average_score <= 10.0),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id) ON DELETE CASCADE,
    UNIQUE (student_id, subject_id)
);

-- Create indexes for better performance
CREATE INDEX idx_students_name ON students(student_name);
CREATE INDEX idx_students_birth_year ON students(birth_year);
CREATE INDEX idx_subjects_name ON subjects(subject_name);
CREATE INDEX idx_grades_student_id ON grades(student_id);
CREATE INDEX idx_grades_subject_id ON grades(subject_id);
CREATE INDEX idx_grades_score ON grades(average_score);

-- Insert sample data for testing
INSERT INTO students (student_id, student_name, birth_year) VALUES 
('SV001', 'Nguyễn Văn An', 2000),
('SV002', 'Trần Thị Bình', 2001),
('SV003', 'Lê Văn Cường', 1999),
('SV004', 'Phạm Thị Dung', 2002),
('SV005', 'Hoàng Văn Em', 2000);

INSERT INTO subjects (subject_id, subject_name) VALUES 
('MH001', 'Toán học'),
('MH002', 'Vật lý'),
('MH003', 'Hóa học'),
('MH004', 'Lập trình Java'),
('MH005', 'Cơ sở dữ liệu');

INSERT INTO grades (student_id, subject_id, average_score) VALUES 
('SV001', 'MH001', 8.5),
('SV001', 'MH002', 7.0),
('SV001', 'MH004', 9.0),
('SV002', 'MH001', 6.5),
('SV002', 'MH003', 8.0),
('SV002', 'MH005', 7.5),
('SV003', 'MH002', 9.5),
('SV003', 'MH004', 8.0),
('SV004', 'MH001', 7.0),
('SV004', 'MH003', 6.0),
('SV005', 'MH005', 8.5);