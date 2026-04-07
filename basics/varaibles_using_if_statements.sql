-- DECLARE
--   n_sales NUMBER := 300000;
--   n_commission NUMBER( 10, 2 ) := 0;
-- BEGIN
--   IF n_sales > 200000 THEN
--     n_commission := n_sales * 0.1;
--   ELSE
--     n_commission := n_sales * 0.05;
--   END IF;
-- END;



DECLARE
  b_profitable BOOLEAN;
  n_sales      NUMBER := 100;
  n_costs      NUMBER := 50;
BEGIN
  b_profitable := n_sales > n_costs;
END;