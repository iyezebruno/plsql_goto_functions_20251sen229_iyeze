SET SERVEROUTPUT ON
DECLARE
    result_text VARCHAR2(100);
BEGIN
    FOR batch IN (
        SELECT batch_id, product_name, actual_litres - target_litres AS difference
        FROM iny_production_checks ORDER BY batch_id
    ) LOOP
        CASE SIGN(batch.difference)
            WHEN 1 THEN GOTO surplus;
            WHEN -1 THEN GOTO shortfall;
            WHEN 0 THEN GOTO target_reached;
            ELSE GOTO unrecorded;
        END CASE;

        <<surplus>>
        result_text := 'POSITIVE: ' || batch.difference || ' litres above target';
        GOTO print_result;
        <<shortfall>>
        result_text := 'NEGATIVE: ' || ABS(batch.difference) || ' litres below target';
        GOTO print_result;
        <<target_reached>>
        result_text := 'ZERO: target met';
        GOTO print_result;
        <<unrecorded>>
        result_text := 'UNKNOWN: actual production is missing';
        <<print_result>>
        DBMS_OUTPUT.PUT_LINE('Batch ' || batch.batch_id || ' - ' || batch.product_name || ': ' || result_text);
    END LOOP;
END;
/
