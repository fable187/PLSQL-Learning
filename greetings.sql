DECLARE
    name VARCHAR2(50);
BEGIN
    name := 'John Doe';
    DBMS_OUTPUT.PUT_LINE('Hello, ' || name || '!');
END;