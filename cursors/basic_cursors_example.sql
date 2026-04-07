-- PL/SQL Cursors Example
-- Demonstrates implicit and explicit cursors

DECLARE
    -- Variables for cursor data
    v_employee_id   NUMBER;
    v_first_name    VARCHAR2(50);
    v_last_name     VARCHAR2(50);
    v_salary        NUMBER;

    -- Explicit cursor declaration
    CURSOR emp_cursor IS
        SELECT employee_id, first_name, last_name, salary
        FROM sample_employees
        ORDER BY employee_id;

BEGIN
    -- Example 1: Implicit cursor (automatic for SELECT INTO)
    DBMS_OUTPUT.PUT_LINE('=== Implicit Cursor Example ===');
    BEGIN
        SELECT employee_id, first_name, last_name, salary
        INTO v_employee_id, v_first_name, v_last_name, v_salary
        FROM sample_employees
        WHERE employee_id = 1;

        DBMS_OUTPUT.PUT_LINE('Employee: ' || v_first_name || ' ' || v_last_name ||
                           ', Salary: ' || v_salary);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No employee found');
    END;

    -- Example 2: Explicit cursor
    DBMS_OUTPUT.PUT_LINE('=== Explicit Cursor Example ===');
    OPEN emp_cursor;

    LOOP
        FETCH emp_cursor INTO v_employee_id, v_first_name, v_last_name, v_salary;
        EXIT WHEN emp_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('ID: ' || v_employee_id || ', Name: ' ||
                           v_first_name || ' ' || v_last_name || ', Salary: ' || v_salary);
    END LOOP;

    CLOSE emp_cursor;

    -- Cursor attributes
    DBMS_OUTPUT.PUT_LINE('=== Cursor Attributes ===');
    OPEN emp_cursor;
    FETCH emp_cursor INTO v_employee_id, v_first_name, v_last_name, v_salary;
    DBMS_OUTPUT.PUT_LINE('Row count: ' || emp_cursor%ROWCOUNT);
    DBMS_OUTPUT.PUT_LINE('Is open: ' || CASE WHEN emp_cursor%ISOPEN THEN 'Yes' ELSE 'No' END);
    CLOSE emp_cursor;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        IF emp_cursor%ISOPEN THEN
            CLOSE emp_cursor;
        END IF;
END;
/