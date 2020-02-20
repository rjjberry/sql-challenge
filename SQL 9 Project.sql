DROP TABLE Departments;
DROP TABLE Departments_EE;
DROP TABLE Dept_Emp;
DROP TABLE Dept_Manager;
DROP TABLE Employees;
DROP TABLE Salaries;
DROP TABLE Titles;

ALTER TABLE Departments DROP CONSTRAINT pk_Departments;
ALTER TABLE Departments_EE DROP CONSTRAINT pk_Departments_EE;
ALTER TABLE Dept_Emp DROP CONSTRAINT pk_Dept_Emp;
ALTER TABLE Dept_Manager DROP CONSTRAINT pk_Dept_Manager;
ALTER TABLE Employees DROP CONSTRAINT pk_Employees;
ALTER TABLE Salaries DROP CONSTRAINT pk_Salaries;
ALTER TABLE titles DROP CONSTRAINT pk_titles;

-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/DIBQcj
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

-- Modify this code to update the DB schema diagram.
-- To reset the sample schema, replace everything with
-- two dots ('..' - without quotes).

CREATE TABLE departments (
    "dept_no" char(4)   NOT NULL,
    "dept_name" char(30)   NOT NULL,
    CONSTRAINT pk_departments PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE departments_EE (
    "dept_no" char(4)   NOT NULL,
    "dept_name" char(30)   NOT NULL,
    CONSTRAINT pk_departments_EE PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE dept_Emp (
    "emp_no" char(6)   NOT NULL,
    "dept_no" char(4)   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL,
    CONSTRAINT pk_dept_emp PRIMARY KEY (
        "emp_no","dept_no"
     )
);

CREATE TABLE dept_manager (
    "dept_no" char(4)   NOT NULL,
    "emp_no" char(6)   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL,
    CONSTRAINT pk_dept_manager PRIMARY KEY (
        "dept_no","emp_no"
     )
);

CREATE TABLE employees (
    "emp_no" char(6)   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" char(30)   NOT NULL,
    "last_name" char(30)   NOT NULL,
    "gender" char(1)   NOT NULL,
    "hire_date" date   NOT NULL,
    CONSTRAINT pk_employees PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE salaries (
    "emp_no" char(6)   NOT NULL,
    "salary" int   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL,
    CONSTRAINT pk_salaries PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE titles (
    "emp_no" char(6)   NOT NULL,
    "titles" char(30)   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL,
    CONSTRAINT pk_titles PRIMARY KEY (
        "emp_no", "titles", "from_date"
     )
);

ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_emp_no FOREIGN KEY("emp_no")
REFERENCES employees ("emp_no");

ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_dept_no FOREIGN KEY("dept_no")
REFERENCES departments_ee ("dept_no");

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_dept_no FOREIGN KEY("dept_no")
REFERENCES departments ("dept_no");

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_emp_no FOREIGN KEY("emp_no")
REFERENCES employees ("emp_no");

ALTER TABLE salaries ADD CONSTRAINT fk_salaries_emp_no FOREIGN KEY("emp_no")
REFERENCES employees ("emp_no");

ALTER TABLE titles ADD CONSTRAINT fk_titles_emp_no FOREIGN KEY("emp_no")
REFERENCES employees ("emp_no");

ALTER TABLE titles ADD CONSTRAINT pk_titles_emp_no_title_date PRIMARY KEY("emp_no", "titles", "from_date");

Grant All on Schema public to postgres;
Grant all on schema public to public;

--copy Departments(dept_no, dept_name) from 'C:\Users\16517\OneDrive\Desktop\ClassRepo6\UofM-STP-DATA-PT-11-2019-U-C\09-SQL\Homework\data\departments.csv' DELIMITER ',' CSV HEADER;
copy departments(dept_no, dept_name) from 'C:\Users\16517\Desktop\departments.csv' DELIMITER ',' CSV HEADER;
copy departments_ee(dept_no, dept_name) from 'C:\Users\16517\Desktop\departments.csv' DELIMITER ',' CSV HEADER;
copy dept_emp from 'C:\Users\16517\Desktop\dept_emp.csv' DELIMITER ',' CSV HEADER;
copy dept_manager from 'C:\Users\16517\Desktop\dept_manager.csv' DELIMITER ',' CSV HEADER;
copy employees from 'C:\Users\16517\Desktop\employees.csv' DELIMITER ',' CSV HEADER;
copy salaries from 'C:\Users\16517\Desktop\salaries.csv' DELIMITER ',' CSV HEADER;
copy titles from 'C:\Users\16517\Desktop\titles.csv' DELIMITER ',' CSV HEADER;

select * from departments;
select * from departments_ee;
select * from dept_emp;
select * from dept_manager;
select * from employees;
select * from salaries;
select * from titles;

-- Question 1, Employee info and Salary
select employees.emp_no,
last_name,
first_name,
gender,
salary
from employees left outer join salaries
on (employees.emp_no = salaries.emp_no);

-- Question 2, Employees hired in 1986
select emp_no,
last_name,
first_name,
Extract(year from hire_date) as hire_year
from employees
where hire_date between '1986-01-01' and '1986-12-31';


-- Question 3, Manager, Department and Start/End date info
select dm.dept_no,
d.dept_name,
dm.emp_no as Mgr_Emp_no,
e.last_name as Mgr_Last_name,
e.first_name as Mgr_First_name,
dm.from_date as Start_date,
dm.to_date as End_date
--last_name,
--first_name
from dept_manager dm left outer join departments d
on (dm.dept_no = d.dept_no) left outer join employees e
on (dm.emp_no = e.emp_no)
Order by mgr_last_name, mgr_first_name;


-- Question 4, Employee info with Department Name
select e.emp_no as Employee_no,
e.last_name,
e.first_name,
d.dept_name
from employees e left outer join dept_emp de
on (e.emp_no = de.emp_no) left outer join departments_ee d
on (de.dept_no = d.dept_no)
Order by e.last_name, e.first_name;


-- Question 5, Employees - Hercules - B
select e.emp_no as Employee_no,
e.last_name,
e.first_name
from employees e
where e.first_name = 'Hercules'
  and e.last_name like 'B%'
Order by e.last_name, e.first_name;


-- Question 6, Employees in Sales Department
select e.emp_no as Employee_no,
e.last_name,
e.first_name,
d.dept_name
from employees e left outer join dept_emp de
on (e.emp_no = de.emp_no) left outer join departments_ee d
on (de.dept_no = d.dept_no)
where d.dept_name = 'Sales'
Order by e.last_name, e.first_name;


-- Question 7, Employees in Sales and Development Departments
select e.emp_no as Employee_no,
e.last_name,
e.first_name,
d.dept_name
from employees e left outer join dept_emp de
on (e.emp_no = de.emp_no) left outer join departments_ee d
on (de.dept_no = d.dept_no)
where d.dept_name in ('Sales','Development')
Order by e.last_name, e.first_name;


-- Question 8, Employee Last Name Count
select e.last_name, 
count(e.last_name)
from employees e
Group By e.last_name
Order by e.last_name desc;

