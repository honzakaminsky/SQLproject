CREATE OR REPLACE TABLE t_jan_kaminsky_project_SQL_primary_final AS (
	SELECT 
	cpay.payroll_year,
	cpay.ib_name,
	cpay.ib_code,
	cpay.salary,
	cpay.value_type_code,
	cp.food_code,
	cp.food_name,
	cp.value
	FROM (
	SELECT
		year(cp.date_from) AS date_from,
		round(avg(cp.value), 2) AS value,
		cpc.code AS food_code,
		cpc.name AS food_name,
		cpc.price_value AS price_value,
		cpc.price_unit AS price_unit
	FROM czechia_price cp
	LEFT JOIN czechia_price_category cpc 
		ON cp.category_code = cpc.code
	WHERE region_code IS NULL
	GROUP BY food_code, year(cp.date_from)
	) cp
	INNER JOIN (
	SELECT 
		cpay.value_type_code AS value_type_code,
		cpay.unit_code AS unit_code,
		cpay_u.name AS unit_code_name,
		round(avg(cpay.value ), 2) AS salary,
		cpay.payroll_year AS payroll_year,
		cpay.calculation_code AS calculation_code,
		cpay_c.name AS cpc_name,
		cpay.industry_branch_code AS ib_code,
		cpay_ib.name AS ib_name
	FROM czechia_payroll cpay
	LEFT JOIN czechia_payroll_calculation cpay_c 
		ON cpay.calculation_code = cpay_c.code
	LEFT JOIN czechia_payroll_industry_branch cpay_ib 
		ON cpay.industry_branch_code = cpay_ib.code 
	LEFT JOIN czechia_payroll_unit cpay_u
		ON cpay.unit_code = cpay_u.code 
	LEFT JOIN czechia_payroll_value_type cpay_vt
		ON cpay.value_type_code = cpay_vt.code
	WHERE cpay.value_type_code = 5958
	GROUP BY payroll_year, ib_code
	) cpay 
	ON cp.date_from = cpay.payroll_year);



CREATE OR REPLACE TABLE t_jan_kaminsky_project_SQL_secondary_final AS (
	SELECT c.country,
		c.capital_city, 
		e.year, 
	    round( e.GDP / 1000000, 2 ) as GDP_mil_dollars,
	    e.population,
	    e.gini
	FROM countries c 
	JOIN economies e 
	    ON c.country = e.country 
	    AND c.continent = "Europe"
	    );



