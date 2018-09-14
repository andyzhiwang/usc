 log using c:\Users\yadto\Dropbox\USC\ECON513\HW2\hw2.log,replace

use c:\Users\yadto\Dropbox\USC\ECON513\HW2\hw2

* Problem 1, question 1 *
reg lnearningswk educyears
* the coefficient on education is the partial effect of education on the log weekly wage *
* which is one year increase in education could bring how much percentage change in weekly wage *

* Problem 1, question 2 *
* the likely sign of the omitted vairable should be positive, so the bias should be upward *
reg lnearningswk educyears iq
* the coefficient on education decreases after adding IQ into regression *
regress iq educyears
* we can see the regressors on education are both positive for the two regression equtions *
* according to the formula, we can see beta1hat = beta1 + beta2*cov(x1,x2)/var(x1) *
* since IQ and education has a positive correlation, cov(x1,x2)>0, so beta1hat has a upward bias *

* Problem 2, question 5 *
* Kx is the coefficient of x in regression of z on x, LamdaX is the coefficient of x in regression of z on x and w *
reg iq educyears
reg iq educyears kww
* so the proxy bias is smaller than the omitted variable bias, as the coefficient of x in second regression is smaller than the coefficient of x in first regression *

log close
