-- ============================================================
-- PLSQL Learning Database Initialization Script
-- ============================================================

-- Create base tables
CREATE TABLE SAMPLE_EMPLOYEES (
    employee_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    salary NUMBER,
    department VARCHAR2(50)
);

CREATE TABLE INVALID_SALARIES (
    employee_id NUMBER,
    salary NUMBER,
    error_reason VARCHAR2(200)
);

CREATE TABLE ETL_EMPLOYEES_STAGING (
    employee_id NUMBER,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    salary NUMBER,
    department VARCHAR2(50),
    bonus NUMBER,
    load_date DATE
);

CREATE TABLE ETL_RECONCILIATION (
    data_type VARCHAR2(50),
    row_count NUMBER,
    total_salary NUMBER,
    total_bonus NUMBER,
    reconcile_date DATE
);

CREATE TABLE ETL_CONTROL (
    step_id NUMBER PRIMARY KEY,
    step_name VARCHAR2(100),
    step_sequence NUMBER,
    source_query CLOB,
    target_table VARCHAR2(100),
    is_active NUMBER DEFAULT 1,
    created_date DATE DEFAULT SYSDATE
);

CREATE TABLE ETL_LOG (
    log_id NUMBER PRIMARY KEY,
    step_id NUMBER,
    step_name VARCHAR2(100),
    execution_start_time TIMESTAMP,
    execution_end_time TIMESTAMP,
    rows_affected NUMBER,
    status VARCHAR2(20),
    error_message VARCHAR2(500),
    cpu_time NUMBER,
    FOREIGN KEY (step_id) REFERENCES ETL_CONTROL(step_id)
);

-- Create sequences
CREATE SEQUENCE etl_log_seq START WITH 1 INCREMENT BY 1;

-- Insert sample employee data
INSERT INTO SAMPLE_EMPLOYEES VALUES (1, 'John', 'Doe', 55000, 'Engineering');
INSERT INTO SAMPLE_EMPLOYEES VALUES (2, 'Jane', 'Smith', 48000, 'Marketing');
INSERT INTO SAMPLE_EMPLOYEES VALUES (3, 'Bob', 'Johnson', 60000, 'Engineering');
INSERT INTO SAMPLE_EMPLOYEES VALUES (4, 'Alice', 'Williams', 42000, 'Sales');
INSERT INTO SAMPLE_EMPLOYEES VALUES (5, 'Charlie', 'Brown', 51000, 'HR');
INSERT INTO SAMPLE_EMPLOYEES VALUES (6, 'Diana', 'Davis', 45000, 'Sales');
INSERT INTO SAMPLE_EMPLOYEES VALUES (7, 'Eve', 'Miller', 58000, 'Engineering');

COMMIT;
