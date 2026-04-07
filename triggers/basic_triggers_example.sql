-- PL/SQL Triggers Example
-- Demonstrates creating row-level and statement-level triggers

-- Create audit table for tracking changes
CREATE TABLE employee_audit (
    audit_id NUMBER PRIMARY KEY,
    employee_id NUMBER,
    action VARCHAR2(10),
    old_salary NUMBER,
    new_salary NUMBER,
    change_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    changed_by VARCHAR2(50)
);

CREATE SEQUENCE employee_audit_seq START WITH 1 INCREMENT BY 1;

-- Row-level trigger: fires for each row affected
CREATE OR REPLACE TRIGGER employee_salary_audit_trigger
    AFTER UPDATE OF salary ON sample_employees
    FOR EACH ROW
BEGIN
    INSERT INTO employee_audit (audit_id, employee_id, action, old_salary, new_salary, changed_by)
    VALUES (employee_audit_seq.NEXTVAL, :OLD.employee_id, 'UPDATE',
            :OLD.salary, :NEW.salary, USER);
END;
/

-- Statement-level trigger: fires once per statement
CREATE OR REPLACE TRIGGER employee_insert_audit_trigger
    AFTER INSERT ON sample_employees
BEGIN
    INSERT INTO etl_log (log_id, step_name, execution_start_time, status, error_message)
    VALUES (etl_log_seq.NEXTVAL, 'Employee Insert Audit',
            SYSTIMESTAMP, 'INFO', 'New employee(s) inserted');
END;
/

-- Test the triggers
DECLARE
    v_old_salary NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Testing Triggers ===');

    -- Get current salary
    SELECT salary INTO v_old_salary FROM sample_employees WHERE employee_id = 1;

    -- Update salary (should fire row-level trigger)
    UPDATE sample_employees
    SET salary = salary + 1000
    WHERE employee_id = 1;

    DBMS_OUTPUT.PUT_LINE('Salary updated from ' || v_old_salary || ' to ' ||
                        (v_old_salary + 1000));

    -- Insert new employee (should fire statement-level trigger)
    INSERT INTO sample_employees VALUES (8, 'Test', 'User', 50000, 'Test');
    DBMS_OUTPUT.PUT_LINE('New employee inserted');

    COMMIT;

    -- Check audit table
    DBMS_OUTPUT.PUT_LINE('=== Audit Records ===');
    FOR audit_rec IN (SELECT * FROM employee_audit ORDER BY audit_id) LOOP
        DBMS_OUTPUT.PUT_LINE('Audit: ' || audit_rec.action || ' on employee ' ||
                           audit_rec.employee_id || ', salary ' ||
                           audit_rec.old_salary || ' -> ' || audit_rec.new_salary);
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK;
END;
/

-- Clean up: delete test data and drop triggers
DELETE FROM sample_employees WHERE employee_id = 8;
DELETE FROM employee_audit;
DROP TRIGGER employee_salary_audit_trigger;
DROP TRIGGER employee_insert_audit_trigger;
DROP TABLE employee_audit;
DROP SEQUENCE employee_audit_seq;