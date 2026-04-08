SET SERVEROUTPUT ON SIZE 1000000;

BEGIN
    ut.run(
        a_include_schema_expr => 'SYSTEM',
        a_include_object_expr => 'TEST_DEMO_IS_EVEN'
    );
END;
/
