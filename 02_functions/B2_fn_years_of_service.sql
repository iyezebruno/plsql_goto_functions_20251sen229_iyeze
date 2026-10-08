CREATE OR REPLACE FUNCTION fn_years_of_service(
    p_hire_date IN DATE, p_report_date IN DATE DEFAULT SYSDATE)
RETURN NUMBER IS
    completed_years PLS_INTEGER;
    anniversary DATE;
BEGIN
    IF p_hire_date IS NULL OR p_report_date IS NULL THEN
        RAISE_APPLICATION_ERROR(-20102, 'Both dates are required');
    END IF;
    IF TRUNC(p_hire_date) > TRUNC(p_report_date) THEN
        RAISE_APPLICATION_ERROR(-20103, 'Hire date cannot be after report date');
    END IF;

    completed_years := EXTRACT(YEAR FROM p_report_date) - EXTRACT(YEAR FROM p_hire_date);
    anniversary := ADD_MONTHS(TRUNC(p_hire_date), completed_years * 12);
    IF TRUNC(p_report_date) < anniversary THEN
        completed_years := completed_years - 1;
    END IF;
    RETURN completed_years;
END;
/
SHOW ERRORS FUNCTION fn_years_of_service
