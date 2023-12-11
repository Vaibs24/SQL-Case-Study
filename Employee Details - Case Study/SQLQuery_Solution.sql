---Simple Queries:
--1. List all the employee details.

SELECT * FROM EMPLOYEE

--2. List all the department details.

SELECT * FROM DEPARTMENT

--3. List all job details.

SELECT * FROM JOB

--4. List all the locations.

SELECT * FROM LOCATION

--5. List out the First Name, Last Name, Salary, Commission for all Employees.

SELECT FIRST_NAME, LAST_NAME, SALARY, COMM FROM EMPLOYEE

--6. List out the Employee ID, Last Name, Department ID for all employees and alias Employee ID as "ID of the Employee", 
--Last Name as "Name of the Employee", Department ID as "Dep_id".

SELECT EMPLOYEE_ID AS 'ID of the Employee', LAST_NAME AS 'Name of the Employee', DEPARTMENT_ID AS Dep_id FROM EMPLOYEE

--7. List out the annual salary of the employees with their names only.

SELECT FIRST_NAME, SALARY FROM EMPLOYEE

--WHERE Condition:
--1. List the details about "Smith".

SELECT * FROM EMPLOYEE
WHERE FIRST_NAME = 'Smith' OR LAST_NAME = 'Smith'

--2. List out the employees who are working in department 20.

SELECT * FROM EMPLOYEE
WHERE DEPARTMENT_ID = 20

--3. List out the employees who are earning salaries between 3000 and4500.

SELECT * FROM EMPLOYEE
WHERE SALARY BETWEEN 3000 AND 4500

--4. List out the employees who are working in department 10 or 20.

SELECT * FROM EMPLOYEE
WHERE DEPARTMENT_ID IN (10, 20)

--5. Find out the employees who are not working in department 10 or 30.

SELECT * FROM EMPLOYEE
WHERE DEPARTMENT_ID NOT IN (10, 30)

--6. List out the employees whose name starts with 'S'.

SELECT * FROM EMPLOYEE
WHERE FIRST_NAME LIKE 'S%'

--7. List out the employees whose name starts with 'S' and ends with 'H'.

SELECT * FROM EMPLOYEE
WHERE FIRST_NAME LIKE 'S%H'

--8. List out the employees whose name length is 4 and start with 'S'.

SELECT * FROM EMPLOYEE
WHERE FIRST_NAME LIKE 'S%' AND FIRST_NAME = 4


--9. List out employees who are working in department 10 and draw salaries more than 3500.

SELECT * FROM EMPLOYEE
WHERE DEPARTMENT_ID = 10  AND SALARY > 3500

--10. List out the employees who are not receiving commission

SELECT * FROM EMPLOYEE
WHERE COMM IS NULL


--ORDER BY Clause:
--1. List out the Employee ID and Last Name in ascending order based on the Employee ID.

SELECT EMPLOYEE_ID, LAST_NAME FROM EMPLOYEE
ORDER BY EMPLOYEE_ID ASC

--2. List out the Employee ID and Name in descending order based on salary.

SELECT EMPLOYEE_ID, LAST_NAME FROM EMPLOYEE
ORDER BY SALARY DESC

--3. List out the employee details according to their Last Name in ascending-order.

SELECT * FROM EMPLOYEE
ORDER BY LAST_NAME ASC

--4. List out the employee details according to their Last Name in ascending order and then Department ID in descending order.

SELECT * FROM EMPLOYEE
ORDER BY LAST_NAME ASC, DEPARTMENT_ID DESC

--GROUP BY and HAVING Clause:
--1. How many employees are in different departments in the organization?

SELECT DEPARTMENT_ID, COUNT(*) FROM EMPLOYEE
GROUP BY DEPARTMENT_ID

--2. List out the department wise maximum salary, minimum salary and average salary of the employees.

SELECT DEPARTMENT_ID, MAX(SALARY) MAX_SALARY, MIN(SALARY) MIN_SALARY, AVG(SALARY) AVG_SALARY FROM EMPLOYEE
GROUP BY DEPARTMENT_ID

--3. List out the job wise maximum salary, minimum salary and average salary of the employees.

SELECT JOB_ID, MAX(SALARY) MAX_SALARY, MIN(SALARY) MIN_SALARY, AVG(SALARY) AVG_SALARY FROM EMPLOYEE
GROUP BY JOB_ID

--4. List out the number of employees who joined each month in ascending order.

SELECT MONTH(HIRE_DATE) AS MONTH, COUNT(*) NO_EMP FROM EMPLOYEE
GROUP BY MONTH(HIRE_DATE)
ORDER BY MONTH(HIRE_DATE)


--5. List out the number of employees for each month and year in ascending order based on the year and month.

SELECT YEAR(HIRE_DATE) YEAR, MONTH(HIRE_DATE) AS MONTH, COUNT(*) NO_EMP FROM EMPLOYEE
GROUP BY MONTH(HIRE_DATE),YEAR(HIRE_DATE)
ORDER BY MONTH(HIRE_DATE),YEAR(HIRE_DATE)

--6. List out the Department ID having at least four employees.

SELECT DEPARTMENT_ID, COUNT(*) FROM EMPLOYEE
GROUP BY DEPARTMENT_ID
HAVING COUNT(*) > 4

--7. How many employees joined in the month of January?

SELECT COUNT(*) FROM EMPLOYEE
WHERE MONTH(HIRE_DATE) = 1

--8. How many employees joined in the month of January or September?

SELECT COUNT(*) FROM EMPLOYEE
WHERE MONTH(HIRE_DATE) IN (1,9)

--9. How many employees joined in 1985?

SELECT COUNT(*) FROM EMPLOYEE
WHERE YEAR(HIRE_DATE) = 1985

--10. How many employees joined each month in 1985?

SELECT MONTH(HIRE_DATE), COUNT(*) FROM EMPLOYEE
WHERE YEAR(HIRE_DATE) = 1985
GROUP BY MONTH(HIRE_DATE)

--11. How many employees joined in March 1985?

SELECT COUNT(*) FROM EMPLOYEE
WHERE YEAR(HIRE_DATE) = 1985 AND MONTH(HIRE_DATE) = 3

--12. Which is the Department ID having greater than or equal to 3 employees joining in April 1985?

SELECT DEPARTMENT_ID, COUNT(*) FROM EMPLOYEE
WHERE YEAR(HIRE_DATE) = 1985 AND MONTH(HIRE_DATE) = 3
GROUP BY DEPARTMENT_ID
HAVING COUNT(*) > 2

--Joins:
--1. List out employees with their department names.

SELECT E.FIRST_NAME, D.NAME FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID

--2. Display employees with their designations.

SELECT E.FIRST_NAME, J.DESIGNATION FROM EMPLOYEE E
JOIN JOB J ON E.JOB_ID = J.JOB_ID

--3. Display the employees with their department names and regional groups.

SELECT E.FIRST_NAME, D.NAME, L.CITY FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
JOIN LOCATION L ON L.LOCATION_ID = D.LOCATION_ID


--4. How many employees are working in different departments? Display with department names.

SELECT D.NAME, COUNT(*) FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY D.NAME

--5. How many employees are working in the sales department?

SELECT COUNT(*) FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE D.NAME = 'SALES'

--6. Which is the department having greater than or equal to 5 employees? Display the department names in ascending order.

SELECT D.NAME, COUNT(*) FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY D.NAME
HAVING COUNT(*)>4

--7. How many jobs are there in the organization? Display with designations.

SELECT J.DESIGNATION, COUNT(*) FROM EMPLOYEE E
JOIN JOB J ON E.JOB_ID = J.JOB_ID
GROUP BY J.DESIGNATION

--8. How many employees are working in "New York"?

SELECT COUNT(*) FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
JOIN LOCATION L ON L.LOCATION_ID = D.LOCATION_ID
WHERE L.CITY = 'New York'

--9. Display the employee details with salary grades. Use conditional statement to create a grade column.

SELECT *, 
(CASE WHEN SALARY <= 1000 THEN 1
WHEN SALARY > 1000 AND SALARY < 2000 THEN 2
ELSE 3
END) AS GRADE FROM EMPLOYEE

--10. List out the number of employees grade wise. Use conditional statementto create a grade column.

SELECT *, 
(CASE WHEN SALARY <= 1000 THEN 1
WHEN SALARY > 1000 AND SALARY < 2000 THEN 2
ELSE 3
END) AS GRADE FROM EMPLOYEE
ORDER BY GRADE

--11. Display the employee salary grades and the number of employees between 2000 to 5000 range of salary.

SELECT *, 
(CASE WHEN SALARY <= 1000 THEN 1
WHEN SALARY > 1000 AND SALARY < 2000 THEN 2
ELSE 3
END) AS GRADE FROM EMPLOYEE
WHERE SALARY BETWEEN 2000 AND 5000
ORDER BY GRADE


--12. Display all employees in sales or operation departments. 

SELECT * FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE D.NAME IN ('SALES', 'OPERATIONS')

--SET Operators:
--1. List out the distinct jobs in sales and accounting departments.

SELECT DISTINCT J.DESIGNATION FROM JOB J
JOIN EMPLOYEE E ON J.JOB_ID = E.JOB_ID
JOIN DEPARTMENT D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE D.NAME IN ('SALES', 'ACCOUNTING')

--2. List out all the jobs in sales and accounting departments.

SELECT J.DESIGNATION FROM JOB J
JOIN EMPLOYEE E ON J.JOB_ID = E.JOB_ID
JOIN DEPARTMENT D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE D.NAME IN ('SALES', 'ACCOUNTING')

--3. List out the common jobs in research and accounting--departments in ascending order.

SELECT J.DESIGNATION FROM JOB J
JOIN EMPLOYEE E ON J.JOB_ID = E.JOB_ID
JOIN DEPARTMENT D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE D.NAME = 'RESEARCH' AND J.DESIGNATION IN (
SELECT J.DESIGNATION FROM JOB J
JOIN EMPLOYEE E ON J.JOB_ID = E.JOB_ID
JOIN DEPARTMENT D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE D.NAME = 'accounting')

--Subqueries:
--1. Display the employees list who got the maximum salary.

SELECT * FROM EMPLOYEE
WHERE SALARY = (SELECT MAX(SALARY) FROM EMPLOYEE)

--2. Display the employees who are working in the sales department.

SELECT * FROM EMPLOYEE
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM DEPARTMENT WHERE NAME = 'SALES')

--3. Display the employees who are working as 'Clerk'.

SELECT * FROM EMPLOYEE
WHERE JOB_ID = (SELECT JOB_ID FROM JOB WHERE DESIGNATION = 'CLERK') 

--4. Display the list of employees who are living in "New York".

SELECT * FROM EMPLOYEE
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM DEPARTMENT WHERE LOCATION_ID = (SELECT LOCATION_ID FROM LOCATION WHERE CITY = 'NEW YORK'))

--5. Find out the number of employees working in the sales department.

SELECT COUNT(*) FROM EMPLOYEE
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM DEPARTMENT WHERE NAME = 'SALES')

--6. Update the salaries of employees who are working as clerks on the basis of 10%.

UPDATE EMPLOYEE
SET SALARY = (SELECT SALARY + SALARY*0.1 FROM EMPLOYEE WHERE JOB_ID = (SELECT JOB_ID FROM JOB WHERE DESIGNATION = 'CLERK'))
WHERE JOB_ID = (SELECT JOB_ID FROM JOB WHERE DESIGNATION = 'CLERK') 

--7. Delete the employees who are working in the accounting department.

DELETE FROM EMPLOYEE
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM DEPARTMENT WHERE NAME = 'ACCOUNTING')

--8. Display the second highest salary drawing employee details.

SELECT * FROM EMPLOYEE
WHERE SALARY = (SELECT TOP 1 lead(SALARY,1) OVER(ORDER BY SALARY DESC) FROM EMPLOYEE)

--9. Display the nth highest salary drawing employee details.

ALTER PROCEDURE NTH(@N INT)
AS
BEGIN
    WITH TBL AS (
SELECT *, DENSE_RANK() OVER(ORDER BY SALARY DESC) RO FROM EMPLOYEE
)
SELECT * FROM TBL WHERE RO = @N
END;

EXEC NTH 

--10. List out the employees who earn more than every employee in department 30.

SELECT * FROM EMPLOYEE
WHERE SALARY =  (SELECT MAX(SALARY) FROM EMPLOYEE WHERE DEPARTMENT_ID = 30)

--11. List out the employees who earn more than the lowest salary in department.

WITH TBL AS (
SELECT *, DENSE_RANK() OVER(PARTITION BY DEPARTMENT_ID ORDER BY SALARY ASC) RO FROM EMPLOYEE
)
SELECT * FROM TBL WHERE RO > 1

--12. Find out which department has no employees.

SELECT NAME FROM DEPARTMENT
WHERE DEPARTMENT_ID NOT IN(SELECT DISTINCT DEPARTMENT_ID FROM EMPLOYEE)

--13. Find out the employees who earn greater than the average salary for their department.

WITH TBL AS (
SELECT *, AVG(SALARY) OVER(PARTITION BY DEPARTMENT_ID ORDER BY SALARY) AS AV FROM EMPLOYEE
)
SELECT * FROM TBL
WHERE SALARY > AV