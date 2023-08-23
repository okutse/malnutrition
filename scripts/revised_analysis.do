*********************************************************************
*Trends of Socio-Economic Disparities in Child Malnutrition (2014 -- 2014)
*Amos Ochieng Okutse
*okutseamos@gmail.com
*Henry Athiany
*henry.athiany@jkuat.ac.ke
***********************************************************
*After data preparation
***********************************************************
*load the combined dataset
use "D:\Biostatistics\1 Malnutrition paper\revised_analysis\clean_combined_data\clean_df.dta", clear

*Table 1: Descriptive statistics by survey year 
***********************************************************
/*2003*/
tab stunting  if syear == 0 
tab underweight if syear == 0
tab underweight if syear == 0
tab wasting if syear == 0
tab sex if syear == 0
tab residence if syear == 0

/*2014*/
tab stunting  if syear == 1 
tab underweight if syear == 1
tab underweight if syear == 1
tab wasting if syear == 1
tab sex if syear == 1
tab residence if syear == 1

*Table 2: Proportions of malnutrition in 2003 relative to 2014 by SSE status
***********************************************************
*stunting
prtest stunting if wealth_index ==1,by(syear) /*Poorest*/ 
prtest stunting if wealth_index ==2,by(syear) /*Poorer*/
prtest stunting if wealth_index ==3,by(syear) /*Middle*/
prtest stunting if wealth_index ==4,by(syear) /*Richer*/
prtest stunting if wealth_index ==5,by(syear) /*Richest*/
prtest stunting,by(syear) /*ALL*/

*Underweight
prtest underweight if wealth_index ==1,by(syear) /*Poorest*/
prtest underweight if wealth_index ==2,by(syear) /*Poorer*/
prtest underweight if wealth_index ==3,by(syear) /*Middle*/
prtest underweight if wealth_index ==4,by(syear) /*Richer*/
prtest underweight if wealth_index ==5,by(syear) /*Richest*/
prtest underweight,by(syear) /*ALL*/

*wasted
prtest wasting if wealth_index ==1,by(syear) /*Poorest*/
prtest wasting if wealth_index ==2,by(syear) /*Poorer*/
prtest wasting if wealth_index ==3,by(syear) /*Middle*/
prtest wasting if wealth_index ==4,by(syear) /*Richer*/
prtest wasting if wealth_index ==5,by(syear) /*Richest*/
prtest wasting,by(syear) /*ALL*/

***********************************************************
*Table 3: Concentration Indices of Child Malnutrition in Kenya      
***********************************************************
//The Distributive Analysis Stata Package (DASP) has to be installed for this section.
/*
net from http://dasp.ecn.ulaval.ca/modules/DASP_V2.3/dasp
net install dasp_p1, force
net install dasp_p2, force
net install dasp_p3, force
net install dasp_p4, force
addDMenu profile.do _daspmenu 
ssc install decompose
ssc install rif
*/

use "D:\Biostatistics\1 Malnutrition paper\revised_analysis\kdhs_2003a.dta", clear
svyset _n [pweight = weights ],  vce(linearized)

digini haz haz, rank1(wealth_index) file2(D:\Biostatistics\1 Malnutrition paper\revised_analysis\kdhs_2014a.dta) test(0)
digini waz waz , rank1(wealth_index) file2(D:\Biostatistics\1 Malnutrition paper\revised_analysis\kdhs_2014a.dta) test(0)
digini whz whz , rank1(wealth_index) file2(D:\Biostatistics\1 Malnutrition paper\revised_analysis\kdhs_2014a.dta) test(0)

***********************************************************
*Table 4, 5, and 6: Determinants of child malnutrition in Kenya
***********************************************************
use "D:\Biostatistics\1 Malnutrition paper\revised_analysis\kdhs_2003a.dta", clear
gen syear=0
append using "D:\Biostatistics\1 Malnutrition paper\revised_analysis\kdhs_2014a.dta"
//indicator for the 2014 dataset
replace syear=1 if syear==.
//labeling survey year values
label values syear labels6
label define labels6 0 "DHS2003" 1 "DHS2014", replace
gen agesquared=(age_mnths)^2
move age_mnths agesquared
//setting data as survey data 
svyset _n [pweight= weights ],  vce(linearized)
////*Fitting logistic regression models: responses, stunting, wasting and underweight
*stunted: response var stunting
replace religion=. if religion==9 | religion==96
replace region=. if region==9
putdocx begin
xi:svy:logistic stunting ib0.syear age_mnths  agesquared ib1.sex ib1.residence ib1.religion ib3.educ_level birth_order ib1.region ib1.delivery_place birth_interval motherage_firstbirth ib5.wealth_index,noconstant
putdocx table stun=etable, title("Stunting Logit Regression Model")
putdocx save stunting_model.docx
putdocx clear

*underweight
putdocx begin
xi:svy:logistic underweight ib0.syear age_mnths  agesquared ib1.sex ib1.residence ib1.religion ib3.educ_level birth_order ib1.region ib1.delivery_place birth_interval motherage_firstbirth ib5.wealth_index,noconstant
putdocx table under=etable, title("Underweight Logit Regression Model")
putdocx save underweight_model.docx
putdocx clear

*wasting
putdocx begin
xi:svy:logistic wast ib0.syear age_mnths  agesquared ib1.sex ib1.residence ib1.religion ib3.educ_level birth_order ib1.region ib1.delivery_place birth_interval motherage_firstbirth ib5.wealth_index,noconstant
putdocx table wast=etable, title("Wasting Logit Regression Model")
putdocx save wasting_model.docx
putdocx clear
************************************************************************
//Table 7: Decomposing the contributions of each determinant of malnutrition on overall malnutrition btn 2003 and 2014 in Kenya [Beginning with 2003]
************************************************************************
// Inequality decomposition shows how much of the overall inequality in these probability can be explained by a particular factor (specific to significant determinants of malnutrition as from logit model). conindex was used to calculate CIs
*ssc install decompose 
//stunting 2003
use "D:\Biostatistics\1 Malnutrition paper\revised_analysis\kdhs_2003a.dta", clear
*install the conindex package for use in 
conindex stun [aw=weight], rank(wealth_index) bounded limits(0 1) wagstaff
sca CI = r(CI)

global X age_mnths religion educ_level birth_order wealth_index

qui glm stun $X [aw=weight], family(binomial) link(logit)

qui margins , dydx(*) post
mat coeff = e(b)
sum stun [aw=weight]
sca m_y=r(mean)

foreach x of varlist $X {
qui{
mat b_`x' = coeff[1,"`x'"]
sca b_`x' = b_`x'[1,1]

qui sum `x'
gen double scaled_`x' = `x'/r(max)
conindex scaled_`x' [aw=weight], rank(wealth_index) bounded limits(0 1) wagstaff

sca CI_`x' = r(CI)
sum `x' [aw=weight]

sca elas_`x' = (b_`x' * r(mean))/m_y

sca con_`x' = elas_`x' * CI_`x'
sca prcnt_`x' = con_`x'/CI
}

di "`x' elasticity:", elas_`x'
di "`x' concentration index:", CI_`x'
di "`x' contribution:", con_`x'
di "`x' percentage contribution:", prcnt_`x'

}

//underweight 2003
use "D:\Biostatistics\1 Malnutrition paper\revised_analysis\kdhs_2003a.dta", clear
conindex und [aw=weight], rank(wealth_index) bounded limits(0 1) wagstaff
sca CI = r(CI)

global X religion age_mnths educ_level birth_order motherage_firstbirth region wealth_index

qui glm und $X [aw=weight], family(binomial) link(logit)

qui margins , dydx(*) post
mat coeff = e(b)
sum und [aw=weight]
sca m_y=r(mean)

foreach x of varlist $X {
qui{
mat b_`x' = coeff[1,"`x'"]
sca b_`x' = b_`x'[1,1]

qui sum `x'
gen double scaled_`x' = `x'/r(max)
conindex scaled_`x' [aw=weight], rank(wealth_index) bounded limits(0 1) wagstaff

sca CI_`x' = r(CI)
sum `x' [aw=weight]

sca elas_`x' = (b_`x' * r(mean))/m_y

sca con_`x' = elas_`x' * CI_`x'
sca prcnt_`x' = con_`x'/CI
}

di "`x' elasticity:", elas_`x'
di "`x' concentration index:", CI_`x'
di "`x' contribution:", con_`x'
di "`x' percentage contribution:", prcnt_`x'

}

*************************************************************************
*Decomposing the 2014 stunting and underweight determinants
*************************************************************************
//stunting 2014
use "D:\Biostatistics\1 Malnutrition paper\revised_analysis\kdhs_2014a.dta", clear
conindex stun [aw=weight], rank(wealth_index) bounded limits(0 1) wagstaff
sca CI = r(CI)

global X age_mnths religion educ_level birth_order wealth_index

qui glm stun $X [aw=weight], family(binomial) link(logit)

qui margins , dydx(*) post
mat coeff = e(b)
sum stun [aw=weight]
sca m_y=r(mean)

foreach x of varlist $X {
qui{
mat b_`x' = coeff[1,"`x'"]
sca b_`x' = b_`x'[1,1]

qui sum `x'
gen double scaled_`x' = `x'/r(max)
conindex scaled_`x' [aw=weight], rank(wealth_index) bounded limits(0 1) wagstaff

sca CI_`x' = r(CI)
sum `x' [aw=weight]

sca elas_`x' = (b_`x' * r(mean))/m_y

sca con_`x' = elas_`x' * CI_`x'
sca prcnt_`x' = con_`x'/CI
}

di "`x' elasticity:", elas_`x'
di "`x' concentration index:", CI_`x'
di "`x' contribution:", con_`x'
di "`x' percentage contribution:", prcnt_`x'

}

//underweight 2014
use "D:\Biostatistics\1 Malnutrition paper\revised_analysis\kdhs_2014a.dta", clear
conindex und [aw=weight], rank(wealth_index) bounded limits(0 1) wagstaff
sca CI = r(CI)

global X religion age_mnths educ_level birth_order motherage_firstbirth region wealth_index

qui glm und $X [aw=weight], family(binomial) link(logit)

qui margins , dydx(*) post
mat coeff = e(b)
sum und [aw=weight]
sca m_y=r(mean)

foreach x of varlist $X {
qui{
mat b_`x' = coeff[1,"`x'"]
sca b_`x' = b_`x'[1,1]

qui sum `x'
gen double scaled_`x' = `x'/r(max)
conindex scaled_`x' [aw=weight], rank(wealth_index) bounded limits(0 1) wagstaff

sca CI_`x' = r(CI)
sum `x' [aw=weight]

sca elas_`x' = (b_`x' * r(mean))/m_y

sca con_`x' = elas_`x' * CI_`x'
sca prcnt_`x' = con_`x'/CI
}

di "`x' elasticity:", elas_`x'
di "`x' concentration index:", CI_`x'
di "`x' contribution:", con_`x'
di "`x' percentage contribution:", prcnt_`x'

}
************************************************************************
*Concentration Curves over SES over significant factors determining
*stunting, overweight, and wasting~decomposing determinant effects
************************************************************************
*using DASP
//Figure 1: HAZ, WAZ, and WHZ in 2003 and 2014 by Socio-Economic Status
use "D:\Biostatistics\1 Malnutrition paper\revised_analysis\kdhs_2003a.dta", clear
clorenz waz haz whz, rank( wealth_index ) title("Concentration Curve for WAZ, HAZ, and WHZ by SES (2003)" )
graph save Graph "F:\Biostatistics\1 Malnutrition paper\Analysis Files\c_2003.gph",replace

use "F:\Biostatistics\1 Malnutrition paper\Analysis Files\kdhs_2014a.dta" ,clear
clorenz waz haz whz, rank( wealth_index ) title("Concentration curve: WAZ, HAZ, and WHZ by SES (2014)" )
graph save Graph "F:\Biostatistics\1 Malnutrition paper\Analysis Files\c_2014",replace

gr combine "F:\Biostatistics\1 Malnutrition paper\Analysis Files\c_2003.gph" "F:\Biostatistics\1 Malnutrition paper\Analysis Files\c_2014",col(2) iscale(0.5)
//saving combined c curves for 2003 and 2014
graph save "Graph" "F:\Biostatistics\1 Malnutrition paper\Analysis Files\concentration_curves_2003_2004_combined.gph", replace
//as png format

*graph export "F:\Biostatistics\1 Malnutrition paper\Analysis Files\concentration_curves_2003_2004_combined.png", as(png) name("Graph")
***********************************************************************
*over the various socio-demographic characteristics
***********************************************************************
//Figure 2: HAZ, WAZ, WHZ in 2003 and 2014 by SSE over Religion 
//2003
use "F:\Biostatistics\1 Malnutrition paper\Analysis Files\kdhs_2003a.dta", clear
*replace religion=. if religion==6
clorenz haz whz waz, rank(wealth_index) hgroup( religion) title("HAZ, WAZ, and WHZ by SES over Religion in 2003" )
graph save Graph "F:\Biostatistics\1 Malnutrition paper\Analysis Files\2003_over_religion.gph",replace
//2014
use "F:\Biostatistics\1 Malnutrition paper\Analysis Files\kdhs_2014a.dta" ,clear
clorenz haz whz waz, rank(wealth_index) hgroup( religion) title("HAZ, WAZ, and WHZ by SES over Religion in 2014" )
graph save Graph "F:\Biostatistics\1 Malnutrition paper\Analysis Files\2014_over_religion.gph",replace
*graph combine
gr combine "F:\Biostatistics\1 Malnutrition paper\Analysis Files\2003_over_religion.gph" "F:\Biostatistics\1 Malnutrition paper\Analysis Files\2014_over_religion",col(2) iscale(0.5)
graph save "Graph" "F:\Biostatistics\1 Malnutrition paper\Analysis Files\c_curves_2003_2014_religion.gph", replace
*as png format
*graph export "F:\Biostatistics\1 Malnutrition paper\Analysis Files\c_curves_2003_2014_religion.png", as(png) name("Graph")
*************************************************************************
//Figure 3: HAZ, WAZ, WHZ in 2003 and 2014 by SSE over Education
//2003
*replace religion=. if religion==6
use "F:\Biostatistics\1 Malnutrition paper\Analysis Files\kdhs_2003a.dta", clear
clorenz haz whz waz, rank(wealth_index) hgroup( educ_level) title("HAZ, WAZ, and WHZ by SES over Education in 2003" )
graph save Graph "F:\Biostatistics\1 Malnutrition paper\Analysis Files\2003_over_education.gph",replace
//2014
use "F:\Biostatistics\1 Malnutrition paper\Analysis Files\kdhs_2014a.dta" ,clear
clorenz haz whz waz, rank(wealth_index) hgroup( educ_level) title("HAZ, WAZ, and WHZ by SES over Education in 2014" )
graph save Graph "F:\Biostatistics\1 Malnutrition paper\Analysis Files\2014_over_education.gph",replace
*graph combine
gr combine "F:\Biostatistics\1 Malnutrition paper\Analysis Files\2003_over_education.gph" "F:\Biostatistics\1 Malnutrition paper\Analysis Files\2014_over_education",col(2) iscale(0.5)
graph save "Graph" "F:\Biostatistics\1 Malnutrition paper\Analysis Files\c_curves_2003_2014_education.gph", replace
*as png format
*graph export "F:\Biostatistics\1 Malnutrition paper\Analysis Files\c_curves_2003_2014_education.png", as(png) name("Graph")
***********************************************************************
//Figure 4:HAZ, WAZ, WHZ in 2003 and 2014 by SSE over Residence
***********************************************************************
//2003
use "F:\Biostatistics\1 Malnutrition paper\Analysis Files\kdhs_2003a.dta", clear
clorenz haz whz waz, rank(wealth_index) hgroup( residence) title("HAZ, WAZ, and WHZ by SES over Residence in 2003" )
graph save Graph "F:\Biostatistics\1 Malnutrition paper\Analysis Files\2003_over_residence.gph",replace
//2014
use "F:\Biostatistics\1 Malnutrition paper\Analysis Files\kdhs_2014a.dta" ,clear
clorenz haz whz waz, rank(wealth_index) hgroup( residence) title("HAZ, WAZ, and WHZ by SES over Residence in 2014" )
graph save Graph "F:\Biostatistics\1 Malnutrition paper\Analysis Files\2014_over_residence.gph",replace
*graph combine
gr combine "F:\Biostatistics\1 Malnutrition paper\Analysis Files\2003_over_residence.gph" "F:\Biostatistics\1 Malnutrition paper\Analysis Files\2014_over_residence",col(2) iscale(0.5)
graph save "Graph" "F:\Biostatistics\1 Malnutrition paper\Analysis Files\c_curves_2003_2014_residence.gph", replace
*as png format
*graph export "F:\Biostatistics\1 Malnutrition paper\Analysis Files\c_curves_2003_2014_residence.png", as(png) name("Graph")

***********************************************************************
//Figure 5:HAZ, WAZ, WHZ in 2003 and 2014 by SSE over Gender
***********************************************************************
//2003
use "F:\Biostatistics\1 Malnutrition paper\Analysis Files\kdhs_2003a.dta", clear
clorenz haz whz waz, rank(wealth_index) hgroup( sex) title("HAZ, WAZ, and WHZ by SES over Gender in 2003" )
graph save Graph "F:\Biostatistics\1 Malnutrition paper\Analysis Files\2003_over_gender.gph",replace
//2014
use "F:\Biostatistics\1 Malnutrition paper\Analysis Files\kdhs_2014a.dta" ,clear
clorenz haz whz waz, rank(wealth_index) hgroup( sex) title("HAZ, WAZ, and WHZ by SES over Gender in 2014" )
graph save Graph "F:\Biostatistics\1 Malnutrition paper\Analysis Files\2014_over_gender.gph",replace
*graph combine
gr combine "F:\Biostatistics\1 Malnutrition paper\Analysis Files\2003_over_gender.gph" "F:\Biostatistics\1 Malnutrition paper\Analysis Files\2014_over_gender",col(2) iscale(0.5)
graph save "Graph" "F:\Biostatistics\1 Malnutrition paper\Analysis Files\c_curves_2003_2014_gender.gph", replace
*as png format
*graph export "F:\Biostatistics\1 Malnutrition paper\Analysis Files\c_curves_2003_2014_gender.png", as(png) name("Graph")
************************************************************************









