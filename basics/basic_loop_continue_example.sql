-- PL/SQL Basic LOOP and CONTINUE Example
-- Demonstrates basic LOOP statement and CONTINUE statement

DECLARE
    v_counter NUMBER := 1;
    v_sum NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Basic LOOP Example ===');

    -- Basic LOOP with EXIT WHEN condition
    LOOP
        v_sum := v_sum + v_counter;
        DBMS_OUTPUT.PUT_LINE('Iteration ' || v_counter || ', Sum: ' || v_sum);

        v_counter := v_counter + 1;
        EXIT WHEN v_counter > 5;  -- Exit condition
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Final sum: ' || v_sum);

    DBMS_OUTPUT.PUT_LINE('=== CONTINUE Example ===');

    -- Reset variables
    v_counter := 0;
    v_sum := 0;

    -- LOOP with CONTINUE
    LOOP
        v_counter := v_counter + 1;
        EXIT WHEN v_counter > 10;

        -- Skip even numbers
        IF MOD(v_counter, 2) = 0 THEN
            CONTINUE;  -- Skip to next iteration
        END IF;

        v_sum := v_sum + v_counter;
        DBMS_OUTPUT.PUT_LINE('Added odd number: ' || v_counter || ', Sum: ' || v_sum);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Sum of odd numbers 1-10: ' || v_sum);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/