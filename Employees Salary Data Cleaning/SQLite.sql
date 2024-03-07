SELECT * FROM companies;
SELECT * FROM employees;
SELECT * FROM functions;
SELECT * FROM salaries;

 
 
CREATE TABLE emp_dataset AS
SELECT *
FROM salaries
 LEFT JOIN companies
 ON salaries.comp_name = companies.company_name
 LEFT JOIN functions
 ON salaries.func_code = functions.function_code
 LEFT JOIN employees
 ON salaries.employee_id = employees.employee_code_emp
 
 
 drop table df_employee
 CREATE TABLE df_employee AS
SELECT CONCAT(employee_id, strftime('%Y-%m-%d', datetime(substr(DATE, 7, 4) || '-' || substr(DATE, 1, 2) || '-' || substr(DATE, 4, 2) || ' ' || substr(DATE, 12, 5)))) AS id,
       strftime('%Y-%m-%d', datetime(substr(DATE, 7, 4) || '-' || substr(DATE, 1, 2) || '-' || substr(DATE, 4, 2) || ' ' || substr(DATE, 12, 5))) as month_year,
       employee_id, 
       employee_name, 
		[GEN(M_F)],
		age,
       salary,
       function_group, 
       company_name, 
       company_city, 
       company_state, 
       company_type, 
       const_site_category
FROM emp_dataset
 select * from df_employee
 
 
 
 ALTER TABLE df_employee RENAME COLUMN [GEN(M_F)] TO gender;
 
 
 
UPDATE df_employee
SET  id = TRIM(id),
  employee_id = TRIM(employee_id),
  employee_name = TRIM(employee_name),
  gender = TRIM(gender),
  function_group = TRIM(function_group),
  company_name = TRIM(company_name),
  company_city = TRIM(company_city),
  company_state = TRIM(company_state),
  company_type = TRIM(company_type),
  const_site_category = TRIM(const_site_category)
 
 
 SELECT count(*)
 FROM df_employee
 WHERE id IS NULL
 OR month_year IS NULL
 OR employee_id IS NULL
 OR employee_name IS NULL
 OR gender IS NULL
 OR age IS NULL
 OR salary IS NULL
 OR function_group IS NULL
 OR company_name IS NULL
 OR company_city IS NULL
 OR company_state IS NULL
 OR company_type IS NULL
 OR const_site_category IS NULL
 
 
 
 SELECT 
    COUNT(CASE WHEN id = '' THEN 1 END) AS id,
    COUNT(CASE WHEN month_year = '' THEN 1 END) AS month_year,
    COUNT(CASE WHEN employee_id = '' THEN 1 END) AS employee_id,
    COUNT(CASE WHEN employee_name = '' THEN 1 END) AS employee_name,
    COUNT(CASE WHEN gender = '' THEN 1 END) AS gender,
    COUNT(CASE WHEN age = '' THEN 1 END) AS age,
    COUNT(CASE WHEN salary = '' THEN 1 END) AS salary,
    COUNT(CASE WHEN function_group = '' THEN 1 END) AS function_group,
    COUNT(CASE WHEN company_name = '' THEN 1 END) AS company_name,
    COUNT(CASE WHEN company_city = '' THEN 1 END) AS company_city,
    COUNT(CASE WHEN company_state = '' THEN 1 END) AS company_state,
    COUNT(CASE WHEN company_type = '' THEN 1 END) AS company_type,
	COUNT(CASE WHEN const_site_category = '' THEN 1 END) AS const_site_category
from df_employee
 
 
 -- salary

DELETE FROM df_employee
WHERE salary = ''

-- const_site_category


DELETE FROM df_employee
WHERE const_site_category = ''
 
 
 SELECT DISTINCT id
FROM df_employee
GROUP BY id
 
 ALTER TABLE df_employee drop column pay_month
 ALTER TABLE df_employee
ADD COLUMN pay_month text;
UPDATE df_employee
SET pay_month = substr(month_year,1,7);


UPDATE df_employee
SET gender = CASE gender
                 WHEN 'M' THEN 'Male'
                 WHEN 'F' THEN 'Female'
                 ELSE gender
             END


SELECT DISTINCT age
FROM df_employee
GROUP BY age
ORDER BY age


SELECT DISTINCT salary,count(*)
FROM df_employee
GROUP BY salary
ORDER BY salary
-- function_group [ok]

SELECT DISTINCT function_group
FROM df_employee
GROUP BY function_group

-- company_name [ok]

SELECT DISTINCT company_name
FROM df_employee
GROUP BY company_name
ORDER BY company_name

DELETE FROM df_employee
WHERE salary = 1000000



-- company_city [correct typing]

UPDATE df_employee
SET company_city = 'Goiania'
WHERE company_city = 'Goianiaa'

-- company_state [correct upper case to proper case]

UPDATE df_employee
SET company_state = 'Goias'
WHERE company_state = 'GOIAS'

-- company_type [correct typing]

UPDATE df_employee
SET company_type = 'Construction Site'
WHERE company_type = 'Construction Sites'

-- const_site_category [correct typing]

UPDATE df_employee
SET const_site_category = 'Commercial'
WHERE const_site_category = 'Commerciall'


 SELECT DISTINCT id ,COUNT(id) as duplicated
FROM df_employee
GROUP BY id
HAVING COUNT(id) > 1


DELETE FROM df_employee
WHERE ROWID IN (
    SELECT ROWID
    FROM (
        SELECT ROWID,
               ROW_NUMBER() OVER (PARTITION BY pay_month, employee_id ORDER BY ROWID) AS rn
        FROM df_employee
    ) AS sub
    WHERE rn > 1
);



SELECT * FROM df_employee

  
  select * from emp_dataset
 select * from df_employee