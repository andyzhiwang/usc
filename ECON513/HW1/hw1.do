log using C:\Users\yadto\Dropbox\USC\ECON513\HW1\hw1.log,replace

use C:\Users\yadto\Dropbox\USC\ECON513\HW1\hw1

*question 1*
gen exp2 = expyears^2
reg lnearningswk educyears expyears exp2

*question 2*
gen beta0 = _b[_cons]
gen beta1 = _b[educyears]
gen beta2 = _b[expyears]
gen beta3 = _b[exp2]
predict residual, res
gen zeta = beta1 - beta2 - beta3*(2*expyears-1)
su zeta

*question 3*
gen educnew = educyears + 1
gen expnew = expyears - 1
gen exp2new = expnew^2
gen newwage = beta0+beta1*educnew+beta2*expnew+beta3*exp2new
egen avnewwage = mean(newwage)
egen avwage = mean(lnearningswk)
gen zetapredict = avnewwage - avwage
su zetapredict
* the mean of zetapredict is the increasing effect of the policy*
* compared to zeta, they are almost the same*

*question 4*
gen educmodify = educyears + (12 - educyears) if educyears <12
replace educmodify = educyears if educyears >= 12
gen expmodify = expyears - (12 - educyears) if educyears < 12
replace expmodify = expyears if educyears >= 12
gen exp2modify = expmodify ^2
gen wagemodify = beta0+beta1*educmodify+beta2*expmodify+beta3*exp2modify
egen avwagemodify = mean(wagemodify)
gen zetamodify = avwagemodify - avwage
su zetamodify 
* the mean of zetamodify is the increasing effect of the policy*
