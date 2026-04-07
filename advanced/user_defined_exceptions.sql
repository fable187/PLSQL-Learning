-- Example of user-defined exceptions in PL/SQL
-- You can declare custom exceptions and raise them as needed

DECLARE
  -- Declare a user-defined exception
  invalid_salary EXCEPTION;

  l_salary SAMPLE_EMPLOYEES.salary%TYPE;
BEGIN
  -- Fetch salary for employee_id = 1
  SELECT salary INTO l_salary
  FROM SAMPLE_EMPLOYEES
  WHERE employee_id = 1;

  -- Check if salary is negative (example condition)
  IF l_salary < 0 THEN
    RAISE invalid_salary;  -- Raise the custom exception
  END IF;

  -- If no exception, print the salary
  DBMS_OUTPUT.PUT_LINE('Salary is valid: ' || l_salary);

EXCEPTION
  WHEN invalid_salary THEN
    DBMS_OUTPUT.PUT_LINE('Error: Invalid salary detected!');
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Error: Employee not found!');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END;
/