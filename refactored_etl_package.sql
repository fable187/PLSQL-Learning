-- ============================================================
-- REFACTORED: Package-Based ETL with TDD
-- This is the cleaner, more maintainable approach
-- ============================================================

-- Step 1: CREATE ETL PACKAGE SPECIFICATION
CREATE OR REPLACE PACKAGE C##PLSQL_T.etl_refactored AS
    -- Procedures for each ETL step (explicit, not in CLOBs)
    PROCEDURE extract_employees;
    PROCEDURE calculate_bonuses;
    PROCEDURE reconcile_totals;
    
    -- Main orchestration procedure
    PROCEDURE run_all_steps;
    
    -- Utility procedures for testing
    PROCEDURE clear_staging;
END etl_refactored;
/

-- Step 2: CREATE ETL PACKAGE BODY (Implementation)
CREATE OR REPLACE PACKAGE BODY C##PLSQL_T.etl_refactored AS

    PROCEDURE clear_staging AS
    BEGIN
        DELETE FROM C##PLSQL_T.ETL_EMPLOYEES_STAGING;
        DELETE FROM C##PLSQL_T.ETL_RECONCILIATION;
        COMMIT;
    END clear_staging;

    PROCEDURE extract_employees AS
        l_start_time TIMESTAMP := SYSTIMESTAMP;
        l_rows_affected NUMBER;
    BEGIN
        -- Clean, readable SQL - NOT in a CLOB
        INSERT INTO C##PLSQL_T.ETL_EMPLOYEES_STAGING (employee_id, first_name, last_name, salary, department, load_date)
        SELECT 
            employee_id, 
            first_name, 
            last_name, 
            salary, 
            department, 
            TRUNC(SYSDATE)
        FROM C##PLSQL_T.SAMPLE_EMPLOYEES
        WHERE salary > 0;
        
        l_rows_affected := SQL%ROWCOUNT;
        
        -- Log the step
        INSERT INTO C##PLSQL_T.ETL_LOG (log_id, step_id, step_name, execution_start_time, execution_end_time, rows_affected, status)
        VALUES (C##PLSQL_T.etl_log_seq.NEXTVAL, 1, 'Extract Employees (Refactored)', l_start_time, SYSTIMESTAMP, l_rows_affected, 'SUCCESS');
        
        DBMS_OUTPUT.PUT_LINE('[EXTRACT] Loaded ' || l_rows_affected || ' employees');
        COMMIT;
    END extract_employees;

    PROCEDURE calculate_bonuses AS
        l_start_time TIMESTAMP := SYSTIMESTAMP;
        l_rows_affected NUMBER;
    BEGIN
        -- Clear, optimized bonus calculation
        UPDATE C##PLSQL_T.ETL_EMPLOYEES_STAGING
        SET bonus = CASE
            WHEN department = 'Engineering' AND salary > 50000 THEN salary * 0.10
            WHEN department = 'Engineering' AND salary <= 50000 THEN salary * 0.05
            WHEN department IN ('Marketing', 'Sales') AND salary > 45000 THEN salary * 0.15
            WHEN department IN ('Marketing', 'Sales') AND salary <= 45000 THEN salary * 0.10
            WHEN department = 'HR' THEN salary * 0.12
            ELSE salary * 0.08
        END
        WHERE load_date = TRUNC(SYSDATE) AND bonus IS NULL;
        
        l_rows_affected := SQL%ROWCOUNT;
        
        INSERT INTO C##PLSQL_T.ETL_LOG (log_id, step_id, step_name, execution_start_time, execution_end_time, rows_affected, status)
        VALUES (C##PLSQL_T.etl_log_seq.NEXTVAL, 2, 'Calculate Bonuses (Refactored)', l_start_time, SYSTIMESTAMP, l_rows_affected, 'SUCCESS');
        
        DBMS_OUTPUT.PUT_LINE('[BONUS] Calculated bonuses for ' || l_rows_affected || ' employees');
        COMMIT;
    END calculate_bonuses;

    PROCEDURE reconcile_totals AS
        l_start_time TIMESTAMP := SYSTIMESTAMP;
        l_rows_affected NUMBER;
    BEGIN
        -- Reconciliation with validation
        INSERT INTO C##PLSQL_T.ETL_RECONCILIATION (data_type, row_count, total_salary, total_bonus, reconcile_date)
        SELECT 
            'EMPLOYEES' as data_type,
            COUNT(*) as row_count,
            SUM(salary) as total_salary,
            SUM(bonus) as total_bonus,
            TRUNC(SYSDATE)
        FROM C##PLSQL_T.ETL_EMPLOYEES_STAGING
        WHERE load_date = TRUNC(SYSDATE);
        
        l_rows_affected := SQL%ROWCOUNT;
        
        INSERT INTO C##PLSQL_T.ETL_LOG (log_id, step_id, step_name, execution_start_time, execution_end_time, rows_affected, status)
        VALUES (C##PLSQL_T.etl_log_seq.NEXTVAL, 3, 'Reconcile Totals (Refactored)', l_start_time, SYSTIMESTAMP, l_rows_affected, 'SUCCESS');
        
        DBMS_OUTPUT.PUT_LINE('[RECONCILE] Reconciliation complete');
        COMMIT;
    END reconcile_totals;

    PROCEDURE run_all_steps AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('========== STARTING REFACTORED ETL (PACKAGE-BASED) ==========');
        
        BEGIN
            extract_employees();
            calculate_bonuses();
            reconcile_totals();
            DBMS_OUTPUT.PUT_LINE('========== ETL COMPLETE (SUCCESS) ==========');
        EXCEPTION WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('========== ETL FAILED: ' || SQLERRM || ' ==========');
            RAISE;
        END;
    END run_all_steps;

END etl_refactored;
/

-- Step 3: RUN THE REFACTORED ETL
BEGIN
    C##PLSQL_T.etl_refactored.clear_staging();
    C##PLSQL_T.etl_refactored.run_all_steps();
END;
/

-- Step 4: COMPARE RESULTS
SELECT * FROM C##PLSQL_T.ETL_LOG WHERE step_name LIKE '%Refactored%' ORDER BY log_id DESC;
SELECT * FROM C##PLSQL_T.ETL_EMPLOYEES_STAGING;
