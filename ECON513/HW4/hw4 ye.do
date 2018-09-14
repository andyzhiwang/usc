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
mkmat e, mat(e)

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

gen group = 0
replace group = 1 if STATE == 0 & bk == 1
replace group = 2 if STATE == 0 & kfc == 1
replace group = 3 if STATE == 0 & roy == 1
replace group = 4 if STATE == 0 & wend == 1
replace group = 5 if STATE == 1 & bk == 1
replace group = 6 if STATE == 1 & kfc == 1
replace group = 7 if STATE == 1 & roy == 1
replace group = 8 if STATE == 1 & wend == 1

gen d01 = 0
gen d02 = 0
gen d03 = 0
gen d04 = 0
gen d11 = 0
gen d12 = 0
gen d13 = 0
gen d14 = 0
replace d01 = 1 if group ==1
replace d02 = 1 if group ==2
replace d03 = 1 if group ==3
replace d04 = 1 if group ==4
replace d11 = 1 if group ==5
replace d12 = 1 if group ==6
replace d13 = 1 if group ==7
replace d14 = 1 if group ==8
mkmat d01 d02 d03 d04 d11 d12 d13 d14, mat(z)

sort group 

forval i =1/8{
qui sum if group == `i'
scalar n`i' = r(N)
display n`i'
}

mat invzz = invsym(z'*z)
mat etilde = (I(391)-z*invzz*z')*e
mat vartilde = (etilde'*etilde)/(391-8-1)
scalar vartilde = vartilde[1,1]
display vartilde

sum e
scalar sdhat = r(sd)
scalar varhat = sdhat^2
display varhat

scalar rhohat = (varhat - vartilde)/varhat
scalar rhohat = -rhohat
scalar vareta = rhohat * varhat
scalar varepsilon = vartilde

scalar L = 391/8
scalar correctfactor = L*rhohat + (1-rhohat) 

scalar corrvarstate = correctfactor*varstate
scalar correctedstate = sqrt(corrvarstate)

scalar corrvarbk = correctfactor*varbk
scalar correctedbk = sqrt(corrvarbk)

scalar corrvarkfc = correctfactor*varkfc
scalar correctedkfc = sqrt(corrvarkfc)

scalar corrvarroy = correctfactor*varroy
scalar correctedroy = sqrt(corrvarroy)

scalar corrvarwend = correctfactor*varwend
scalar correctedwend = sqrt(corrvarwend)

mat X1 = (0\1\0\0\0)
mat X2 = (0\0\1\0\0)
mat X3 = (0\0\0\1\0)
mat X4 = (0\0\0\0\1)
mat X5 = (1\1\0\0\0)
mat X6 = (1\0\1\0\0)
mat X7 = (1\0\0\1\0)
mat X8 = (1\0\0\0\1)

mat A = J(5,5,.)
mat B = J(5,5,.)
forval i =1/8{
mat A`i' = n`i'*X`i'*X`i''
scalar n`i'sq = n`i'^2
mat B`i' = n`i'sq*(vareta + varepsilon/n`i')*X`i'*X`i''
}

mat A = A1+A2+A3+A4+A5+A6+A7+A8
mat B = B1+B2+B3+B4+B5+B6+B7+B8
mat invA = inv(A)
mat varbeta = invA*B*invA

scalar varbetastate = varbeta[1,1]
scalar varbetabk = varbeta[2,2]
scalar varbetakfc = varbeta[3,3]
scalar varbetaroy = varbeta[4,4]
scalar varbetawend = varbeta[5,5]
scalar correctstate = sqrt(varbetastate)
scalar correctbk = sqrt(varbetabk)
scalar correctfc = sqrt(varbetakfc)
scalar correctroy = sqrt(varbetaroy)
scalar correctwend = sqrt(varbetawend)

gen sbk = STATE*bk
gen skfc = STATE*kfc
gen sroy = STATE*roy
gen swend = STATE*wend
reg y STATE bk kfc roy wend sbk skfc sroy swend, nocon

reg y STATE bk kfc roy wend, nocon vce(boot)
