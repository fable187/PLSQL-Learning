# 🎓 Interactive PL/SQL Learning Course

## Overview
This is a comprehensive, self-paced learning curriculum with **32 assignments** organized into 4 levels, designed to take you from PL/SQL beginner to expert. Each assignment has clear objectives, hints, and you can verify your work as you complete them.

---

## 📚 Course Structure

### **LEVEL 1: Fundamentals** (Assignments 1-8)
Master core PL/SQL concepts: variables, control flow, and loops.

| # | Topic | Assignment | 
|----|-------|-----------|
| 1 | Variables & Basics | Hello PL/SQL |
| 2 | Variables & Basics | Variable Declaration |
| 3 | Variables & Basics | Working with NULL |
| 4 | Control Structures | Simple IF Statement |
| 5 | Control Structures | CASE Statement |
| 6 | Loops | LOOP Statement |
| 7 | Loops | FOR Loop |
| 8 | Loops | WHILE Loop |

### **LEVEL 2: Intermediate** (Assignments 9-17)
Work with database queries, procedures, functions, and cursors.

| # | Topic | Assignment | 
|----|-------|-----------|
| 9 | SELECT INTO | Basic SELECT INTO |
| 10 | SELECT INTO | Handling NO_DATA_FOUND |
| 11 | Procedures | Simple Procedure |
| 12 | Procedures | Procedure with Multiple Parameters |
| 13 | Functions | Simple Function |
| 14 | Functions | Function with Calculations |
| 15 | Cursors | Simple Cursor |
| 16 | Cursors | Cursor FOR Loop |
| 17 | Cursors | Parameterized Cursor |

### **LEVEL 3: Advanced** (Assignments 18-26)
Master exception handling, packages, records, and triggers.

| # | Topic | Assignment | 
|----|-------|-----------|
| 18 | Exception Handling | Basic Exceptions |
| 19 | Exception Handling | User-Defined Exceptions |
| 20 | Exception Handling | Exception with SQLCODE |
| 21 | Packages | Package Specification |
| 22 | Packages | Package Body |
| 23 | Records | Table-based Record |
| 24 | Records | User-Defined Record |
| 25 | Triggers | Simple INSERT Trigger |
| 26 | Triggers | UPDATE Trigger |

### **LEVEL 4: Expert** (Assignments 27-32)
Learn bulk operations, collections, and dynamic SQL.

| # | Topic | Assignment | 
|----|-------|-----------|
| 27 | Collections | Nested Tables |
| 28 | Collections | Associative Arrays |
| 29 | BULK Operations | BULK COLLECT |
| 30 | BULK Operations | FORALL Statement |
| 31 | Advanced | Dynamic SQL |
| 32 | Advanced | Refactoring Project |

---

## 🚀 How to Get Started

### Step 1: View Your Curriculum
```sql
SELECT assignment_id, level_num, topic, title 
FROM learning_curriculum 
ORDER BY assignment_id;
```

### Step 2: Get Details on an Assignment
To get detailed instructions, objectives, and hints for any assignment:
```sql
EXEC show_assignment(4);
```
Replace `4` with the assignment number you want to learn about.

### Step 3: Complete the Assignment
- Write your PL/SQL code in a new SQL file
- Test it thoroughly to ensure it works
- Verify the outputs match the requirements

### Step 4: Log Your Completion
Once you've verified your solution works:
```sql
EXEC log_assignment_attempt(4, 'COMPLETED', 'Successfully created IF statement checking positive/negative');
```

### Step 5: Track Your Progress
```sql
EXEC show_progress;
```

---

## 📝 Example: Assignment #4

### Get the Assignment Details
```sql
EXEC show_assignment(4);
```

### Assignment Requirements
**Topic:** Control Structures  
**Title:** Simple IF Statement  
**Description:** Check if a number is positive, negative, or zero  
**Objectives:** Learn IF...THEN...ELSIF...ELSE...END IF syntax  
**Hints:** Use comparison operators (>, <, =, >=, <=)  

### Sample Solution
```plsql
DECLARE
  v_number NUMBER := -5;
BEGIN
  IF v_number > 0 THEN
    DBMS_OUTPUT.PUT_LINE(v_number || ' is positive');
  ELSIF v_number < 0 THEN
    DBMS_OUTPUT.PUT_LINE(v_number || ' is negative');
  ELSE
    DBMS_OUTPUT.PUT_LINE(v_number || ' is zero');
  END IF;
END;
/
```

### Test Your Solution
Run your code and verify the output is correct. If it works, log it:
```sql
EXEC log_assignment_attempt(4, 'COMPLETED', 'IF statement working correctly for positive, negative, and zero values');
```

---

## 💡 Tips for Success

1. **Start at Level 1** - Even if you know some PL/SQL, the fundamentals are important
2. **Test Thoroughly** - Make sure your code produces the expected output
3. **Use Hints** - If stuck, run `EXEC show_assignment(X)` to see helpful hints
4. **Practice, Practice** - Complete 1-2 assignments per day for consistent learning
5. **Review Past Work** - Look at previous assignments to reinforce concepts
6. **Build Projects** - Level 4 has a Refactoring Project where you combine everything

---

## 📊 Tracking Your Progress

### View All Completed Assignments
```sql
SELECT * FROM assignment_attempts WHERE status = 'COMPLETED' ORDER BY attempt_date;
```

### View Your Learning Stats
```sql
EXEC show_progress;
```

### See What's Next
```sql
SELECT assignment_id, title FROM learning_curriculum 
WHERE assignment_id NOT IN (SELECT assignment_id FROM assignment_attempts)
ORDER BY assignment_id 
FETCH FIRST 5 ROWS ONLY;
```

---

## 🎯 Curriculum Highlights

### **What You'll Learn**

- ✅ PL/SQL Block Structure (DECLARE, BEGIN, END)
- ✅ Variables & Data Types
- ✅ Control Structures (IF, CASE)
- ✅ Loops (LOOP, FOR, WHILE)
- ✅ SELECT INTO and Data Retrieval
- ✅ Procedures (Creating and Calling)
- ✅ Functions (Creating and Using)
- ✅ Cursors (Declared, FOR Loop, Parameterized)
- ✅ Exception Handling (Built-in, Custom)
- ✅ Packages (Spec & Body)
- ✅ Records (Table-based, User-defined)
- ✅ Triggers (INSERT, UPDATE, DELETE)
- ✅ Collections (Nested Tables, Associative Arrays)
- ✅ BULK Operations (BULK COLLECT, FORALL)
- ✅ Dynamic SQL (EXECUTE IMMEDIATE)

---

## 🔧 Available Commands

| Command | Purpose |
|---------|---------|
| `EXEC show_curriculum;` | Display all assignments organized by level |
| `EXEC show_assignment(X);` | Show detailed info for assignment #X |
| `EXEC log_assignment_attempt(X, 'COMPLETED', 'notes');` | Record completion of assignment #X |
| `EXEC show_progress;` | View your learning progress and statistics |

---

## 📌 Important Notes

- **Always test your code** before logging completion
- **Use DBMS_OUTPUT** when you need to see results  
- Remember to `SET SERVEROUTPUT ON` for output visibility
- Save your work in separate SQL files organized by level
- The database is your sandbox - experiment freely!

---

## 🎓 Next Steps

1. Open `learning_course.sql` for quick reference
2. Run `SELECT * FROM learning_curriculum` to see all assignments
3. Start with Assignment #1 and work your way through
4. Use `EXEC show_progress` to track your journey
5. Join the quest to become a PL/SQL master! 🚀

---

**Happy Learning! 🎉**
