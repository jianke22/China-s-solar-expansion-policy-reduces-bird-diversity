*------------------------------------------------------------------------
* Import data
*------------------------------------------------------------------------
cd "/Users/zhangaixin/Library/CloudStorage/OneDrive-个人/BD/DATA"

*核心变量+控制变量
use "Bird.dta",clear
merge 1:1 id year using "BTN.dta",keepus(BT BN)
drop if _merge==2
drop _merge
merge m:1 id YEAR using "PI.dta",keepus(PI)
drop if _merge==2
drop _merge
merge m:1 id YEAR using "Climate.dta",keepus(Avt Wind)
drop if _merge==2
drop _merge
rename Avt Temp
merge m:1 id YEAR using "PD.dta",keepus(PD)
drop if _merge==2
drop _merge
merge m:1 id YEAR using "air.dta",keepus(CO2 PM)
drop if _merge==2
drop _merge
rename PM PM25
merge m:1 id YEAR using "TD.dta",keepus(Water Green Farm Grass)
drop if _merge==2
drop _merge


*稳健性
**替换PI
merge m:1 id YEAR using "PI1.dta",keepus(PI1)
drop if _merge==2
drop _merge
merge m:1 id YEAR using "PI2.dta",keepus(PI2)
drop if _merge==2
drop _merge
merge m:1 id YEAR using "PI3.dta",keepus(PI3)
drop if _merge==2
drop _merge
merge m:1 id YEAR using "PI4.dta",keepus(PI4)
drop if _merge==2
drop _merge
merge m:1 id YEAR using "PI5.dta",keepus(PI5)
drop if _merge==2
drop _merge
merge m:1 id YEAR using "PI6.dta",keepus(PI6)
drop if _merge==2
drop _merge
replace PI1 = 0 if missing(PI1)
replace PI2 = 0 if missing(PI2)
replace PI3 = 0 if missing(PI3)
replace PI4 = 0 if missing(PI4)
replace PI5 = 0 if missing(PI5)
replace PI6 = 0 if missing(PI6)
**王为伟装机规模
merge m:1 id YEAR using "IC.dta",keepus(ICtotal)
drop if _merge==2
drop _merge
replace ICtotal=0 if missing(ICtotal)
**省会城市直辖市cities
merge m:1 省 市 using "cities.dta",keepus(cities)
drop if _merge==2
drop _merge
replace cities = 0 if missing(cities)
**环保督察政策CEI
merge m:1 省 YEAR using "enin.dta",keepus(enin)
drop if _merge==2
drop _merge
rename enin CEI
**煤电厂
merge m:1 id YEAR using "Coal.dta",keepus(FFP)
drop if _merge==2
drop _merge	
gen 煤电厂=0 
replace 煤电厂=1 if FFP !=.	
rename 煤电厂 Coal
**风电扩张
merge m:1 id YEAR using "Windexp.dta",keepus(风电数量)
drop if _merge==2
drop _merge	
gen 风电扩张=0 
replace 风电扩张=1 if 风电数量 !=0	
rename 风电扩张 Windexp
**绿色金融（如果不需要导入，直接生成）
gen 绿色金融 = 0
local group1 "湖州市 衢州市 广州市 哈密市 昌吉回族自治州 克拉玛依市"
foreach city in `group1' {
    replace 绿色金融 = 1 if strpos(市, "`city'") > 0 & (YEAR > 2017 | (YEAR == 2017 & month >= 7))
}
*赣江新区
replace 绿色金融 = 1 if (strpos(市, "南昌市") > 0 & (strpos(县, "新建区") > 0 | strpos(县, "青山湖区") > 0)) ///
                & (YEAR > 2017 | (YEAR == 2017 & month >= 7))
replace 绿色金融 = 1 if (strpos(市, "九江市") > 0 & (strpos(县, "共青城市") > 0 | strpos(县, "永修县") > 0)) ///
                & (YEAR > 2017 | (YEAR == 2017 & month >= 7))
*贵安新区
replace 绿色金融 = 1 if (strpos(市, "贵阳市") > 0) ///
                & (YEAR > 2017 | (YEAR == 2017 & month >= 7))
replace 绿色金融 = 1 if (strpos(市, "安顺市") > 0 & strpos(县, "平坝区") > 0) ///
                & (YEAR > 2017 | (YEAR == 2017 & month >= 7))
* 兰州新区
replace 绿色金融 = 1 if (strpos(市, "兰州市") > 0 & (strpos(县, "皋兰县") > 0 | strpos(县, "永登县") > 0)) ///
                & (YEAR > 2019 | (YEAR == 2019 & month >= 12))
* 重庆市
replace 绿色金融 = 1 if strpos(市, "重庆市") > 0 ///
                & (YEAR > 2022 | (YEAR == 2022 & month >= 9))
rename 绿色金融 Greenfin
**IV 
***sun算术平均1984-2013
merge m:1 id YEAR using "sunshine.dta",keepus(sun)
drop if _merge==2
drop _merge
***地级市CPU
merge m:1 市 YEAR using "CCPU.dta",keepus(CCPU)
drop if _merge==2
drop _merge
gen Sun_ccpu = ln(sun) / CCPU
**高PI县相邻县
merge m:1 id using "highPI.dta",keepus(is_neighbor_of_highPI)
drop if _merge==2
drop _merge
replace is_neighbor_of_highPI=0 if missing(is_neighbor_of_highPI)


*异质性
**贫困县poverty_county、三北地区north_region、低碳试点low_carbon_city
merge m:1 县 using "poverty.dta",keepus(poverty_county)
drop if _merge==2
drop _merge
replace poverty_county = 0 if missing(poverty_county)
merge m:1 省 using "north_region.dta",keepus(north_region)
drop if _merge==2
drop _merge
replace north_region = 0 if missing(north_region)
merge m:1 id using "Gebi.dta",keepus(desert_gobi)
drop if _merge==2
drop _merge
**候鸟Migratory、留鸟Resident+特有物种Endemic、非特有物种non_Endemic+国家保护Protected、非国家保护non_Protected
merge 1:1 id year using "Migratory.dta", keepus(Migratory)
drop if _merge==2
drop _merge
merge 1:1 id year using "Resident.dta", keepus(Resident)
drop if _merge==2
drop _merge
merge 1:1 id year using "Endemic.dta", keepus(Endemic)
drop if _merge==2
drop _merge
merge 1:1 id year using "non_Endemic.dta", keepus(non_Endemic)
drop if _merge==2
drop _merge
merge 1:1 id year using "Protected.dta", keepus(Protected)
drop if _merge==2
drop _merge
merge 1:1 id year using "non_Protected.dta", keepus(non_Protected)
drop if _merge==2
drop _merge
**植物筑巢Nest_veg、水上筑巢Land_water+食肉杂食non_herbivorous、食草Herbivorous+小群落Small_flock、大群落Large_flock
merge 1:1 id year using "Nest_veg.dta", keepus(Nest_veg)
drop if _merge==2
drop _merge
merge 1:1 id year using "Land_water.dta", keepus(Land_water)
drop if _merge==2
drop _merge
merge 1:1 id year using "non_Herbivorous.dta", keepus(non_Herbivorous)
drop if _merge==2
drop _merge
merge 1:1 id year using "Herbivorous.dta", keepus(Herbivorous)
drop if _merge==2
drop _merge
merge 1:1 id year using "Small_flock.dta", keepus(Small_flock)
drop if _merge==2
drop _merge
merge 1:1 id year using "Large_flock.dta", keepus(Large_flock)
drop if _merge==2
drop _merge


*机制
merge m:1 id YEAR using "Ndvi.dta",keepus(Ndvi)
drop if _merge==2
drop _merge
replace Ndvi = Ndvi*100
merge m:1 id YEAR using "NL.dta",keepus(Nightlight)
drop if _merge==2
drop _merge
merge m:1 id YEAR using "LAI.dta",keepus(LAI)
drop if _merge==2
drop _merge


*经济后果
**丰富度与均匀度
merge 1:1 id year using "Richeven.dta",keepus(丰富度)
drop if _merge==2
drop _merge
gen 均匀度 = ShannonBD/ln(丰富度)
rename 丰富度 Richness
rename 均匀度 Evenness
**农作物产量
merge m:1 id YEAR using "AP.dta",keepus(APtotal)
drop if _merge==2
drop _merge


*数据预处理
**生成人均观鸟时长
gen BTN=BT/BN
**PI缺失值替换为0
replace PI = 0 if missing(PI)
**剔除控制变量存在缺失的样本
drop if missing(Temp, Wind, PD, BTN, CO2, Water, Green, Farm, Grass)
**王为伟老师装机规模换算成面积
gen Area = ICtotal*1000/0.15
replace Area = Area / 1000000
label var Area "集中式光伏电站面积平方千米"
**取对数
gen Pop=ln(PD)
gen Duration=ln(BTN+1)
gen Carbon=ln(CO2)
gen PM=ln(PM25)
gen Output = ln(APtotal) 

**所有连续变量缩尾
local var "ShannonBD SimpsonBD PI Temp Wind Pop Duration Carbon Water Green Farm Grass PM ICtotal Area Ndvi Nightlight LAI PI1 PI2 PI3 PI4 PI5 PI6 Migratory Resident Endemic non_Endemic Protected non_Protected Nest_veg Land_water non_Herbivorous Herbivorous Small_flock Large_flock Richness Evenness Output Sun_ccpu"
winsor2 `var', cuts(1 99) replace
**生成county
egen county = group(id)



cd "/Users/zhangaixin/Library/CloudStorage/OneDrive-个人/BD/Documents"
*------------------------------------------------------------------------
* Descriptive statistics
*------------------------------------------------------------------------
preserve
local var "ShannonBD SimpsonBD PI Temp Wind Pop Duration Carbon Water Green Farm Grass Sun_ccpu"
estpost tabstat `var', stats(count mean sd min max) c(s) 
eststo stats
esttab  stats using sum_stats.rtf, replace title("Table S4. Descriptive statistics.") ///
	cells("count(fmt(%9.0fc) label(N)) mean(fmt(%9.4fc) label(Mean)) sd(fmt(%9.4fc) label(S.D.)) min(fmt(%9.4fc) label(Min)) max(fmt(%9.4fc) label(Max))") ///
	nomtitle nonumber noobs 
restore



*------------------------------------------------------------------------
* Pearson Correlation Matrix
*------------------------------------------------------------------------
preserve
estpost correlate ShannonBD PI Temp Wind Pop Duration Carbon Water Green Farm Grass, matrix listwise
eststo corr
esttab corr using sum_stats.rtf, append title("Table S4. Pearson Correlation Matrix.") ///
	star(* 0.1 ** 0.05 *** 0.01) b(%6.2f) ///
	nomtitle nonumber noobs unstack compress nonotes not ///
	note("Notes: Panel A shows the descriptive statistics for the key variables covering the period from 2014 to 2023. ShannonBD refers to the bird biodiversity in the sample area (the negative sum of the proportion of each bird species multiplied by its natural logarithm). SimpsonBD refers to the Simpson Diversity Index, an alternative measure of bird biodiversity in the sample area (one minus the sum of the squared proportions of each bird species in the community). PI refers to the intensity of photovoltaic policies in the sample area (the weighted sum of policies at the provincial, municipal, and county levels). Other control variables include Temp (annual average temperature), Wind (annual average wind speed), Pop (the logarithm of the ratio of total population to regional area), Duration (the logarithm of the ratio of birdwatching duration to the number of birdwatchers), Carbon (the logarithm of the carbon emissions), Water (the area of water divided by the total area), Green (the sum of the area of forests and shrubs divided by the total area), Farm (the area of farmland divided by the total area), Grass (the area of the grassland divided by the total area). Panel B shows the correlation matrix of the main variables in this study. Each cell shows the Pearson correlation coefficient between the two variables.")
restore



*------------------------------------------------------------------------
* Baseline Regression
*------------------------------------------------------------------------
preserve
reghdfe ShannonBD PI, absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s1
reghdfe ShannonBD PI Temp Wind Pop Duration Carbon, absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s2
reghdfe ShannonBD PI Temp Wind Pop Duration Carbon Water Green Farm Grass, absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s3
esttab s1 s2 s3 using baseline.rtf, replace title("Table 1. Solar policy intensity significantly reduces bird diversity.") ///
	stats(year county N r2_a, labels("Year-month FE" "County FE" "Observations" "R-squared") fmt(0 0 0 4)) ///
	star(* 0.10 ** 0.05 *** 0.01) nonotes nocons b(4) se compress nogaps /// 
	note("Notes: This table presents the association between the bird diversity and intensity of photovoltaic policies for a sample of 2,344 counties from 2014 to 2023. The dependent variable is ShannonBD (the negative sum of the proportion of each bird species multiplied by its natural logarithm). The independent variable is PI (the weighted sum of policies at the provincial, municipal, and county levels). Other control variables include Temp (annual average temperature), Wind (annual average wind speed), Pop (the logarithm of the ratio of total population to regional area), Duration (the logarithm of the ratio of birdwatching duration to the number of birdwatchers), Carbon (the logarithm of the carbon emissions), Water (the area of water divided by the total area), Green (the sum of the area of forests and shrubs divided by the total area), Farm (the area of farmland divided by the total area), Grass (the area of the grassland divided by the total area). All specifications include county and Year-month fixed effects. The robust standard errors clustered by the county are reported in parenthesis. ***, **, * denote the significance at the 1%, 5%, and 10% levels, respectively.")
restore


 
*------------------------------------------------------------------------
* Endogeneity Treatment
*------------------------------------------------------------------------
*Instrumental variables regression 
preserve
global control "Temp Wind Pop Duration Carbon Water Green Farm Grass"
reghdfe PI Sun_ccpu $control , absorb(county year) cluster(county) //Sun_ccpu即Ln Sunshine / city CPU
estadd local year "YES"
estadd local county "YES"
est store s1
ivreghdfe ShannonBD (PI = Sun_ccpu) $control , absorb(county year) cluster(county) first
estadd local year "YES"
estadd local county "YES"
est store s2

esttab s1 s2 using IV.rtf, replace title("Table S6. Instrumental variable estimates.") ///
	stats(year county N, labels("Year-month FE" "County FE" "Observations") fmt(0 0 0)) ///
	star(* 0.10 ** 0.05 *** 0.01) nonotes nocons b(4) se compress nogaps ///
	order(Sun_ccpu PI $control) ///
	note("Notes: Column (1) shows the result of the first-stage regression. The dependent variable in Column (1) is PI (the weighted sum of policies at the provincial, municipal, and county levels). The independent variable in Column (1) is Ln Sunshine / city CPU, defined as the natural logarithm of the average sunshine duration from 1984 to 2013 divided by the city-level climate policy uncertainty index. The city-level climate policy uncertainty index is sourced from Ma, Y.-R., Liu, Z., Ma, D. et al. A news-based climate policy uncertainty index for China. Sci Data 10, 881 (2023). https://doi.org/10.1038/s41597-023-02817-5. Column (2) shows the result of the second-stage regression. The dependent variable in Column (2) is ShannonBD (the negative sum of the proportion of each bird species multiplied by its natural logarithm). The independent variable in Column (2) is PI (the weighted sum of policies at the provincial, municipal, and county levels). K-P rk LM statistic shows the result of underidentification test. K-P rk Wald F statistic shows the result of weak identification test. Other control variables include Temp (annual average temperature), Wind (annual average wind speed), Pop (the logarithm of the ratio of total population to regional area), Duration (the logarithm of the ratio of birdwatching duration to the number of birdwatchers), Carbon (the logarithm of the carbon emissions), Water (the area of water divided by the total area), Green (the sum of the area of forests and shrubs divided by the total area), Farm (the area of farmland divided by the total area), Grass (the area of the grassland divided by the total area). All specifications include county and Year-month fixed effects. The robust standard errors clustered by the county are reported in parenthesis. ***, **, * denote the significance at the 1%, 5%, and 10% levels, respectively.")
restore


*psm
preserve
global control "Temp Wind Pop Duration Carbon Water Green Farm Grass"
gen treated = (PI > 0)
**1:1 邻近匹配
psmatch2 treated $control i.year, outcome(ShannonBD) neighbor(1) caliper(0.05) common
reghdfe ShannonBD PI $control if _weight != ., absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s1
**重新匹配，1:2 邻近匹配
psmatch2 treated $control i.year, outcome(ShannonBD) neighbor(2) caliper(0.05) common
reghdfe ShannonBD PI $control if _weight != ., absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s2
**核匹配
psmatch2 treated $control i.year, outcome(ShannonBD) kernel common
reghdfe ShannonBD PI $control if _weight != ., absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s3
esttab s1 s2 s3 using psm.rtf, replace title("Table S7. Propensity score matching.") ///
	stats(year county N r2_a, labels("Year-month FE" "County FE" "Observations" "R-squared") fmt(0 0 0 4)) ///
	star(* 0.10 ** 0.05 *** 0.01) nonotes nocons b(4) se compress nogaps ///
	note("Notes: Column (1) presents the PSM results using 1:1 nearest neighbor matching with a caliper of 0.05. Column (2) reports the PSM results using 1:2 nearest neighbor matching with a caliper of 0.05. Column (3) shows the PSM results based on kernel matching. The dependent variable is ShannonBD (the negative sum of the proportion of each bird species multiplied by its natural logarithm). The independent variable is PI (the weighted sum of policies at the provincial, municipal, and county levels). Other control variables include Temp (annual average temperature), Wind (annual average wind speed), Pop (the logarithm of the ratio of total population to regional area), Duration (the logarithm of the ratio of birdwatching duration to the number of birdwatchers), Carbon (the logarithm of the carbon emissions), Water (the area of water divided by the total area), Green (the sum of the area of forests and shrubs divided by the total area), Farm (the area of farmland divided by the total area), Grass (the area of the grassland divided by the total area). All specifications include county and Year-month fixed effects. The robust standard errors clustered by the county are reported in parenthesis. ***, **, * denote the significance at the 1%, 5%, and 10% levels, respectively.")
restore	



*------------------------------------------------------------------------
* Robustness Check
*------------------------------------------------------------------------
*Alternative variables 
preserve
global control "Temp Wind Pop Duration Carbon Water Green Farm Grass"
reghdfe ShannonBD Area $control , absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s1
reghdfe ShannonBD PI1 $control , absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s2
reghdfe ShannonBD PI2 $control , absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s3
reghdfe ShannonBD PI3 $control , absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s4
reghdfe ShannonBD PI4 $control , absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s5
reghdfe ShannonBD PI5 $control , absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s6
reghdfe ShannonBD PI6 $control , absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s7
reghdfe SimpsonBD PI $control , absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s8
esttab s1 s2 s3 s4 s5 s6 s7 s8 using robust_alternative_var.rtf, replace title("Table S8. Robustness checks using alternative variable measures.") ///
	mtitles("Central PV Areas" "Weighted Score 123" "Weighted Score 124" "Weighted Score 248" "Unweighted Score 123" "Unweighted Score 124" "Unweighted Score 248" "SimpsonBD") ///
	stats(year county N r2_a, labels("Year-month FE" "County FE" "Observations" "R-squared") fmt(0 0 0 4)) ///
	star(* 0.10 ** 0.05 *** 0.01) nonotes nocons b(4) se compress nogaps ///
	order(Area PI1 PI2 PI3 PI4 PI5 PI6 PI) ///
	note("Notes: This table presents the regression results with alternative measures of key variables. The dependent variable in Columns (1)-(7) is ShannonBD (the negative sum of the proportion of each bird species multiplied by its natural logarithm). In Column (1), the core explanatory variable is replaced with Area (the area of centralized photovoltaic power stations). Column (2) replaces it with policy intensity calculated using arithmetic progression scores of 1, 2, and 3 with hierarchical weights of 0.5, 0.3, and 0.2. Column (3) replaces it with geometric progression scores of 1, 2, and 4 with hierarchical weights of 0.5, 0.3, and 0.2. Column (4) replaces it with exponential progression scores of 2, 4, and 8 with hierarchical weights of 0.5, 0.3, and 0.2. Column (5) replaces it with arithmetic progression scores of 1, 2, and 3 with equal weights of 1. Column (6) replaces it with geometric progression scores of 1, 2, and 4 with equal weights of 1. Column (7) replaces it with exponential progression scores of 2, 4, and 8 with equal weights of 1. The dependent variable in Columns (8) is SimpsonBD (one minus the sum of the squared proportions of each bird species in the community). The independent variable in Column (8) is PI (the weighted sum of policies at the provincial, municipal, and county levels). Other control variables include Temp (annual average temperature), Wind (annual average wind speed), Pop (the logarithm of the ratio of total population to regional area), Duration (the logarithm of the ratio of birdwatching duration to the number of birdwatchers), Carbon (the logarithm of the carbon emissions), Water (the area of water divided by the total area), Green (the sum of the area of forests and shrubs divided by the total area), Farm (the area of farmland divided by the total area), Grass (the area of the grassland divided by the total area). All specifications include county and Year-month fixed effects. The robust standard errors clustered by the county are reported in parenthesis. ***, **, * denote the significance at the 1%, 5%, and 10% levels, respectively.")
restore


*Sample interval adjustment
preserve
xtset county year
global control "Temp Wind Pop Duration Carbon Water Green Farm Grass"
**5%Shannon
quietly egen mean_diversity = mean(ShannonBD), by(county)
centile mean_diversity if !missing(mean_diversity), centile(5 95)
local p5 = r(c_1)   
local p95 = r(c_2)
gen to_exclude = (mean_diversity <= `p5' | mean_diversity >= `p95') if !missing(mean_diversity)
reghdfe ShannonBD PI $control if  to_exclude != 1, absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s1
**5%PI
quietly egen mean_pi = mean(PI), by(county)
centile mean_pi if !missing(mean_pi), centile(95) 
local p95 = r(c_1)
gen exclude_high_pi = (mean_pi >= `p95') if !missing(mean_pi)
reghdfe ShannonBD PI $control if  exclude_high_pi!= 1, absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s2
**Provincial capitals and municipalities
reghdfe ShannonBD PI $control if cities==0, absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s3
esttab s1 s2 s3 using robust_alternative_model.rtf, replace title("Table S9. Robustness checks using alternative sampling criteria.") ///
	stats(year county N r2_a, labels("Year-month FE" "County FE" "Observations" "R-squared") fmt(0 0 0 4)) ///
	star(* 0.10 ** 0.05 *** 0.01) nonotes nocons b(4) se compress nogaps ///
	note("Notes: This table shows the results of robustness checks using alternative sampling criteria. Column (1) excludes the top and bottom 5% of the dependent variable based on county-level averages. Column (2) removes the top 5% of the independent variable based on county-level averages. Column (3) excludes provincial capital cities and municipalities directly under the central government. The dependent variable is ShannonBD (the negative sum of the proportion of each bird species multiplied by its natural logarithm). The independent variable is PI (the weighted sum of policies at the provincial, municipal, and county levels). Other control variables include Temp (annual average temperature), Wind (annual average wind speed), Pop (the logarithm of the ratio of total population to regional area), Duration (the logarithm of the ratio of birdwatching duration to the number of birdwatchers), Carbon (the logarithm of the carbon emissions), Water (the area of water divided by the total area), Green (the sum of the area of forests and shrubs divided by the total area), Farm (the area of farmland divided by the total area), Grass (the area of the grassland divided by the total area). All specifications include county and Year-month fixed effects. The robust standard errors clustered by the county are reported in parenthesis. ***, **, * denote the significance at the 1%, 5%, and 10% levels, respectively.")
restore


*Eliminate other policy interference
**CEPI policy
preserve
global control "Temp Wind Pop Duration Carbon Water Green Farm Grass"
reghdfe ShannonBD PI $control CEI, absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s1
**煤电厂
reghdfe ShannonBD PI $control Coal, absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s2
**风电扩张
reghdfe ShannonBD PI $control Windexp, absorb(county year) cluster(county)	
estadd local year "YES"
estadd local county "YES"
est store s3	
**绿色金融
reghdfe ShannonBD PI $control Greenfin, absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s4
**全部放进来
reghdfe ShannonBD PI $control CEI Coal Windexp Greenfin, absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s5
esttab s1 s2 s3 s4 s5 using robust_eliminate_policy.rtf, replace title("Table S10. Ruling out confounding effects from related policies.") ///
	stats(year county N r2_a, labels("Year-month FE" "County FE" "Observations" "R-squared") fmt(0 0 0 4)) ///
	star(* 0.10 ** 0.05 *** 0.01) nonotes nocons b(4) se compress nogaps ///
	order(PI CEI Coal Windexp Greenfin $control) ///
	note("Notes: This table presents the regression results after excluding the interference of related policies. Column (1) controls for the central environmental inspection policy indicator CEI (equals 1 if an inspection team was stationed in the area in that year, and 0 otherwise). Column (2) controls for the coal power plant closure policy indicator Coal (equals 1 if a coal-fired power plant was closed in the area in that year, and 0 otherwise). Column (3) controls for the wind power expansion policy indicator Windexp (equals 1 if new wind power generation facilities were constructed in the area in that year, and 0 otherwise), Column (4) controls for the green finance pilot policy indicator Greenfin (equals 1 if the region was designated as a National Green Finance Reform and Innovation Pilot Zone in the current year, and 0 otherwise), and Column (5) controls for all of the above policies simultaneously. The dependent variable is ShannonBD (the negative sum of the proportion of each bird species multiplied by its natural logarithm). The independent variable is PI (the weighted sum of policies at the provincial, municipal, and county levels). Other control variables include Temp (annual average temperature), Wind (annual average wind speed), Pop (the logarithm of the ratio of total population to regional area), Duration (the logarithm of the ratio of birdwatching duration to the number of birdwatchers), Carbon (the logarithm of the carbon emissions), Water (the area of water divided by the total area), Green (the sum of the area of forests and shrubs divided by the total area), Farm (the area of farmland divided by the total area), Grass (the area of the grassland divided by the total area). All specifications include county and Year-month fixed effects. The robust standard errors clustered by the county are reported in parenthesis. ***, **, * denote the significance at the 1%, 5%, and 10% levels, respectively.")
restore


*Other robustness check
preserve
global control "Temp Wind Pop Duration Carbon Water Green Farm Grass"
**dditional control variables
reghdfe ShannonBD PI $control PM, absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s1
**剔除高PI相邻县域
reghdfe ShannonBD PI $control if is_neighbor_of_highPI==0, absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s2
/*
bysort YEAR: egen p90_PI = pctile(PI), p(90)
gen high_pi = (PI > p90_PI)
*/
**Seasonal robustness check
keep if month>=5 & month<=7
reghdfe ShannonBD PI $control, absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s3
esttab s1 s2 s3 using robust_other.rtf, replace title("Table S11. Other robustness checks.") ///
	stats(year county N r2_a, labels("Year-month FE" "County FE" "Observations" "R-squared") fmt(0 0 0 4)) ///
	star(* 0.10 ** 0.05 *** 0.01) nonotes nocons b(4) se compress nogaps ///
	note("Notes: Column (1) includes PM2.5 as an additional control variable. Column (2) excludes all counties immediately adjacent to high-PI counties. Column (3) conducts a seasonal robustness check by running the main model exclusively on data from the peak breeding season (e.g., May to July). The dependent variable is ShannonBD (the negative sum of the proportion of each bird species multiplied by its natural logarithm). The independent variable is PI (the weighted sum of policies at the provincial, municipal, and county levels). Other control variables include Temp (annual average temperature), Wind (annual average wind speed), Pop (the logarithm of the ratio of total population to regional area), Duration (the logarithm of the ratio of birdwatching duration to the number of birdwatchers), Carbon (the logarithm of the carbon emissions), Water (the area of water divided by the total area), Green (the sum of the area of forests and shrubs divided by the total area), Farm (the area of farmland divided by the total area), Grass (the area of the grassland divided by the total area). All specifications include county and Year-month fixed effects. The robust standard errors clustered by the county are reported in parenthesis. ***, **, * denote the significance at the 1%, 5%, and 10% levels, respectively.")
restore



*------------------------------------------------------------------------
* Heterogeneity Analysis1
*------------------------------------------------------------------------
preserve
global control "Temp Wind Pop Duration Carbon Water Green Farm Grass"
//bdiff, group(poverty_county) model(reghdfe ShannonBD PI $control, absorb(county year) vce(cluster county)) reps(1000) first detail seed(1234)
reghdfe ShannonBD PI $control if poverty_county==0, absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s1
reghdfe ShannonBD PI $control if poverty_county==1, absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s2
//bdiff, group(north_region) model(reghdfe ShannonBD PI $control, absorb(county year) vce(cluster county)) reps(1000) first detail seed(1234)
reghdfe ShannonBD PI $control if north_region==0, absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s3
reghdfe ShannonBD PI $control if north_region==1, absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s4
//bdiff, group(desert_gobi) model(reghdfe ShannonBD PI $control, absorb(county year) vce(cluster county)) reps(1000) first detail seed(1234)
reghdfe ShannonBD PI $control if desert_gobi==0, absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s5
reghdfe ShannonBD PI $control if desert_gobi==1, absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s6
esttab s1 s2 s3 s4 s5 s6 using heterogeneity1.rtf, replace title("Table S12. Cross-sectional heterogeneity.") ///
	mtitles("Non-poverty counties" "Poverty counties" "Non-Three-North regions" "Three-North regions" "Non-sandy and gravel desert" "Sandy and gravel desert") ///
	stats(year county N r2_a, labels("Year-month FE" "County FE" "Observations" "R-squared") fmt(0 0 0 4)) ///
	star(* 0.10 ** 0.05 *** 0.01) nonotes nocons b(4) se compress nogaps ///
	note("Notes: Specification 1 divides the sample into Non-poverty counties and poverty counties. Specification 2 divides the sample into Non-Three-North regions and Three-North regions. Specification 3 divides the sample into Non-sandy and gravel desert and sandy and gravel desert. The bdiff row reports the results of the between-group coefficient difference test. The dependent variable is ShannonBD (the negative sum of the proportion of each bird species multiplied by its natural logarithm). The independent variable is PI (the weighted sum of policies at the provincial, municipal, and county levels). Other control variables include Temp (annual average temperature), Wind (annual average wind speed), Pop (the logarithm of the ratio of total population to regional area), Duration (the logarithm of the ratio of birdwatching duration to the number of birdwatchers), Carbon (the logarithm of the carbon emissions), Water (the area of water divided by the total area), Green (the sum of the area of forests and shrubs divided by the total area), Farm (the area of farmland divided by the total area), Grass (the area of the grassland divided by the total area). All specifications include county and Year-month fixed effects. The robust standard errors clustered by the county are reported in parenthesis. ***, **, * denote the significance at the 1%, 5%, and 10% levels, respectively.")
restore



*------------------------------------------------------------------------
* Heterogeneity Analysis2
*------------------------------------------------------------------------
preserve
global control "Temp Wind Pop Duration Carbon Water Green Farm Grass"
reghdfe Endemic PI $control , absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s1
reghdfe non_Endemic PI $control , absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s2
reghdfe Migratory PI $control , absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s3
reghdfe Resident PI $control , absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s4
reghdfe Protected PI $control , absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s5
reghdfe non_Protected PI $control , absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s6
esttab s1 s2 s3 s4 s5 s6 using heterogeneity2.rtf, replace title("Table S13. Bird species heterogeneity.") ///
	mtitles("Endemic" "Non-endemic" "Migratory" "Resident" "Protected" "Non-protected") ///
	stats(year county N r2_a, labels("Year-month FE" "County FE" "Observations" "R-squared") fmt(0 0 0 4)) ///
	star(* 0.10 ** 0.05 *** 0.01) nonotes nocons b(4) se compress nogaps ///
	note("Notes: Panel A presents the results classified by endemism status, migratory status, and conservation status in sequence. Columns (1) and (2) correspond to endemic species and Non-endemic species. Columns (3) and (4) correspond to migratory birds and resident birds. Columns (5) and (6) correspond to nationally protected species and Non-protected species. Panel B presents the results classified by nesting guilds, dietary guilds, and flocking behavior in sequence. Columns (7) and (8) correspond to land or water nesters and vegetation nesters. Columns (9) and (10) correspond to carnivorous and omnivorous species and herbivores species. Columns (11) and (12) correspond to small-flock species and large-flock species. The dependent variable is ShannonBD (the negative sum of the proportion of each bird species multiplied by its natural logarithm). The independent variable is PI (the weighted sum of policies at the provincial, municipal, and county levels). Other control variables include Temp (annual average temperature), Wind (annual average wind speed), Pop (the logarithm of the ratio of total population to regional area), Duration (the logarithm of the ratio of birdwatching duration to the number of birdwatchers), Carbon (the logarithm of the carbon emissions), Water (the area of water divided by the total area), Green (the sum of the area of forests and shrubs divided by the total area), Farm (the area of farmland divided by the total area), Grass (the area of the grassland divided by the total area). All specifications include county and Year-month fixed effects. The robust standard errors clustered by the county are reported in parenthesis. ***, **, * denote the significance at the 1%, 5%, and 10% levels, respectively.")
restore

preserve 
global control "Temp Wind Pop Duration Carbon Water Green Farm Grass"
reghdfe Land_water PI $control , absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s1
reghdfe Nest_veg PI $control , absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s2
reghdfe non_Herbivorous PI $control , absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s3
reghdfe Herbivorous PI $control , absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s4
reghdfe Small_flock PI $control , absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s5
reghdfe Large_flock PI $control , absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s6
esttab s1 s2 s3 s4 s5 s6 using heterogeneity3.rtf, replace title("Table S13. Bird species heterogeneity.") ///
	mtitles("Land-water" "Vegetation" "Carnivorous and omnivorous" "Herbivorous" "Small-flock" "Large-flock") ///
	stats(year county N r2_a, labels("Year-month FE" "County FE" "Observations" "R-squared") fmt(0 0 0 4)) ///
	star(* 0.10 ** 0.05 *** 0.01) nonotes nocons b(4) se compress nogaps
restore



*------------------------------------------------------------------------
* Plausible channels
*------------------------------------------------------------------------
preserve
global control "Temp Wind Pop Duration Carbon Water Green Farm Grass"
reghdfe Ndvi PI $control , absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s1
reghdfe Nightlight PI $control , absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s2
reghdfe LAI PI $control , absorb(county year) cluster(county)
estadd local year "YES"
estadd local county "YES"
est store s3
esttab s1 s2 s3 using mechenism.rtf, replace title("Table 2. Statistical evidence for the inferior greening mechanism.") ///
	mtitles("NDVI" "Nightlight" "Leaf area") ///
	stats(year county N r2_a, labels("Year-month FE" "County FE" "Observations" "R-squared") fmt(0 0 0 4)) ///
	star(* 0.10 ** 0.05 *** 0.01) nonotes nocons b(4) se compress nogaps ///
	note("Notes: This table presents the results of the mechanism test. The dependent variables in Columns (1), (2), and (3) are NDVI, Nightlight, and Leaf area, respectively. NDVI is calculated as the difference between near-infrared and red band reflectance, divided by their sum, and scaled by a factor of 100. Nightlight is computed from raster data using spatial statistics, with core indicators including total light value, average light intensity, and a composite light index. Leaf area is defined as the total leaf area per unit of ground area. The independent variable is PI (the weighted sum of policies at the provincial, municipal, and county levels). Other control variables include Temp (annual average temperature), Wind (annual average wind speed), Pop (the logarithm of the ratio of total population to regional area), Duration (the logarithm of the ratio of birdwatching duration to the number of birdwatchers), Carbon (the logarithm of the carbon emissions), Water (the area of water divided by the total area), Green (the sum of the area of forests and shrubs divided by the total area), Farm (the area of farmland divided by the total area), Grass (the area of the grassland divided by the total area). All specifications include county and Year-month fixed effects. The robust standard errors clustered by the county are reported in parenthesis. ***, **, * denote the significance at the 1%, 5%, and 10% levels, respectively.")
restore



*------------------------------------------------------------------------
* Further discussion
*------------------------------------------------------------------------
*Socioeconomic consequences
preserve
keep id YEAR PI
duplicates drop id YEAR, force
xtset id YEAR
gen PI_LAG1 = L1.PI
tempfile lag1_data
save `lag1_data'
restore
merge m:1 id YEAR using `lag1_data',keepus(PI_LAG1)
drop _merge 

preserve
keep id YEAR Output
duplicates drop id YEAR, force
xtset id YEAR
gen Output_lead = F.Output
tempfile lead_data
save `lead_data'
restore
merge m:1 id YEAR using `lead_data',keepus(Output_lead)
drop _merge

preserve
global control "Temp Wind Pop Duration Carbon Water Green Farm Grass"
reghdfe ShannonBD PI PI_LAG1 $control , absorb(county year) cluster(county) //PI_LAG1即Leg one PI
estadd local year "YES"
estadd local county "YES"
est store s1
reghdfe Richness PI $control , absorb(county year) cluster(county) 
estadd local year "YES"
estadd local county "YES"
est store s2
reghdfe Evenness PI $control , absorb(county year) cluster(county) 
estadd local year "YES"
estadd local county "YES"
est store s3
reghdfe Output_lead PI ShannonBD $control , absorb(county year) cluster(county) 
estadd local year "YES"
estadd local county "YES"
est store s4
esttab s1 s2 s3 s4 using outcomes.rtf, replace title("Table S14. Further discussion.") ///
	mtitles("ShannonBD" "Species richness" "Species evenness" "Agricultural crop yield") ///
	stats(year county N r2_a, labels("Year-month FE" "County FE" "Observations" "R-squared") fmt(0 0 0 4)) ///
	star(* 0.10 ** 0.05 *** 0.01) nonotes nocons b(4) se compress nogaps ///
	order(PI PI_LAG1 ShannonBD $control) ///
	note("Notes: Column (1) includes Leg one PI (the one-period lagged term of PI). The dependent variable in Columns (1) is ShannonBD (the negative sum of the proportion of each bird species multiplied by its natural logarithm). The dependent variable in Column (2) is the species richness (the total number of species observed within the survey area). The dependent variable in Column (3) is the species evenness (the ratio of ShannonBD to the logarithm of species richness). The dependent variable in Column (4) is the agricultural crop yield (the one-period lead of the logarithm of agricultural crop yield). The independent variable in Column (1) to (4) is PI (the weighted sum of policies at the provincial, municipal, and county levels). Other control variables include Temp (annual average temperature), Wind (annual average wind speed), Pop (the logarithm of the ratio of total population to regional area), Duration (the logarithm of the ratio of birdwatching duration to the number of birdwatchers), Carbon (the logarithm of the carbon emissions), Water (the area of water divided by the total area), Green (the sum of the area of forests and shrubs divided by the total area), Farm (the area of farmland divided by the total area), Grass (the area of the grassland divided by the total area). All specifications include county and Year-month fixed effects. The robust standard errors clustered by the county are reported in parenthesis. ***, **, * denote the significance at the 1%, 5%, and 10% levels, respectively.")
restore
