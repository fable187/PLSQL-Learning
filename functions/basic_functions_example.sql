-- PL/SQL Functions Example
-- Demonstrates creating and calling stored functions

-- Create a function to get employee full name
CREATE OR REPLACE FUNCTION get_employee_full_name(
    p_employee_id IN NUMBER
) RETURN VARCHAR2 IS
    v_full_name VARCHAR2(101);
BEGIN
    SELECT first_name || ' ' || last_name
    INTO v_full_name
    FROM sample_employees
    WHERE employee_id = p_employee_id;

    RETURN v_full_name;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Employee not found';
    WHEN OTHERS THEN
        RETURN 'Error: ' || SQLERRM;
END get_employee_full_name;
/

-- Create a function to calculate department statistics
CREATE OR REPLACE FUNCTION get_dept_stats(
    p_department IN VARCHAR2
) RETURN VARCHAR2 IS
    v_emp_count NUMBER;
    v_avg_salary NUMBER;
    v_total_salary NUMBER;
BEGIN
    SELECT COUNT(*), AVG(salary), SUM(salary)
    INTO v_emp_count, v_avg_salary, v_total_salary
    FROM sample_employees
    WHERE department = p_department;

    RETURN 'Department: ' || p_department ||
           ', Employees: ' || v_emp_count ||
           ', Avg Salary: ' || ROUND(v_avg_salary, 2) ||
           ', Total Salary: ' || v_total_salary;

EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error getting department stats: ' || SQLERRM;
END get_dept_stats;
/

-- Test the functions
DECLARE
    v_full_name VARCHAR2(101);
    v_dept_stats VARCHAR2(500);
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Testing Functions ===');

    -- Test full name function
    v_full_name := get_employee_full_name(1);
    DBMS_OUTPUT.PUT_LINE('Employee 1 full name: ' || v_full_name);

    v_full_name := get_employee_full_name(999); -- Non-existent
    DBMS_OUTPUT.PUT_LINE('Employee 999: ' || v_full_name);

    -- Test department stats function
    v_dept_stats := get_dept_stats('Engineering');
    DBMS_OUTPUT.PUT_LINE(v_dept_stats);

    v_dept_stats := get_dept_stats('HR');
    DBMS_OUTPUT.PUT_LINE(v_dept_stats);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- Drop the functions (cleanup)
DROP FUNCTION get_employee_full_name;
DROP FUNCTION get_dept_stats;