-- ===================================================================
-- INTERACTIVE PL/SQL LEARNING COURSE
-- ===================================================================

-- SET SERVEROUTPUT ON to see output
SET SERVEROUTPUT ON SIZE 20000;

-- ===================================================================
-- VIEW YOUR CURRICULUM
-- ===================================================================
-- Run this to see all assignments organized by level:
SELECT assignment_id, level_num, topic, title 
FROM learning_curriculum 
ORDER BY assignment_id;

-- ===================================================================
-- VIEW SPECIFIC ASSIGNMENT DETAILS
-- ===================================================================
-- Replace X with assignment number (e.g., 1, 2, 3, etc.)
-- EXEC show_assignment(X);

-- Example: To see Assignment #1
-- EXEC show_assignment(1);

-- ===================================================================
-- TRACK YOUR PROGRESS
-- ===================================================================
-- View your completed assignments and progress:
-- EXEC show_progress;

-- ===================================================================
-- LOG YOUR COMPLETION
-- ===================================================================
-- Once you complete an assignment, record it:
-- EXEC log_assignment_attempt(assignment_id, 'COMPLETED', 'Brief notes about what you built');

-- Example:
-- EXEC log_assignment_attempt(1, 'COMPLETED', 'Created Hello World block with DBMS_OUTPUT');

-- ===================================================================
-- QUICK REFERENCE: ASSIGNMENT LIST
-- ===================================================================

-- LEVEL 1: FUNDAMENTALS (Assignments 1-8)
-- 1. Hello PL/SQL - Write your first PL/SQL block to print Hello World
-- 2. Variable Declaration - Declare variables of different types
-- 3. Working with NULL - Handle NULL values with NVL
-- 4. Simple IF Statement - Check if number is positive, negative, or zero
-- 5. CASE Statement - Return grade letter based on score
-- 6. LOOP Statement - Count from 1 to 10 with EXIT condition
-- 7. FOR Loop - Print multiplication table
-- 8. WHILE Loop - Find sum from 1 to 100

-- LEVEL 2: INTERMEDIATE (Assignments 9-17)
-- 9. Basic SELECT INTO - Query user from all_users table
-- 10. Handling NO_DATA_FOUND - Safe SELECT INTO with exception handling
-- 11. Simple Procedure - Create procedure to return square of number
-- 12. Procedure with Multiple Parameters - Calculate rectangle area
-- 13. Simple Function - Return max of two numbers
-- 14. Function with Calculations - Compound interest calculator
-- 15. Simple Cursor - Fetch all table names
-- 16. Cursor FOR Loop - Display all user objects
-- 17. Parameterized Cursor - Filter tables by name pattern

-- LEVEL 3: ADVANCED (Assignments 18-26)
-- 18. Basic Exceptions - Catch ZERO_DIVIDE and VALUE_ERROR
-- 19. User-Defined Exceptions - Custom exception for invalid age
-- 20. Exception with SQLCODE - Display Oracle error code and message
-- 21. Package Specification - Create package spec with procedures
-- 22. Package Body - Implement package body
-- 23. Table-based Record - Use ROWTYPE with EMPLOYEES table
-- 24. User-Defined Record - Create custom record type
-- 25. Simple INSERT Trigger - Log inserts to audit table
-- 26. UPDATE Trigger - Prevent salary decrease

-- LEVEL 4: EXPERT (Assignments 27-32)
-- 27. Nested Tables - Create and operate on nested tables
-- 28. Associative Arrays - Key-value storage indexed by ID
-- 29. BULK COLLECT - Fetch 1000+ records efficiently
-- 30. FORALL Statement - Insert multiple records efficiently
-- 31. Dynamic SQL - Use EXECUTE IMMEDIATE for dynamic queries
-- 32. Refactoring Project - Apply all concepts learned

-- ===================================================================
-- HOW TO USE THIS COURSE
-- ===================================================================
-- 1. Start with LEVEL 1 assignments (fundamentals)
-- 2. Create your PL/SQL code in a new SQL file or directly in the IDE
-- 3. Test your code to make sure it works
-- 4. When complete, update your progress: log_assignment_attempt(id, 'COMPLETED', notes)
-- 5. Move to the next assignment
-- 6. Use show_progress to track your learning journey
-- 7. Review hints if you get stuck: EXEC show_assignment(id);

-- ===================================================================
-- HELPER PROCEDURES AVAILABLE
-- ===================================================================

-- show_curriculum - Displays all assignments organized by level
-- show_assignment(id) - Shows detailed assignment information, objectives, and hints
-- log_assignment_attempt(id, status, feedback) - Records your attempt
-- show_progress - Shows your completed assignments and learning progress

-- ===================================================================
-- EXAMPLE WORKFLOW
-- ===================================================================

-- Step 1: View the curriculum
-- SELECT * FROM learning_curriculum ORDER BY assignment_id;

-- Step 2: Get details for Assignment #1
-- EXEC show_assignment(1);

-- Step 3: Create your PL/SQL solution in a separate file

-- Step 4: After completion, log it
-- EXEC log_assignment_attempt(1, 'COMPLETED', 'Successfully printed Hello World');

-- Step 5: Check your progress
-- EXEC show_progress;

-- Step 6: Move to Assignment #2 and repeat!

-- ===================================================================
