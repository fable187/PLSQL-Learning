-- =======================================================================
-- QUICK START GUIDE - Run these commands to get started
-- =======================================================================

-- First, make sure output is enabled:
SET SERVEROUTPUT ON SIZE 20000;

-- =======================================================================
-- STEP 1: View your complete curriculum
-- =======================================================================
SELECT assignment_id, level_num, topic, title 
FROM learning_curriculum 
ORDER BY assignment_id;

-- This shows all 32 assignments organized by difficulty level

-- =======================================================================
-- STEP 2: Pick your first assignment and get details
-- =======================================================================
-- Option A: View Assignment #1 (Hello PL/SQL)
EXEC show_assignment(1);

-- Option B: View Assignment #4 (Simple IF Statement)  
EXEC show_assignment(4);

-- Option C: View any assignment - just change the number
-- EXEC show_assignment(15);

-- =======================================================================
-- STEP 3: Write your solution
-- =======================================================================
-- Option 1: Create a new SQL file for each assignment
-- - Use: EXAMPLE_SOLUTIONS_LEVEL1.sql as a reference
-- - TRY to solve it yourself FIRST
-- - Only look at the example if you're stuck

-- Option 2: Write directly in the Oracle terminal
-- Copy the example code, modify it, and run it

-- =======================================================================
-- STEP 4: Test your solution
-- =======================================================================
-- Run your code and verify:
-- ✓ Does it produce the expected output?
-- ✓ Are there any error messages?
-- ✓ Have you used the correct syntax?

-- =======================================================================
-- STEP 5: Record your completion
-- =======================================================================
-- Once your solution is working, run this:
EXEC log_assignment_attempt(1, 'COMPLETED', 'Successfully created Hello World block');

-- Replace the numbers:
-- - 1 = the assignment number you completed
-- - 'COMPLETED' = your status
-- - 'Successfully created...' = any notes about your solution

-- =======================================================================
-- STEP 6: Check your progress
-- =======================================================================
-- See how many assignments you've completed:
EXEC show_progress;

-- This will show:
-- - Total assignments
-- - How many you've completed
-- - How many are in progress
-- - Your 5 most recent attempts

-- =======================================================================
-- STEP 7: Move to the next assignment
-- =======================================================================
-- When ready, view the next assignment and repeat Steps 2-6
-- EXEC show_assignment(2);

-- =======================================================================
-- USEFUL QUERIES
-- =======================================================================

-- See all your completed assignments:
SELECT aa.assignment_id, lc.title, aa.status, aa.attempt_date, aa.feedback
FROM assignment_attempts aa
JOIN learning_curriculum lc ON aa.assignment_id = lc.assignment_id
ORDER BY aa.attempt_date DESC;

-- See assignments you haven't started yet:
SELECT assignment_id, level_num, topic, title
FROM learning_curriculum
WHERE assignment_id NOT IN (SELECT assignment_id FROM assignment_attempts)
ORDER BY assignment_id;

-- See your completion rate by level:
SELECT 
  lc.level_num,
  COUNT(DISTINCT lc.assignment_id) AS total_assignments,
  COUNT(DISTINCT CASE WHEN aa.status = 'COMPLETED' THEN lc.assignment_id END) AS completed,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN aa.status = 'COMPLETED' THEN lc.assignment_id END) 
        / COUNT(DISTINCT lc.assignment_id), 1) AS completion_percentage
FROM learning_curriculum lc
LEFT JOIN assignment_attempts aa ON lc.assignment_id = aa.assignment_id AND aa.status = 'COMPLETED'
GROUP BY lc.level_num
ORDER BY lc.level_num;

-- =======================================================================
-- CURRICULUM OVERVIEW
-- =======================================================================
--
-- LEVEL 1 (Fundamental): Assignments 1-8
-- ├─ Variables, NULL handling, IF/CASE, Loops
--
-- LEVEL 2 (Intermediate): Assignments 9-17
-- ├─ SELECT INTO, Procedures, Functions, Cursors
--
-- LEVEL 3 (Advanced): Assignments 18-26
-- ├─ Exception Handling, Packages, Records, Triggers
--
-- LEVEL 4 (Expert): Assignments 27-32
-- └─ Collections, BULK Operations, Dynamic SQL, Refactoring
--
-- =======================================================================
-- FILES CREATED FOR THIS COURSE
-- =======================================================================
--
-- 1. COURSE_GUIDE.md - Complete guide to the curriculum
-- 2. learning_course.sql - Quick reference and utilities
-- 3. EXAMPLE_SOLUTIONS_LEVEL1.sql - Sample code for first 8 assignments
-- 4. QUICK_START_GUIDE.sql - This file! Execute the commands above
--
-- =======================================================================
-- READY TO START? 🚀
-- =======================================================================
-- 
-- 1. Run: EXEC show_assignment(1);
-- 2. Read the assignment details carefully
-- 3. Write your PL/SQL code in a new file
-- 4. Test it until it works
-- 5. Run: EXEC log_assignment_attempt(1, 'COMPLETED', 'Your notes');
-- 6. Move to assignment #2 and repeat
--
-- You've got this! 💪
--
-- =======================================================================
