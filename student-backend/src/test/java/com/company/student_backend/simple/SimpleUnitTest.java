package com.company.student_backend.simple;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class SimpleUnitTest {

    @Test
    void testBasicAssertion() {
        String expected = "Hello World";
        String actual = "Hello World";
        assertEquals(expected, actual);
    }

    @Test
    void testTrueAssertion() {
        assertTrue(true);
    }

    @Test
    void testMathCalculation() {
        int result = 2 + 2;
        assertEquals(4, result);
    }
}
