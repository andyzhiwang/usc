use "C:\Users\yadto\Dropbox\USC\ECON513\HW4\Card-Krueger.dta", clear

quietly:{
noisily: display _n,_n, "--------------------question a ----------------------"
// generate delta y 
gen deltay = EMPL1 -EMPL0

//generate clusters by chains
gen bk = 0
replace bk = 1 if CHAIN == 1
gen kfc = 0
replace kfc = 1 if CHAIN == 2
gen roy = 0 
replace roy = 1 if CHAIN == 3
gen wend = 0
replace wend = 1 if CHAIN ==4



// reg changeiny d bk kfc roy wend no intercept 
noisily: reg deltay STATE bk kfc roy wend, nocon
noisily: display "coefficient of STATE is what we are interested "
noisily: display "compared to result in lecture 11, p9, beta is slightly bigger in conditional "
noisily: display " --> dif-in-dif, and standard error seems to be no change."

//store the variance of coefficients
mat variance = get(VCE)
scalar varstate = variance[1,1]
scalar varbk = variance[2,2]
scalar varkfc = variance[3,3]
scalar varroy = variance[4,4]
scalar varwend = variance[5,5]
scalar sestate = sqrt(varstate)
scalar sebk = sqrt(varbk)
scalar sekfc = sqrt(varkfc)
scalar seroy = sqrt(varroy)
scalar sewend = sqrt(varwend)


noisily: display _n,_n, "----------------------question b----------------------"
//store the residuals
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

gen group = 0
replace group = 1 if d01 == 1
replace group = 2 if d02 == 1
replace group = 3 if d03 == 1
replace group = 4 if d04 == 1
replace group = 5 if d11 == 1
replace group = 6 if d12 == 1
replace group = 7 if d13 == 1
replace group = 8 if d14 == 1

mkmat d01 d02 d03 d04 d11 d12 d13 d14, mat(z) //this is matirx z
mkmat e, mat(e) // this is vector e

//number of observations in each cluster
forval i =1/4 {
qui sum d0`i'
qui gen n0`i' = r(sum)
qui sum d1`i'
qui gen n1`i' = r(sum)
}
noisily: sum n01 n02 n03 n04 n11 n12 n13 n14

scalar n1= n01
scalar n2= n02
scalar n3= n03
scalar n4= n04
scalar n5= n11
scalar n6= n12
scalar n7= n13
scalar n8= n14



// solve the etilde, sigma^2_tilde, thus rho
mata: 
z = st_matrix("z")
e = st_matrix("e")
z2inv = invsym(z'*z)
I = I(391)
etilde = (I-z*z2inv*z')*e
variance = (etilde'*etilde)/(391-8-1)
st_matrix("var", variance)
end

scalar vartilde = var[1,1]
noisily: display "this is vartilde: ", vartilde //this is vartilde

reg deltay STATE bk kfc roy wend, nocon
ereturn list
scalar dfr = e(df_r)
scalar rss = e(rss)
scalar varhat = rss/dfr //this is varhat
noisily: display "this is varhat: ", varhat

noisily: display "it appears that varhat is smaller than vartilde, which is weird, I take the absolute value of their difference"

scalar rhohat = (vartilde - varhat)/varhat
noisily: display "within cluster correlation:", rhohat //this is within cluster correlation
scalar varcluster = rhohat * varhat
noisily: display "variance of eta:", varcluster //this is variance of eta
scalar varindio = (1-rhohat)*varhat
noisily: display "variance of epsilon:", varindio //this is varince of epsilon

noisily: display _n,_n, "-------------------question c-------------------"

// correction factor
scalar L = 391/8
scalar correct = L*rhohat + (1-rhohat) 
noisily: display "correction factor:", correct //this is correction factor

//corrected standard errors
scalar correctvarstate = correct*varstate
scalar correctsestate = sqrt(correctvarstate)
noisily: display "corrected standard error of state:", correctsestate //this is corrected OLS standard error of STATE
scalar correctvarbk = correct*varbk
scalar correctsebk = sqrt(correctvarbk)
noisily: display "corrected standard error of bk:", correctsebk //this is corrected OLS standard error of bk
scalar correctvarkfc = correct*varkfc
scalar correctsekfc = sqrt(correctvarkfc)
noisily: display "corrected standard error of kfc:", correctsekfc //this is corrected OLS standard error of STATE
scalar correctvarroy = correct*varroy
scalar correctseroy = sqrt(correctvarroy)
noisily: display "corrected standard error of roy:", correctseroy //this is corrected OLS standard error of STATE
scalar correctvarwend = correct*varwend
scalar correctsewend = sqrt(correctvarwend)
noisily: display "corrected standard error of wend:", correctsewend //this is corrected OLS standard error of STATE


noisily: display _n,_n, "-------------------question d-------------------"

replace group = 1 if STATE == 0 & bk == 1
replace group = 2 if STATE == 0 & kfc == 1
replace group = 3 if STATE == 0 & roy == 1
replace group = 4 if STATE == 0 & wend == 1
replace group = 5 if STATE == 1 & bk == 1
replace group = 6 if STATE == 1 & kfc == 1
replace group = 7 if STATE == 1 & roy == 1
replace group = 8 if STATE == 1 & wend == 1
sort group
by group: gen counter =_n
mkmat STATE bk kfc roy wend if counter ==1, mat(X)
mat list X //this is matrix X
mat X1 = (0\1\0\0\0)
mat X2 = (0\0\1\0\0)
mat X3 = (0\0\0\1\0)
mat X4 = (0\0\0\0\1)
mat X5 = (1\1\0\0\0)
mat X6 = (1\0\1\0\0)
mat X7 = (1\0\0\1\0)
mat X8 = (1\0\0\0\1)
scalar n1 = n01
scalar n2 = n02
scalar n3 = n03
scalar n4 = n04
scalar n5 = n11
scalar n6 = n12
scalar n7 = n13
scalar n8 = n14

mat sumM = J(5,5,.)
mat sumN = J(5,5,.)
forval i =1/8{
mat M`i' = n`i'*X`i'*X`i''
scalar n`i'sq = n`i'^2
mat N`i' = n`i'sq*(varcluster + varindio/n`i')*X`i'*X`i''
}

mat sumM = M1+M2+M3+M4+M5+M6+M7+M8
mat sumN = N1+N2+N3+N4+N5+N6+N7+N8
mat sumMinv = inv(sumM)
mat varbeta = sumMinv*sumN*sumMinv
scalar varbetastate = varbeta[1,1]
scalar varbetabk = varbeta[2,2]
scalar varbetakfc = varbeta[3,3]
scalar varbetaroy = varbeta[4,4]
scalar varbetawend = varbeta[5,5]
scalar sebetastate = sqrt(varbetastate)
scalar sebetabk = sqrt(varbetabk)
scalar sebetakfc = sqrt(varbetakfc)
scalar sebetaroy = sqrt(varbetaroy)
scalar sebetawend = sqrt(varbetawend)

noisily: display _n, "                   state    bk    kfc   roy   wend"
noisily: display "(OLS)              ", sestate, sebk, sekfc, seroy, sewend
noisily: display "(Correct)          ", sebetastate, sebetabk, sebetakfc, sebetaroy, sebetawend
noisily: display "(Correction factor)", correctsestate, correctsebk, correctsekfc, correctseroy, correctsewend



noisily: display  _n,_n, "-------------------question e -------------------"
gen sbk = STATE*bk
gen skfc = STATE*kfc
gen sroy = STATE*roy
gen swend = STATE*wend
noisily: reg deltay STATE bk kfc roy wend sbk skfc sroy swend, nocon
noisily: display " we cannot do clustered standard errors since ols residual e has properties:"
noisily: display " --> e*s*c has expectation of 0, where d is state, c is chain,"
noisily: display " --> so ols estimator of variance of cluster specific error is also 0."


noisily: display _n,_n, "------------------question f --------------------"

noisily: reg deltay STATE bk kfc roy wend, nocon vce(boot)
noisily: display "the standard error grows bigger compared to a"

}
