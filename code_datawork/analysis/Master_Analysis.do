/*******************************************************************************
Project: Coding for Reproducible Research Training at LSE, Fall 2022

Purpose: Learn how to code to make reproducible tables in Stata and Latex
********************************************************************************/

	***************
	* Housekeeping 
	***************

	clear all
	set more off
	
	
	* Directories
	if c(username) == "sakina" {
		global git	   "C:\Users\sakina\Documents\Git\training_lse_fall2022"
	}

	if c(username) == "YourUserName" {
		global dropbox "YourPathToYourDropboxFolder"
		global git	   "YourPathToYourGitHubFolder"
	}


	global dofiles		"$git/code_datawork"
	global tables		"$git/output/tables"
	global graphs		"$git/output/graphs"

		*** User-written commands
	local download = 0 // Switch to 1 to downlaod
	if `download' {
		ssc install outreg2, replace
		ssc install texdoc, replace
		ssc install texsave, replace
		}
	
	* Sections
	global makeTables 1
	
	
	****************
	* Making Tables
	****************
	if $makeTables {
		
		do "$dofiles/analysis/tables.do"
		
		}
		