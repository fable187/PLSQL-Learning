# Interactive PL/SQL Learning Course

## Overview

This project now uses a 44-assignment curriculum stored in `SYSTEM.LEARNING_CURRICULUM`.
The course is designed for daily practice over several weeks, with one assignment solved at a time and reviewed before it is marked complete.

## Course Structure

### LEVEL 1: Fundamentals

| # | Topic | Assignment |
|---|---|---|
| 1 | Variables & Basics | Hello PL/SQL |
| 2 | Variables & Basics | Variable Declaration |
| 3 | Variables & Basics | Working with NULL |
| 4 | Control Structures | Simple IF Statement |
| 5 | Control Structures | CASE Statement |
| 6 | Loops | LOOP Statement |
| 7 | Loops | FOR Loop |
| 8 | Loops | WHILE Loop |

### LEVEL 2: Intermediate

| # | Topic | Assignment |
|---|---|---|
| 9 | SELECT INTO | Basic SELECT INTO |
| 10 | SELECT INTO | Handling NO_DATA_FOUND |
| 11 | Procedures | Simple Procedure |
| 12 | Procedures | Procedure with Multiple Parameters |
| 13 | Functions | Simple Function |
| 14 | Functions | Function with Calculations |
| 15 | Cursors | Simple Cursor |
| 16 | Cursors | Cursor FOR Loop |
| 17 | Cursors | Parameterized Cursor |

### LEVEL 3: Advanced

| # | Topic | Assignment |
|---|---|---|
| 18 | Exception Handling | Basic Exceptions |
| 19 | Exception Handling | User-Defined Exceptions |
| 20 | Exception Handling | Exception with SQLCODE |
| 21 | Packages | Package Specification |
| 22 | Packages | Package Body |
| 23 | Records | Table-based Record |
| 24 | Records | User-Defined Record |
| 25 | Triggers | Simple INSERT Trigger |
| 26 | Triggers | UPDATE Trigger |

### LEVEL 4: Expert

| # | Topic | Assignment |
|---|---|---|
| 27 | Collections | Nested Tables |
| 28 | Collections | Associative Arrays |
| 29 | BULK Operations | BULK COLLECT |
| 30 | BULK Operations | FORALL Statement |
| 31 | Advanced | Dynamic SQL |
| 32 | Advanced | Refactoring Project |

### LEVEL 5: Bulk Processing Foundations

| # | Topic | Assignment |
|---|---|---|
| 33 | Records | Record Warm-Up |
| 34 | Collections | Nested Table Aggregation |
| 35 | BULK Operations | BULK COLLECT with Setup Data |
| 36 | BULK Operations | FORALL Data Load |

### LEVEL 6: Data Access Patterns

| # | Topic | Assignment |
|---|---|---|
| 37 | Cursors | Explicit Cursor Reporting |
| 38 | Cursors | Parameterized Cursor Filtering |
| 39 | Advanced | Dynamic SQL Table Counter |
| 40 | Exception Handling | Custom Validation Exception |

### LEVEL 7: Production Patterns

| # | Topic | Assignment |
|---|---|---|
| 41 | Packages | Package State Counter |
| 42 | Packages | Collection-Returning Package Function |
| 43 | Transactions | Autonomous Transaction Logger |
| 44 | Triggers | Compound Trigger Summary |

## Core Commands

View the full curriculum:

```sql
SELECT assignment_id, level_num, topic, title
FROM learning_curriculum
ORDER BY assignment_id;
```

View one assignment in detail:

```sql
EXEC show_assignment(1);
```

Track progress:

```sql
EXEC show_progress;
```

Log a completed assignment:

```sql
EXEC log_assignment_attempt(1, 'COMPLETED', 'First block created and verified');
```

## How We Will Work

For each assignment:

1. Run `EXEC show_assignment(<id>);`
2. Solve it in your own SQL file
3. Execute it
4. Paste me the code and the output or error
5. I review it with you
6. When it is correct, log it as `COMPLETED`

This keeps the course focused and lets us verify each concept before moving on.

## Recommended Pace

- Week 1: Assignments 1-8
- Week 2: Assignments 9-17
- Week 3: Assignments 18-26
- Week 4: Assignments 27-36
- Week 5: Assignments 37-44 plus review

See [DAILY_PLAN_14_DAYS.md](c:\Users\gaela\OracleSandBox\PLSQL-Learning\DAILY_PLAN_14_DAYS.md) for the original 32-assignment sprint plan. The new Levels 5-7 extend the course beyond that schedule.

## Files To Use

- [QUICK_START_GUIDE.sql](c:\Users\gaela\OracleSandBox\PLSQL-Learning\QUICK_START_GUIDE.sql)
- [learning_course.sql](c:\Users\gaela\OracleSandBox\PLSQL-Learning\learning_course.sql)
- [EXAMPLE_SOLUTIONS_LEVEL1.sql](c:\Users\gaela\OracleSandBox\PLSQL-Learning\EXAMPLE_SOLUTIONS_LEVEL1.sql)
- [work\README.md](c:\Users\gaela\OracleSandBox\PLSQL-Learning\work\README.md)

## Notes

- Enable output with `SET SERVEROUTPUT ON`.
- Solve assignments in order unless we explicitly decide to skip ahead.
- Use `EXAMPLE_SOLUTIONS_LEVEL1.sql` as a reference, not as the default first attempt.
- Later assignments may use `SAMPLE_EMPLOYEES`, `INVALID_SALARIES`, and the ETL tables already present in the database.
