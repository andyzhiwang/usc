clear
set more off
use "C:\Users\yadto\Dropbox\USC\ECON513\HW3\hw3.dta"


* n=5000, OLS

egen group1=seq(), f(1) t(65) b(5000)

gen educ_coef=0
gen educ_std=0

forval i=1/65{
	qui reg lnwage educ if group1==`i'
	qui replace educ_coef=educ_coef+_b[educ]
	matrix V=e(V)
	scalar stder=sqrt(V[1,1])
	qui replace educ_std=educ_std+stder
}
replace educ_coef=educ_coef/65
replace educ_std=educ_std/65
sum educ_coef educ_std

* n=5000, 2sls

gen iveduc_coef=0
gen iveduc_std=0
gen tvalue=0

forval i=1/65{
	qui ivreg lnwage (educ = qob) if group1==`i'
	qui replace iveduc_coef=iveduc_coef+_b[educ]
	matrix V=e(V)
	scalar stder=sqrt(V[1,1])
	qui replace iveduc_std=iveduc_std+stder
	qui reg educ qob  if group1==`i'
	qui replace tvalue =tvalue+(_b[qob]/_se[qob])
}
replace iveduc_coef=iveduc_coef/65
replace iveduc_std=iveduc_std/65
replace tvalue=tvalue/65
sum iveduc_coef iveduc_std tvalue

* n=10000, OLS

egen group2=seq(), f(1) t(32) b(10000)

replace educ_coef=0
replace educ_std=0

forval i=1/32{
	qui reg lnwage educ if group2==`i'
	qui replace educ_coef=educ_coef+_b[educ]
	matrix V=e(V)
	scalar stder=sqrt(V[1,1])
	qui replace educ_std=educ_std+stder
}
replace educ_coef=educ_coef/32
replace educ_std=educ_std/32
sum educ_coef educ_std

* n=10000, 2sls

replace iveduc_coef=0
replace iveduc_std=0
replace tvalue=0

forval i=1/32{
	qui ivreg lnwage (educ = qob) if group2==`i'
	qui replace iveduc_coef=iveduc_coef+_b[educ]
	matrix V=e(V)
	scalar stder=sqrt(V[1,1])
	qui replace iveduc_std=iveduc_std+stder
	qui reg educ qob  if group2==`i'
	qui replace tvalue =tvalue+(_b[qob]/_se[qob])
}
replace iveduc_coef=iveduc_coef/32
replace iveduc_std=iveduc_std/32
replace tvalue=tvalue/32
sum iveduc_coef iveduc_std tvalue

* n=20000, OLS

egen group3=seq(), f(1) t(16) b(20000)

replace educ_coef=0
replace educ_std=0

forval i=1/16{
	qui reg lnwage educ if group3==`i'
	qui replace educ_coef=educ_coef+_b[educ]
	matrix V=e(V)
	scalar stder=sqrt(V[1,1])
	qui replace educ_std=educ_std+stder
}
replace educ_coef=educ_coef/16
replace educ_std=educ_std/16
sum educ_coef educ_std

* n=20000, 2sls

replace iveduc_coef=0
replace iveduc_std=0
replace tvalue=0

forval i=1/16{
	qui ivreg lnwage (educ = qob) if group3==`i'
	qui replace iveduc_coef=iveduc_coef+_b[educ]
	matrix V=e(V)
	scalar stder=sqrt(V[1,1])
	qui replace iveduc_std=iveduc_std+stder
	qui reg educ qob  if group3==`i'
	qui replace tvalue =tvalue+(_b[qob]/_se[qob])
}
replace iveduc_coef=iveduc_coef/16
replace iveduc_std=iveduc_std/16
replace tvalue=tvalue/16
sum iveduc_coef iveduc_std tvalue
