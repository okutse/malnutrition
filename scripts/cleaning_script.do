************************************************************************
*Trends and Patterns of Disparities in Kenyan Under 5 Child Malnutrition Burden
*Amos Ochieng Okutse
*okutseamos@gmail.com
*Henry Athiany
*henry.athiany@jkuat.ac.ke
************************************************************************

//loading the 2014 dataset for use. We will be using the childrens recode file which has one record for every child of interviewed women, born in the five years preceding the survey.

use "/Users/aokutse/Desktop/malnutrition/rawdhs/raw2014/KEKR72FL.DTA", clear


//keep only variables of interest in adjustment
keep v021 v023 v005 hw70 hw71 hw72 b4 v102 v130 v106 bord hw1 v190 v024 m15 b11 v212      

// rename variables selected from the data set

	// sample design variables
	rename v021 psu		/* primary sampling unit */
	rename v023 stratum /* stratification used in sample design */
	rename v005 weight	/* women's individual sample weight 6 dlp */
	
	// generate the correct weight variable to use in weighted analyses and drop the weight variable 
	gen wt = weight/1000000
	drop weight
	
	// malnutrition indicators have 2 implied decimal points and thus are divided by 100 to get them in the right form for analysis
	gen haz = hw70/100	/* height for age */
	gen waz = hw71/100	/* weight for age */
	gen whz = hw72/100	/* weight for height */
	
	// demographic and socioeconomic variables
	rename b4 child_sex	  	/* sex of child */
	rename v102 residence 	/* type of place of residence */
	rename v130 religion  	/* religion */
	rename v106 educ_level	/* mothers highest education level attended */
	rename bord birth_order /* the order in which the children were born */
	rename hw1 childs_age	/* child's age in months */
	rename v190 wealth_index /* wealth index */
	rename v024 region 		/*de facto region of residence */
	rename m15 delivery_place /* place of delivery */
	rename b11 birth_interval /* Preceding birth interval is calculated as the difference in months between the current birth and the previous birth */
	*rename v212 age_at_firstbrth /* age of respondent at first birth computed as the difference between the birth date of the first-born child and birth date of the woman */
	
	
	
	
	
	
	
* TO DO
* check all missing values and other inconsistencies in all variables for analysis	
* check how the variables are coded to see which levels to use as reference in analysis
* create the categorical versions of variables of interest including child's age, education, mothers age, fathers education, maternal bmi, maternal height, maternal working status, 
* save the cleaned data set after all modifications

* clean the DHS 2022 data and save

* append the 2014 and 2022 data files for final analysis


*rename b4 sex
*rename v102 residence
*rename v130 religion
*rename v106 educ_level
*rename v021 pri_sample_unit
*rename hw1 age_mnths
*rename hw3 height_cms
*rename hw2 weight_kgs
*rename v190 wealth_index
*rename bord birth_order
*rename v024 region
rename m15 delivery_place
rename b11 birth_interval
mothers_age
mothers wrking status

*rename v212 motherage_firstbirth
//
*check on some of the variables and replace missing value codes
replace waz = . if waz == 9996 | waz == 9998
replace haz = . if haz == 9996 | haz == 9998
replace whz = . if whz == 9996 | whz == 9998

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


