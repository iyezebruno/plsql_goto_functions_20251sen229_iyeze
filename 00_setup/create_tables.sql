CREATE TABLE iny_departments (
    department_id NUMBER(3) CONSTRAINT iny_department_pk PRIMARY KEY,
    department_name VARCHAR2(60) NOT NULL
);

CREATE TABLE iny_employees (
    employee_id NUMBER(5) CONSTRAINT iny_employee_pk PRIMARY KEY,
    employee_name VARCHAR2(60) NOT NULL,
    department_id NUMBER(3) NOT NULL REFERENCES iny_departments(department_id),
    hire_date DATE NOT NULL,
    monthly_salary NUMBER(12,2) NOT NULL CHECK (monthly_salary > 0),
    active_flag CHAR(1) DEFAULT 'Y' NOT NULL CHECK (active_flag IN ('Y','N'))
);

CREATE TABLE iny_payroll_stage (
    employee_id NUMBER(5) CONSTRAINT iny_stage_pk PRIMARY KEY,
    employee_name VARCHAR2(60) NOT NULL,
    department_id NUMBER(3),
    hire_date DATE,
    monthly_salary NUMBER(12,2),
    active_flag CHAR(1) CHECK (active_flag IN ('Y','N'))
);

CREATE TABLE iny_production_checks (
    batch_id NUMBER(5) CONSTRAINT iny_batch_pk PRIMARY KEY,
    product_name VARCHAR2(60) NOT NULL,
    production_date DATE NOT NULL,
    target_litres NUMBER(10) NOT NULL CHECK (target_litres > 0),
    actual_litres NUMBER(10) CHECK (actual_litres >= 0)
);

INSERT INTO iny_departments VALUES (11, 'Milk Processing');
INSERT INTO iny_departments VALUES (22, 'Quality Control');
INSERT INTO iny_departments VALUES (33, 'Packaging');
INSERT INTO iny_departments VALUES (44, 'Plant Maintenance');

INSERT INTO iny_employees VALUES (501, 'Alice', 11, DATE '2021-10-08', 360000, 'Y');
INSERT INTO iny_employees VALUES (502, 'Eric', 33, DATE '2024-02-01', 180000, 'Y');
INSERT INTO iny_employees VALUES (503, 'Diane', 22, DATE '2020-06-12', 420000, 'Y');
INSERT INTO iny_employees VALUES (504, 'Patrick', 44, DATE '2023-10-09', 200000, 'Y');
INSERT INTO iny_employees VALUES (509, 'Claudine', 33, DATE '2022-05-02', 240000, 'N');
INSERT INTO iny_employees VALUES (512, 'Samuel', 11, DATE '2026-10-08', 300000, 'Y');

INSERT INTO iny_payroll_stage
    (employee_id, employee_name, department_id, hire_date, monthly_salary, active_flag)
SELECT employee_id, employee_name, department_id, hire_date, monthly_salary, active_flag
FROM iny_employees;
INSERT INTO iny_payroll_stage VALUES (505, 'Emmanuel', 11, DATE '2025-01-10', 0, 'Y');
INSERT INTO iny_payroll_stage VALUES (506, 'Rose', 22, DATE '2024-03-21', -8000, 'Y');
INSERT INTO iny_payroll_stage VALUES (507, 'Paul', 99, DATE '2022-07-01', 260000, 'Y');
INSERT INTO iny_payroll_stage VALUES (508, 'Nadine', 44, DATE '2027-02-01', 310000, 'Y');
INSERT INTO iny_payroll_stage VALUES (510, 'Joseph', 33, DATE '2025-04-01', NULL, 'Y');
INSERT INTO iny_payroll_stage VALUES (511, 'Estelle', 22, NULL, 280000, 'Y');

INSERT INTO iny_production_checks VALUES (1, 'Pasteurised milk', DATE '2026-10-01', 1000, 1120);
INSERT INTO iny_production_checks VALUES (2, 'Fruit juice', DATE '2026-10-02', 800, 765);
INSERT INTO iny_production_checks VALUES (3, 'Yoghurt', DATE '2026-10-03', 500, 500);
INSERT INTO iny_production_checks VALUES (4, 'Pasteurised milk', DATE '2026-10-04', 1000, NULL);
COMMIT;
