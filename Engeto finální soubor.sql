
CREATE TABLE t_pavel_kocovsky_project_SQL_primary_final AS
WITH price_avg AS (
    SELECT
        EXTRACT(YEAR FROM date_from) AS year_data,
        category_code,
        AVG(value) AS avg_price
    FROM czechia_price
    GROUP BY EXTRACT(YEAR FROM date_from), category_code
),
payroll_avg AS (
    SELECT
        payroll_year,
        industry_branch_code,
        AVG(value) AS avg_wage
    FROM czechia_payroll
    WHERE value_type_code = 5958 
      AND calculation_code = 100 
    GROUP BY payroll_year, industry_branch_code
)
SELECT
    pa.year_data AS year,
    cpc.name AS food_category,
    pa.avg_price,
    cpib.name AS industry_name,
    pya.avg_wage
FROM price_avg AS pa
JOIN payroll_avg AS pya
    ON pa.year_data = pya.payroll_year
JOIN czechia_price_category AS cpc
    ON pa.category_code = cpc.code
JOIN czechia_payroll_industry_branch AS cpib
    ON pya.industry_branch_code = cpib.code;

---

SELECT *
FROM t_pavel_kocovsky_project_sql_primary_final AS tpkf


--

CREATE TABLE t_pavel_kocovsky_project_SQL_secondary_final AS
SELECT
    e.country,
    e.year,
    e.gdp,
    e.gini,
    e.population
FROM economies AS e
JOIN countries AS c
    ON e.country = c.country
WHERE c.continent = 'Europe'
  AND e.year BETWEEN 2006 AND 2018
ORDER BY e.country, e.year;

--

WITH CalculatedData AS (
    SELECT
        year,
        industry_name,
        avg_wage,
        avg_wage - LAG(avg_wage) OVER (PARTITION BY industry_name ORDER BY year) AS diff_raw
    FROM t_pavel_kocovsky_project_SQL_primary_final
    GROUP BY year, industry_name, avg_wage
)
SELECT
    year,
    industry_name,
    ROUND(avg_wage, 0) AS avg_wage,
    ROUND(diff_raw, 0) AS wage_difference
FROM CalculatedData
WHERE diff_raw < 0
ORDER BY wage_difference ASC;    --- První otázka

--

SELECT
    year,
    food_category,
    ROUND(AVG(avg_price)::numeric, 2) AS price,
    ROUND(AVG(avg_wage)::numeric, 0) AS avg_wage,
    ROUND((AVG(avg_wage) / AVG(avg_price))::numeric, 0) AS units_to_buy
FROM t_pavel_kocovsky_project_SQL_primary_final
WHERE food_category IN ('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
  AND year IN (2006, 2018)
GROUP BY year, food_category
ORDER BY food_category, year;   --- druhá otázka

--

WITH price_growth AS (
    SELECT
        year,
        food_category,
        avg_price,
        LAG(avg_price) OVER (PARTITION BY food_category ORDER BY year) AS prev_year_price
    FROM t_pavel_kocovsky_project_SQL_primary_final
    GROUP BY year, food_category, avg_price
)
SELECT
    food_category,
    ROUND(AVG((avg_price - prev_year_price) / prev_year_price * 100)::numeric, 2) AS avg_yearly_growth_pct
FROM price_growth
WHERE prev_year_price IS NOT NULL
GROUP BY food_category
ORDER BY avg_yearly_growth_pct ASC
LIMIT 1;   -- třetí otázka

--

WITH yearly_stats AS (
    SELECT
        year,
        AVG(avg_price) AS global_price,
        AVG(avg_wage) AS global_wage
    FROM t_pavel_kocovsky_project_SQL_primary_final
    GROUP BY year
),
growth_calc AS (
    SELECT
        year,
        (global_price - LAG(global_price) OVER (ORDER BY year)) / LAG(global_price) OVER (ORDER BY year) * 100 AS price_growth,
        (global_wage - LAG(global_wage) OVER (ORDER BY year)) / LAG(global_wage) OVER (ORDER BY year) * 100 AS wage_growth
    FROM yearly_stats
)
SELECT
    year,
    ROUND(price_growth::numeric, 2) AS price_growth_pct,
    ROUND(wage_growth::numeric, 2) AS wage_growth_pct,
    ROUND((price_growth - wage_growth)::numeric, 2) AS difference_pct
FROM growth_calc
WHERE (price_growth - wage_growth) > 10; --- Čtvrtá otázka

--


WITH czech_stats AS (
    SELECT
        year,
        AVG(avg_price) AS global_price,
        AVG(avg_wage) AS global_wage
    FROM t_pavel_kocovsky_project_SQL_primary_final
    GROUP BY year
),
growth_calc AS (
    SELECT
        cs.year,
        ROUND( ((sec.gdp - LAG(sec.gdp) OVER (ORDER BY sec.year)) / LAG(sec.gdp) OVER (ORDER BY sec.year) * 100)::numeric, 2) AS gdp_growth,
        ROUND( ((cs.global_price - LAG(cs.global_price) OVER (ORDER BY cs.year)) / LAG(cs.global_price) OVER (ORDER BY cs.year) * 100)::numeric, 2) AS price_growth,
        ROUND( ((cs.global_wage - LAG(cs.global_wage) OVER (ORDER BY cs.year)) / LAG(cs.global_wage) OVER (ORDER BY cs.year) * 100)::numeric, 2) AS wage_growth
    FROM czech_stats AS cs
    JOIN t_pavel_kocovsky_project_SQL_secondary_final AS sec
        ON cs.year = sec.year
    WHERE sec.country = 'Czech Republic'
)
SELECT *
FROM growth_calc
ORDER BY year;  --- pátá otázka





