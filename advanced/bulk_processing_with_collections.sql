-- Example: Bulk processing with conditions and collections
-- Process multiple salaries, collect valid ones in a collection,
-- and insert invalid ones into an error table

DECLARE
  -- Collection to hold valid salaries (nested table of numbers)
  TYPE salary_list IS TABLE OF NUMBER;
  valid_salaries salary_list := salary_list();

  -- Variables for processing
  l_employee_id SAMPLE_EMPLOYEES.employee_id%TYPE;
  l_salary SAMPLE_EMPLOYEES.salary%TYPE;
  l_name VARCHAR2(100);  -- For full name

  -- Cursor to fetch all employees
  CURSOR emp_cursor IS
    SELECT employee_id, first_name || ' ' || last_name AS full_name, salary
    FROM SAMPLE_EMPLOYEES;

BEGIN
  -- Open cursor and process each row
  FOR emp_rec IN emp_cursor LOOP
    l_employee_id := emp_rec.employee_id;
    l_salary := emp_rec.salary;
    l_name := emp_rec.full_name;

    -- Condition: Salary must be positive
    IF l_salary > 0 THEN
      -- Valid: Add to collection
      valid_salaries.EXTEND;
      valid_salaries(valid_salaries.LAST) := l_salary;
      DBMS_OUTPUT.PUT_LINE('Valid salary for ' || l_name || ': ' || l_salary);
    ELSE
      -- Invalid: Insert into error table
      INSERT INTO INVALID_SALARIES (employee_id, salary, error_reason)
      VALUES (l_employee_id, l_salary, 'Salary must be positive');
      DBMS_OUTPUT.PUT_LINE('Invalid salary for ' || l_name || ': ' || l_salary || ' - Ejected to error table');
    END IF;
  END LOOP;

  -- After processing, show summary
  DBMS_OUTPUT.PUT_LINE('Total valid salaries collected: ' || valid_salaries.COUNT);

  -- Optional: Loop through valid salaries and do something (e.g., print)
  FOR i IN 1 .. valid_salaries.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE('Valid salary ' || i || ': ' || valid_salaries(i));
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error during processing: ' || SQLERRM);
END;
/