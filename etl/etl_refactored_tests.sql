-- ============================================================
-- TEST SUITE: TDD for Refactored ETL Package
-- ============================================================

CREATE OR REPLACE PROCEDURE C##PLSQL_T.test_etl_refactored
AS
    -- Test counters
    l_pass_count NUMBER := 0;
    l_fail_count NUMBER := 0;

    -- Helper to assert values
    PROCEDURE assert_equal(p_test_name VARCHAR2, p_actual NUMBER, p_expected NUMBER) AS
    BEGIN
        IF p_actual = p_expected THEN
            DBMS_OUTPUT.PUT_LINE('[PASS] ' || p_test_name);
            l_pass_count := l_pass_count + 1;
        ELSE
            DBMS_OUTPUT.PUT_LINE('[FAIL] ' || p_test_name || ' - Expected: ' || p_expected || ', Got: ' || p_actual);
            l_fail_count := l_fail_count + 1;
        END IF;
    END assert_equal;

    PROCEDURE assert_true(p_test_name VARCHAR2, p_condition BOOLEAN) AS
    BEGIN
        IF p_condition THEN
            DBMS_OUTPUT.PUT_LINE('[PASS] ' || p_test_name);
            l_pass_count := l_pass_count + 1;
        ELSE
            DBMS_OUTPUT.PUT_LINE('[FAIL] ' || p_test_name);
            l_fail_count := l_fail_count + 1;
        END IF;
    END assert_true;

    -- Test variables
    l_employee_count NUMBER;
    l_bonus_count NUMBER;
    l_recon_count NUMBER;
    l_avg_bonus NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('========== STARTING TEST SUITE ==========');

    -- TEST 1: Clear staging tables
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Test Group 1: Staging Tables ---');
    C##PLSQL_T.etl_refactored.clear_staging();
    
    SELECT COUNT(*) INTO l_employee_count FROM C##PLSQL_T.ETL_EMPLOYEES_STAGING;
    assert_equal('Test 1.1: Staging table cleared', l_employee_count, 0);

    -- TEST 2: Extract employees
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Test Group 2: Extract Procedure ---');
    C##PLSQL_T.etl_refactored.extract_employees();
    
    SELECT COUNT(*) INTO l_employee_count FROM C##PLSQL_T.ETL_EMPLOYEES_STAGING;
    assert_equal('Test 2.1: Extracted correct number of employees', l_employee_count, 5);
    
    -- Verify no negative salaries
    SELECT COUNT(*) INTO l_employee_count FROM C##PLSQL_T.ETL_EMPLOYEES_STAGING WHERE salary < 0;
    assert_equal('Test 2.2: No negative salaries extracted', l_employee_count, 0);

    -- TEST 3: Calculate bonuses
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Test Group 3: Bonus Calculation ---');
    C##PLSQL_T.etl_refactored.calculate_bonuses();
    
    SELECT COUNT(*) INTO l_bonus_count FROM C##PLSQL_T.ETL_EMPLOYEES_STAGING WHERE bonus IS NOT NULL;
    assert_equal('Test 3.1: All employees have bonuses', l_bonus_count, 5);
    
    SELECT COUNT(*) INTO l_bonus_count FROM C##PLSQL_T.ETL_EMPLOYEES_STAGING WHERE bonus > 0;
    assert_equal('Test 3.2: All bonuses are positive', l_bonus_count, 5);
    
    SELECT AVG(bonus) INTO l_avg_bonus FROM C##PLSQL_T.ETL_EMPLOYEES_STAGING WHERE department = 'Engineering';
    assert_true('Test 3.3: Engineering bonus calculation', l_avg_bonus > 0);

    -- TEST 4: Reconciliation
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Test Group 4: Reconciliation ---');
    C##PLSQL_T.etl_refactored.reconcile_totals();
    
    SELECT COUNT(*) INTO l_recon_count FROM C##PLSQL_T.ETL_RECONCILIATION WHERE reconcile_date = TRUNC(SYSDATE);
    assert_equal('Test 4.1: Reconciliation record created', l_recon_count, 1);
    
    SELECT row_count INTO l_employee_count FROM C##PLSQL_T.ETL_RECONCILIATION WHERE reconcile_date = TRUNC(SYSDATE);
    assert_equal('Test 4.2: Reconciliation row count matches', l_employee_count, 5);

    -- TEST 5: Full ETL pipeline
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Test Group 5: Full Pipeline ---');
    C##PLSQL_T.etl_refactored.clear_staging();
    C##PLSQL_T.etl_refactored.run_all_steps();
    
    SELECT COUNT(*) INTO l_employee_count FROM C##PLSQL_T.ETL_EMPLOYEES_STAGING;
    assert_equal('Test 5.1: Full pipeline completed', l_employee_count, 5);

    -- TEST SUMMARY
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '========== TEST SUMMARY ==========');
    DBMS_OUTPUT.PUT_LINE('Passed: ' || l_pass_count);
    DBMS_OUTPUT.PUT_LINE('Failed: ' || l_fail_count);
    DBMS_OUTPUT.PUT_LINE('Total: ' || (l_pass_count + l_fail_count));
    
    IF l_fail_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[SUCCESS] All tests passed!');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[FAILED] Some tests failed.');
    END IF;

END test_etl_refactored;
/

-- RUN THE TESTS
CALL C##PLSQL_T.test_etl_refactored();
