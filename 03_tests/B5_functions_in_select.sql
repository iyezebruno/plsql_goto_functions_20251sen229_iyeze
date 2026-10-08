ALTER SESSION SET NLS_CALENDAR = 'GREGORIAN';
WITH payroll_values AS (
    SELECT employee_id, employee_name, department_id, monthly_salary,
           CASE WHEN monthly_salary >= 0
                THEN fn_annual_salary(monthly_salary) END AS annual_rwf,
           CASE WHEN hire_date IS NOT NULL AND TRUNC(hire_date) <= DATE '2026-10-08'
                THEN fn_years_of_service(hire_date, DATE '2026-10-08') END AS years_service,
           CASE WHEN monthly_salary >= 0
                THEN fn_calculate_tax(monthly_salary) END AS tax_rwf,
           fn_validate_payroll(employee_id, DATE '2026-10-08') AS payroll_status
    FROM iny_payroll_stage
)
SELECT employee_id, employee_name,
       NVL(fn_dept_name(department_id), 'Unknown') AS department,
       monthly_salary AS monthly_rwf, annual_rwf, years_service, tax_rwf,
       CASE WHEN monthly_salary >= 0 THEN monthly_salary - tax_rwf END AS net_rwf,
       payroll_status
FROM payroll_values
ORDER BY department, employee_id;
