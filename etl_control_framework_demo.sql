PROMPT Setting up control-table ETL demo...
SET SERVEROUTPUT ON

BEGIN
    FOR rec IN (
        SELECT object_name, object_type
        FROM user_objects
        WHERE object_name IN (
            'DEMO_ETL_RUN_CONTROL',
            'DEMO_ETL_CONTROL',
            'DEMO_ETL_RUN_LOG',
            'DEMO_ETL_RUN_LOG_SEQ',
            'DEMO_SRC_CUSTOMERS',
            'DEMO_SRC_ORDERS',
            'DEMO_SRC_PAYMENTS',
            'DEMO_TGT_CUSTOMER_DIM',
            'DEMO_TGT_ORDER_FACT',
            'DEMO_TGT_PAYMENT_SUMMARY',
            'DEMO_TGT_HIGH_VALUE_CUSTOMERS',
            'DEMO_TGT_RECON'
        )
        ORDER BY CASE object_type
            WHEN 'PROCEDURE' THEN 1
            WHEN 'TABLE' THEN 2
            WHEN 'SEQUENCE' THEN 3
            ELSE 4
        END
    ) LOOP
        BEGIN
            IF rec.object_type = 'PROCEDURE' THEN
                EXECUTE IMMEDIATE 'DROP PROCEDURE ' || rec.object_name;
            ELSIF rec.object_type = 'TABLE' THEN
                EXECUTE IMMEDIATE 'DROP TABLE ' || rec.object_name || ' PURGE';
            ELSIF rec.object_type = 'SEQUENCE' THEN
                EXECUTE IMMEDIATE 'DROP SEQUENCE ' || rec.object_name;
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Drop skipped for ' || rec.object_name || ': ' || SQLERRM);
        END;
    END LOOP;
END;
/

CREATE TABLE demo_src_customers (
    customer_id   NUMBER PRIMARY KEY,
    customer_name VARCHAR2(100) NOT NULL,
    region_code   VARCHAR2(10) NOT NULL,
    status_code   VARCHAR2(10) NOT NULL,
    signup_date   DATE NOT NULL
);

CREATE TABLE demo_src_orders (
    order_id      NUMBER PRIMARY KEY,
    customer_id   NUMBER NOT NULL,
    order_date    DATE NOT NULL,
    order_total   NUMBER(12,2) NOT NULL,
    order_status  VARCHAR2(20) NOT NULL,
    CONSTRAINT demo_src_orders_fk1
        FOREIGN KEY (customer_id) REFERENCES demo_src_customers(customer_id)
);

CREATE TABLE demo_src_payments (
    payment_id      NUMBER PRIMARY KEY,
    order_id         NUMBER NOT NULL,
    customer_id      NUMBER NOT NULL,
    payment_date     DATE NOT NULL,
    payment_amount   NUMBER(12,2) NOT NULL,
    payment_method   VARCHAR2(20) NOT NULL,
    CONSTRAINT demo_src_payments_fk1
        FOREIGN KEY (order_id) REFERENCES demo_src_orders(order_id),
    CONSTRAINT demo_src_payments_fk2
        FOREIGN KEY (customer_id) REFERENCES demo_src_customers(customer_id)
);

CREATE TABLE demo_tgt_customer_dim (
    customer_id      NUMBER PRIMARY KEY,
    customer_name    VARCHAR2(100) NOT NULL,
    region_code      VARCHAR2(10) NOT NULL,
    customer_status  VARCHAR2(20) NOT NULL,
    signup_year      NUMBER NOT NULL
);

CREATE TABLE demo_tgt_order_fact (
    order_id            NUMBER PRIMARY KEY,
    customer_id         NUMBER NOT NULL,
    customer_name       VARCHAR2(100) NOT NULL,
    region_code         VARCHAR2(10) NOT NULL,
    order_month         VARCHAR2(7) NOT NULL,
    order_total         NUMBER(12,2) NOT NULL,
    normalized_status   VARCHAR2(20) NOT NULL
);

CREATE TABLE demo_tgt_payment_summary (
    customer_id          NUMBER PRIMARY KEY,
    payment_count        NUMBER NOT NULL,
    total_payment_amount NUMBER(12,2) NOT NULL,
    last_payment_date    DATE NOT NULL
);

CREATE TABLE demo_tgt_high_value_customers (
    customer_id         NUMBER PRIMARY KEY,
    customer_name       VARCHAR2(100) NOT NULL,
    total_order_amount  NUMBER(12,2) NOT NULL,
    total_payment_amount NUMBER(12,2) NOT NULL,
    customer_tier       VARCHAR2(20) NOT NULL
);

CREATE TABLE demo_tgt_recon (
    metric_name    VARCHAR2(100) PRIMARY KEY,
    metric_value   NUMBER(18,2) NOT NULL,
    recorded_at    DATE NOT NULL
);

CREATE TABLE demo_etl_control (
    step_id          NUMBER PRIMARY KEY,
    step_name        VARCHAR2(100) NOT NULL,
    step_sequence    NUMBER NOT NULL,
    target_object    VARCHAR2(100) NOT NULL,
    step_sql         CLOB NOT NULL,
    is_active        NUMBER DEFAULT 1 NOT NULL,
    notes            VARCHAR2(500),
    created_date     DATE DEFAULT SYSDATE NOT NULL
);

CREATE TABLE demo_etl_run_log (
    log_id           NUMBER PRIMARY KEY,
    run_label        VARCHAR2(100) NOT NULL,
    step_id          NUMBER NOT NULL,
    step_name        VARCHAR2(100) NOT NULL,
    status           VARCHAR2(20) NOT NULL,
    rows_affected    NUMBER,
    elapsed_cs       NUMBER,
    error_message    VARCHAR2(1000),
    created_at       TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE SEQUENCE demo_etl_run_log_seq START WITH 1 INCREMENT BY 1;

INSERT INTO demo_src_customers (customer_id, customer_name, region_code, status_code, signup_date) VALUES (1, 'Acme Health', 'CENTRAL', 'A', DATE '2023-01-15');
INSERT INTO demo_src_customers (customer_id, customer_name, region_code, status_code, signup_date) VALUES (2, 'Blue Retail', 'EAST', 'A', DATE '2022-11-03');
INSERT INTO demo_src_customers (customer_id, customer_name, region_code, status_code, signup_date) VALUES (3, 'Cedar Labs', 'WEST', 'I', DATE '2021-07-19');
INSERT INTO demo_src_customers (customer_id, customer_name, region_code, status_code, signup_date) VALUES (4, 'Delta Foods', 'SOUTH', 'A', DATE '2024-02-10');
INSERT INTO demo_src_customers (customer_id, customer_name, region_code, status_code, signup_date) VALUES (5, 'Evergreen Stores', 'EAST', 'A', DATE '2020-05-08');
INSERT INTO demo_src_customers (customer_id, customer_name, region_code, status_code, signup_date) VALUES (6, 'Futura Parts', 'WEST', 'S', DATE '2023-09-21');

INSERT INTO demo_src_orders (order_id, customer_id, order_date, order_total, order_status) VALUES (1001, 1, DATE '2025-01-10', 350.00, 'COMPLETE');
INSERT INTO demo_src_orders (order_id, customer_id, order_date, order_total, order_status) VALUES (1002, 1, DATE '2025-02-14', 220.00, 'SHIPPED');
INSERT INTO demo_src_orders (order_id, customer_id, order_date, order_total, order_status) VALUES (1003, 2, DATE '2025-01-18', 900.00, 'COMPLETE');
INSERT INTO demo_src_orders (order_id, customer_id, order_date, order_total, order_status) VALUES (1004, 2, DATE '2025-03-02', 175.00, 'PENDING');
INSERT INTO demo_src_orders (order_id, customer_id, order_date, order_total, order_status) VALUES (1005, 3, DATE '2025-01-23', 120.00, 'CANCELLED');
INSERT INTO demo_src_orders (order_id, customer_id, order_date, order_total, order_status) VALUES (1006, 4, DATE '2025-03-05', 640.00, 'COMPLETE');
INSERT INTO demo_src_orders (order_id, customer_id, order_date, order_total, order_status) VALUES (1007, 5, DATE '2025-03-17', 430.00, 'SHIPPED');
INSERT INTO demo_src_orders (order_id, customer_id, order_date, order_total, order_status) VALUES (1008, 5, DATE '2025-03-25', 615.00, 'COMPLETE');
INSERT INTO demo_src_orders (order_id, customer_id, order_date, order_total, order_status) VALUES (1009, 6, DATE '2025-04-01', 250.00, 'HOLD');

INSERT INTO demo_src_payments (payment_id, order_id, customer_id, payment_date, payment_amount, payment_method) VALUES (5001, 1001, 1, DATE '2025-01-11', 350.00, 'ACH');
INSERT INTO demo_src_payments (payment_id, order_id, customer_id, payment_date, payment_amount, payment_method) VALUES (5002, 1002, 1, DATE '2025-02-15', 220.00, 'CARD');
INSERT INTO demo_src_payments (payment_id, order_id, customer_id, payment_date, payment_amount, payment_method) VALUES (5003, 1003, 2, DATE '2025-01-19', 900.00, 'WIRE');
INSERT INTO demo_src_payments (payment_id, order_id, customer_id, payment_date, payment_amount, payment_method) VALUES (5004, 1004, 2, DATE '2025-03-03', 175.00, 'CARD');
INSERT INTO demo_src_payments (payment_id, order_id, customer_id, payment_date, payment_amount, payment_method) VALUES (5005, 1006, 4, DATE '2025-03-07', 640.00, 'ACH');
INSERT INTO demo_src_payments (payment_id, order_id, customer_id, payment_date, payment_amount, payment_method) VALUES (5006, 1007, 5, DATE '2025-03-18', 430.00, 'CARD');
INSERT INTO demo_src_payments (payment_id, order_id, customer_id, payment_date, payment_amount, payment_method) VALUES (5007, 1008, 5, DATE '2025-03-26', 615.00, 'WIRE');

INSERT INTO demo_etl_control (step_id, step_name, step_sequence, target_object, step_sql, notes) VALUES (
    10,
    'Load customer dimension',
    1,
    'DEMO_TGT_CUSTOMER_DIM',
    q'[
INSERT INTO demo_tgt_customer_dim (
    customer_id,
    customer_name,
    region_code,
    customer_status,
    signup_year
)
SELECT
    c.customer_id,
    c.customer_name,
    c.region_code,
    CASE c.status_code
        WHEN 'A' THEN 'ACTIVE'
        WHEN 'I' THEN 'INACTIVE'
        WHEN 'S' THEN 'SUSPENDED'
        ELSE 'UNKNOWN'
    END AS customer_status,
    EXTRACT(YEAR FROM c.signup_date) AS signup_year
FROM demo_src_customers c
]',
    'Simple INSERT..SELECT with CASE logic'
);

INSERT INTO demo_etl_control (step_id, step_name, step_sequence, target_object, step_sql, notes) VALUES (
    20,
    'Load order fact',
    2,
    'DEMO_TGT_ORDER_FACT',
    q'[
INSERT INTO demo_tgt_order_fact (
    order_id,
    customer_id,
    customer_name,
    region_code,
    order_month,
    order_total,
    normalized_status
)
SELECT
    o.order_id,
    c.customer_id,
    c.customer_name,
    c.region_code,
    TO_CHAR(o.order_date, 'YYYY-MM') AS order_month,
    o.order_total,
    CASE
        WHEN o.order_status IN ('COMPLETE', 'SHIPPED') THEN 'CLOSED'
        WHEN o.order_status = 'PENDING' THEN 'OPEN'
        ELSE 'EXCEPTION'
    END AS normalized_status
FROM demo_src_orders o
JOIN demo_src_customers c
    ON c.customer_id = o.customer_id
]',
    'Join-heavy fact load with derived status'
);

INSERT INTO demo_etl_control (step_id, step_name, step_sequence, target_object, step_sql, notes) VALUES (
    30,
    'Summarize payments',
    3,
    'DEMO_TGT_PAYMENT_SUMMARY',
    q'[
MERGE INTO demo_tgt_payment_summary tgt
USING (
    SELECT
        p.customer_id,
        COUNT(*) AS payment_count,
        SUM(p.payment_amount) AS total_payment_amount,
        MAX(p.payment_date) AS last_payment_date
    FROM demo_src_payments p
    GROUP BY p.customer_id
) src
ON (tgt.customer_id = src.customer_id)
WHEN MATCHED THEN
    UPDATE SET
        tgt.payment_count = src.payment_count,
        tgt.total_payment_amount = src.total_payment_amount,
        tgt.last_payment_date = src.last_payment_date
WHEN NOT MATCHED THEN
    INSERT (
        customer_id,
        payment_count,
        total_payment_amount,
        last_payment_date
    )
    VALUES (
        src.customer_id,
        src.payment_count,
        src.total_payment_amount,
        src.last_payment_date
    )
]',
    'Aggregate plus MERGE to mimic summary maintenance'
);

INSERT INTO demo_etl_control (step_id, step_name, step_sequence, target_object, step_sql, notes) VALUES (
    40,
    'Build high value customer list',
    4,
    'DEMO_TGT_HIGH_VALUE_CUSTOMERS',
    q'[
MERGE INTO demo_tgt_high_value_customers tgt
USING (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(o.order_total) AS total_order_amount,
        NVL(SUM(p.payment_amount), 0) AS total_payment_amount,
        CASE
            WHEN SUM(o.order_total) >= 1200 THEN 'PLATINUM'
            WHEN SUM(o.order_total) >= 700 THEN 'GOLD'
            ELSE 'SILVER'
        END AS customer_tier
    FROM demo_src_customers c
    JOIN demo_src_orders o
        ON o.customer_id = c.customer_id
    LEFT JOIN demo_src_payments p
        ON p.order_id = o.order_id
    WHERE o.order_status <> 'CANCELLED'
    GROUP BY c.customer_id, c.customer_name
    HAVING SUM(o.order_total) >= 700
) src
ON (tgt.customer_id = src.customer_id)
WHEN MATCHED THEN
    UPDATE SET
        tgt.customer_name = src.customer_name,
        tgt.total_order_amount = src.total_order_amount,
        tgt.total_payment_amount = src.total_payment_amount,
        tgt.customer_tier = src.customer_tier
WHEN NOT MATCHED THEN
    INSERT (
        customer_id,
        customer_name,
        total_order_amount,
        total_payment_amount,
        customer_tier
    )
    VALUES (
        src.customer_id,
        src.customer_name,
        src.total_order_amount,
        src.total_payment_amount,
        src.customer_tier
    )
]',
    'Multi-join MERGE with GROUP BY and HAVING'
);

INSERT INTO demo_etl_control (step_id, step_name, step_sequence, target_object, step_sql, notes) VALUES (
    50,
    'Write reconciliation metrics',
    5,
    'DEMO_TGT_RECON',
    q'[
INSERT INTO demo_tgt_recon (
    metric_name,
    metric_value,
    recorded_at
)
SELECT 'CUSTOMER_DIM_COUNT', COUNT(*), SYSDATE FROM demo_tgt_customer_dim
UNION ALL
SELECT 'ORDER_FACT_COUNT', COUNT(*), SYSDATE FROM demo_tgt_order_fact
UNION ALL
SELECT 'PAYMENT_SUMMARY_COUNT', COUNT(*), SYSDATE FROM demo_tgt_payment_summary
UNION ALL
SELECT 'HIGH_VALUE_CUSTOMER_COUNT', COUNT(*), SYSDATE FROM demo_tgt_high_value_customers
]',
    'Reconciliation step that reads downstream targets'
);

COMMIT;

CREATE OR REPLACE PROCEDURE demo_etl_run_control(
    p_run_label IN VARCHAR2 DEFAULT 'CONTROL_RUN'
) IS
    v_start_cs      NUMBER;
    v_elapsed_cs    NUMBER;
    v_rows_affected NUMBER;
    v_error_message VARCHAR2(1000);
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE demo_tgt_customer_dim';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE demo_tgt_order_fact';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE demo_tgt_payment_summary';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE demo_tgt_high_value_customers';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE demo_tgt_recon';

    FOR rec IN (
        SELECT step_id, step_name, step_sql
        FROM demo_etl_control
        WHERE is_active = 1
        ORDER BY step_sequence
    ) LOOP
        v_start_cs := DBMS_UTILITY.GET_TIME;

        BEGIN
            EXECUTE IMMEDIATE rec.step_sql;
            v_elapsed_cs := DBMS_UTILITY.GET_TIME - v_start_cs;
            v_rows_affected := SQL%ROWCOUNT;

            INSERT INTO demo_etl_run_log (
                log_id,
                run_label,
                step_id,
                step_name,
                status,
                rows_affected,
                elapsed_cs,
                error_message
            )
            VALUES (
                demo_etl_run_log_seq.NEXTVAL,
                p_run_label,
                rec.step_id,
                rec.step_name,
                'SUCCESS',
                v_rows_affected,
                v_elapsed_cs,
                NULL
            );

            DBMS_OUTPUT.PUT_LINE(
                'Step ' || rec.step_id || ' [' || rec.step_name || '] succeeded. '
                || 'Rows=' || v_rows_affected || ', Elapsed_cs=' || v_elapsed_cs
            );
        EXCEPTION
            WHEN OTHERS THEN
                v_elapsed_cs := DBMS_UTILITY.GET_TIME - v_start_cs;
                v_error_message := SUBSTR(SQLERRM, 1, 1000);

                INSERT INTO demo_etl_run_log (
                    log_id,
                    run_label,
                    step_id,
                    step_name,
                    status,
                    rows_affected,
                    elapsed_cs,
                    error_message
                )
                VALUES (
                    demo_etl_run_log_seq.NEXTVAL,
                    p_run_label,
                    rec.step_id,
                    rec.step_name,
                    'FAILED',
                    NULL,
                    v_elapsed_cs,
                    v_error_message
                );

                DBMS_OUTPUT.PUT_LINE(
                    'Step ' || rec.step_id || ' [' || rec.step_name || '] failed: ' || v_error_message
                );
                RAISE;
        END;
    END LOOP;

    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE demo_etl_reset(
    p_clear_logs IN VARCHAR2 DEFAULT 'N'
) IS
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE demo_tgt_customer_dim';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE demo_tgt_order_fact';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE demo_tgt_payment_summary';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE demo_tgt_high_value_customers';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE demo_tgt_recon';

    IF UPPER(NVL(p_clear_logs, 'N')) = 'Y' THEN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE demo_etl_run_log';
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE demo_etl_show_state IS
    v_count NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- SOURCE COUNTS ---');

    SELECT COUNT(*) INTO v_count FROM demo_src_customers;
    DBMS_OUTPUT.PUT_LINE('DEMO_SRC_CUSTOMERS: ' || v_count);

    SELECT COUNT(*) INTO v_count FROM demo_src_orders;
    DBMS_OUTPUT.PUT_LINE('DEMO_SRC_ORDERS: ' || v_count);

    SELECT COUNT(*) INTO v_count FROM demo_src_payments;
    DBMS_OUTPUT.PUT_LINE('DEMO_SRC_PAYMENTS: ' || v_count);

    DBMS_OUTPUT.PUT_LINE('--- TARGET COUNTS ---');

    SELECT COUNT(*) INTO v_count FROM demo_tgt_customer_dim;
    DBMS_OUTPUT.PUT_LINE('DEMO_TGT_CUSTOMER_DIM: ' || v_count);

    SELECT COUNT(*) INTO v_count FROM demo_tgt_order_fact;
    DBMS_OUTPUT.PUT_LINE('DEMO_TGT_ORDER_FACT: ' || v_count);

    SELECT COUNT(*) INTO v_count FROM demo_tgt_payment_summary;
    DBMS_OUTPUT.PUT_LINE('DEMO_TGT_PAYMENT_SUMMARY: ' || v_count);

    SELECT COUNT(*) INTO v_count FROM demo_tgt_high_value_customers;
    DBMS_OUTPUT.PUT_LINE('DEMO_TGT_HIGH_VALUE_CUSTOMERS: ' || v_count);

    SELECT COUNT(*) INTO v_count FROM demo_tgt_recon;
    DBMS_OUTPUT.PUT_LINE('DEMO_TGT_RECON: ' || v_count);
END;
/

PROMPT Demo ready.
PROMPT Run the baseline control-table process with:
PROMPT   BEGIN demo_etl_run_control('BASELINE'); END;
PROMPT   /
PROMPT Reset the target tables with:
PROMPT   BEGIN demo_etl_reset; END;
PROMPT   /
PROMPT Reset targets and logs with:
PROMPT   BEGIN demo_etl_reset('Y'); END;
PROMPT   /
PROMPT Show current source/target row counts with:
PROMPT   SET SERVEROUTPUT ON
PROMPT   BEGIN demo_etl_show_state; END;
PROMPT   /
PROMPT Inspect the control rows with:
PROMPT   SELECT step_id, step_name, target_object FROM demo_etl_control ORDER BY step_sequence;
PROMPT Inspect timing with:
PROMPT   SELECT run_label, step_id, step_name, status, rows_affected, elapsed_cs FROM demo_etl_run_log ORDER BY log_id;
