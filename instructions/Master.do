/*******************************************************************************
Project: Coding for Reproducible Research Training at LSE, Fall 2022

Purpose: Learn how to code to make research organized and reproducible
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


	global instructions	"$git/instructions"
	
	texdoc do "$instructions/instructions.do"
	
