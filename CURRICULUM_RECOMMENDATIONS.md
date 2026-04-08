# PL/SQL Curriculum Recommendations

## Current State

- The live `SYSTEM.LEARNING_CURRICULUM` table contains 44 assignments.
- Assignment IDs run from `1` through `44`.
- `SYSTEM.ASSIGNMENT_ATTEMPTS` is ready to track progress.
- The helper procedures are available and valid:
  - `SHOW_CURRICULUM`
  - `SHOW_ASSIGNMENT`
  - `SHOW_PROGRESS`
  - `LOG_ASSIGNMENT_ATTEMPT`

## Recommended Sequence

Work in strict assignment order.

### Level 1

1. Hello PL/SQL
2. Variable Declaration
3. Working with NULL
4. Simple IF Statement
5. CASE Statement
6. LOOP Statement
7. FOR Loop
8. WHILE Loop

### Level 2

9. Basic SELECT INTO
10. Handling NO_DATA_FOUND
11. Simple Procedure
12. Procedure with Multiple Parameters
13. Simple Function
14. Function with Calculations
15. Simple Cursor
16. Cursor FOR Loop
17. Parameterized Cursor

### Level 3

18. Basic Exceptions
19. User-Defined Exceptions
20. Exception with SQLCODE
21. Package Specification
22. Package Body
23. Table-based Record
24. User-Defined Record
25. Simple INSERT Trigger
26. UPDATE Trigger

### Level 4

27. Nested Tables
28. Associative Arrays
29. BULK COLLECT
30. FORALL Statement
31. Dynamic SQL
32. Refactoring Project

### Level 5

33. Record Warm-Up
34. Nested Table Aggregation
35. BULK COLLECT with Setup Data
36. FORALL Data Load

### Level 6

37. Explicit Cursor Reporting
38. Parameterized Cursor Filtering
39. Dynamic SQL Table Counter
40. Custom Validation Exception

### Level 7

41. Package State Counter
42. Collection-Returning Package Function
43. Autonomous Transaction Logger
44. Compound Trigger Summary

## Why This Flow Works

- It starts with anonymous blocks and output.
- It adds branching and loops before database querying.
- It moves into procedures and functions before cursors.
- It introduces exceptions before packages and triggers.
- It leaves collections, bulk processing, dynamic SQL, package state, and transaction patterns for the end.

## Review Workflow

For each assignment:

1. Run:
   ```sql
   SET SERVEROUTPUT ON
   EXEC show_assignment(<id>);
   ```
2. Write your solution in the `work` folder.
3. Execute it.
4. Share the assignment number, code, and output.
5. Review it with me.
6. Log it as completed only after verification.

## Best Project Improvements Already Applied

1. Reinserted assignments `1-3` into `LEARNING_CURRICULUM`.
2. Updated the guides to match the live database.
3. Added a 14-day study plan.
4. Added a `work` folder guide for saving daily solutions.

## Recommended Start

Start with assignment `1` today and send me your solution before logging it.
