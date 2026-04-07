-- PL/SQL Cursor FOR LOOP Example
-- Demonstrates using cursor FOR LOOP for automatic cursor management

DECLARE
    -- Cursor declaration
    CURSOR emp_cursor IS
        SELECT employee_id, first_name, last_name, salary, department
        FROM sample_employees
        ORDER BY department, last_name;

BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Cursor FOR LOOP Example ===');

    -- Cursor FOR LOOP automatically handles OPEN, FETCH, and CLOSE
    FOR emp_record IN emp_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('Department: ' || emp_record.department ||
                           ', Employee: ' || emp_record.first_name || ' ' || emp_record.last_name ||
                           ', Salary: ' || emp_record.salary);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('=== Subquery in Cursor FOR LOOP ===');

    -- Cursor FOR LOOP with subquery (no need to declare cursor)
    FOR dept_record IN (
        SELECT department, COUNT(*) as emp_count, AVG(salary) as avg_salary
        FROM sample_employees
        GROUP BY department
        ORDER BY department
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Department: ' || dept_record.department ||
                           ', Employee Count: ' || dept_record.emp_count ||
                           ', Average Salary: ' || ROUND(dept_record.avg_salary, 2));
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/