DECLARE
  b_status BOOLEAN := TRUE;  -- Initialize to demonstrate GOTO
BEGIN
  IF b_status THEN
    GOTO end_of_program;
  END IF;
  -- Further processing here (skipped if b_status is TRUE)
  DBMS_OUTPUT.PUT_LINE('This will not print if GOTO triggered');
  <<end_of_program>>
  NULL;  -- NULL statement does nothing, just marks the end
END;
/