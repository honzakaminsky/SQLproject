/*2) Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období 
v dostupných datech cen a mezd?*/

#mleko 114201
#chleb 111301

SELECT *
FROM (
	SELECT 
		payroll_year,
		food_code,
		food_name,
		value,
		salary,
		ROUND((salary/value), 0) AS kolik_si_koupim
	FROM t_jan_kaminsky_project_SQL_primary_final 
	WHERE food_code IN (114201, 111301)
		AND ib_code IS NULL
	GROUP BY payroll_year, food_code 
	ORDER BY payroll_year ASC 
	LIMIT 2) AS subquery1
UNION ALL
SELECT *
FROM (
	SELECT 
		payroll_year,
		food_code,
		food_name,
		value,
		salary,
		ROUND((salary/value), 0) AS kolik_si_koupim
	FROM t_jan_kaminsky_project_SQL_primary_final 
	WHERE food_code IN (114201, 111301)
		AND ib_code IS NULL
	GROUP BY payroll_year, food_code 
	ORDER BY payroll_year DESC 
	LIMIT 2) AS subquery2
;

