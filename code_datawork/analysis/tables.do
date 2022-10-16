* Reproducible tables for publications

************************************************************
* Easy and quicy way to output regression results - outreg2
************************************************************

	* We are going to use an example longitudinal data for the purpose of this training. 
	webuse nlswork, clear

	gen black = (race == 2)
	label var black "Black"
	
	label var collgrad "College"
	label var south "South"

	* Suppose we want to output the estimated coefficients from the following estimation.
	reg ln_wage collgrad##black i.year, r
	estimates store reg1
		
	reg ln_wage south##black i.year, r
	estimates store reg2

	reg hours collgrad##black i.year, r
	estimates store reg3
		
	reg hours south##black i.year, r
	estimates store reg4

	outreg2 [reg1 reg2 reg3 reg4] using "$tables/regs_outreg2.tex", ///
		replace /// Replaces the existing file
		tex(frag) /// Creates a tex file without preembles
		label /// Use variable lables
		title("Correlation between Work, Race, Education, and Region") ///
		drop(i.year) /// Drop coefficients on the year FE
		dec(4) // Show estimates till 4th decimals
		

**************************************************************
* More customizable way to output regression results - estout
**************************************************************
	
	
	****** Regression 1 : wage on educationXblack
	
		*** Estimate coefficients
		reg ln_wage collgrad##black i.year, r
		eststo reg1_new
			
		*** Year FE indicator
		estadd local yearFE "Yes", replace 
		
		*** Get the mean of dependent variables 
		sum ln_wage if e(sample), meanonly // if e(sample) calculates estimate using the regression sample
		local mean: di %9.2f r(mean) // Setting the mean value at 2 decimals
		estadd local dvmean `mean', replace // Getting it ready to be added to the estout command later
		
		*** Add a blank row 
		estadd local blank " ", replace
		
	
	****** Regression 2 : hours on educationXblack

		reg hours collgrad##black i.year, r
		eststo reg2_new
		
		estadd local yearFE "Yes", replace 
		sum hours if e(sample), meanonly 
		local mean: di %9.2f r(mean) 
		estadd local dvmean `mean', replace 
		estadd local blank " ", replace
		
	
	
	****** Regression 3 : wage on southXblack
	
		reg ln_wage south##black i.year, r
		eststo reg3_new
		
		estadd local yearFE "Yes", replace 
		sum ln_wage if e(sample), meanonly 
		local mean: di %9.2f r(mean) 
		estadd local dvmean `mean', replace 
		estadd local blank " ", replace

	
	****** Regression 4 : hours on southXblack		
	
		reg hours south##black i.year, r
		eststo reg4_new

		estadd local yearFE "Yes", replace 
		sum hours if e(sample), meanonly 
		local mean: di %9.2f r(mean) 
		estadd local dvmean `mean', replace 
		estadd local blank " ", replace
		
	
	***** Ouput a table
	
		*** Panel A: educationXblack
		estout reg1_new reg2_new ///
				using "$tables/regs_estout_panelA.tex", ///
				style(tex) replace ///
				keep(1.collgrad#1.black) /// Keeping the estimate of interest.
				interaction(" $\times$ ") /// Specifying how the interaction is shown in the doc.
				cells(b(star fmt(%9.3f)) se(par([ ]) fmt(%9.3f))) /// Setting how the point esitmate (b) and SE are shown. 
				label nonumbers prehead() eqlabels(" ", none) /// Setting column titles
				mgroups(, none) mlabels(, none) collabels(, none) /// Setting column titles
				stats(blank yearFE N dvmean, fmt(0) /// Adding the stats and notes on FE 
					  labels(" " "Year FE" "Observations" "Dep. var. mean")) /// Labeling the stats and notes on FE			 
				 postfoot(\hline \noalign{\smallskip}) /// Writing out the lines at the bottom
		
		*** Panel B: southXblack
		estout reg3_new reg4_new ///
				using "$tables/regs_estout_panelB.tex", ///
				style(tex) replace ///
				keep(1.south#1.black) ///
				interaction(" $\times$ ") ///
				cells(b(star fmt(%9.3f)) se(par([ ]) fmt(%9.3f))) ///
				label nonumbers prehead() eqlabels(" ", none) ///
				mgroups(, none) mlabels(, none) collabels(, none) ///
				stats(blank yearFE N dvmean, fmt(0) ///
					  labels(" " "Year FE" "Observations" ///
							 "Dep. var. mean")) ///
				 postfoot(\hline \noalign{\smallskip})
				 
	***** Compile two panels into one latex file
	texdoc do "$dofiles/analysis/table_regs_estout.do"
