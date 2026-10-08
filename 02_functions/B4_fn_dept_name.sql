CREATE OR REPLACE FUNCTION fn_dept_name(p_department_id IN NUMBER)
RETURN VARCHAR2 IS
BEGIN
    FOR department IN (
        SELECT department_name FROM iny_departments
        WHERE department_id = p_department_id
    ) LOOP
        RETURN department.department_name;
    END LOOP;
    RETURN NULL;
END;
/
SHOW ERRORS FUNCTION fn_dept_name
