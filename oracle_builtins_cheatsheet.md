# Oracle / PL/SQL Built-Ins Cheat Sheet

This is a practical reference for common Oracle SQL and PL/SQL built-ins you are likely to use in assignments.

## 1. Output and Debugging

```sql
SET SERVEROUTPUT ON;
DBMS_OUTPUT.PUT_LINE('Hello');
```

- `DBMS_OUTPUT.PUT_LINE(text)` prints a line to the output buffer.
- `SET SERVEROUTPUT ON` is required in SQL*Plus/SQLcl/VS Code SQL Developer tooling to see output.

## 2. Comparison and Conditional Helpers

```sql
GREATEST(10, 5)      -- 10
LEAST(10, 5)         -- 5
NVL(NULL, 0)         -- 0
NVL2(expr, a, b)     -- a if expr is not null, else b
COALESCE(a, b, c)    -- first non-null value
NULLIF(a, b)         -- null if a = b, else a
```

- `GREATEST(a, b, ...)` returns the largest scalar value.
- `LEAST(a, b, ...)` returns the smallest scalar value.
- `NVL(expr, default)` replaces `NULL`.
- `COALESCE(...)` is a more flexible `NVL`.
- `NULLIF(a, b)` is useful for avoiding divide-by-zero logic.

## 3. Numeric Functions

```sql
ABS(-7)          -- 7
MOD(10, 3)       -- 1
ROUND(12.345, 2) -- 12.35
TRUNC(12.345, 2) -- 12.34
CEIL(4.2)        -- 5
FLOOR(4.8)       -- 4
POWER(2, 3)      -- 8
SQRT(25)         -- 5
SIGN(-8)         -- -1
```

- `ROUND(n, d)` rounds to `d` decimal places.
- `TRUNC(n, d)` cuts off digits without rounding.
- `MOD(a, b)` gives the remainder.

## 4. String Functions

```sql
UPPER('cat')                 -- CAT
LOWER('CAT')                 -- cat
INITCAP('hello world')       -- Hello World
LENGTH('Oracle')             -- 6
SUBSTR('Oracle', 2, 3)       -- rac
INSTR('banana', 'na')        -- 3
REPLACE('a-b-c', '-', ' ')   -- a b c
TRIM('  hi  ')               -- hi
LTRIM('  hi')                -- hi
RTRIM('hi  ')                -- hi
LPAD('7', 3, '0')            -- 007
RPAD('7', 3, '0')            -- 700
CONCAT('A', 'B')             -- AB
```

- `||` is the usual string concatenation operator.
- `SUBSTR(text, start, len)` starts at position `1`, not `0`.
- `INSTR(text, search)` returns the position of the match.

## 5. Date / Time Functions

```sql
SYSDATE
CURRENT_DATE
SYSTIMESTAMP
ADD_MONTHS(SYSDATE, 1)
MONTHS_BETWEEN(date1, date2)
NEXT_DAY(SYSDATE, 'FRIDAY')
LAST_DAY(SYSDATE)
```

- `SYSDATE` returns current date/time from the database server.
- `SYSTIMESTAMP` includes fractional seconds and timezone info.
- `ADD_MONTHS(date, n)` adds months.
- `LAST_DAY(date)` returns the last day of that month.

Formatting:

```sql
TO_CHAR(SYSDATE, 'YYYY-MM-DD')
TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS')
TO_DATE('2026-04-07', 'YYYY-MM-DD')
```

## 6. Conversion Functions

```sql
TO_CHAR(1234.56)
TO_CHAR(SYSDATE, 'YYYY-MM-DD')
TO_NUMBER('42')
TO_DATE('07-APR-2026', 'DD-MON-YYYY')
CAST(5 AS VARCHAR2(10))
```

- `TO_CHAR` converts numbers/dates to text.
- `TO_NUMBER` converts text to number.
- `TO_DATE` converts text to date using a format mask.
- `CAST` converts between compatible types.

## 7. Aggregate Functions

Used across many rows in SQL:

```sql
COUNT(*)
SUM(salary)
AVG(salary)
MIN(salary)
MAX(salary)
```

Important:

- `MAX()` and `MIN()` are aggregate SQL functions.
- They are not the same thing as Python-style `max(a, b)`.
- For scalar comparisons, use `GREATEST()` and `LEAST()`.

## 8. Common Single-Row SQL Helpers

```sql
DISTINCT
CASE
DECODE
```

Example `CASE`:

```sql
CASE
    WHEN salary >= 10000 THEN 'HIGH'
    WHEN salary >= 5000 THEN 'MEDIUM'
    ELSE 'LOW'
END
```

Example `DECODE`:

```sql
DECODE(status, 'A', 'Active', 'I', 'Inactive', 'Unknown')
```

- Prefer `CASE` for readability.
- `DECODE` is older Oracle syntax but still common.

## 9. Exception Names You Will See Often

```sql
NO_DATA_FOUND
TOO_MANY_ROWS
ZERO_DIVIDE
VALUE_ERROR
INVALID_NUMBER
```

Example:

```sql
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No matching row');
```

## 10. Common SQL / PL/SQL Patterns

### One row into variables

```sql
SELECT first_name, last_name
INTO v_first_name, v_last_name
FROM employees
WHERE employee_id = 100;
```

- `SELECT ... INTO ...` expects exactly one row.
- `0` rows -> `NO_DATA_FOUND`
- more than `1` row -> `TOO_MANY_ROWS`

### Multiple rows with a loop

```sql
FOR emp IN (
    SELECT employee_id, first_name
    FROM employees
) LOOP
    DBMS_OUTPUT.PUT_LINE(emp.employee_id || ' ' || emp.first_name);
END LOOP;
```

### Multiple rows with `BULK COLLECT`

```sql
DECLARE
    TYPE num_tab IS TABLE OF NUMBER;
    v_ids num_tab;
BEGIN
    SELECT employee_id
    BULK COLLECT INTO v_ids
    FROM employees;
END;
/
```

## 11. Procedure / Function Syntax Reminders

Procedure:

```sql
CREATE OR REPLACE PROCEDURE proc_name(p_id IN NUMBER) IS
BEGIN
    NULL;
END;
/
```

Function:

```sql
CREATE OR REPLACE FUNCTION fn_name(p_id IN NUMBER)
RETURN NUMBER
IS
BEGIN
    RETURN p_id * 2;
END;
/
```

Parameter modes:

- `IN` = input only
- `OUT` = output only
- `IN OUT` = input and output

## 12. Handy SQL*Plus / SQLcl Commands

```sql
SET SERVEROUTPUT ON;
DESC employees;
VARIABLE area NUMBER;
EXEC my_proc(:area);
PRINT area;
```

- `SET SERVEROUTPUT ON` shows `DBMS_OUTPUT`.
- `DESC table_name` describes columns.
- `VARIABLE x NUMBER` creates a bind variable.
- `EXEC` is shorthand for `EXECUTE`.
- `PRINT x` shows a bind variable value.

## 13. Package-Based Shared Constants and Types

Shared constants:

```sql
CREATE OR REPLACE PACKAGE app_constants IS
    c_status_new CONSTANT VARCHAR2(10) := 'NEW';
END app_constants;
/
```

Shared types:

```sql
CREATE OR REPLACE PACKAGE app_types IS
    TYPE num_tab IS TABLE OF NUMBER;
END app_types;
/
```

Usage:

```sql
DECLARE
    v_nums app_types.num_tab;
BEGIN
    NULL;
END;
/
```

## 14. Fast Mental Rules

- Use `GREATEST()` instead of Python-style `max(a, b)`.
- Use `CASE` for branching in SQL expressions.
- Use `IF` for branching in PL/SQL statements.
- Use `SELECT ... INTO ...` only when exactly one row should come back.
- Use `DBMS_OUTPUT.PUT_LINE` for simple debugging.
- Use `TO_CHAR` / `TO_DATE` when formatting or parsing dates.
- Use packages for shared constants and types.

## 15. Small Example Block

```sql
SET SERVEROUTPUT ON;

DECLARE
    v_a NUMBER := 10;
    v_b NUMBER := 5;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Greatest: ' || GREATEST(v_a, v_b));
    DBMS_OUTPUT.PUT_LINE('Rounded: ' || ROUND(12.345, 2));
    DBMS_OUTPUT.PUT_LINE('Today: ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD'));
END;
/
```
