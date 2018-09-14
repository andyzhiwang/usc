use "C:\Users\yadto\Dropbox\USC\ECON 541\term paper\datasest.dta", clear



gen ad_gdp = gdp/(1+inflation)
gen ad_invest = invest/(1+inflation)
gen expend_RnD = RnD*ad_gdp
gen ad_trade = trade/(1+inflation)
gen ad_invest_1 = invest_1 / (1 +inflation)
gen ad_gdp_1 = gdp_1/(1+inflation)
gen ad_trade_1 = trade_1 / (1 + inflation)



///
gen gdp_pp = ad_gdp / labor

gen invest_pp = ad_invest / labor

gen Ln_invest_pp = log(invest_pp)

gen Ln_gdp_pp = log(gdp_pp)


/// 
gen Ln_gdp = log(ad_gdp)
gen Ln_gdp_1 = log(ad_gdp_1)

gen Ln_RnD = log(expend_RnD)

gen Ln_trade = log(ad_trade)
gen Ln_trade_1 = log(ad_trade_1)

gen Ln_labor = log(labor)
gen Ln_labor_1 = log(labor_1)

gen Ln_invest = log(ad_invest)
gen Ln_invest_1 = log(ad_invest_1)

///

gen diff_gdp = Ln_gdp - Ln_gdp_1
gen diff_trade = Ln_trade - Ln_trade_1
gen diff_invest = Ln_invest - Ln_invest_1
gen diff_labor =  Ln_labor - Ln_labor_1







reg Ln_gdp Ln_invest Ln_trade Ln_RnD Ln_labor hka

corr Ln_invest Ln_trade Ln_RnD Ln_labor hka

reg Ln_gdp Ln_invest Ln_trade Ln_RnD Ln_labor hka crisis




