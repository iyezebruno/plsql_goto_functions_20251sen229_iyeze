CREATE OR REPLACE FUNCTION fn_validate_payroll(
    p_employee_id IN NUMBER, p_report_date IN DATE DEFAULT SYSDATE)
RETURN VARCHAR2 IS
    worker iny_payroll_stage%ROWTYPE;
    issues VARCHAR2(1000);

    PROCEDURE add_issue(message_text VARCHAR2) IS
    BEGIN
        IF issues IS NOT NULL THEN issues := issues || '; '; END IF;
        issues := issues || message_text;
    END;
BEGIN
    IF p_report_date IS NULL THEN
        add_issue('report date missing');
        GOTO build_result;
    END IF;

    SELECT * INTO worker FROM iny_payroll_stage WHERE employee_id = p_employee_id;

    IF worker.monthly_salary IS NULL OR worker.monthly_salary <= 0 THEN
        add_issue('salary must be positive');
    END IF;
    IF worker.active_flag IS NULL OR worker.active_flag <> 'Y' THEN
        add_issue('worker is not active');
    END IF;
    IF fn_dept_name(worker.department_id) IS NULL THEN
        add_issue('department not recognised');
    END IF;
    IF worker.hire_date IS NULL THEN
        add_issue('hire date missing');
    ELSIF TRUNC(worker.hire_date) > TRUNC(p_report_date) THEN
        add_issue('hire date is in the future');
    END IF;

    <<build_result>>
    IF issues IS NULL THEN RETURN 'VALID'; END IF;
    RETURN 'INVALID: ' || issues;
EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN 'INVALID: payroll record not found';
END;
/
SHOW ERRORS FUNCTION fn_validate_payroll
