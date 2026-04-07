-- =======================================================================
-- PL/SQL LEARNING COURSE - EXAMPLE SOLUTIONS (LEVEL 1)
-- =======================================================================
-- These are EXAMPLE solutions to help you understand the pattern
-- Try solving each assignment yourself FIRST, then compare with these examples
-- =======================================================================

-- =======================================================================
-- ASSIGNMENT #1: Hello PL/SQL
-- =======================================================================
-- Requirement: Write your first PL/SQL block to print Hello World 
-- using DBMS_OUTPUT

SET SERVEROUTPUT ON;

BEGIN
  DBMS_OUTPUT.PUT_LINE('Hello, PL/SQL!');
END;
/

-- Expected Output: Hello, PL/SQL!

-- Log your completion:
-- EXEC log_assignment_attempt(1, 'COMPLETED', 'First block created successfully');

-- =======================================================================
-- ASSIGNMENT #2: Variable Declaration
-- =======================================================================
-- Requirement: Declare variables of different types and assign values

DECLARE
  v_age NUMBER := 25;
  v_name VARCHAR2(50) := 'John Doe';
  v_birth_date DATE := '01-JAN-1999';
  v_salary NUMBER(10, 2) := 45000.50;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Age: ' || v_age);
  DBMS_OUTPUT.PUT_LINE('Name: ' || v_name);
  DBMS_OUTPUT.PUT_LINE('Birth Date: ' || v_birth_date);
  DBMS_OUTPUT.PUT_LINE('Salary: $' || v_salary);
END;
/

-- Expected Output:
-- Age: 25
-- Name: John Doe
-- Birth Date: 01-JAN-99
-- Salary: $45000.5

-- Log your completion:
-- EXEC log_assignment_attempt(2, 'COMPLETED', 'Declared NUMBER, VARCHAR2, and DATE variables');

-- =======================================================================
-- ASSIGNMENT #3: Working with NULL
-- =======================================================================
-- Requirement: Create a block that handles NULL values and NVL functionality

DECLARE
  v_commission NUMBER;
  v_salary NUMBER := 50000;
  v_total_earning NUMBER;
BEGIN
  -- v_commission is NULL (never assigned)
  DBMS_OUTPUT.PUT_LINE('Commission is: ' || NVL(v_commission, 0));
  
  -- Calculate total with NVL handling
  v_total_earning := v_salary + NVL(v_commission, 0);
  DBMS_OUTPUT.PUT_LINE('Base Salary: ' || v_salary);
  DBMS_OUTPUT.PUT_LINE('Commission: ' || NVL(v_commission, 'Not Applicable'));
  DBMS_OUTPUT.PUT_LINE('Total Earnings: ' || v_total_earning);
END;
/

-- Expected Output:
-- Commission is: 0
-- Base Salary: 50000
-- Commission: Not Applicable
-- Total Earnings: 50000

-- Log your completion:
-- EXEC log_assignment_attempt(3, 'COMPLETED', 'NVL function handles NULL values correctly');

-- =======================================================================
-- ASSIGNMENT #4: Simple IF Statement
-- =======================================================================
-- Requirement: Check if number is positive, negative, or zero

DECLARE
  v_number NUMBER := 42;
BEGIN
  IF v_number > 0 THEN
    DBMS_OUTPUT.PUT_LINE(v_number || ' is POSITIVE');
  ELSIF v_number < 0 THEN
    DBMS_OUTPUT.PUT_LINE(v_number || ' is NEGATIVE');
  ELSE
    DBMS_OUTPUT.PUT_LINE(v_number || ' is ZERO');
  END IF;
END;
/

-- Test with different numbers:
-- Try: v_number := 0;
-- Try: v_number := -15;
-- Try: v_number := 100;

-- Log your completion:
-- EXEC log_assignment_attempt(4, 'COMPLETED', 'IF ELSIF ELSE working for positive/negative/zero');

-- =======================================================================
-- ASSIGNMENT #5: CASE Statement
-- =======================================================================
-- Requirement: Return grade letter based on score (A=90+, B=80+, C=70+, etc.)

DECLARE
  v_score NUMBER := 85;
  v_grade VARCHAR2(1);
BEGIN
  v_grade := CASE
    WHEN v_score >= 90 THEN 'A'
    WHEN v_score >= 80 THEN 'B'
    WHEN v_score >= 70 THEN 'C'
    WHEN v_score >= 60 THEN 'D'
    ELSE 'F'
  END;
  
  DBMS_OUTPUT.PUT_LINE('Score: ' || v_score || ' - Grade: ' || v_grade);
END;
/

-- Test with different scores:
-- Try: v_score := 95; (Should be A)
-- Try: v_score := 72; (Should be C)
-- Try: v_score := 55; (Should be F)

-- Log your completion:
-- EXEC log_assignment_attempt(5, 'COMPLETED', 'CASE statement correctly assigns grades');

-- =======================================================================
-- ASSIGNMENT #6: LOOP Statement
-- =======================================================================
-- Requirement: Use LOOP to count from 1 to 10 with EXIT condition

DECLARE
  v_counter NUMBER := 1;
BEGIN
  LOOP
    DBMS_OUTPUT.PUT_LINE('Count: ' || v_counter);
    v_counter := v_counter + 1;
    EXIT WHEN v_counter > 10;
  END LOOP;
END;
/

-- Expected Output: Count: 1 through Count: 10

-- Log your completion:
-- EXEC log_assignment_attempt(6, 'COMPLETED', 'LOOP with EXIT WHEN works correctly');

-- =======================================================================
-- ASSIGNMENT #7: FOR Loop
-- =======================================================================
-- Requirement: Use FOR LOOP to print multiplication table (5 x 1 through 5 x 10)

DECLARE
  v_table_number NUMBER := 5;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Multiplication Table for ' || v_table_number);
  DBMS_OUTPUT.PUT_LINE('-----------------------------------');
  
  FOR i IN 1..10 LOOP
    DBMS_OUTPUT.PUT_LINE(v_table_number || ' x ' || i || ' = ' || (v_table_number * i));
  END LOOP;
END;
/

-- Expected Output:
-- Multiplication Table for 5
-- -----------------------------------
-- 5 x 1 = 5
-- 5 x 2 = 10
-- ... (continues through 5 x 10 = 50)

-- Log your completion:
-- EXEC log_assignment_attempt(7, 'COMPLETED', 'FOR LOOP multiplication table working');

-- =======================================================================
-- ASSIGNMENT #8: WHILE Loop
-- =======================================================================
-- Requirement: Use WHILE LOOP to find sum of numbers from 1 to 100

DECLARE
  v_counter NUMBER := 1;
  v_sum NUMBER := 0;
BEGIN
  WHILE v_counter <= 100 LOOP
    v_sum := v_sum + v_counter;
    v_counter := v_counter + 1;
  END LOOP;
  
  DBMS_OUTPUT.PUT_LINE('Sum of numbers from 1 to 100: ' || v_sum);
END;
/

-- Expected Output: Sum of numbers from 1 to 100: 5050

-- Verification: Use the formula n*(n+1)/2 = 100*101/2 = 5050 ✓

-- Log your completion:
-- EXEC log_assignment_attempt(8, 'COMPLETED', 'WHILE LOOP sum calculation correct');

-- =======================================================================
-- PROGRESS CHECK
-- =======================================================================
-- After completing assignments 1-8, run this to see your progress:
-- EXEC show_progress;

-- You should see:
-- Total Assignments: 32
-- Completed: 8
-- In Progress: 0
-- Remaining: 24

-- Next: Move on to LEVEL 2 (Assignments 9-17)
-- Focus on: SELECT INTO, Procedures, Functions, and Cursors

-- =======================================================================
