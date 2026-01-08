# Engeto_project
### **Informace o výstupních datech**

Pro zodpovězení výzkumných otázek byly vytvořeny dvě finální tabulky pomocí příkazu CREATE TABLE AS SELECT. Tyto tabulky sjednocují data z několika zdrojových tabulek (czechia_price, czechia_payroll, t_economies).

#### **1. Hlavní tabulka: t_pavel_kocovsky_project_SQL_primary_final**
Tato tabulka obsahuje sjednocená data o mzdách a cenách potravin pro Českou republiku.
* **Časový rámec:** 2006–2018.
* **Datová kvalita a chybějící hodnoty:**
    * V původní sadě (czechia_payroll) chyběla data u některých specifických regionů nebo byla pro určité kvartály neúplná. 
    * Data o cenách potravin (czechia_price) rovněž neobsahovala záznamy pro všechny kategorie v každém týdnu měření.

#### **2. Sekundární tabulka: t_pavel_kocovsky_project_SQL_secondary_final**
Obsahuje makroekonomická data pro porovnání s HDP.
* **Zpracování:** Data byla napojena z tabulky economies a filtrována pouze na relevantní roky (2006–2018), aby odpovídala primární tabulce.

* # Report prodeje: Fiktivní obchod s elektronikou

Pro vizualizaci dat jsem si vybral **fiktivní obchod s elektronikou**. Snažil jsem se klást důraz na **jednoduchost dostupných dat**, aby nebylo náročné se v reportu pohybovat a data byla jasná na první dobrou. 

### Interaktivita a ovládání
Pro filtrování jsem zvolil **průřezy v horní stránce projektu** a také **navigaci po stránkách** (pravý horní roh)

### Klíčové ukazatele (KPI)
* **Hlavní ukazatele:** Jsou umístěny v levé části
* **Časový kontext:** Pod každým KPI je malý graf znázorňující danou hodnotu v čase. Bez tohoto zobrazení by samotná hodnota nebyla dobře porovnatelná.

### Struktura stránek
1. **První stránka:** Celkový přehled a výkonnostní metriky.
2. **Druhá stránka:** Obsahuje stejné KPI, ale s možností filtrovat podle konkrétních **zákazníků**.

