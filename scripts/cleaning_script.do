************************************************************************
* Trends and Patterns of Disparities in Kenyan Under 5 Child Malnutrition Burden
* Amos Ochieng Okutse
* amos_okutse@brown.edu
************************************************************************

///////////////////////////////////////
// DHS 2014
///////////////////////////////////////

// loading the 2014 dataset for use. We will be using the childrens recode file which has one record for every child of interviewed women, born in the five years preceding the survey.
set more off
clear
use "/Users/aokutse/Desktop/malnutrition/rawdhs/raw2014/KEKR72FL.DTA", clear

// keep only variables of interest in adjustment
keep v021 v023 v005 hw70 hw71 hw72 b4 v102 v130 v106 bord hw1 v190 v024 m15 b11 v012 v714 v701 v438 v437 v322  


// describe data set in memory
describe

// rename variables selected from the data set

	// sample design variables
	rename v021 psu		/* primary sampling unit */
	rename v023 stratum /* stratification used in sample design */
	rename v005 weight	/* women's individual sample weight 6 dlp */
	
	// generate the correct weight variable to use in weighted analyses and drop the weight variable 
	gen wt = weight/1000000
	label variable wt "weight"
	drop weight
	
	// malnutrition indicators have 2 implied decimal points and thus are divided by 100 to get them in the right form for analysis
	tab hw70, missing
	codebook hw70 		//check how the variable was coded
	// replace coded missing values as missing in hw70 
	replace hw70 = . if hw70 == 9999 | hw70 == 999 | hw70 == 99 | hw70 == 9 | hw70 == 9998 | hw70 == 7 | hw70 == 9996
	gen haz = hw70/100	/* height for age */
	label variable haz "height/age"
	
	tab hw71, missing
	replace hw71 = . if hw71 == 9996 | hw71 == 9998 | hw71 == 9997
	tab hw71, missing
	gen waz = hw71/100	/* weight for age */
	label var waz "weight/age"
	
	tab hw72, missing
	replace hw72 = . if hw72 == 9996 | hw72 == 9998 | hw72 == 9997
	tab hw72, missing
	gen whz = hw72/100	/* weight for height */
	label var whz "weight/height"
	
	drop hw70 hw71 hw72 

// categorize the malnutrition indicators	
// stunting
gen stunted = 1 if haz < -2.00
replace stunted = 0 if missing(stunted) & !missing(haz)
label values stunted stunted 
label def stunted 0 "No", modify
label def stunted 1 "Yes", modify
label var stunted "stunted"	
tab stunted, missing
	
// underweight
gen underweight = 1 if waz < -2.00
replace underweight = 0 if missing(underweight) & !missing(waz)
label values underweight underweight
label def underweight 0 "No", modify
label def underweight 1 "Yes", modify
label var underweight "underweight"
tab underweight, missing

// wasting
gen wasted = 1 if whz < -2.00
replace wasted = 0 if missing(wasted) & !missing(whz)
label values wasted wasted 
label def wasted 0 "No", modify
label def wasted 1 "Yes", modify
label var wasted "wasted"	
tab wasted, missing


	// demographic and socioeconomic variables
	rename b4 child_sex	  	/* sex of child: 1 = male, 2 = female */
	rename v102 residence 	/* type of place of residence: 1 = urban, 2 = rural (ref) */
	rename v130 religion  	/* religion: 1 = roman catholic, 2 = protestant/other xtian, 3 = muslim, 4 = no religion (ref) */
	rename v106 educ_level	/* mothers highest education level attended */
	rename bord birth_order /* the order in which the children were born */
	rename hw1 childs_age	/* child's age in months */
	rename v190 wealth_index /* wealth index */
	rename v024 region 		/* de facto region of residence */
	rename m15 delivery_place /* place of delivery */
	rename b11 birth_interval /* Preceding birth interval calculated as the difference in months between the current birth and the previous birth */
	rename v012 mothers_age		/* current age in completed years of the respondent: continuos (<=24, 25-34, >=35 yrs) */
	rename v714 maternal_work	/* respondent currently working: categorical */
	rename v70 husband_educ		/* partners highest education level */
	rename v438 m_height /* height of the respondent in cms: divide by 10 and convert to meters */
	rename v437 m_weight	/* respondent weight in kg: divide by 10. To compute bmi divide weight in kgs by height in meters*/
	rename v322 m_parity /* parity at sterilization */
	
	
// cleaning up the variables as necessary
codebook child_sex
codebook residence
codebook religion

// convert code 96 (other) to missing value 
replace religion = . if religion == 96
tab religion, missing
tab religion, missing nolabel // no religion (reference = 4)

// education level: recoded to combine secondary and higher education (reference = 0)
codebook educ_level 
tab educ_level, missing
recode educ_level (0 = 0 None) (1 = 1 Primary) (2/3=2 ">= Secondary"), gen(maternal_edu)
tab maternal_edu, missing // no education (reference = 0)
drop educ_level

// birth order analyzed as continuous
// childs_age analyzed as continuous

// wealth index: 1 = poorest (reference) ... 5 = richest
codebook wealth_index

// region of residence: 1 = coast (reference) ... 9 = nairobi
codebook region

// delivery place: to be recoded
codebook delivery_place
tab delivery_place, nolabel
tab delivery_place, missing

recode delivery_place (11/12 = 0 Home) (21 22 23 26 = 1 "Public sector") (31 32 33 36 = 2 "Private sector") (96 = 3 Other), gen(dlv_place)
tab dlv_place, missing
drop delivery_place
	
// birth interval analyzed as continuos

// mothers age: 
tab mothers_age, missing nolabel
recode mothers_age (15/24 = 0 "<= 24 yrs") (25/34 = 1 "25-34 yrs") (35/49 = 2 ">= 35 yrs"), gen(maternal_age)
tab maternal_age, missing

// maternal work: 0 = no, 1 = yes (reference = 0)
tab maternal_work, nolabel missing
label define mat_work 0 "No" 1 "Yes"
label values maternal_work mat_work
tab maternal_work

// fathers education level 
tab husband_educ, nolabel missing
tab husband_educ 
replace husband_educ = . if husband_educ == 8
recode husband_educ (0 = 0 None) (1 = 1 Primary) (2/3=2 ">= Secondary"), gen(paternal_edu)
drop husband_educ


// save the cleaned 2014 data set for further analysis
save "/Users/aokutse/Desktop/malnutrition/cleaned/kdhs2014.dta", replace


////////////////////////////////////////////////////////////////////////////////
// DHS 2022
////////////////////////////////////////////////////////////////////////////////

use "/Users/aokutse/Desktop/malnutrition/rawdhs/raw2022/KEKR8AFL.DTA", clear

// keep only variables of interest in adjustment
keep v021 v023 v005 hw70 hw71 hw72 b4 v102 v130 v106 bord hw1 v190 v024 m15 b11 v012 v714 v701 v438 v437 v322  


// describe data set in memory
describe

// rename variables selected from the data set

	// sample design variables
	rename v021 psu		/* primary sampling unit */
	rename v023 stratum /* stratification used in sample design */
	rename v005 weight	/* women's individual sample weight 6 dlp */
	
	// generate the correct weight variable to use in weighted analyses and drop the weight variable 
	gen wt = weight/1000000
	label variable wt "weight"
	drop weight
	
	// malnutrition indicators have 2 implied decimal points and thus are divided by 100 to get them in the right form for analysis
	tab hw70, missing
	codebook hw70 		//check how the variable was coded
	// replace coded missing values as missing in hw70 
	replace hw70 = . if hw70 == 9999 | hw70 == 999 | hw70 == 99 | hw70 == 9 | hw70 == 9998 | hw70 == 7 | hw70 == 9996
	gen haz = hw70/100	/* height for age */
	label variable haz "height/age"
	
	tab hw71, missing
	replace hw71 = . if hw71 == 9996 | hw71 == 9998 | hw71 == 9997
	tab hw71, missing
	gen waz = hw71/100	/* weight for age */
	label var waz "weight/age"
	
	tab hw72, missing
	replace hw72 = . if hw72 == 9996 | hw72 == 9998 | hw72 == 9997
	tab hw72, missing
	gen whz = hw72/100	/* weight for height */
	label var whz "weight/height"
	
	drop hw70 hw71 hw72 

// categorize the malnutrition indicators	
// stunting
gen stunted = 1 if haz < -2.00
replace stunted = 0 if missing(stunted) & !missing(haz)
label values stunted stunted 
label def stunted 0 "No", modify
label def stunted 1 "Yes", modify
label var stunted "stunted"	
tab stunted, missing
	
// underweight
gen underweight = 1 if waz < -2.00
replace underweight = 0 if missing(underweight) & !missing(waz)
label values underweight underweight
label def underweight 0 "No", modify
label def underweight 1 "Yes", modify
label var underweight "underweight"
tab underweight, missing

// wasting
gen wasted = 1 if whz < -2.00
replace wasted = 0 if missing(wasted) & !missing(whz)
label values wasted wasted 
label def wasted 0 "No", modify
label def wasted 1 "Yes", modify
label var wasted "wasted"	
tab wasted, missing


	// demographic and socioeconomic variables
	rename b4 child_sex	  	/* sex of child: 1 = male, 2 = female */
	rename v102 residence 	/* type of place of residence: 1 = urban, 2 = rural (ref) */
	rename v130 religion  	/* religion: 1 = roman catholic, 2 = protestant/other xtian, 3 = muslim, 4 = no religion (ref) */
	rename v106 educ_level	/* mothers highest education level attended */
	rename bord birth_order /* the order in which the children were born */
	rename hw1 childs_age	/* child's age in months */
	rename v190 wealth_index /* wealth index */
	rename v024 region 		/* de facto region of residence */
	rename m15 delivery_place /* place of delivery */
	rename b11 birth_interval /* Preceding birth interval calculated as the difference in months between the current birth and the previous birth */
	rename v012 mothers_age		/* current age in completed years of the respondent: continuos (<=24, 25-34, >=35 yrs) */
	rename v714 maternal_work	/* respondent currently working: categorical */
	rename v70 husband_educ		/* partners highest education level */
	rename v438 m_height /* height of the respondent in cms: divide by 10 and convert to meters */
	rename v437 m_weight	/* respondent weight in kg: divide by 10. To compute bmi divide weight in kgs by height in meters*/
	rename v322 m_parity /* parity at sterilization */
	
	
// cleaning up the variables as necessary
codebook child_sex
codebook residence
codebook religion

// convert code 96 (other) to missing value 
replace religion = . if religion == 96
tab religion, missing
tab religion, missing nolabel // no religion (reference = 4)

// education level: recoded to combine secondary and higher education (reference = 0)
codebook educ_level 
tab educ_level, missing
recode educ_level (0 = 0 None) (1 = 1 Primary) (2/3=2 ">= Secondary"), gen(maternal_edu)
tab maternal_edu, missing // no education (reference = 0)
drop educ_level

// birth order analyzed as continuous
// childs_age analyzed as continuous

// wealth index: 1 = poorest (reference) ... 5 = richest
codebook wealth_index

// region of residence: 1 = coast (reference) ... 9 = nairobi
codebook region

// delivery place: to be recoded
codebook delivery_place
tab delivery_place, nolabel
tab delivery_place, missing

recode delivery_place (11/12 = 0 Home) (21 22 23 26 = 1 "Public sector") (31 32 33 36 = 2 "Private sector") (96 = 3 Other), gen(dlv_place)
tab dlv_place, missing
drop delivery_place
	
// birth interval analyzed as continuos

// mothers age: 
tab mothers_age, missing nolabel
recode mothers_age (15/24 = 0 "<= 24 yrs") (25/34 = 1 "25-34 yrs") (35/49 = 2 ">= 35 yrs"), gen(maternal_age)
tab maternal_age, missing

// maternal work: 0 = no, 1 = yes (reference = 0)
tab maternal_work, nolabel missing
label define mat_work 0 "No" 1 "Yes"
label values maternal_work mat_work
tab maternal_work

// fathers education level 
tab husband_educ, nolabel missing
tab husband_educ 
replace husband_educ = . if husband_educ == 8
recode husband_educ (0 = 0 None) (1 = 1 Primary) (2/3=2 ">= Secondary"), gen(paternal_edu)
drop husband_educ


// save the cleaned 2014 data set for further analysis
save "/Users/aokutse/Desktop/malnutrition/cleaned/kdhs2014.dta", replace

*************************************************
*use kdhs_2003a.dta, clear
*gen syear=0
*use "F:\Biostatistics\1 Malnutrition paper\Analysis Files\kdhs_2014a.dta"
*append using kdhs_2014a.dta
//indicator for the 2014 dataset
*replace syear=1 if syear==.
//labeling survey year values
*label values syear labels6
*label define labels6 0 "DHS2003" 1 "DHS2014", replace
//sample sizes in dataset by year
*tab syear, mis

*saving the cleaned combined dataset
*save "D:\Biostatistics\1 Malnutrition paper\revised_analysis\clean_combined_data\clean_df.dta", replace


