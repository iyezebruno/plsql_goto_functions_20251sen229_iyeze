SET SERVEROUTPUT ON
DECLARE
    actual_status VARCHAR2(1200);
    passed PLS_INTEGER := 0;
BEGIN
    FOR test IN (
        SELECT 501 AS employee_id, 'VALID' AS expected_status, DATE '2026-10-08' AS report_date FROM dual
        UNION ALL
        SELECT 502 AS employee_id, 'VALID' AS expected_status, DATE '2026-10-08' AS report_date FROM dual
        UNION ALL
        SELECT 503 AS employee_id, 'VALID' AS expected_status, DATE '2026-10-08' AS report_date FROM dual
        UNION ALL
        SELECT 504 AS employee_id, 'VALID' AS expected_status, DATE '2026-10-08' AS report_date FROM dual
        UNION ALL
        SELECT 505 AS employee_id, 'INVALID: salary must be positive' AS expected_status, DATE '2026-10-08' AS report_date FROM dual
        UNION ALL
        SELECT 506 AS employee_id, 'INVALID: salary must be positive' AS expected_status, DATE '2026-10-08' AS report_date FROM dual
        UNION ALL
        SELECT 507 AS employee_id, 'INVALID: department not recognised' AS expected_status, DATE '2026-10-08' AS report_date FROM dual
        UNION ALL
        SELECT 508 AS employee_id, 'INVALID: hire date is in the future' AS expected_status, DATE '2026-10-08' AS report_date FROM dual
        UNION ALL
        SELECT 509 AS employee_id, 'INVALID: worker is not active' AS expected_status, DATE '2026-10-08' AS report_date FROM dual
        UNION ALL
        SELECT 510 AS employee_id, 'INVALID: salary must be positive' AS expected_status, DATE '2026-10-08' AS report_date FROM dual
        UNION ALL
        SELECT 511 AS employee_id, 'INVALID: hire date missing' AS expected_status, DATE '2026-10-08' AS report_date FROM dual
        UNION ALL
        SELECT 512 AS employee_id, 'VALID' AS expected_status, DATE '2026-10-08' AS report_date FROM dual
        UNION ALL
        SELECT 999 AS employee_id, 'INVALID: payroll record not found' AS expected_status, DATE '2026-10-08' AS report_date FROM dual
        UNION ALL
        SELECT NULL AS employee_id, 'INVALID: payroll record not found' AS expected_status, DATE '2026-10-08' AS report_date FROM dual
        UNION ALL SELECT 501, 'INVALID: report date missing', NULL FROM dual
    ) LOOP
        actual_status := fn_validate_payroll(test.employee_id, test.report_date);
        IF actual_status IS NULL OR actual_status <> test.expected_status THEN
            RAISE_APPLICATION_ERROR(-20904, 'Unexpected status for ' || NVL(TO_CHAR(test.employee_id), 'NULL') || ': ' || NVL(actual_status, 'NULL'));
        END IF;
        passed := passed + 1;
        DBMS_OUTPUT.PUT_LINE('PASS ' || NVL(TO_CHAR(test.employee_id), 'NULL') || ': ' || actual_status);
    END LOOP;

    SAVEPOINT before_combined_test;
    BEGIN
        UPDATE iny_payroll_stage
        SET monthly_salary = 0, department_id = NULL, active_flag = NULL
        WHERE employee_id = 501;
        actual_status := fn_validate_payroll(501, DATE '2026-10-08');
        IF actual_status IS NULL OR actual_status <>
           'INVALID: salary must be positive; worker is not active; department not recognised' THEN
            RAISE_APPLICATION_ERROR(-20905, 'Combined validation failed: ' || NVL(actual_status, 'NULL'));
        END IF;
        ROLLBACK TO before_combined_test;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK TO before_combined_test;
            RAISE;
    END;
    passed := passed + 1;
    DBMS_OUTPUT.PUT_LINE('PASS: all three problems reported; temporary changes rolled back');
    DBMS_OUTPUT.PUT_LINE('Payroll tests passed: ' || passed);
END;
/
