SET SERVEROUTPUT ON
BEGIN
    GOTO inspect_batch;
    FOR batch_number IN 1..2 LOOP
        <<inspect_batch>>
        DBMS_OUTPUT.PUT_LINE('Inspect batch ' || batch_number);
    END LOOP;
END;
/
