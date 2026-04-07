-- PL/SQL SELECT INTO Example
-- Demonstrates fetching single row data into variables

DECLARE
    -- Variables to hold query results
    v_employee_id   NUMBER;
    v_first_name    VARCHAR2(50);
    v_last_name     VARCHAR2(50);
    v_salary        NUMBER;
    v_department    VARCHAR2(50);

    -- Variables for aggregate queries
    v_total_employees NUMBER;
    v_avg_salary      NUMBER;
    v_max_salary      NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Single Row SELECT INTO ===');

    -- Fetch single employee data
    SELECT employee_id, first_name, last_name, salary, department
    INTO v_employee_id, v_first_name, v_last_name, v_salary, v_department
    FROM sample_employees
    WHERE employee_id = 1;

    DBMS_OUTPUT.PUT_LINE('Employee Details:');
    DBMS_OUTPUT.PUT_LINE('ID: ' || v_employee_id);
    DBMS_OUTPUT.PUT_LINE('Name: ' || v_first_name || ' ' || v_last_name);
    DBMS_OUTPUT.PUT_LINE('Salary: ' || v_salary);
    DBMS_OUTPUT.PUT_LINE('Department: ' || v_department);

    DBMS_OUTPUT.PUT_LINE('=== Aggregate SELECT INTO ===');

    -- Fetch aggregate data
    SELECT COUNT(*), AVG(salary), MAX(salary)
    INTO v_total_employees, v_avg_salary, v_max_salary
    FROM sample_employees;

    DBMS_OUTPUT.PUT_LINE('Total Employees: ' || v_total_employees);
    DBMS_OUTPUT.PUT_LINE('Average Salary: ' || ROUND(v_avg_salary, 2));
    DBMS_OUTPUT.PUT_LINE('Maximum Salary: ' || v_max_salary);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found for the query');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Query returned more than one row');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/