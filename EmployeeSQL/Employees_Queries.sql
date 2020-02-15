--------------------------------------------------------------------------------
-- IMPORT CSV DATA TO TABLES
-- employees
COPY employees FROM '/Library/PostgreSQL/12/Data_Tec/Homework_SQL/employees.csv'
WITH (format CSV, HEADER);

SELECT * FROM employees;

-- salaries
COPY salaries FROM '/Library/PostgreSQL/12/Data_Tec/Homework_SQL/salaries.csv'
WITH (format CSV, HEADER);

SELECT * FROM salaries;

-- titles
COPY titles FROM '/Library/PostgreSQL/12/Data_Tec/Homework_SQL/titles.csv'
WITH (format CSV, HEADER);

SELECT * FROM titles;

-- departments
COPY departments FROM '/Library/PostgreSQL/12/Data_Tec/Homework_SQL/departments.csv'
WITH (format CSV, HEADER);

SELECT * FROM departments;

-- dept_emp
COPY dept_emp FROM '/Library/PostgreSQL/12/Data_Tec/Homework_SQL/dept_emp.csv'
WITH (format CSV, HEADER);

SELECT * FROM dept_emp;

-- dept_manager
COPY dept_manager FROM '/Library/PostgreSQL/12/Data_Tec/Homework_SQL/dept_manager.csv'
WITH (format CSV, HEADER);

SELECT * FROM dept_manager;

--------------------------------------------------------------------------------
-- QUERIES
-- Data Analysis:

-- 1. List the following details of each employee: 
-- 	  employee number, last name, first name, gender, and salary.
SELECT employees.emp_no AS "Employee Number", employees.last_name AS "Last Name", 
	   employees.first_name AS "First Name", employees.gender AS "Gender", 
	   salaries.salary AS "Salary"
	FROM salaries INNER JOIN employees ON salaries.emp_no = employees.emp_no;

-- 2. List employees who were hired in 1986.
SELECT *
	FROM employees
	WHERE DATE_PART('year', hire_date) = '1986';

-- 3. List the manager of each department with the following information: 
-- 	  department number, department name, the manager's employee number, last name, first name, 
--    and start and end employment dates.
SELECT DEP.dept_no AS "Department Number", departments.dept_name AS "Department Name",
	   DEP.emp_no AS "Employee Number", DEP.last_name AS "Last Name", 
	   DEP.first_name AS "First Name", DEP.from_date AS "Start Employment Date", 
	   DEP.to_date AS "End Employment Date"
	FROM (
		  SELECT EMP.emp_no, EMP.first_name, EMP.last_name, dept_manager.from_date, 
				 dept_manager.to_date, dept_manager.dept_no
		      FROM (
				    SELECT employees.emp_no, employees.first_name, employees.last_name 
				        FROM dept_manager INNER JOIN employees 
				  			ON dept_manager.emp_no = employees.emp_no
			  		) AS EMP
			        INNER JOIN dept_manager ON EMP.emp_no = dept_manager.emp_no
		) AS DEP INNER JOIN departments ON DEP.dept_no = departments.dept_no;


-- 4. List the department of each employee with the following information: 
--    employee number, last name, first name, and department name.
SELECT EMP.emp_no AS "Employee Number", EMP.last_name AS "Last Name", 
	   EMP.first_name AS "First Name", departments.dept_name AS "Department Name"
	FROM ( 
		  SELECT employees.emp_no, employees.last_name, employees.first_name, DEP.dept_no
			 FROM (
			   	   SELECT emp_no, dept_no 
					  FROM dept_emp 
						WHERE DATE_PART('year', to_date) = '9999'
			      ) AS DEP
			    INNER JOIN employees ON DEP.emp_no = employees.emp_no
	     ) AS EMP
	   INNER JOIN departments ON EMP.dept_no = departments.dept_no;

--- 5. List all employees whose first name is "Hercules" and last names begin with "B."
SELECT emp_no AS "Employee Number", last_name AS "Last Name", first_name AS "First Name"
	FROM employees 
		WHERE (first_name = 'Hercules') AND (LEFT(last_name, 1) = 'B');

-- 6. List all employees in the Sales department, including their: 
--    employee number, last name, first name, and department name.
SELECT employees.emp_no AS "Employee Number", employees.last_name AS "Last Name", 
	   employees.first_name AS "First Name", DEP2.dept_name AS "Department Name"
	FROM ( 
		  SELECT emp_no, dept_name 
			  FROM (
				    SELECT * FROM departments WHERE dept_name = 'Sales'
	               ) AS DEP
	            INNER JOIN dept_emp ON DEP.dept_no = dept_emp.dept_no
				WHERE DATE_PART('year', dept_emp.to_date) = '9999'
	     ) AS DEP2 
	  INNER JOIN employees ON DEP2.emp_no = employees.emp_no;

-- 7. List all employees in the Sales and Development departments, including their:
--    employee number, last name, first name, and department name.
SELECT employees.emp_no AS "Employee Number", employees.last_name AS "Last Name", 
	   employees.first_name AS "First Name", DEP2.dept_name AS "Department Name"
	FROM ( 
		  SELECT emp_no, dept_name 
			  FROM (
				    SELECT * 
				  		FROM departments 
				  		  WHERE (dept_name = 'Sales') OR (dept_name = 'Development')
	               ) AS DEP
	            INNER JOIN dept_emp ON DEP.dept_no = dept_emp.dept_no
				WHERE DATE_PART('year', dept_emp.to_date) = '9999'
	     ) AS DEP2 
	  INNER JOIN employees ON DEP2.emp_no = employees.emp_no;

-- 8. In descending order, list the frequency count of employee last names, i.e., 
--    how many employees share each last name.
SELECT last_name AS "Last Name", COUNT(last_name) AS "Frequency"
	FROM employees
		GROUP BY last_name
		ORDER BY "Frequency" DESC;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
