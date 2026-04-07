-- PL/SQL Records Example
-- Demonstrates using record types to group related data

DECLARE
    -- Define a record type based on table structure
    TYPE emp_record_type IS RECORD (
        employee_id NUMBER,
        first_name  VARCHAR2(50),
        last_name   VARCHAR2(50),
        salary      NUMBER
    );

    -- Declare a record variable
    emp_record emp_record_type;

    -- Define a record type with different field names
    TYPE custom_emp_record_type IS RECORD (
        id    NUMBER,
        fname VARCHAR2(50),
        lname VARCHAR2(50),
        sal   NUMBER
    );

    custom_record custom_emp_record_type;
BEGIN
    -- Fetch data into record using SELECT INTO
    SELECT employee_id, first_name, last_name, salary
    INTO emp_record
    FROM sample_employees
    WHERE employee_id = 1;

    -- Display record data
    DBMS_OUTPUT.PUT_LINE('Employee Record:');
    DBMS_OUTPUT.PUT_LINE('ID: ' || emp_record.employee_id);
    DBMS_OUTPUT.PUT_LINE('Name: ' || emp_record.first_name || ' ' || emp_record.last_name);
    DBMS_OUTPUT.PUT_LINE('Salary: ' || emp_record.salary);

    -- Assign values to custom record
    custom_record.id := 2;
    custom_record.fname := 'Jane';
    custom_record.lname := 'Smith';
    custom_record.sal := 48000;

    -- Display custom record
    DBMS_OUTPUT.PUT_LINE('Custom Record:');
    DBMS_OUTPUT.PUT_LINE('ID: ' || custom_record.id);
    DBMS_OUTPUT.PUT_LINE('Name: ' || custom_record.fname || ' ' || custom_record.lname);
    DBMS_OUTPUT.PUT_LINE('Salary: ' || custom_record.sal);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No employee found with ID 1');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/