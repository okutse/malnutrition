*********************************************************************
*Trends and Patterns of Disparities in Kenyan Under 5 Child Malnutrition Burden
*Amos Ochieng Okutse
*okutseamos@gmail.com
*Henry Athiany
*henry.athiany@jkuat.ac.ke
************************************************************************

/*Loading the 2003 DHS data for use*/
use kdhs_2003.dta, clear
***********************************************************************
***********************************************************************
drop ID_Variable

*anthropometry calculations
//simple sample weighting using DHS for clusters only, no strata; must multiply by 1000000
*gen weight=V005/1000000
*svyset [pweight=weight], psu(V021)

//hw15 is lying (1) and standing (2) height measure; clean DHS code
gen newm=HW15 if HW15!=9
//hw3 is height, clean DHS code and converts to cm
gen newh=HW3/10 if HW3!=9999
//hw2 is Weight in kg to one decimal w/o the decimal; convert to kg w/decimal; clean DHS code and
gen neww=HW2/10 if HW2!=999
//run zscore06. age in months (hw1) and gender (b4) need no cleaning in this dataset
*ssc install zscore06
zscore06, a(HW1) s(B4) h(newh) w(neww) measure(newm) male(1) female(2)


//remove biologically implausible scores; and set them to missing
replace haz06=. if haz06<-6 | haz06>6
replace waz06=. if waz06<-6 | waz06>5
replace whz06=. if whz06<-5 | whz06>5
replace bmiz06=. if bmiz06<-5 | bmiz06>5


* rename variables to more familiar names

rename waz06 waz
rename haz06 haz
rename bmiz06 bmiz
rename whz06 whz

//regrouping the three variables into categories
// stunting
gen stunting = 1 if haz <-2
replace stunting = 0 if missing(stunting) & !missing(haz)
label values stunting stunted 
label def stunted 0 "No", modify
label def stunted 1 "Yes", modify

//underweight
gen underweight = 1 if waz <-2
replace underweight = 0 if missing(underweight) & !missing(waz)
label values underweight underweight
label def underweight 0 "No", modify
label def underweight 1 "Yes", modify

//wasting
gen wasting = 1 if whz <-2
replace wasting = 0 if missing(wasting) & !missing(whz)
label values wasting wasted 
label def wasted 0 "No", modify
label def wasted 1 "Yes", modify

//keep only variables needed for further analysis and clean names
keep V005 V001 HW1 HW2 HW3 HW15 B4 V102 V021 V130 V106 BORD V024 M15 B11 V212 wealth_index haz waz whz bmiz stunting underweight wasting
rename V005 weights
rename V001 cluster_no
rename B4 sex
rename V102 residence
rename V130 religion
rename V106 educ_level
rename V021 pri_sample_unit
rename HW1 age_mnths
rename HW3 height_cms
rename HW2 weight_kgs
rename BORD birth_order
rename V024 region
rename M15 delivery_place
rename B11 birth_interval
rename V212 motherage_firstbirth
label variable stunting "stunted"
label variable underweight "underweight"
label variable wasting "wasted"

//proportions of malnutrition indicators with missing values
tab stunting, mis
tab underweight,mis
tab wasting,mis


//order and save the 2003 dataset
keep weights cluster_no age_mnths sex residence religion educ_level birth_order region delivery_place birth_interval motherage_firstbirth wealth_index haz waz whz stunting underweight wasting
order weights cluster_no age_mnths sex residence religion educ_level birth_order region delivery_place birth_interval motherage_firstbirth wealth_index haz waz whz stunting underweight wasting
replace religion=. if religion==9 | religion==96
replace delivery_place=. if delivery_place==99

save "kdhs_2003a.dta", replace



//loading the 2014 dataset for use
use kdhs_2014, clear
//keep only relevant variables
keep v005 v001 hw1 hw2 hw3 hw15 b4 v102 v021 v130 v106 bord v024 m15 b11 v212 v190 hw70 hw71 hw72 hw73 
rename hw70 haz
rename hw71 waz
rename hw72 whz
rename hw73 bmi
rename v005 weights
rename v001 cluster_no
rename b4 sex
rename v102 residence
rename v130 religion
rename v106 educ_level
rename v021 pri_sample_unit
rename hw1 age_mnths
rename hw3 height_cms
rename hw2 weight_kgs
rename v190 wealth_index
rename bord birth_order
rename v024 region
rename m15 delivery_place
rename b11 birth_interval
rename v212 motherage_firstbirth
//
*check on some of the variables and replace missing value codes
replace waz=. if waz==9996 | waz==9998
replace haz=. if haz==9996 | haz==9998
replace whz=. if whz==9996 | whz==9998
//regrouping into categories the waz, haz, whz
// stunting
gen stunting = 1 if haz <-200
replace stunting = 0 if missing(stunting) & !missing(haz)
label values stunting stunted 
label def stunted 0 "No", modify
label def stunted 1 "Yes", modify

//underweight
gen underweight = 1 if waz <-200
replace underweight = 0 if missing(underweight) & !missing(waz)
label values underweight underweight
label def underweight 0 "No", modify
label def underweight 1 "Yes", modify

//wasting
gen wasting = 1 if whz <-200
replace wasting = 0 if missing(wasting) & !missing(whz)
label values wasting wasted 
label def wasted 0 "No", modify
label def wasted 1 "Yes", modify
**************************************************
label variable stunting "stunted"
label variable underweight "underweight"
label variable wasting "wasted"
//basic tabulations of malnutrition indicators
tab stunting, miss
tab underweight, miss
tab wasting, miss
//ordering and keeping
keep weights cluster_no age_mnths sex residence religion educ_level birth_order region delivery_place birth_interval motherage_firstbirth wealth_index haz waz whz stunting underweight wasting
order weights cluster_no age_mnths sex residence religion educ_level birth_order region delivery_place birth_interval motherage_firstbirth wealth_index haz waz whz stunting underweight wasting
replace religion=. if religion==9 | religion==96
//saving the new 2014 dataset
save kdhs_2014a.dta, replace
*************************************************
use kdhs_2003a.dta, clear
gen syear=0
*use "F:\Biostatistics\1 Malnutrition paper\Analysis Files\kdhs_2014a.dta"
append using kdhs_2014a.dta
//indicator for the 2014 dataset
replace syear=1 if syear==.
//labeling survey year values
label values syear labels6
label define labels6 0 "DHS2003" 1 "DHS2014", replace
//sample sizes in dataset by year
tab syear, mis

*saving the cleaned combined dataset
save "D:\Biostatistics\1 Malnutrition paper\revised_analysis\clean_combined_data\clean_df.dta", replace


