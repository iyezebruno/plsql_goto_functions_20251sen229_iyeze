# Inyange Factory Checks

**PL/SQL Assignment III | INSY 8311**  
**IYEZE BRUNO | 20251SEN229**

## What this project checks

A factory needs to know whether production reached its target and whether its payroll records are ready for processing. This project uses those two questions to demonstrate Oracle PL/SQL.

The Inyange setting is a fictional classroom example. Employee details, production figures, salary rules and tax bands are invented. Amounts are expressed in Rwandan francs (RWF).

### Production: did the batch reach its target?

The production table stores target and actual quantities in litres. The program subtracts the target from the actual quantity.

| Sample batch | Target | Actual | Meaning |
|---|---:|---:|---|
| Pasteurised milk | 1,000 | 1,120 | 120 litres above target |
| Fruit juice | 800 | 765 | 35 litres below target |
| Yoghurt | 500 | 500 | Target met |
| Pasteurised milk | 1,000 | Missing | Cannot determine the difference |

A1 uses SIGN and CASE to choose a GOTO destination. Each branch prepares a message, which is printed at one shared location.

### Payroll: which records need attention?

The payroll input includes valid records and deliberate problems: zero or negative pay, missing information, an unknown department, an inactive worker and a future hire date.

Two checks answer different questions:

- **Salary review:** A positive salary below RWF 200,000 needs review. Missing or nonpositive pay is invalid. Other amounts are classified as standard pay.
- **Payroll validation:** A record needs positive pay, active status, a recognised department and a valid hire date. Several problems can appear together in one message.

For example, worker 502 earns RWF 180,000. The salary needs review, but the payroll record can still be valid.

## Where the data lives

| Table | Role | Starting records |
|---|---|---:|
| INY_PRODUCTION_CHECKS | Batch targets and readings | 4 |
| INY_DEPARTMENTS | Factory department directory | 4 |
| INY_EMPLOYEES | Employee records with basic constraints | 6 |
| INY_PAYROLL_STAGE | Input records to be checked | 12 |

The staging table permits incomplete data so the validator can explain the errors. Validation does not automatically update the employee table.

## Program guide

| Task | File | Main idea |
|---|---|---|
| A1 | 01_goto/A1_number_classifier.sql | Classify production differences |
| A2 | 01_goto/A2_salary_review.sql | Review salaries with GOTO and count outcomes |
| A3 | 01_goto/A3_illegal_goto.sql | Demonstrate an illegal jump into a loop |
| A3 fix | 01_goto/A3_fixed_goto.sql | Keep the jump inside the loop |
| A4 | 01_goto/A4_rewrite_no_goto.sql | Produce the same review using searched CASE |
| B1 | 02_functions/B1_fn_annual_salary.sql | Multiply monthly salary by twelve |
| B2 | 02_functions/B2_fn_years_of_service.sql | Count completed service anniversaries |
| B3 | 02_functions/B3_fn_calculate_tax.sql | Add tax from separate salary bands |
| B4 | 02_functions/B4_fn_dept_name.sql | Find a department through a cursor loop |
| B5 | 03_tests/B5_functions_in_select.sql | Assemble a payroll report using functions |
| C1 | 02_functions/C1_fn_validate_payroll.sql | Collect payroll problems in one result |
| C2 | docs/REFLECTION.md | Discuss understanding and personal experience |

## Understanding the calculations

The example tax bands are 0% on the first RWF 120,000, 8% on the next RWF 180,000 and 18% on the portion above RWF 300,000. They are exercise rules, not Rwanda PAYE rates.

For worker 501, the expected report values are:

| Item | Calculation or result |
|---|---|
| Monthly salary | RWF 360,000 |
| Annual salary | 360,000 x 12 = RWF 4,320,000 |
| Monthly tax | (180,000 x 8%) + (60,000 x 18%) = RWF 25,200 |
| Net salary | 360,000 - 25,200 = RWF 334,800 |
| Completed service | 5 years on 8 October 2026 |

Service is calculated against the fixed report date of **8 October 2026**. ADD_MONTHS determines the anniversary under the Gregorian calendar, including month-end handling. A 29 February anniversary becomes 28 February in a non-leap year.

The report uses CASE guards to avoid calculating with invalid inputs. Zero is accepted by the annual-salary and tax functions, but rejected by the payroll validator.

## Run the project

Use Oracle 21c and SQL Developer with a separate practice schema. It needs CREATE SESSION, CREATE TABLE, CREATE PROCEDURE and a quota on an application tablespace. Use a connection to the correct PDB and avoid SYS for the assignment objects.

Open each file, check the worksheet connection and press **F5**.

1. Run `00_setup/create_tables.sql` once in a clean schema.
2. Run A1, A2, A3 illegal, A3 fixed and A4 in that order.
3. Create the functions by running B1, B2, B3, B4 and C1.
4. Run `03_tests/test_functions.sql`.
5. Run `03_tests/B5_functions_in_select.sql`.
6. Run `03_tests/test_validate_payroll.sql`.

A3 deliberately produces a compilation error. Its correction is a separate file. Other unexpected errors should be investigated before continuing.

For a readable B5 grid, execute its ALTER SESSION statement first, then select the complete WITH ... SELECT query and press **Ctrl+Enter**.

If setup already succeeded, do not rerun it to update functions. Run the function files directly. CREATE OR REPLACE replaces functions with matching names in the connected schema, so keep this project separate from other assignments.

## Results and testing

The saved execution screenshots show:

| Program | Observed result |
|---|---|
| A1 | +120 litres, -35 litres, target met and one missing reading |
| A2 and A4 | Matching totals: 8 standard, 1 review and 3 invalid salaries |
| A3 | The original example fails; the correction prints Inspect batch 1 and Inspect batch 2 |
| B5, worker 501 | Annual RWF 4,320,000; service 5 years; tax RWF 25,200; net RWF 334,800; VALID |
| C1 tests | 16 payroll tests passed, including the combined-error test |

The function test script contains 24 checks covering calculations, boundaries, missing inputs and expected exceptions. A successful run ends with `Function tests passed: 24`. The full B5 report is expected to contain 12 records.

Each function file includes SHOW ERRORS so compilation messages can be checked immediately after creation.

Tests compare returned values with expected answers. A PASS line containing INVALID means the validator correctly rejected the test record.

The final payroll test temporarily gives worker 501 three problems and checks that all three are reported. It rolls back those changes on success or failure. The validator itself only reads data.

Execution evidence is stored in `screenshots/` using these filenames:

- A1_output.png
- A2_output.png
- A3_error_and_fix.png
- A4_output.png
- B5_select_output.png
- C1_output.png

## Notes on assistance

ChatGPT assisted with the fictional scenario, SQL drafts, revisions, tests and documentation. The reflection discusses the program concepts and design decisions. The results table above records the outcomes visible in the execution screenshots; other test counts are identified as expected results.
