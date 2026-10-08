CREATE OR REPLACE FUNCTION fn_annual_salary(p_monthly_salary IN NUMBER)
RETURN NUMBER IS
BEGIN
    IF p_monthly_salary IS NULL OR p_monthly_salary < 0 THEN
        RAISE_APPLICATION_ERROR(-20101, 'Monthly salary must be zero or positive');
    END IF;
    RETURN ROUND(p_monthly_salary * 12, 2);
END;
/
SHOW ERRORS FUNCTION fn_annual_salary
