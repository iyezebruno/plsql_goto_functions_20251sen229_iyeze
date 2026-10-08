CREATE OR REPLACE FUNCTION fn_calculate_tax(p_monthly_salary IN NUMBER)
RETURN NUMBER IS
    v_tax NUMBER := 0;
BEGIN
    IF p_monthly_salary IS NULL OR p_monthly_salary < 0 THEN
        RAISE_APPLICATION_ERROR(-20104, 'Tax requires a zero or positive salary');
    END IF;
    IF p_monthly_salary > 120000 THEN
        v_tax := (LEAST(p_monthly_salary, 300000) - 120000) * 0.08;
    END IF;
    IF p_monthly_salary > 300000 THEN
        v_tax := v_tax + (p_monthly_salary - 300000) * 0.18;
    END IF;
    RETURN ROUND(v_tax, 2);
END;
/
SHOW ERRORS FUNCTION fn_calculate_tax
