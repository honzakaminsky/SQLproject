#4) Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

WITH vysledek AS(
	SELECT 
		t1.payroll_year AS payroll_year,
		t1.salary AS salary,
		t2.salary AS salary_nextyear,
		ROUND(((t2.salary - t1.salary)/t1.salary)*100, 2) AS rozdil_mezd,
		AVG(t1.value) AS cena_potravin,
		AVG(t2.value) AS cena_potravin_dalsi_rok,
		AVG(ROUND(((t2.value/t1.value) - 1)*100, 2)) AS rozdil_potravin
	FROM t_jan_kaminsky_project_SQL_primary_final t1
	JOIN t_jan_kaminsky_project_SQL_primary_final t2
		ON t1.payroll_year = t2.payroll_year-1
		AND t1.food_code = t2.food_code
	WHERE t1.ib_code IS NULL
	GROUP BY t1.payroll_year)
SELECT
	payroll_year,
	(payroll_year + 1) AS nextyear,
	salary,
	cena_potravin,
	(rozdil_potravin - rozdil_mezd) AS mzdyXpotraviny,
	rozdil_mezd,
	rozdil_potravin	
FROM vysledek
#ORDER BY (rozdil_mezd - rozdil_potravin) DESC
;

	
	