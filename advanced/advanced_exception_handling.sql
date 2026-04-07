-- PL/SQL Advanced Exception Handling Example
-- Demonstrates exception propagation, custom exceptions, and SQLCODE/SQLERRM

DECLARE
    -- Custom exception
    e_invalid_salary EXCEPTION;
    v_employee_id NUMBER := 1;
    v_salary NUMBER;

    -- Procedure that can raise exceptions
    PROCEDURE validate_and_update_salary(p_emp_id NUMBER, p_new_salary NUMBER) IS
        v_current_salary NUMBER;
    BEGIN
        -- Get current salary
        SELECT salary INTO v_current_salary
        FROM sample_employees
        WHERE employee_id = p_employee_id;

        -- Validate salary increase
        IF p_new_salary < v_current_salary THEN
            RAISE e_invalid_salary;
        END IF;

        -- Update salary
        UPDATE sample_employees
        SET salary = p_new_salary
        WHERE employee_id = p_employee_id;

        DBMS_OUTPUT.PUT_LINE('Salary updated successfully');

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Re-raise with custom message
            RAISE_APPLICATION_ERROR(-20001, 'Employee not found: ' || p_emp_id);
        WHEN e_invalid_salary THEN
            RAISE_APPLICATION_ERROR(-20002, 'New salary cannot be less than current salary');
    END validate_and_update_salary;

BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Testing Exception Handling ===');

    -- Test successful update
    BEGIN
        validate_and_update_salary(1, 65000);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error in successful update: ' || SQLERRM);
    END;

    -- Test invalid salary (should raise custom exception)
    BEGIN
        validate_and_update_salary(1, 30000);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Caught invalid salary exception: ' || SQLERRM);
    END;

    -- Test non-existent employee
    BEGIN
        validate_and_update_salary(999, 50000);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Caught employee not found: ' || SQLERRM);
    END;

    -- Demonstrate SQLCODE and SQLERRM
    DBMS_OUTPUT.PUT_LINE('=== SQLCODE and SQLERRM Example ===');
    BEGIN
        -- Force a division by zero
        v_salary := 100 / 0;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('SQLCODE: ' || SQLCODE);
            DBMS_OUTPUT.PUT_LINE('SQLERRM: ' || SQLERRM);
            DBMS_OUTPUT.PUT_LINE('Custom message: An error occurred with code ' || SQLCODE);
    END;

    ROLLBACK;  -- Undo any changes

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Outer block error: ' || SQLERRM);
        ROLLBACK;
END;
/