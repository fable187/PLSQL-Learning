-- PL/SQL Packages Example
-- Demonstrates creating package specification and body

-- Package Specification
CREATE OR REPLACE PACKAGE employee_pkg IS
    -- Public procedure
    PROCEDURE update_employee_salary(
        p_employee_id IN NUMBER,
        p_new_salary IN NUMBER
    );

    -- Public function
    FUNCTION get_employee_count RETURN NUMBER;

    -- Public function with parameters
    FUNCTION get_department_budget(
        p_department IN VARCHAR2
    ) RETURN NUMBER;

    -- Public exception
    employee_not_found EXCEPTION;

END employee_pkg;
/

-- Package Body
CREATE OR REPLACE PACKAGE BODY employee_pkg IS

    -- Private procedure (not in spec)
    PROCEDURE log_salary_change(
        p_employee_id IN NUMBER,
        p_old_salary IN NUMBER,
        p_new_salary IN NUMBER
    ) IS
    BEGIN
        INSERT INTO etl_log (log_id, step_name, execution_start_time, status, error_message)
        VALUES (etl_log_seq.NEXTVAL, 'Salary Update',
                SYSTIMESTAMP, 'SUCCESS',
                'Salary changed for employee ' || p_employee_id ||
                ' from ' || p_old_salary || ' to ' || p_new_salary);
    END log_salary_change;

    -- Implementation of public procedure
    PROCEDURE update_employee_salary(
        p_employee_id IN NUMBER,
        p_new_salary IN NUMBER
    ) IS
        v_old_salary NUMBER;
    BEGIN
        -- Get current salary
        SELECT salary INTO v_old_salary
        FROM sample_employees
        WHERE employee_id = p_employee_id;

        -- Update salary
        UPDATE sample_employees
        SET salary = p_new_salary
        WHERE employee_id = p_employee_id;

        -- Log the change
        log_salary_change(p_employee_id, v_old_salary, p_new_salary);

        COMMIT;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE employee_not_found;
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END update_employee_salary;

    -- Implementation of public function
    FUNCTION get_employee_count RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM sample_employees;
        RETURN v_count;
    END get_employee_count;

    -- Implementation of public function
    FUNCTION get_department_budget(
        p_department IN VARCHAR2
    ) RETURN NUMBER IS
        v_budget NUMBER;
    BEGIN
        SELECT SUM(salary) INTO v_budget
        FROM sample_employees
        WHERE department = p_department;

        RETURN NVL(v_budget, 0);
    END get_department_budget;

END employee_pkg;
/

-- Test the package
DECLARE
    v_count NUMBER;
    v_budget NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Testing Package ===');

    -- Test function
    v_count := employee_pkg.get_employee_count();
    DBMS_OUTPUT.PUT_LINE('Total employees: ' || v_count);

    -- Test department budget
    v_budget := employee_pkg.get_department_budget('Engineering');
    DBMS_OUTPUT.PUT_LINE('Engineering budget: ' || v_budget);

    -- Test procedure (update salary)
    BEGIN
        employee_pkg.update_employee_salary(1, 60000);
        DBMS_OUTPUT.PUT_LINE('Salary updated successfully');
    EXCEPTION
        WHEN employee_pkg.employee_not_found THEN
            DBMS_OUTPUT.PUT_LINE('Employee not found');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error updating salary: ' || SQLERRM);
    END;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- Drop the package (cleanup)
DROP PACKAGE employee_pkg;