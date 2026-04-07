DECLARE 
    l_order_count INT;
BEGIN
    select count(*) into l_order_count from SAMPLE_EMPLOYEES;
    DBMS_OUTPUT.PUT_LINE('Total Orders: ' || l_order_count);
END;
