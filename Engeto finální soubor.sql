CREATE TABLE t_pavel_kocovsky_project_SQL_primary_final AS
SELECT 
cp.id,
cp.category_code,
cp.date_from,
cp.date_to,
cp.region_code,
cp.value AS mnozstvi_nakupu,
cp2.value AS mzda_nebo_osoby, 
cp2.value_type_code,
cp2.unit_code,
cp2.calculation_code,
cp2.industry_branch_code,
cp2.payroll_year,
cp2.payroll_quarter,
cpc.name,
cpc.price_value,
cpc.price_unit,
cpc2.name AS calculation_name,
cpib."name" AS industry_name,
cpu."name" AS changer,
cpvt."name" AS average_code
FROM czechia_price AS cp 
JOIN czechia_payroll AS cp2 
ON date_part('year' , cp.date_from ) = cp2.payroll_year
JOIN czechia_price_category AS cpc 
ON cpc.code = cp.category_code
JOIN czechia_payroll_calculation AS cpc2 
ON cpc2. code = cp2.calculation_code
JOIN czechia_payroll_industry_branch AS cpib 
ON cpib.code = cp2.industry_branch_code 
JOIN czechia_payroll_unit AS cpu 
ON cpu.code = cp2.unit_code 
JOIN czechia_payroll_value_type AS cpvt 
ON cpvt.code = cp2.value_type_code;                                ----- JOIN na primární tabulku


--
CREATE TABLE  t_pavel_kocovsky_project_SQL_secondary_final AS 
SELECT 
tpk.mzda_nebo_osoby,
tpk.mnozstvi_nakupu,
tpk.payroll_year,
tpk.value_type_code,
e.country,
e."year",
e.gdp,
e.population,
e.gini,
e.taxes,
e.fertility,
e.mortaliy_under5 
FROM t_pavel_kocovsky_project_sql_primary_final AS tpk
JOIN economies AS e 
ON e."year" = tpk.payroll_year
WHERE e.country  = 'Czech Republic' AND tpk.value_type_code =5958   ---JOIN na dodatečnou tabulku
--
 
SELECT *
FROM t_pavel_kocovsky_project_sql_primary_final AS tpk;


--

SELECT 
AVG(tpk.mzda_nebo_osoby) AS avg_salary,
tpk.payroll_year,
tpk.industry_name,
tpk.industry_branch_code 
FROM t_pavel_kocovsky_project_sql_primary_final AS tpk
WHERE tpk.value_type_code = 5958    						                      --- první otázka
GROUP BY tpk.payroll_year, tpk.industry_name, tpk.industry_branch_code
ORDER BY industry_branch_code ASC; 
--

SELECT 
tpk."name", 
AVG(tpk.mzda_nebo_osoby) AS avg_salary,
tpk.mnozstvi_nakupu AS price,
tpk.price_value,
tpk.price_unit, 
tpk.date_from,
AVG(tpk.mzda_nebo_osoby)/tpk.mnozstvi_nakupu AS kolik_nakoupim
from t_pavel_kocovsky_project_sql_primary_final AS tpk
WHERE tpk.category_code = 114201 AND tpk.value_type_code = 5958
GROUP BY tpk."name",date_from, tpk.mnozstvi_nakupu,tpk.price_value,tpk.price_unit    ----- druhá otázka mléko první období
ORDER BY date_from ASC
LIMIT 1;

SELECT 
tpk."name", 
AVG(tpk.mzda_nebo_osoby) AS avg_salary,
tpk.mnozstvi_nakupu AS price,
tpk.price_value,
tpk.price_unit, 
tpk.date_to, 
AVG(tpk.mzda_nebo_osoby)/tpk.mnozstvi_nakupu AS kolik_nakoupim
from t_pavel_kocovsky_project_sql_primary_final AS tpk
WHERE tpk.category_code = 114201 AND tpk.value_type_code = 5958
GROUP BY tpk."name",date_to,tpk.mnozstvi_nakupu,tpk.price_value,tpk.price_unit    ----- druhá otázka mléko poslední období
ORDER BY date_to desc
LIMIT 1;

SELECT 
tpk."name", 
AVG(tpk.mzda_nebo_osoby) AS avg_salary,
tpk.mnozstvi_nakupu AS price,
tpk.price_value,
tpk.price_unit, 
tpk.date_from,
AVG(tpk.mzda_nebo_osoby)/tpk.mnozstvi_nakupu AS kolik_nakoupim
from t_pavel_kocovsky_project_sql_primary_final AS tpk
WHERE tpk.category_code = 111301 AND tpk.value_type_code = 5958
GROUP BY tpk."name",date_from, tpk.mnozstvi_nakupu,tpk.price_value,tpk.price_unit    ----- druhá otázka chleba první období
ORDER BY date_from ASC
LIMIT 1;

SELECT 
tpk."name", 
AVG(tpk.mzda_nebo_osoby) AS avg_salary,
tpk.mnozstvi_nakupu AS price,
tpk.price_value,
tpk.price_unit, 
tpk.date_to, 
AVG(tpk.mzda_nebo_osoby)/tpk.mnozstvi_nakupu AS kolik_nakoupim
from t_pavel_kocovsky_project_sql_primary_final AS tpk
WHERE tpk.category_code = 111301 AND tpk.value_type_code = 5958
GROUP BY tpk."name",date_to,tpk.mnozstvi_nakupu,tpk.price_value,tpk.price_unit    ----- druhá otázka chleba poslední období
ORDER BY date_to desc
LIMIT 1

---

SELECT 
tpk."name",
AVG(tpk.mnozstvi_nakupu ) AS avg_price_year,
tpk.payroll_year
FROM t_pavel_kocovsky_project_sql_primary_final AS tpk
GROUP BY payroll_year, "name"  
ORDER BY "name" ASC;                                         ---------Třetí otázka

--- 

SELECT
AVG(tpk.mzda_nebo_osoby) AS avg_salary,
AVG(tpk.mnozstvi_nakupu ) AS avg_price_year,
tpk.payroll_year
FROM t_pavel_kocovsky_project_sql_primary_final AS tpk  ---- čtvrtá otázka
WHERE tpk.value_type_code = 5958
GROUP BY tpk.payroll_year   
ORDER BY payroll_year  ASC;



---

SELECT
AVG(tpk2.mzda_nebo_osoby) AS avg_salary,
AVG(tpk2.mnozstvi_nakupu ) AS avg_price_year,
tpk2.payroll_year,
tpk2.gdp 
FROM t_pavel_kocovsky_project_sql_secondary_final AS tpk2  ---- pátá otázka
WHERE tpk2.value_type_code = 5958
GROUP BY tpk2.payroll_year , tpk2.gdp 
ORDER BY tpk2.payroll_year   ASC;