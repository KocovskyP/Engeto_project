# Engeto_project
## Informace o výstupních datech (Metadata)

Tato sekce popisuje strukturu a charakteristiky dat obsažených ve finálních tabulkách v databázi.

### 1. Rozsah a časové období dat

* **Pokryté období:** Finální tabulky jsou sloučeny a filtrovány tak, aby obsahovaly pouze **společné roky 2006 až 2018** (primární tabulka) a k nim příslušná data z HDP.
* **Měnové jednotky (ČR):** Údaje o mzdách (`avg_salary`) a cenách (`avg_price`) jsou v **Českých korunách (Kč)**.
* **Měnové jednotky (Sekundární tabulka):** HDP (`gdp`) je uvedeno v **miliardách amerických dolarů** (USD).

### 2. Tabulka: `t_jméno_příjmení_project_SQL_primary_final`
(Primární data o mzdách a cenách v ČR)

| Sloupec | Typ dat | Popis | Poznámky / Anomálie |
| :--- | :--- | :--- | :--- |
| `payroll_year` | INT | Rok, ke kterému se údaj vztahuje. | Slouží k výpočtu meziročního růstu. |
| `industry_branch` | VARCHAR | Název odvětví. | Sloupec `avg_salary` je průměrná mzda za **celý rok**. |
| `avg_salary` | DECIMAL | Průměrná mzda v daném odvětví. | |
| `commodity_name` | VARCHAR | Název komodity (např. Cukr, Mléko). | |
| `avg_price` | DECIMAL | Průměrná cena komodity za rok a jednotku. | |
| `price_unit` | VARCHAR | Měrná jednotka (např. kg, litr). | |

#### 2.1 Omezení / Chybějící data (NULL)
* ** V některých datech chyběla hodnota, například v rogion_code se čato objevovala hodnota NULL

### 3. Tabulka: `t_jméno_příjmení_project_SQL_secondary_final`
(Data pro korelaci s HDP)

| Sloupec | Typ dat | Popis |
| :--- | :--- | :--- |
| `year` | INT | Rok, ke kterému se údaj vztahuje. |
| `country` | VARCHAR | Název země (pro kontext). |
| `gdp` | DECIMAL | Hrubý domácí produkt (HDP). |
