clear
use "data assignment1.dta"
gen expersquared=expyears^2
reg lnearningswk educyears expyears expersquared

summ

gen x1=expyears+educyears
gen x2=expersquared+(2*13.6-1)*educyears

* regression with redefined variables
reg lnearningswk educyears x1 x2
* to list variance of estimated parameters
matrix list e(V)

**** Problem 4
* generate variables that correspond to the new level of education and experience for 
* individuals affected by the policy

gen ed_new=educyears
gen exp_new=expyears

replace ed_new=12 if educyears<12
replace exp_new=expyears-(12-educyears) if educyears<12

* generate variable that calculates the expected change in income for each individual
* affected by the policy

gen inc_change=0

replace inc_change=exp(4.016274+12*.0923143 + .079138*exp_new -.0019633 * exp_new^2+0.410^2/2)- ///
exp(4.016274+educyears*.0923143 + .079138*expyears -.0019633 * expersquared+0.410^2/2) if educyears<12



summ inc_change
