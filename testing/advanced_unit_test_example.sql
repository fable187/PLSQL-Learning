-- Advanced Unit Test Example for PL/SQL
-- Demonstrates comprehensive testing with assertions and error handling

CREATE OR REPLACE PACKAGE advanced_test_suite IS

    -- Test suite with description
    -- %suite(Advanced PL/SQL Testing Suite)
    -- %suitepath(PLSQL.Advanced)

    -- Global test data
    g_test_employee_id NUMBER;

    -- Setup for entire suite
    -- %beforeall
    PROCEDURE global_setup;

    -- Cleanup for entire suite
    -- %afterall
    PROCEDURE global_cleanup;

    -- Test setup
    -- %beforetest
    PROCEDURE setup;

    -- Test cleanup
    -- %aftertest
    PROCEDURE cleanup;

    -- Test cases
    -- %test(Test employee data validation)
    PROCEDURE test_employee_validation;

    -- %test(Test salary range validation)
    -- %throws(-20001)
    PROCEDURE test_salary_validation;

    -- %test(Test department aggregation)
    PROCEDURE test_department_aggregation;

    -- %test(Test exception handling)
    PROCEDURE test_exception_handling;

    -- %disabled(Feature not implemented yet)
    -- %test(Test future feature)
    PROCEDURE test_future_feature;

END advanced_test_suite;
/

CREATE OR REPLACE PACKAGE BODY advanced_test_suite IS

    PROCEDURE global_setup IS
    BEGIN
        -- Create any global test fixtures
        DBMS_OUTPUT.PUT_LINE('Global setup completed');
    END global_setup;

    PROCEDURE global_cleanup IS
    BEGIN
        -- Clean up global test fixtures
        DBMS_OUTPUT.PUT_LINE('Global cleanup completed');
    END global_cleanup;

    PROCEDURE setup IS
    BEGIN
        -- Insert test data
        g_test_employee_id := 999;
        INSERT INTO sample_employees VALUES (g_test_employee_id, 'Test', 'User', 45000, 'QA');
        COMMIT;
    END setup;

    PROCEDURE cleanup IS
    BEGIN
        -- Remove test data
        DELETE FROM sample_employees WHERE employee_id = g_test_employee_id;
        COMMIT;
    END cleanup;

    PROCEDURE test_employee_validation IS
        v_count NUMBER;
    BEGIN
        -- Test that employee was inserted
        SELECT COUNT(*) INTO v_count
        FROM sample_employees
        WHERE employee_id = g_test_employee_id;

        IF v_count != 1 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Employee validation failed: expected 1, got ' || v_count);
        END IF;

        -- Test data integrity
        DECLARE
            v_name VARCHAR2(50);
        BEGIN
            SELECT first_name INTO v_name
            FROM sample_employees
            WHERE employee_id = g_test_employee_id;

            IF v_name != 'Test' THEN
                RAISE_APPLICATION_ERROR(-20002, 'Name validation failed');
            END IF;
        END;
    END test_employee_validation;

    PROCEDURE test_salary_validation IS
    BEGIN
        -- Test salary range validation (should raise exception for negative salary)
        BEGIN
            INSERT INTO sample_employees VALUES (998, 'Invalid', 'Salary', -1000, 'Test');
            RAISE_APPLICATION_ERROR(-20003, 'Salary validation should have failed');
        EXCEPTION
            WHEN OTHERS THEN
                -- Expected - clean up and re-raise if not expected error
                DELETE FROM sample_employees WHERE employee_id = 998;
                COMMIT;
                IF SQLCODE != -2290 THEN -- Check constraint violation
                    RAISE;
                END IF;
        END;
    END test_salary_validation;

    PROCEDURE test_department_aggregation IS
        v_dept_count NUMBER;
        v_total_salary NUMBER;
    BEGIN
        -- Test department aggregation
        SELECT COUNT(*), SUM(salary)
        INTO v_dept_count, v_total_salary
        FROM sample_employees
        WHERE department = 'Engineering';

        -- Assertions
        IF v_dept_count <= 0 THEN
            RAISE_APPLICATION_ERROR(-20004, 'No engineering employees found');
        END IF;

        IF v_total_salary <= 0 THEN
            RAISE_APPLICATION_ERROR(-20005, 'Invalid total salary');
        END IF;

        -- Test average calculation
        DECLARE
            v_avg_salary NUMBER;
        BEGIN
            SELECT AVG(salary) INTO v_avg_salary
            FROM sample_employees
            WHERE department = 'Engineering';

            IF v_avg_salary != v_total_salary / v_dept_count THEN
                RAISE_APPLICATION_ERROR(-20006, 'Average calculation mismatch');
            END IF;
        END;
    END test_department_aggregation;

    PROCEDURE test_exception_handling IS
    BEGIN
        -- Test proper exception handling
        BEGIN
            -- This should raise NO_DATA_FOUND
            DECLARE
                v_dummy NUMBER;
            BEGIN
                SELECT salary INTO v_dummy
                FROM sample_employees
                WHERE employee_id = -999;
            END;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- Expected - test passes
                DBMS_OUTPUT.PUT_LINE('Exception handling test passed');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20007, 'Unexpected exception: ' || SQLERRM);
        END;
    END test_exception_handling;

    PROCEDURE test_future_feature IS
    BEGIN
        -- Placeholder for future test
        NULL;
    END test_future_feature;

END advanced_test_suite;
/

-- Running Tests in Oracle Developer Tools:
-- 1. Open this file in VS Code
-- 2. Go to View → Test Explorer (or Ctrl+Shift+T)
-- 3. Expand the test suite to see individual tests
-- 4. Click the play button next to any test to run it
-- 5. View results with pass/fail status and execution time
-- 6. Use the play button at suite level to run all tests