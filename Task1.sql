#1) Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?


SELECT *
FROM t_jan_kaminsky_project_SQL_primary_final;


/*
Pokud plat meziročně vzrostl nebo zůstal stejný potom ve sloupci growing bude 0 
Pokud se naopak snížil tak ve sloupci growing najdeme text: salary is lower than previous year
*/
SELECT  
	t1.payroll_year,
	t1.ib_code,
	t1.ib_name,
	t1.salary AS "salary",
	t2.salary AS "salary+1_year",
	CASE
		WHEN t1.salary - t2.salary > 0 THEN "salary is lower than previous year"
		ELSE 0
	END AS growing
FROM t_jan_kaminsky_project_SQL_primary_final t1
JOIN t_jan_kaminsky_project_SQL_primary_final t2
	ON t1.payroll_year = t2.payroll_year-1
	AND t1.ib_code = t2.ib_code
GROUP BY t1.ib_code, t1.payroll_year
;


/*
 Seřazení dat podle toho jestli mzdy klesaly a podle odvětví a roku
 */
WITH vysledek AS(
	SELECT  
		t1.payroll_year AS "year",
		t2.payroll_year AS "year+1",
		t1.ib_name AS "industry_branch",
		t1.ib_code AS "industry_branch_code",
		t1.salary AS "salary",
		t2.salary AS "salary+1_year",
		CASE
			WHEN t1.salary - t2.salary > 0 THEN "salary is lower than previous year"
			ELSE 0
		END AS growing, 
		(t1.salary - t2.salary) AS "difference"
	FROM t_jan_kaminsky_project_SQL_primary_final t1
	JOIN t_jan_kaminsky_project_SQL_primary_final t2
		ON t1.payroll_year = t2.payroll_year-1
		AND t1.ib_name = t2.ib_name
	GROUP BY t1.ib_name, t1.payroll_year
	ORDER BY t1.ib_name, t1.payroll_year)
SELECT *
FROM vysledek
ORDER BY growing DESC, industry_branch_code, year
	;
	
	