package com.company.student_backend;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.NONE)
@ActiveProfiles("test")
class StudentBackendApplicationTests {

	@Test
	void contextLoads() {
		// This test just verifies that the Spring context loads successfully
	}

}
