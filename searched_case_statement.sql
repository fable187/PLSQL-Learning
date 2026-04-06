SET SERVEROUTPUT ON;

DECLARE
  n_sales      NUMBER := 150000;  -- Example sales amount
  n_commission NUMBER;
BEGIN
  -- Calculate commission based on sales brackets
  -- Using searched CASE for clear, readable conditions
  CASE
    WHEN n_sales > 200000 THEN
      n_commission := 0.2;  -- 20% for high sales
    WHEN n_sales >= 100000 THEN
      n_commission := 0.15; -- 15% for medium-high sales
    WHEN n_sales >= 50000 THEN
      n_commission := 0.1;  -- 10% for medium sales
    WHEN n_sales > 30000 THEN
      n_commission := 0.05; -- 5% for low sales
    ELSE
      n_commission := 0;    -- 0% for very low sales
  END CASE;

  DBMS_OUTPUT.PUT_LINE('Commission is ' || (n_commission * 100) || '%');
END;
/