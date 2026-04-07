-- PL/SQL Comments Example
-- Demonstrates single-line and multi-line comments

DECLARE
    v_employee_id NUMBER := 1;  -- Employee ID to query
    v_salary NUMBER;            -- Variable to store salary
BEGIN
    /*
     * Multi-line comment example
     * This block demonstrates different types of comments
     * and fetches employee salary
     */

    -- Single-line comment: Get employee salary
    SELECT salary
    INTO v_salary
    FROM sample_employees
    WHERE employee_id = v_employee_id;

    -- Display result
    DBMS_OUTPUT.PUT_LINE('Employee ' || v_employee_id || ' salary: ' || v_salary);

    -- TODO: Add more functionality here
    -- This is a reminder comment for future enhancements

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Handle case when employee not found
        DBMS_OUTPUT.PUT_LINE('Employee not found');
    WHEN OTHERS THEN
        -- Generic error handling
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/