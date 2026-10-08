Reflection

Name: IYEZE BRUNO

Student ID: 20251SEN229

Project purpose

This project models a small part of a fictional Inyange manufacturing operation. It compares production quantities with targets and checks payroll records before processing. The sample data includes incomplete and incorrect records to demonstrate how the programs handle different situations.

Understanding the programs

- A1: A positive difference means production exceeded the target. A negative difference indicates a shortage, while zero means the target was met. Missing production data requires a separate result.

- A2: GOTO directs each salary record to the output statement after choosing its review category. The program also counts the records in each category.

- A3: Jumping into a loop from outside it is illegal. Moving the jump inside the loop allows execution to follow the loop’s normal structure.

- A4: The searched CASE version groups the salary conditions together. It produces the same messages and totals as A2 with fewer jumps.

- B1: The annual salary function receives a monthly amount and returns that amount multiplied by twelve.

- B2: Years of service depend on whether the anniversary has occurred. A worker who is one day short of the anniversary has not completed the next year.

- B3: For RWF 360,000, the fictional tax is RWF 14,400 on the middle band plus RWF 10,800 on the upper band, giving RWF 25,200. Each rate applies only to its portion of the salary.

- B4: The cursor loop returns the matching department name. If it finds no matching department, the function returns NULL.

- B5: The report combines several functions in one query. CASE guards prevent invalid salary or date values from reaching functions that would reject them.

- C1: Worker 502 requires salary review but still has valid payroll information. The validator checks data validity separately and can report several problems in one record.

Decisions that mattered

The staging table accepts incomplete payroll information so the validator can explain what needs correction. Rejecting every incomplete record during insertion would prevent this demonstration.

Another useful distinction is between missing information and zero. Zero production difference means the target was met; a missing reading means the result cannot be determined.

The multiple-error test temporarily changes one record and then rolls back those changes. This allows another test run to start with the original data.

Execution results

Payroll tests passed: 16.

A rejection test succeeds when invalid input produces the expected rejection message. Therefore, a line containing both PASS and INVALID can indicate correct behaviour.

AI assistance

ChatGPT helped draft and revise the manufacturing scenario, SQL programs, tests and documentation. It also provided explanations of the program logic. The execution results and any personal account of difficulties should reflect what I actually ran and observed.

Further development

A useful extension would be a validation history table. It could record when a payroll check occurred and which problems were found, making it easier to track corrections over time.
