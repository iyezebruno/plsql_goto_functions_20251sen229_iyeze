SET SERVEROUTPUT ON
DECLARE
    decision VARCHAR2(20);
    review_count PLS_INTEGER := 0;
    invalid_count PLS_INTEGER := 0;
    standard_count PLS_INTEGER := 0;
BEGIN
    FOR worker IN (
        SELECT employee_id, monthly_salary FROM iny_payroll_stage ORDER BY employee_id
    ) LOOP

        decision := 'INVALID PAY';
        IF worker.monthly_salary IS NULL OR worker.monthly_salary <= 0 THEN
            invalid_count := invalid_count + 1;
            GOTO display_decision;
        END IF;

        decision := 'REVIEW PAY';
        IF worker.monthly_salary < 200000 THEN
            review_count := review_count + 1;
            GOTO display_decision;
        END IF;

        decision := 'STANDARD PAY';
        standard_count := standard_count + 1;
        <<display_decision>>

        DBMS_OUTPUT.PUT_LINE(worker.employee_id || ': ' || decision);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Standard: ' || standard_count || '; Review: ' || review_count || '; Invalid: ' || invalid_count);
END;
/
