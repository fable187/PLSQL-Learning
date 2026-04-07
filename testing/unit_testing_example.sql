-- Example: Simple Unit Testing in PL/SQL
-- We'll create a function, then write tests for it

-- Step 1: CREATE A FUNCTION TO TEST
CREATE OR REPLACE FUNCTION calculate_bonus(p_salary NUMBER, p_department VARCHAR2)
RETURN NUMBER
AS
  l_bonus NUMBER;
BEGIN
  CASE
    WHEN p_department = 'Engineering' AND p_salary > 50000 THEN
      l_bonus := p_salary * 0.10;
    WHEN p_department = 'Engineering' AND p_salary <= 50000 THEN
      l_bonus := p_salary * 0.05;
    WHEN p_department IN ('Marketing', 'Sales') AND p_salary > 45000 THEN
      l_bonus := p_salary * 0.15;
    WHEN p_department IN ('Marketing', 'Sales') AND p_salary <= 45000 THEN
      l_bonus := p_salary * 0.10;
    WHEN p_department = 'HR' THEN
      l_bonus := p_salary * 0.12;
    ELSE
      l_bonus := p_salary * 0.08;
  END CASE;
  RETURN l_bonus;
END calculate_bonus;
/

-- Step 2: CREATE A TEST PROCEDURE
CREATE OR REPLACE PROCEDURE test_calculate_bonus
AS
  -- Test variables
  l_result NUMBER;
  l_expected NUMBER;
  l_pass_count NUMBER := 0;
  l_fail_count NUMBER := 0;

  -- Helper procedure to assert results
  PROCEDURE assert_equal(p_test_name VARCHAR2, p_actual NUMBER, p_expected NUMBER)
  AS
  BEGIN
    IF p_actual = p_expected THEN
      DBMS_OUTPUT.PUT_LINE('[PASS] ' || p_test_name);
      l_pass_count := l_pass_count + 1;
    ELSE
      DBMS_OUTPUT.PUT_LINE('[FAIL] ' || p_test_name || ' - Expected: ' || p_expected || ', Got: ' || p_actual);
      l_fail_count := l_fail_count + 1;
    END IF;
  END assert_equal;

BEGIN
  DBMS_OUTPUT.PUT_LINE('========== STARTING UNIT TESTS ==========');
  
  -- Test 1: Engineering with high salary
  l_result := calculate_bonus(60000, 'Engineering');
  l_expected := 6000;  -- 60000 * 0.10
  assert_equal('Test 1: Engineering high salary', l_result, l_expected);

  -- Test 2: Engineering with low salary
  l_result := calculate_bonus(40000, 'Engineering');
  l_expected := 2000;  -- 40000 * 0.05
  assert_equal('Test 2: Engineering low salary', l_result, l_expected);

  -- Test 3: Marketing with high salary
  l_result := calculate_bonus(50000, 'Marketing');
  l_expected := 7500;  -- 50000 * 0.15
  assert_equal('Test 3: Marketing high salary', l_result, l_expected);

  -- Test 4: Sales with low salary
  l_result := calculate_bonus(40000, 'Sales');
  l_expected := 4000;  -- 40000 * 0.10
  assert_equal('Test 4: Sales low salary', l_result, l_expected);

  -- Test 5: HR (flat 12%)
  l_result := calculate_bonus(50000, 'HR');
  l_expected := 6000;  -- 50000 * 0.12
  assert_equal('Test 5: HR flat bonus', l_result, l_expected);

  -- Test 6: Unknown department (default 8%)
  l_result := calculate_bonus(50000, 'Finance');
  l_expected := 4000;  -- 50000 * 0.08
  assert_equal('Test 6: Unknown department', l_result, l_expected);

  -- Test Summary
  DBMS_OUTPUT.PUT_LINE('========== TEST SUMMARY ==========');
  DBMS_OUTPUT.PUT_LINE('Passed: ' || l_pass_count);
  DBMS_OUTPUT.PUT_LINE('Failed: ' || l_fail_count);
  DBMS_OUTPUT.PUT_LINE('Total: ' || (l_pass_count + l_fail_count));
  
  IF l_fail_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[SUCCESS] All tests passed!');
  ELSE
    DBMS_OUTPUT.PUT_LINE('[FAILED] Some tests failed.');
  END IF;
END test_calculate_bonus;
/
