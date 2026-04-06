DECLARE
  l_first_name C##PLSQL_T.SAMPLE_EMPLOYEES.first_name%TYPE;
  l_last_name C##PLSQL_T.SAMPLE_EMPLOYEES.last_name%TYPE;
  l_salary C##PLSQL_T.SAMPLE_EMPLOYEES.salary%TYPE;
BEGIN
  SELECT
    first_name, last_name, salary
  INTO
    l_first_name, l_last_name, l_salary
  FROM
    C##PLSQL_T.SAMPLE_EMPLOYEES
  WHERE
    employee_id = 1;

  DBMS_OUTPUT.PUT_LINE(l_first_name || ' ' || l_last_name || ': ' || l_salary);
END;
/