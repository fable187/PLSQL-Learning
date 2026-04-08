CREATE OR REPLACE FUNCTION demo_is_even(p_number IN NUMBER)
RETURN VARCHAR2 AS
BEGIN
    RETURN CASE
        WHEN MOD(p_number, 2) = 0 THEN 'Y'
        ELSE 'N'
    END;
END;
/

CREATE OR REPLACE PACKAGE test_demo_is_even IS
    --%suite(Demo is_even tests)
    --%suitepath(learning.demo)

    --%test(Returns Y for even numbers)
    PROCEDURE returns_y_for_even;

    --%test(Returns N for odd numbers)
    PROCEDURE returns_n_for_odd;
END;
/

CREATE OR REPLACE PACKAGE BODY test_demo_is_even IS
    PROCEDURE returns_y_for_even IS
    BEGIN
        ut.expect(demo_is_even(4)).to_equal('Y');
    END;

    PROCEDURE returns_n_for_odd IS
    BEGIN
        ut.expect(demo_is_even(5)).to_equal('N');
    END;
END;
/
