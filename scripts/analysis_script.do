*********************************************************************
* Socio-Economic Disparities in Child Malnutrition: Evidence from the Kenya Demographic and Health Surveys (2014 -- 2022)
* Amos Ochieng Okutse
* Brown University
* School of Public Health, Providence, RI, USA
***********************************************************
*After data preparation
***********************************************************


*load the combined dataset
use "/Users/aokutse/Desktop/malnutrition/cleaned/kdhs.dta", clear

cd "/Users/aokutse/Desktop/malnutrition/results"

// consider the complex survey design
svyset psu [pweight = wt], strata(stratum) singleunit(centered) vce(linearized) // singleunit(centered) option accounts for the case if there is a single PSU within a stratum and adjusts for the possibility of correlated obs within the strata. vce(linearized) option uses the Taylor expansion for variance estimation which is efficient

// Table 1: Weighted prevalence of child malnutrition in Kenya by selected factors
svy: tab syear, count column perc format(%9.0f) // weighted sample size and proportion of n by year
svy: tab child_sex, count column perc format(%9.0f)

svy: tab child_sex if syear == 0, count column perc format(%9.0f)
// 2014 stunting
svy: tab stunted if syear == 0, count column perc format(%9.0f)
svy: tab child_sex stunted if syear == 0, count column perc format(%9.1f)
svy: tab residence stunted if syear == 0, count column perc format(%9.1f)
svy: tab religion stunted if syear == 0, count column perc format(%9.1f)
svy: tab wealth_index stunted if syear == 0, count column perc format(%9.1f)
svy: tab maternal_edu stunted if syear == 0, count column perc format(%9.1f)
svy: tab maternal_age stunted if syear == 0, count column perc format(%9.1f)
svy: tab maternal_work stunted if syear == 0, count column perc format(%9.1f)
svy: tab paternal_edu stunted if syear == 0, count column perc format(%9.1f)
svy: tab delivery_place stunted if syear == 0, count column perc format(%9.1f)
svy: tab region stun if syear == 0, count column perc format(%9.1f)

svy: mean childs_age if syear == 0, over(stunted)
svy: regress stunted childs_age if syear == 0		// test of significance of difference in group means
svy: mean birth_order if syear == 0, over(stunted)
svy: regress stunted birth_order if syear == 0		// test of significance of difference in group means
svy: mean birth_interval if syear == 0, over(stunted)	
svy: regress stunted birth_interval if syear == 0	// test of significance of difference in group means	
		
		
		
// 2014 underweight
svy: tab underweight if syear == 0, count column perc format(%9.0f)
svy: tab child_sex underweight if syear == 0, count column perc format(%9.1f)
svy: tab residence underweight if syear == 0, count column perc format(%9.1f)
svy: tab religion underweight if syear == 0, count column perc format(%9.1f)
svy: tab wealth_index underweight if syear == 0, count column perc format(%9.1f)
svy: tab maternal_edu underweight if syear == 0, count column perc format(%9.1f)
svy: tab maternal_age underweight if syear == 0, count column perc format(%9.1f)
svy: tab maternal_work underweight if syear == 0, count column perc format(%9.1f)
svy: tab paternal_edu underweight if syear == 0, count column perc format(%9.1f)
svy: tab delivery_place underweight if syear == 0, count column perc format(%9.1f)
svy: tab region und if syear == 0, count column perc format(%9.1f)

svy: mean childs_age if syear == 0, over(underweight)
svy: regress underweight childs_age if syear == 0		// test of significance of difference in group means
svy: mean birth_order if syear == 0, over(underweight)
svy: regress underweight birth_order if syear == 0		// test of significance of difference in group means
svy: mean birth_interval if syear == 0, over(underweight)	
svy: regress underweight birth_interval if syear == 0	// test of significance of difference in group means	



// 2014 wasting
svy: tab wasted if syear == 0, count column perc format(%9.0f)
svy: tab child_sex wasted if syear == 0, count column perc format(%9.1f)
svy: tab residence wasted if syear == 0, count column perc format(%9.1f)
svy: tab religion wasted if syear == 0, count column perc format(%9.1f)
svy: tab wealth_index wasted if syear == 0, count column perc format(%9.1f)
svy: tab maternal_edu wasted if syear == 0, count column perc format(%9.1f)
svy: tab maternal_age wasted if syear == 0, count column perc format(%9.1f)
svy: tab maternal_work wasted if syear == 0, count column perc format(%9.1f)
svy: tab paternal_edu wasted if syear == 0, count column perc format(%9.1f)
svy: tab delivery_place wasted if syear == 0, count column perc format(%9.1f)
svy: tab region wast if syear == 0, count column perc format(%9.1f)

svy: mean childs_age if syear == 0, over(wasted)
svy: regress wasted childs_age if syear == 0		// test of significance of difference in group means
svy: mean birth_order if syear == 0, over(wasted)
svy: regress wasted birth_order if syear == 0		// test of significance of difference in group means
svy: mean birth_interval if syear == 0, over(wasted)	
svy: regress wasted birth_interval if syear == 0	// test of significance of difference in group means

////////////////////////////////////////////////////////////////////////////////
// 2022 stunting
svy: tab stunted if syear == 1, count column perc format(%9.0f)
svy: tab child_sex stunted if syear == 1, count column perc format(%9.1f)
svy: tab residence stunted if syear == 1, count column perc format(%9.1f)
svy: tab religion stunted if syear == 1, count column perc format(%9.1f)
svy: tab wealth_index stunted if syear == 1, count column perc format(%9.1f)
svy: tab maternal_edu stunted if syear == 1, count column perc format(%9.1f)
svy: tab maternal_age stunted if syear == 1, count column perc format(%9.1f)
svy: tab maternal_work stunted if syear == 1, count column perc format(%9.1f)
svy: tab paternal_edu stunted if syear == 1, count column perc format(%9.1f)
svy: tab delivery_place stunted if syear == 1, count column perc format(%9.1f)
svy: tab region und if syear == 1, count column perc format(%9.1f)

svy: mean childs_age if syear == 1, over(stunted)
svy: regress stunted childs_age if syear == 1		// test of significance of difference in group means
svy: mean birth_order if syear == 1, over(stunted)
svy: regress stunted birth_order if syear == 1		// test of significance of difference in group means
svy: mean birth_interval if syear == 1, over(stunted)	
svy: regress stunted birth_interval if syear == 1	// test of significance of difference in group means	
		
		
		
// 2022 underweight
svy: tab underweight if syear == 1, count column perc format(%9.0f)
svy: tab child_sex underweight if syear == 1, count column perc format(%9.1f)
svy: tab residence underweight if syear == 1, count column perc format(%9.1f)
svy: tab religion underweight if syear == 1, count column perc format(%9.1f)
svy: tab wealth_index underweight if syear == 1, count column perc format(%9.1f)
svy: tab maternal_edu underweight if syear == 1, count column perc format(%9.1f)
svy: tab maternal_age underweight if syear == 1, count column perc format(%9.1f)
svy: tab maternal_work underweight if syear == 1, count column perc format(%9.1f)
svy: tab paternal_edu underweight if syear == 1, count column perc format(%9.1f)
svy: tab delivery_place underweight if syear == 1, count column perc format(%9.1f)
svy: tab region und if syear == 1, count column perc format(%9.1f)

svy: mean childs_age if syear == 1, over(underweight)
svy: regress underweight childs_age if syear == 0		// test of significance of difference in group means
svy: mean birth_order if syear == 1, over(underweight)
svy: regress underweight birth_order if syear == 0		// test of significance of difference in group means
svy: mean birth_interval if syear == 1, over(underweight)	
svy: regress underweight birth_interval if syear == 1	// test of significance of difference in group means	



// 2022 wasting
svy: tab wasted if syear == 1, count column perc format(%9.0f)
svy: tab child_sex wasted if syear == 1, count column perc format(%9.1f)
svy: tab residence wasted if syear == 1, count column perc format(%9.1f)
svy: tab religion wasted if syear == 1, count column perc format(%9.1f)
svy: tab wealth_index wasted if syear == 1, count column perc format(%9.1f)
svy: tab maternal_edu wasted if syear == 1, count column perc format(%9.1f)
svy: tab maternal_age wasted if syear == 1, count column perc format(%9.1f)
svy: tab maternal_work wasted if syear == 1, count column perc format(%9.1f)
svy: tab paternal_edu wasted if syear == 1, count column perc format(%9.1f)
svy: tab delivery_place wasted if syear == 1, count column perc format(%9.1f)
svy: tab region wasted if syear == 1, count column perc format(%9.1f)

svy: mean childs_age if syear == 1, over(wasted)
svy: regress wasted childs_age if syear == 1		// test of significance of difference in group means
svy: mean birth_order if syear == 1, over(wasted)
svy: regress wasted birth_order if syear == 1		// test of significance of difference in group means
svy: mean birth_interval if syear == 1, over(wasted)	
svy: regress wasted birth_interval if syear == 1	// test of significance of difference in group means






*Table 2: Proportions of malnutrition in 2014 relative to 2022 by SSE
***********************************************************
*stunting
prtest stun if wealth_index ==1, by(syear) /*Poorest*/ 
prtest stun if wealth_index ==2, by(syear) /*Poorer*/
prtest stun if wealth_index ==3, by(syear) /*Middle*/
prtest stun if wealth_index ==4, by(syear) /*Richer*/
prtest stun if wealth_index ==5, by(syear) /*Richest*/
prtest stun, by(syear) /*ALL*/

*Underweight
prtest und if wealth_index ==1, by(syear) /*Poorest*/
prtest und if wealth_index ==2, by(syear) /*Poorer*/
prtest und if wealth_index ==3, by(syear) /*Middle*/
prtest und if wealth_index ==4, by(syear) /*Richer*/
prtest und if wealth_index ==5, by(syear) /*Richest*/
prtest und, by(syear) /*ALL*/

*wasted
prtest wast	if wealth_index ==1, by(syear) /*Poorest*/
prtest wast	if wealth_index ==2, by(syear) /*Poorer*/
prtest wast if wealth_index ==3, by(syear) /*Middle*/
prtest wast	if wealth_index ==4, by(syear) /*Richer*/
prtest wast	if wealth_index ==5, by(syear) /*Richest*/
prtest wast, by(syear) /*ALL*/


*Table 3: Concentration Indices of Child Malnutrition      
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

use "/Users/aokutse/Desktop/malnutrition/cleaned/kdhs2014.dta", clear
svyset psu [pweight = wt], strata(stratum) singleunit(centered) vce(linearized) 
digini haz haz, rank1(wealth_index) file2(/Users/aokutse/Desktop/malnutrition/cleaned/kdhs2022.dta) test(0) // stun 2014 vs 2022
digini waz waz , rank1(wealth_index) file2(/Users/aokutse/Desktop/malnutrition/cleaned/kdhs2022.dta) test(0) // und 2014 vs 2022
digini whz whz , rank1(wealth_index) file2(/Users/aokutse/Desktop/malnutrition/cleaned/kdhs2022.dta) test(0) // wast 2014 vs 2022



* Table 4: Determinants of child malnutrition
use "/Users/aokutse/Desktop/malnutrition/cleaned/kdhs.dta", clear
svyset psu [pweight = wt], strata(stratum) singleunit(centered) vce(linearized) 

set cformat %9.2f //changes # of dl places to 2 (%9.1f changes to 1 dlp)
// stunting
putdocx begin
xi:svy:logistic stun ib1.syear ib2.child_sex ib2.residence ib4.religion ib5.wealth_index ib0.maternal_edu ib0.maternal_age ib0.maternal_work ib0.paternal_edu ib0.delivery_place ib9.region birth_interval birth_order childs_age, noconstant
putdocx table stun=etable, title("Stunting Logit Regression Model")
putdocx save stunting_model.docx, replace
putdocx clear


// underweight
putdocx begin
xi:svy:logistic und ib1.syear ib2.child_sex ib2.residence ib4.religion ib5.wealth_index ib0.maternal_edu ib0.maternal_age ib0.maternal_work ib0.paternal_edu ib0.delivery_place ib9.region birth_interval birth_order childs_age, noconstant
putdocx table und=etable, title("Underweight Logit Regression Model")
putdocx save und_model.docx, replace
putdocx clear

// Wasting 
putdocx begin
xi:svy:logistic wast ib1.syear ib2.child_sex ib2.residence ib4.religion ib5.wealth_index ib0.maternal_edu ib0.maternal_age ib0.maternal_work ib0.paternal_edu ib0.delivery_place ib9.region birth_interval birth_order childs_age, noconstant
putdocx table was=etable, title("Wasting Logit Regression Model")
putdocx save was_model.docx, replace
putdocx clear


* Table 5: Decomposing the contribution of each significant socioeconomic determinant to child malnutrition

// 2014 stunting
// ssc install conindex 	// to compute the rank dependent concentration indices 

use "/Users/aokutse/Desktop/malnutrition/cleaned/kdhs2014.dta", clear
svyset psu [pweight = wt], strata(stratum) singleunit(centered) vce(linearized) 

conindex stun, rank(wealth_index) bounded limits(0 1) wagstaff svy // option svy declares that our dataset is a complex survey
sca CI = r(CI)

global X child_sex residence religion maternal_edu maternal_age maternal_work paternal_edu delivery_place region birth_interval birth_order childs_age wealth_index 

qui xi: svy: glm stun $X , family(binomial) link(logit)
// qui svy: glm stun $X [aw=weight], family(binomial) link(logit)

qui margins, dydx(*) post
mat coeff = e(b)
sum stun [aw=wt]
sca m_y=r(mean)

foreach x of varlist $X {
qui{
mat b_`x' = coeff[1,"`x'"]
sca b_`x' = b_`x'[1,1]

qui sum `x'
gen double scaled_`x' = `x'/r(max)
conindex scaled_`x', rank(wealth_index) bounded limits(0 1) wagstaff svy

sca CI_`x' = r(CI)
sum `x' [aw=wt]

sca elas_`x' = (b_`x' * r(mean))/m_y

sca con_`x' = elas_`x' * CI_`x'
sca prcnt_`x' = con_`x'/CI
}

di "`x' elasticity:", elas_`x'
di "`x' concentration index:", CI_`x'
di "`x' contribution:", con_`x'
di "`x' percentage contribution:", prcnt_`x'

}


// 2022 stunting

use "/Users/aokutse/Desktop/malnutrition/cleaned/kdhs2022.dta", clear
svyset psu [pweight = wt], strata(stratum) singleunit(centered) vce(linearized) 

conindex stun, rank(wealth_index) bounded limits(0 1) wagstaff svy // option svy declares that our dataset is a complex survey
sca CI = r(CI)

global X child_sex residence religion maternal_edu maternal_age maternal_work paternal_edu delivery_place region birth_interval birth_order childs_age wealth_index 

qui xi: svy: glm stun $X , family(binomial) link(logit)
// qui svy: glm stun $X [aw=weight], family(binomial) link(logit)

qui margins, dydx(*) post
mat coeff = e(b)
sum stun [aw=wt]
sca m_y=r(mean)

foreach x of varlist $X {
qui{
mat b_`x' = coeff[1,"`x'"]
sca b_`x' = b_`x'[1,1]

qui sum `x'
gen double scaled_`x' = `x'/r(max)
conindex scaled_`x', rank(wealth_index) bounded limits(0 1) wagstaff svy

sca CI_`x' = r(CI)
sum `x' [aw=wt]

sca elas_`x' = (b_`x' * r(mean))/m_y

sca con_`x' = elas_`x' * CI_`x'
sca prcnt_`x' = con_`x'/CI
}

di "`x' elasticity:", elas_`x'
di "`x' concentration index:", CI_`x'
di "`x' contribution:", con_`x'
di "`x' percentage contribution:", prcnt_`x'

}

drop scaled_child_sex - scaled_wealth_index

// 2014 underweight

conindex und, rank(wealth_index) bounded limits(0 1) wagstaff svy // option svy declares that our dataset is a complex survey
sca CI = r(CI)

global X child_sex residence religion maternal_edu maternal_age maternal_work paternal_edu delivery_place region birth_interval birth_order childs_age wealth_index 

qui xi: svy: glm und $X , family(binomial) link(logit)

qui margins, dydx(*) post
mat coeff = e(b)
sum und [aw=wt]
sca m_y=r(mean)

foreach x of varlist $X {
qui{
mat b_`x' = coeff[1,"`x'"]
sca b_`x' = b_`x'[1,1]

qui sum `x'
gen double scaled_`x' = `x'/r(max)
conindex scaled_`x', rank(wealth_index) bounded limits(0 1) wagstaff svy

sca CI_`x' = r(CI)
sum `x' [aw=wt]

sca elas_`x' = (b_`x' * r(mean))/m_y

sca con_`x' = elas_`x' * CI_`x'
sca prcnt_`x' = con_`x'/CI
}

di "`x' elasticity:", elas_`x'
di "`x' concentration index:", CI_`x'
di "`x' contribution:", con_`x'
di "`x' percentage contribution:", prcnt_`x'

}

// 2022 underweight
use "/Users/aokutse/Desktop/malnutrition/cleaned/kdhs2022.dta", clear
svyset psu [pweight = wt], strata(stratum) singleunit(centered) vce(linearized) 
conindex und, rank(wealth_index) bounded limits(0 1) wagstaff svy // option svy declares that our dataset is a complex survey
sca CI = r(CI)

global X child_sex residence religion maternal_edu maternal_age maternal_work paternal_edu delivery_place region birth_interval birth_order childs_age wealth_index 

qui xi: svy: glm und $X , family(binomial) link(logit)

qui margins, dydx(*) post
mat coeff = e(b)
sum und [aw=wt]
sca m_y=r(mean)

foreach x of varlist $X {
qui{
mat b_`x' = coeff[1,"`x'"]
sca b_`x' = b_`x'[1,1]

qui sum `x'
gen double scaled_`x' = `x'/r(max)
conindex scaled_`x', rank(wealth_index) bounded limits(0 1) wagstaff svy

sca CI_`x' = r(CI)
sum `x' [aw=wt]

sca elas_`x' = (b_`x' * r(mean))/m_y

sca con_`x' = elas_`x' * CI_`x'
sca prcnt_`x' = con_`x'/CI
}

di "`x' elasticity:", elas_`x'
di "`x' concentration index:", CI_`x'
di "`x' contribution:", con_`x'
di "`x' percentage contribution:", prcnt_`x'

}


*Table 6: Sensitivity of screening using the significant determinants

use "/Users/aokutse/Desktop/malnutrition/cleaned/kdhs.dta", clear
svyset psu [pweight = wt], strata(stratum) singleunit(centered) vce(linearized) 

// stunting

splitsample, generate(sample) nsplit(2) rseed(1234) // split sample into train and test

lasso logit stun ib1.syear ib2.child_sex ib2.residence ib4.religion ib5.wealth_index ib0.maternal_edu ib0.maternal_age ib0.maternal_work ib0.paternal_edu ib0.delivery_place ib9.region birth_interval birth_order childs_age if sample == 1 [iw = wt] // test on sample == 1 and refit the risk score model on the full data
estimates store mod_stunt // save the estimated coefficients from the stun lasso model

// see selected covariates
lassocoef mod_stunt, sort(coef, standardized)

lassogof mod_stunt, over(sample) postselection // evaluation of the lasso model



// stun 
//xi:svy:logistic stun ib1.syear ib2.child_sex ib2.residence ib4.religion ib5.wealth_index ib0.maternal_edu ib0.maternal_age ib0.maternal_work ib0.paternal_edu ib0.delivery_place ib9.region birth_interval birth_order childs_age

//estat svyset ic //
//estat classify
//margins, dydx(*)
//marginsplot

/////////////////////////////////////

// revised code
* Setting up the complex survey design
use "/Users/aokutse/Desktop/malnutrition/cleaned/kdhs2014.dta", clear
* Setting up the complex survey design
svyset psu [pweight = wt], strata(stratum) singleunit(centered) vce(linearized)

* Calculation of Concentration Index for the Outcome
conindex stun, rank(wealth_index) bounded limits(0 1) wagstaff svy
sca CI = r(CI)

* Variables list without factor variable notation
global X child_sex residence religion maternal_edu maternal_age maternal_work paternal_edu delivery_place region wealth_index 

* GLM modeling using factor variable notation for categorical variables
svy: glm stun i.child_sex i.residence i.religion i.maternal_edu i.maternal_age i.maternal_work i.paternal_edu i.delivery_place i.region i.wealth_index, family(binomial) link(logit)

* Calculate average marginal effects
qui margins, dydx(*) post
mat coeff = e(b)

* Mean of outcome variable
sum stun [aw=wt]
sca m_y = r(mean)

* Create a temporary dataset to store decomposition results
clear
gen varname = ""
gen category = ""
gen elasticity = .
gen conc_index = .
gen contribution = .
gen perc_contrib = .

* Decomposition
foreach x of global X {

    if inlist("`x'", "child_sex", "residence", "religion", "maternal_edu", "maternal_age", "maternal_work", "paternal_edu", "delivery_place", "region", "wealth_index") {
        
        qui levelsof `x', local(categories)

        foreach cat of local categories {
            capture conindex `x' if `x' == `cat', rank(wealth_index) bounded limits(0 1) wagstaff svy

            if _rc != 0 {
                continue
            }

            local CI_`x'_`cat' = r(CI)
            local b_`x'_`cat' = coeff[1,"`x'[`cat']"]
            local elas_`x'_`cat' = (b_`x'_`cat' * r(mean))/m_y
            local con_`x'_`cat' = elas_`x'_`cat' * CI_`x'_`cat'
            local prcnt_`x'_`cat' = con_`x'_`cat'/CI
            
            * Store in dataset
            replace varname = "`x'" in 1
            replace category = "`cat'" in 1
            replace elasticity = `elas_`x'_`cat'' in 1
            replace conc_index = `CI_`x'_`cat'' in 1
            replace contribution = `con_`x'_`cat'' in 1
            replace perc_contrib = `prcnt_`x'_`cat'' in 1

            * Prepare for next result
            set obs _N+1
        }
    } else {

        conindex `x', rank(wealth_index) bounded limits(0 1) wagstaff svy

        local CI_`x' = r(CI)
        local b_`x' = coeff[1,"`x'"]
        local elas_`x' = (b_`x' * r(mean))/m_y
        local con_`x' = elas_`x' * CI_`x'
        local prcnt_`x' = con_`x'/CI

        * Store in dataset
        replace varname = "`x'" in 1
        replace elasticity = `elas_`x'' in 1
        replace conc_index = `CI_`x'' in 1
        replace contribution = `con_`x'' in 1
        replace perc_contrib = `prcnt_`x'' in 1

        * Prepare for next result
        set obs _N+1
    }
}


* Child stunting could be predicted by SES, Age, Gender, and BORD. But what is the clinical utility of these predictors for it? How good are they?

* We test how good these actually are starting with SES
use "/Users/aokutse/Desktop/malnutrition/cleaned/kdhs.dta", clear
svyset psu [pweight = wt], strata(stratum) singleunit(centered) vce(linearized)
*xi:svy:logistic stun ib1.syear ib2.child_sex ib2.residence ib4.religion ib5.wealth_index ib0.maternal_edu ib0.maternal_age ib0.maternal_work ib0.paternal_edu ib0.delivery_place ib9.region birth_interval birth_order childs_age, noconstant

*******************************************************
*SCREENING FOR STUNTING USING HOUSEHOLD SES, CHILD AGE, BORD, & GENDER
*******************************************************

/*SES*/
xi:svy: logistic stun ib5.wealth_index
logistic stun ib5.wealth_index
* compute the classification matrix based on using this covariate as a diagnostic test. we set the cutoff to the mean of the outcome due to class imbalance and the fact that the model has high percentage correctly predicted (hit ratio) and very low explanatory power (see ). 
sum stun if e(sample)
estat classification, cutoff(`r(mean)') /* estat classification only works with non-survey data: use threshold moving to counter imbalanced data*/

/* predict probability of stunting given SES*/
predict sesmod, pr
/*classify as either stunted or not given this probability if greater than 0.50 */
gen se_stun = (sesmod >= 0.2)

/* use the diagt command to estimate the diagnostic efficacy of SES as a proxy*/
diagti 5509 2663 13752 14059, level(95)

/*CHILDS AGE*/
logistic stun childs_age
sum stun if e(sample)
estat classification, cutoff(`r(mean)')
diagti 4055 4117 13191 14620, level(95)

/*CHILD GENDER*/
logistic stun child_sex
sum stun if e(sample)
estat classification, cutoff(`r(mean)')
diagti 4654 3518 13573 14238, level(95)


/*BORD*/
logistic stun birth_order
sum stun if e(sample)
estat classification, cutoff(`r(mean)')
diagti 3670 4502 10073 17738, level(95)





****
* Load your data
*use "your_data.dta"

* Split your data into training and test datasets
*sample 70, count
*gen byte train = _n <= _N
*gen byte test = _n > _N

* Fit your model on the training dataset
*logit outcome_var independent_vars if train

* Predict probabilities on the test dataset

*install package roctab
*ssc install roctab
***


**********************************
* Algorithm for threshold moving
**********************************
xi:svy: logistic stun ib5.wealth_index
predict double pred_prob, pr

* Initialize best threshold and best metric
local best_threshold = .
local best_metric = .

* Loop over potential thresholds
forvalues t = 0(.01)1 {
    * Generate predicted outcome based on threshold
    gen byte pred_outcome = (pred_prob >= `t')

    * Calculate your evaluation metric
    roctab stun pred_outcome, graph
    local metric = r(area)

    * Update best threshold and best metric if necessary
    if `metric' > `best_metric' {
        local best_threshold = `t'
        local best_metric = `metric'
    }

    * Drop the temporary variable
    drop pred_outcome
}

* Display the best threshold
display `best_threshold'
drop pred_prob pred_outcome

