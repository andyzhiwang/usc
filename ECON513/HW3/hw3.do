clear
set more off
use "C:\Users\yadto\Dropbox\USC\ECON513\HW3\hw3.dta"
gen qob2 = 0 
gen qob3 = 0
gen qob4 = 0
gen birth2 = birthyr^2
replace qob2=1 if qob==2
replace qob3=1 if qob==3
replace qob4=1 if qob==4

egen group1=seq(), f(1) t(65) b(5000)

gen educ_coef=0
gen educ_std=0
gen educ_ss=0
gen sample_std=0

forval i=1/65{
	qui reg lnwage educ birthyr birth2 if group1==`i'
	qui replace educ_coef=educ_coef+_b[educ]
	matrix V=e(V)
	scalar stder=sqrt(V[1,1])
	qui replace educ_std=educ_std+stder
}
replace educ_coef=educ_coef/65
replace educ_std=educ_std/65
forval i=1/65{
	qui reg lnwage educ birthyr birth2 if group1==`i'
	qui replace educ_ss=educ_ss+(_b[educ]-educ_coef)^2
}
	qui replace educ_ss=educ_ss/64
	qui replace sample_std=sqrt(educ_ss)   
* sampling standard deviation of 65 samples of beta coefficients

* n=5000, OLS regression result
sum educ_coef educ_std sample_std

gen iveduc_coef=0
gen iveduc_std=0
gen fvalue=0
gen overall_fvalue=0

forval i=1/65{
	qui ivreg lnwage birthyr birth2 (educ = qob2 qob3 qob4) if group1==`i'
	qui replace iveduc_coef=iveduc_coef+_b[educ]
	matrix V=e(V)
	scalar stder=sqrt(V[1,1])
	qui replace iveduc_std=iveduc_std+stder
	qui reg educ birthyr birth2 qob2 qob3 qob4  if group1 ==`i'
	qui test qob2 qob3 qob4
	qui replace fvalue=fvalue+r(F)
	qui test birthyr birth2 qob2 qob3 qob4
	qui replace overall_fvalue=overall_fvalue+r(F)
}
replace iveduc_coef=iveduc_coef/65
replace iveduc_std=iveduc_std/65 
replace fvalue=fvalue/65
replace overall_fvalue=overall_fvalue/65
* n=5000, 2SLS regression result
sum iveduc_coef iveduc_std fvalue overall_fvalue  


egen group2=seq(), f(1) t(32) b(10000)

replace educ_coef=0
replace educ_std=0

forval i=1/32{
	qui reg lnwage educ birthyr birth2 if group2==`i'
	qui replace educ_coef=educ_coef+_b[educ]
	matrix V=e(V)
	scalar stder=sqrt(V[1,1])
	qui replace educ_std=educ_std+stder
}
replace educ_coef=educ_coef/32
replace educ_std=educ_std/32
* n=10000, OLS regression result
sum educ_coef educ_std

replace iveduc_coef=0
replace iveduc_std=0
replace fvalue=0
replace overall_fvalue=0

forval i=1/32{
	qui ivreg lnwage birthyr birth2 (educ = qob2 qob3 qob4) if group2 ==`i'
	qui replace iveduc_coef=iveduc_coef+_b[educ]
	matrix V=e(V)
	scalar stder=sqrt(V[1,1])
	qui replace iveduc_std=iveduc_std+stder
	qui reg educ birthyr birth2 qob2 qob3 qob4  if group2 ==`i'
	qui test qob2 qob3 qob4
	qui replace fvalue=fvalue+r(F)
	qui test birthyr birth2 qob2 qob3 qob4
	qui replace overall_fvalue=overall_fvalue+r(F)
}
replace iveduc_coef=iveduc_coef/32
replace iveduc_std=iveduc_std/32
replace fvalue=fvalue/32
replace overall_fvalue=overall_fvalue/32
* n=10000, 2SLS regression result
sum iveduc_coef iveduc_std fvalue overall_fvalue

egen group3=seq(), f(1) t(16) b(20000)

replace educ_coef=0
replace educ_std=0

forval i=1/16{
	qui reg lnwage educ birthyr birth2 if group3==`i'
	qui replace educ_coef=educ_coef+_b[educ]
	matrix V=e(V)
	scalar stder=sqrt(V[1,1])
	qui replace educ_std=educ_std+stder
}
replace educ_coef=educ_coef/16
replace educ_std=educ_std/16
* n=20000, OLS regression result
sum educ_coef educ_std

replace iveduc_coef=0
replace iveduc_std=0
replace fvalue=0
replace overall_fvalue=0

forval i=1/16{
	qui ivreg lnwage birthyr birth2 (educ = qob2 qob3 qob4) if group3 ==`i'
	qui replace iveduc_coef=iveduc_coef+_b[educ]
	matrix V=e(V)
	scalar stder=sqrt(V[1,1])
	qui replace iveduc_std=iveduc_std+stder
	qui reg educ birthyr birth2 qob2 qob3 qob4  if group3 ==`i'
	qui test qob2 qob3 qob4
	qui replace fvalue=fvalue+r(F)
	qui test birthyr birth2 qob2 qob3 qob4
	qui replace overall_fvalue=overall_fvalue+r(F)
}
replace iveduc_coef=iveduc_coef/16
replace iveduc_std=iveduc_std/16
replace fvalue=fvalue/16
replace overall_fvalue=overall_fvalue/16

* n=20000, 2SLS regression result
sum iveduc_coef iveduc_std fvalue overall_fvalue
