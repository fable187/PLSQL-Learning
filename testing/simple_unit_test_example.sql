-- Simple Unit Test Example for PL/SQL
-- This demonstrates basic testing structure that can be run with Oracle Developer Tools
-- The extension recognizes --%test annotations and provides play button functionality

CREATE OR REPLACE PACKAGE test_employee_operations IS

    -- Test suite setup
    -- %suite(Employee Operations Tests)

    -- Setup procedure (runs before each test)
    -- %beforetest
    PROCEDURE setup_test_data;

    -- Test case: Validate employee bonus calculation
    -- %test(Bonus calculation for valid employee)
    PROCEDURE test_calculate_bonus_valid;

    -- Test case: Handle invalid employee
    -- %test(Bonus calculation for invalid employee)
    PROCEDURE test_calculate_bonus_invalid;

    -- Test case: Validate department statistics
    -- %test(Department statistics calculation)
    PROCEDURE test_department_stats;

    -- Cleanup procedure (runs after each test)
    -- %aftertest
    PROCEDURE cleanup_test_data;

END test_employee_operations;
/

CREATE OR REPLACE PACKAGE BODY test_employee_operations IS

    PROCEDURE setup_test_data IS
    BEGIN
        -- Insert test data
        INSERT INTO sample_employees VALUES (999, 'Test', 'User', 50000, 'Test');
        COMMIT;
    END setup_test_data;

    PROCEDURE test_calculate_bonus_valid IS
        v_bonus NUMBER;
    BEGIN
        -- Test bonus calculation for valid employee
        -- Assuming we have a function to calculate bonus
        v_bonus := 50000 * 0.1; -- 10% bonus

        -- Assertion: bonus should be 5000
        IF v_bonus != 5000 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Bonus calculation failed. Expected 5000, got ' || v_bonus);
        END IF;
    END test_calculate_bonus_valid;

    PROCEDURE test_calculate_bonus_invalid IS
    BEGIN
        -- Test bonus calculation for invalid employee
        -- This should raise an exception
        BEGIN
            -- This would call a function that raises NO_DATA_FOUND
            DECLARE
                v_dummy NUMBER;
            BEGIN
                SELECT salary INTO v_dummy FROM sample_employees WHERE employee_id = -1;
                RAISE_APPLICATION_ERROR(-20002, 'Expected NO_DATA_FOUND exception');
            END;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- Expected exception - test passes
                NULL;
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20003, 'Unexpected exception: ' || SQLERRM);
        END;
    END test_calculate_bonus_invalid;

    PROCEDURE test_department_stats IS
        v_emp_count NUMBER;
        v_avg_salary NUMBER;
    BEGIN
        -- Test department statistics
        SELECT COUNT(*), AVG(salary)
        INTO v_emp_count, v_avg_salary
        FROM sample_employees
        WHERE department = 'Engineering';

        -- Assertions
        IF v_emp_count < 0 THEN
            RAISE_APPLICATION_ERROR(-20004, 'Employee count cannot be negative');
        END IF;

        IF v_avg_salary < 0 THEN
            RAISE_APPLICATION_ERROR(-20005, 'Average salary cannot be negative');
        END IF;
    END test_department_stats;

    PROCEDURE cleanup_test_data IS
    BEGIN
        -- Remove test data
        DELETE FROM sample_employees WHERE employee_id = 999;
        COMMIT;
    END cleanup_test_data;

END test_employee_operations;
/

-- To run these tests in Oracle Developer Tools:
-- 1. Open the package in VS Code
-- 2. Look for the play button (▶️) next to test procedure names
-- 3. Click to run individual tests or the whole suite
-- 4. View results in the Test Explorer panel