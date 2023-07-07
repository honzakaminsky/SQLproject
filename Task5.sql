/*5) Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?*/



WITH mzdy_ceny AS(
	SELECT 
		t1.payroll_year AS "payroll_year",
		t1.salary AS "salary",
		t2.salary AS "salary+1_year",
		ROUND(((t2.salary - t1.salary)/t1.salary)*100, 2) AS "rozdil_mezd",
		AVG(t1.value) AS "cena_potravin",
		AVG(t2.value) AS "cena_potravin+1_rok",
		AVG(ROUND(((t2.value - t1.value)/ t1.value)*100, 2)) AS "rozdil_potravin"
	FROM t_jan_kaminsky_project_SQL_primary_final t1
	JOIN t_jan_kaminsky_project_SQL_primary_final t2
		ON t1.payroll_year = t2.payroll_year-1
		AND t1.food_code = t2.food_code
	WHERE t1.ib_code IS NULL
	GROUP BY t1.payroll_year),
hdp AS (
	SELECT 
		secondary1.country,
		secondary1.year AS "rok",
		secondary2.year AS "rok+1",
		secondary1.GDP_mil_dollars,
		ROUND(((secondary2.GDP_mil_dollars-secondary1.GDP_mil_dollars)/secondary1.GDP_mil_dollars *100), 2) AS procentualni_rozdil_HDP
	FROM t_jan_kaminsky_project_SQL_secondary_final secondary1
	JOIN t_jan_kaminsky_project_SQL_secondary_final secondary2
		ON secondary1.year = secondary2.year-1
		AND secondary1.country = secondary2.country
	WHERE secondary1.country = "Czech republic"
	AND secondary1.GDP_mil_dollars IS NOT NULL)	
SELECT
	m.payroll_year,
	(m.payroll_year + 1) AS "year_+1",
	#m.salary,
	#m.cena_potravin,
	m.rozdil_mezd,
	m.rozdil_potravin,
	hdp.procentualni_rozdil_HDP
FROM mzdy_ceny m
JOIN hdp
	ON m.payroll_year = hdp.rok
ORDER BY m.payroll_year;