SET SERVEROUTPUT ON
ALTER SESSION SET NLS_CALENDAR = 'GREGORIAN';
DECLARE
    passed PLS_INTEGER := 0;
    actual_code NUMBER;
    unused_result NUMBER;
BEGIN
    FOR test IN (
        SELECT 'Annual salary' AS test_name, fn_annual_salary(360000) AS actual_value, 4320000 AS expected_value FROM dual
        UNION ALL
        SELECT 'Zero annual salary' AS test_name, fn_annual_salary(0) AS actual_value, 0 AS expected_value FROM dual
        UNION ALL
        SELECT 'Decimal salary' AS test_name, fn_annual_salary(123.45) AS actual_value, 1481.40 AS expected_value FROM dual
        UNION ALL
        SELECT 'Service anniversary' AS test_name, fn_years_of_service(DATE '2021-10-08', DATE '2026-10-08') AS actual_value, 5 AS expected_value FROM dual
        UNION ALL
        SELECT 'Day before anniversary' AS test_name, fn_years_of_service(DATE '2023-10-09', DATE '2026-10-08') AS actual_value, 2 AS expected_value FROM dual
        UNION ALL
        SELECT 'New worker' AS test_name, fn_years_of_service(DATE '2026-10-08', DATE '2026-10-08') AS actual_value, 0 AS expected_value FROM dual
        UNION ALL
        SELECT 'Leap-day anniversary' AS test_name, fn_years_of_service(DATE '2024-02-29', DATE '2025-02-28') AS actual_value, 1 AS expected_value FROM dual
        UNION ALL
        SELECT 'Zero tax' AS test_name, fn_calculate_tax(0) AS actual_value, 0 AS expected_value FROM dual
        UNION ALL
        SELECT 'First tax boundary' AS test_name, fn_calculate_tax(120000) AS actual_value, 0 AS expected_value FROM dual
        UNION ALL
        SELECT 'Above first boundary' AS test_name, fn_calculate_tax(120001) AS actual_value, 0.08 AS expected_value FROM dual
        UNION ALL
        SELECT 'Middle band' AS test_name, fn_calculate_tax(180000) AS actual_value, 4800 AS expected_value FROM dual
        UNION ALL
        SELECT 'Second tax boundary' AS test_name, fn_calculate_tax(300000) AS actual_value, 14400 AS expected_value FROM dual
        UNION ALL
        SELECT 'Above second boundary' AS test_name, fn_calculate_tax(300001) AS actual_value, 14400.18 AS expected_value FROM dual
        UNION ALL
        SELECT 'Upper band' AS test_name, fn_calculate_tax(360000) AS actual_value, 25200 AS expected_value FROM dual
    ) LOOP
        IF test.actual_value IS NULL OR ABS(test.actual_value - test.expected_value) > 0.000001 THEN
            RAISE_APPLICATION_ERROR(-20901, test.test_name || ': numeric result mismatch');
        END IF;
        passed := passed + 1;
        DBMS_OUTPUT.PUT_LINE('PASS: ' || test.test_name);
    END LOOP;

    FOR test IN (
        SELECT 'Missing salary' AS test_name, q'[SELECT fn_annual_salary(NULL) FROM dual]' AS statement_text, -20101 AS expected_code FROM dual
        UNION ALL
        SELECT 'Negative salary' AS test_name, q'[SELECT fn_annual_salary(-1) FROM dual]' AS statement_text, -20101 AS expected_code FROM dual
        UNION ALL
        SELECT 'Missing hire date' AS test_name, q'[SELECT fn_years_of_service(NULL, DATE '2026-10-08') FROM dual]' AS statement_text, -20102 AS expected_code FROM dual
        UNION ALL
        SELECT 'Missing report date' AS test_name, q'[SELECT fn_years_of_service(DATE '2021-10-08', NULL) FROM dual]' AS statement_text, -20102 AS expected_code FROM dual
        UNION ALL
        SELECT 'Future hire date' AS test_name, q'[SELECT fn_years_of_service(DATE '2027-01-01', DATE '2026-10-08') FROM dual]' AS statement_text, -20103 AS expected_code FROM dual
        UNION ALL
        SELECT 'Negative tax input' AS test_name, q'[SELECT fn_calculate_tax(-1) FROM dual]' AS statement_text, -20104 AS expected_code FROM dual
        UNION ALL
        SELECT 'Null tax input' AS test_name, q'[SELECT fn_calculate_tax(NULL) FROM dual]' AS statement_text, -20104 AS expected_code FROM dual
    ) LOOP
        actual_code := 0;
        BEGIN
            EXECUTE IMMEDIATE test.statement_text INTO unused_result;
        EXCEPTION
            WHEN OTHERS THEN actual_code := SQLCODE;
        END;
        IF actual_code <> test.expected_code THEN
            RAISE_APPLICATION_ERROR(-20902, test.test_name || ': expected error ' || test.expected_code || ', got ' || actual_code);
        END IF;
        passed := passed + 1;
        DBMS_OUTPUT.PUT_LINE('PASS: ' || test.test_name);
    END LOOP;

    FOR test IN (
        SELECT 11 AS department_id, 'Milk Processing' AS expected_name FROM dual
        UNION ALL SELECT 99, NULL FROM dual
        UNION ALL SELECT NULL, NULL FROM dual
    ) LOOP
        IF NVL(fn_dept_name(test.department_id), '[missing]') <> NVL(test.expected_name, '[missing]') THEN
            RAISE_APPLICATION_ERROR(-20903, 'Department lookup mismatch');
        END IF;
        passed := passed + 1;
        DBMS_OUTPUT.PUT_LINE('PASS: department ' || NVL(TO_CHAR(test.department_id), 'NULL'));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Function tests passed: ' || passed);
END;
/
