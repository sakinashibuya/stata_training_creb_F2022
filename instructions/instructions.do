/*
This dofile is to be executed from Master.do.
It creates a latex file with instructions for the training.
*/


* Initialize the latex file
texdoc init "$instructions/instructions.tex", replace

***********
* Preemble
***********

/***
\documentclass[14pt]{article}

%%%%%% packages 

\usepackage[utf8]{inputenc}
\usepackage{booktabs}
\usepackage{amsmath}
\usepackage{amsfonts}
\usepackage{amssymb}
\usepackage{float}
\usepackage{color}
%\usepackage{appendix}
\usepackage{booktabs}
%\usepackage{etex}
\usepackage{microtype}
\usepackage{geometry}
\geometry{
	a4paper,
	left=20mm,
	top=20mm,
	right=20mm,
	bottom=20mm
}

%\usepackage[pdfborder={0 0 0},pdfusetitle]{hyperref}
%\usepackage{doi}
\usepackage{tikz}
\usepackage{pgfplots}
%\usepackage{imakeidx}
\usepackage{hyperref}
\usepackage{multirow}
\usepackage{setspace}
\usepackage{comment}
%\usepackage[labelformat=parens,labelsep=quad,skip=3pt]{caption}
\usepackage{graphicx}
\usepackage{caption}
\usepackage{subcaption}
\usepackage{stata}

\usepackage{tabularx}

\usepackage{enumitem}

\usepackage{adjustbox}

\usepackage{pdflscape}

\usepackage{colortbl}

\usepackage{booktabs}

\setlength\parindent{0pt} 

%%%%%% End of preemble

\title{Coding for Reproducible Research \\ Making Tables in Stata and Latex}
\author{Sakina Shibuya}
\date{October 19, 2022}

\begin{document}
		
\maketitle
		
		
\section{Introduction}

Over the next two courses (one hour each), we will learn how to make your research more reproducible. \\

Today, we are going to focus on making reproducible tables using Stata and Latex, while we learn some tricks for better collaboration and code organizations. \\

In this lecture, I'm assuming the following:
\begin{itemize}
	\item You have Stata, Latex, and an Latex editor installed in your device.
	\item You are already familiar and somewhat comfortable with coding in Stata and Latex.
	\item You feel comfotable reading Stata help files.
\end{itemize}

My code has a lot of explanations. If you are unfamiliar with Stata and/or Latex, I hope they are helpful.

\section{Tricks for Easier Collaboration}

It's rarely the case that we work on a research project all on our own. \\ 

When you have co-authors, it's extremely important that the work each team member does is shared with others in a timely as well as organized manner. \\ 

One amazing tool we can use is Git. We will learn about this on next Wednesday (Oct. 26th). \\

Today I want show you how I make mine as well as my co-authors lives less miserable in Stata. \\

\subsection{Master do-files}

We often have multiple do-files to complete one task (e.g. conducting a robustness check). \\ 

To make sure that all do-files associated with a particular task are easily recognizable by my team mates, I often write a master do file. \\ 

\begin{figure}[H]
	\centering
	\caption{Example Folder Structure with a Master Do File}
	\includegraphics[width=0.7\linewidth]{example_folder}
	\label{fig:examplefolder}
\end{figure}
	

\subsection{Do-files Executable by All Your Team Members}

It's very important that your code is executable by your team members. \\ 

For this to be possible, they have to have proper access to input (i.e. data) and 
code. \\

One way to make your code executable by others is to have a "housekeeping" section as the following.
This one is from a project I'm working on with Zunia. \\ 

Notice that I have the following sections:
\begin{enumerate}
	\item User identification
	\item File directories
	\item Sections
	\item User-written commands
\end{enumerate}

\textbf{User identification} identifies your device and set folder paths to the folders shared by all the team members. \\

\textbf{File directories} make it clear where things are. \\

\textbf{Sections} provide a map for this current do file. \\

\textbf{User-written commands} make sure that everyone has all the necessary commands installed to run your code.

\newpage
***/

texdoc stlog , nodo cmdlog
	
	***************
	* Housekeeping 
	***************

	clear all
	set more off
	set mem 100m
	set graphics off

	
	* User identification
	if c(username) == "sakina" {
		global dropbox "C:\Users\sakina\Dropbox\Projects\Pakistan_HiringCostsWomen"
		global git	   "C:\Users\sakina\Documents\Git\pakistan_flfp"
	}

	if c(username) == "YourUserName" {
		global dropbox "YourPathToYourDropboxFolder"
		global git	   "YourPathToYourGitHubFolder"
	}

	
	* File directories
	global rawData 		"$dropbox/Data/PrimaryData/rawData"
	global modData 		"$dropbox/Data/PrimaryData/modifiedData"
	global dofiles		"$git/code_datawork"
	global tables		"$git/output/tables/hfc/pilot_baseline"
	global graphs		"$git/output/graphs/hfc/pilot_baseline"
	global report		"$git/code_writings/HFCReports/pilot_baseline"

	
	* Sections
	global labeling		1
	global cleanData	1
	global constructVars  1
	global analysis	1

		
	* User-written commands
	local download = 0 // Switch to 1 to user-written programs
	if `download' {
		ssc install texdoc, replace
		ssc install texsave, replace
		}

texdoc stlog close

	
*******************
* Prepare the data 
*******************


/***
\newpage
\section{Making Reproducible Tables}

We are going to use an example dataset that comes with Stata, called \textbf{nlswork.dta}. \\

If you want to know a bit about this dataset, simply

***/

texdoc stlog
	webuse nlswork, clear
	notes
texdoc stlog close


/***
We need to make one variable and change tha labels of two existing variables for our exercise. \\
***/
texdoc stlog, nodo cmdlog
	gen black = (race == 2)
	label var black "Black"
	label var collgrad "College"
	label var south "South"
texdoc stlog close 
	
************************************************************
* Easy and quicy way to output regression results - outreg2
************************************************************

/***
\subsection{Making Tables with outreg2}

Suppose we are interested in understanding the relationships between wage and working hours (dependent variables), and education, race, and region in US in which respondents reside (independent variables). \\

We want to output the results into one table. \\

The easiest command for this purpose is probably \textit{outreg2}. \\

So we can run the following code. \\

***/

texdoc stlog, nodo cmdlog
	

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
		
		
texdoc stlog close
		
/***

This command produces the following table. \\

\begin{table}[H]
	\centering
	\adjustbox{max width=\textwidth}{
	\input{regs_outreg2.tex}
	}
\end{table}


This is fine for quick outputting, but it's very hard to read. \\

We also probably don't really need to show all estimates. \\

Let's say that we are only interested in the interacted terms for the purpose of this exercise. \\

The following table is much easier to read and looks more professional. \\

\input{regs_estout.tex} 


Once we start thinking about more customization, we git the limitations of \textit{outreg2} quickly. \\

How can we make this table? \\
***/
		
		
				
**************************************************************
* More customizable way to output regression results - estout
**************************************************************

/***
\newpage
\subsection{Making tables with estout and texdoc}

We can use \textit{estout} and \textit{texdoc} to achieve this. \\


\textbf{\textit{estout}} is a flexible command for outputting a table. \\

You can do all kinds of customization, although it can get pretty complicated. \\

I like to combined \textit{estout} and \textbf{\textit{texdoc}} to make my life a bit easier withouth compromizing on customizabiliy. \\


I won't really go deep into explaining \textit{texdoc}, because there is a very nice insturction on the web \href{http://repec.sowi.unibe.ch/stata/texdoc/getting-started.html}{by Ben Jann}. \\

I just note a couple of things.
\begin{itemize}
	\item The code that produces a tex file must be called from another do-file using the command \textit{textdoc do}.
	\item You also need to have \textit{stata.sty} in the same folder to complile the tex file.
\end{itemize}

Here is the code to do this. \\

***/	
	
	
texdoc stlog, nodo cmdlog
	
	****** Regression 1 : wage on educationXblack
	
		*** Estimate coefficients
		reg ln_wage collgrad##black i.year, r
		eststo reg1_new // Storing the results in the way eststo can read.
			
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
				 		 
texdoc stlog close 



/***

After this part, you have to call the do file that writes out a whole tex file that companies \textit{Panel A} and \textit{Panel B} in a special way using the command, \textbf{\textit{texdoc do}} as the following: \\

\begin{verbatim}
texdoc do "\$dofiles/analysis/table\_regs\_estout.do"
\end{verbatim}


And this is what's inside of this do-file. \\


\begin{figure}[H]
	\centering
	\caption{Inside \textit{table\_regs\_estout.do}}
	\includegraphics[width=\linewidth]{example_texdoc}
	\label{fig:exampletexdoc}
\end{figure}


This is the end of today's class. \\


Next time, we will cover how to use Git with Github. \\


Any questions and concerns?

***/	
	
***********************	
* End of the document
***********************

/***
\end{document}
***/	