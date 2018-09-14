use "C:\Users\yadto\Dropbox\USC\ECON513\HW4\Card-Krueger.dta", clear
gen y = EMPL1 -EMPL0
gen bk = 0
replace bk = 1 if CHAIN == 1
gen kfc = 0
replace kfc = 1 if CHAIN == 2
gen roy = 0 
replace roy = 1 if CHAIN == 3
gen wend = 0
replace wend = 1 if CHAIN ==4

reg y STATE bk kfc roy wend, nocon

predict e, r

//construct matrix Z, indicator dtc, t time, c chain
gen d01 = 0
gen d02 = 0
gen d03 = 0
gen d04 = 0
gen d11 = 0
gen d12 = 0
gen d13 = 0
gen d14 = 0
replace d01 = 1 if STATE == 0 & bk == 1
replace d02 = 1 if STATE == 0 & kfc == 1
replace d03 = 1 if STATE == 0 & roy == 1
replace d04 = 1 if STATE == 0 & wend == 1
replace d11 = 1 if STATE == 1 & bk == 1
replace d12 = 1 if STATE == 1 & kfc == 1
replace d13 = 1 if STATE == 1 & roy == 1
replace d14 = 1 if STATE == 1 & wend == 1
mkmat d01 d02 d03 d04 d11 d12 d13 d14, mat(z)
mkmat e, mat(e) 


forval i =1/4 {
qui sum d0`i'
scalar n0`i' = r(sum)
qui sum d1`i'
scalar n1`i' = r(sum)
}
display n01 n02 n03 n04 n11 n12 n13 n14

//calculate mu, population mean of y in group g
qui gen mu = 0
qui gen total = 0
forval t = 0/1{
	forval c = 1/4{
		qui sum y if d`t'`c' == 1
		qui replace total = r(sum) if d`t'`c' == 1
		qui replace mu = total/n`t'`c' if d`t'`c' == 1
	}
}

//reg mu on d, get cluster error
reg mu STATE
predict eta, r

//calculate variance of individual error and cluster error
egen sdepsilon = sd(e)
egen sdeta = sd(eta)
gen varepsilon = sdepsilon^2
gen vareta = sdeta^2
sum varepsilon
sum vareta

//calculate within cluster correlation
scalar rhohat = vareta/(varepsilon+vareta)
display rhohat

// correction factor
scalar L = 391/8
scalar correct = L*rhohat + (1-rhohat)
display correct

//corrected standard error
scalar correctvar = correct*rhohat
scalar correctsd = sqrt(correctvar)
display correctsd


gen sbk = STATE*bk
gen skfc = STATE*kfc
gen sroy = STATE*roy
gen swend = STATE*wend
reg y STATE bk kfc roy wend sbk skfc sroy swend, nocon



reg y STATE bk kfc roy wend, nocon vce(boot)
