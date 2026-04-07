-- PL/SQL Procedures Example
-- Demonstrates creating and calling stored procedures

-- Create a procedure to calculate employee bonus
CREATE OR REPLACE PROCEDURE calculate_employee_bonus(
    p_employee_id IN NUMBER,
    p_bonus_percentage IN NUMBER DEFAULT 10,
    p_bonus_amount OUT NUMBER
) IS
    v_salary NUMBER;
    v_department VARCHAR2(50);
BEGIN
    -- Get employee details
    SELECT salary, department
    INTO v_salary, v_department
    FROM sample_employees
    WHERE employee_id = p_employee_id;

    -- Calculate bonus
    p_bonus_amount := v_salary * (p_bonus_percentage / 100);

    -- Log the calculation
    INSERT INTO etl_log (log_id, step_name, execution_start_time, status, error_message)
    VALUES (etl_log_seq.NEXTVAL, 'Bonus Calculation',
            SYSTIMESTAMP, 'SUCCESS',
            'Bonus calculated for employee ' || p_employee_id || ': ' || p_bonus_amount);

    COMMIT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Employee not found with ID: ' || p_employee_id);
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error calculating bonus: ' || SQLERRM);
END calculate_employee_bonus;
/

-- Test the procedure
DECLARE
    v_bonus NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Testing Procedure ===');

    -- Call procedure with default bonus percentage
    calculate_employee_bonus(1, v_bonus_amount => v_bonus);
    DBMS_OUTPUT.PUT_LINE('Bonus for employee 1: ' || v_bonus);

    -- Call procedure with custom bonus percentage
    calculate_employee_bonus(2, 15, v_bonus);
    DBMS_OUTPUT.PUT_LINE('Bonus for employee 2 (15%): ' || v_bonus);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- Drop the procedure (cleanup)
DROP PROCEDURE calculate_employee_bonus;