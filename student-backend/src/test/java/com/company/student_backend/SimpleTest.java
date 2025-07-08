package com.company.student_backend;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class SimpleTest {

    @Test
    public void testSimple() {
        assertEquals(1, 1);
    }
    
    @Test 
    public void testString() {
        String hello = "Hello";
        assertNotNull(hello);
        assertEquals("Hello", hello);
    }
}
