-- ============================================================
-- EXAMPLE: Metadata-Driven ETL (Control Table Pattern)
-- This demonstrates the CLOB-based approach teams often use
-- ============================================================

-- Step 1: CREATE CONTROL/METADATA TABLE
CREATE TABLE C##PLSQL_T.ETL_CONTROL (
    step_id NUMBER PRIMARY KEY,
    step_name VARCHAR2(100),
    step_sequence NUMBER,
    source_query CLOB,
    target_table VARCHAR2(100),
    is_active NUMBER DEFAULT 1,
    created_date DATE DEFAULT SYSDATE
);

-- Step 2: CREATE LOGGING TABLE
CREATE TABLE C##PLSQL_T.ETL_LOG (
    log_id NUMBER PRIMARY KEY,
    step_id NUMBER,
    step_name VARCHAR2(100),
    execution_start_time TIMESTAMP,
    execution_end_time TIMESTAMP,
    rows_affected NUMBER,
    status VARCHAR2(20),  -- SUCCESS, FAILED
    error_message VARCHAR2(500),
    cpu_time NUMBER,
    FOREIGN KEY (step_id) REFERENCES C##PLSQL_T.ETL_CONTROL(step_id)
);

-- Step 3: CREATE LOG SEQUENCE
CREATE SEQUENCE C##PLSQL_T.etl_log_seq START WITH 1 INCREMENT BY 1;

-- Step 4: INSERT SAMPLE ETL STEPS (THE "UGLY" ONES)
INSERT INTO C##PLSQL_T.ETL_CONTROL (step_id, step_name, step_sequence, source_query, target_table, is_active) 
VALUES (1, 'Extract Employees', 1, 
  'INSERT INTO C##PLSQL_T.ETL_EMPLOYEES_STAGING 
   SELECT e.employee_id, e.first_name, e.last_name, e.salary, e.department, 
          TRUNC(SYSDATE) as load_date 
   FROM C##PLSQL_T.SAMPLE_EMPLOYEES e 
   WHERE e.salary > 0 AND e.employee_id IN 
         (SELECT employee_id FROM C##PLSQL_T.SAMPLE_EMPLOYEES WHERE department IS NOT NULL)',
  'ETL_EMPLOYEES_STAGING', 1);

INSERT INTO C##PLSQL_T.ETL_CONTROL (step_id, step_name, step_sequence, source_query, target_table, is_active) 
VALUES (2, 'Calculate Bonus', 2, 
  'UPDATE C##PLSQL_T.ETL_EMPLOYEES_STAGING ees 
   SET ees.bonus = CASE 
       WHEN ees.department = ''Engineering'' AND ees.salary > 50000 THEN ees.salary * 0.10
       WHEN ees.department = ''Engineering'' AND ees.salary <= 50000 THEN ees.salary * 0.05
       WHEN ees.department IN (''Marketing'', ''Sales'') AND ees.salary > 45000 THEN ees.salary * 0.15
       WHEN ees.department IN (''Marketing'', ''Sales'') AND ees.salary <= 45000 THEN ees.salary * 0.10
       WHEN ees.department = ''HR'' THEN ees.salary * 0.12
       ELSE ees.salary * 0.08
   END 
   WHERE ees.load_date = TRUNC(SYSDATE) AND ees.bonus IS NULL',
  'ETL_EMPLOYEES_STAGING', 1);

INSERT INTO C##PLSQL_T.ETL_CONTROL (step_id, step_name, step_sequence, source_query, target_table, is_active) 
VALUES (3, 'Reconcile Totals', 3, 
  'INSERT INTO C##PLSQL_T.ETL_RECONCILIATION 
   SELECT ''EMPLOYEES'' as data_type, COUNT(*) as row_count, SUM(salary) as total_salary, 
          SUM(bonus) as total_bonus, TRUNC(SYSDATE) as reconcile_date 
   FROM C##PLSQL_T.ETL_EMPLOYEES_STAGING 
   WHERE load_date = TRUNC(SYSDATE)',
  'ETL_RECONCILIATION', 1);

COMMIT;

-- Step 5: CREATE STAGING TABLES
CREATE TABLE C##PLSQL_T.ETL_EMPLOYEES_STAGING (
    employee_id NUMBER,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    salary NUMBER,
    department VARCHAR2(50),
    bonus NUMBER,
    load_date DATE
);

CREATE TABLE C##PLSQL_T.ETL_RECONCILIATION (
    data_type VARCHAR2(50),
    row_count NUMBER,
    total_salary NUMBER,
    total_bonus NUMBER,
    reconcile_date DATE
);

-- Step 6: CREATE THE ETL ENGINE (reads from control table and executes)
CREATE OR REPLACE PROCEDURE C##PLSQL_T.execute_etl_from_control_table
AS
    CURSOR etl_steps IS
        SELECT step_id, step_name, source_query, target_table, step_sequence
        FROM C##PLSQL_T.ETL_CONTROL
        WHERE is_active = 1
        ORDER BY step_sequence;

    l_rows_affected NUMBER;
    l_start_time TIMESTAMP;
    l_end_time TIMESTAMP;
    l_status VARCHAR2(20);
    l_error_msg VARCHAR2(500);
    l_log_id NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('========== STARTING METADATA-DRIVEN ETL ==========');
    
    FOR etl_rec IN etl_steps LOOP
        l_start_time := SYSTIMESTAMP;
        l_status := 'SUCCESS';
        l_error_msg := NULL;
        l_rows_affected := 0;

        BEGIN
            DBMS_OUTPUT.PUT_LINE('Executing Step ' || etl_rec.step_id || ': ' || etl_rec.step_name);
            
            -- Execute the dynamic SQL from CLOB
            EXECUTE IMMEDIATE etl_rec.source_query;
            l_rows_affected := SQL%ROWCOUNT;
            
            DBMS_OUTPUT.PUT_LINE('  -> Completed. Rows affected: ' || l_rows_affected);

        EXCEPTION WHEN OTHERS THEN
            l_status := 'FAILED';
            l_error_msg := SQLERRM;
            DBMS_OUTPUT.PUT_LINE('  -> ERROR: ' || l_error_msg);
        END;

        l_end_time := SYSTIMESTAMP;

        -- Log the execution
        l_log_id := C##PLSQL_T.etl_log_seq.NEXTVAL;
        INSERT INTO C##PLSQL_T.ETL_LOG (log_id, step_id, step_name, execution_start_time, execution_end_time, 
                                        rows_affected, status, error_message)
        VALUES (l_log_id, etl_rec.step_id, etl_rec.step_name, l_start_time, l_end_time, 
                l_rows_affected, l_status, l_error_msg);
        COMMIT;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('========== ETL EXECUTION COMPLETE ==========');
END execute_etl_from_control_table;
/

-- Step 7: RUN THE ETL
BEGIN
    DBMS_OUTPUT.PUT_LINE('Starting ETL execution from control table...');
    C##PLSQL_T.execute_etl_from_control_table();
END;
/

-- Step 8: CHECK RESULTS
SELECT * FROM C##PLSQL_T.ETL_LOG ORDER BY log_id;
SELECT * FROM C##PLSQL_T.ETL_EMPLOYEES_STAGING;
SELECT * FROM C##PLSQL_T.ETL_RECONCILIATION;
