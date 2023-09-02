#3) Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

SELECT 
	t1.food_code,
	t1.food_name,
	t1.value,
	t2.value AS value_nextyear,
	AVG(ROUND(((t2.value/t1.value) - 1)*100, 2)) AS result_in_percentage
FROM t_jan_kaminsky_project_SQL_primary_final t1
JOIN t_jan_kaminsky_project_SQL_primary_final t2
	ON t1.payroll_year = t2.payroll_year-1
	AND t1.food_code = t2.food_code
GROUP BY food_code
ORDER BY result_in_percentage;


