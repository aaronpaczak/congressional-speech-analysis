# Congressional Speech Analysis 

This repository contains information regarding congressional speech analysis to contribute to 
"Party, Gender, and Speech: Analyzing Language to Measure Gender and Partisian Polarization." The
goals for this project include the following:  
- Analyze the differences between congressional floor speeches given by men and women.
- Use techniques in machine learning to make casual inferences regarding these difference.
	- Compare differenct models for speech classification and report on the results. 
- Find differences across time using data that dates back to the 43rd Congress of the US.  

## Code

The code in this repo contains the analysis tools for congressional speech data from hein-online. 

## Data 

The data we're using is a preprocessed set of congressional speech data provided by Matthew
Gentzkow, Jesse Shapiro, and Matt Taddy. The data contains conressional speeches from the 43rd 
to the 114th sessions of Congress from both the bound and daily editions. Thankfully, Gentzkow,
Shapiro, and Taddy provides us with a lot of useful metadata, and makes our development experience
a lot easier.   

Link: [Congressional Record for the 43rd-114th Congresses: Parsed Speeches and Phrase Counts](https://data.stanford.edu/congress_text)  
Citation: Gentzkow, Matthew, Jesse M. Shapiro, and Matt Taddy. Congressional Record for the 43rd-114th Congresses: Parsed Speeches and Phrase Counts. Palo Alto, CA: Stanford Libraries [distributor], 2018-01-16.   

The data originially comes from Hein Online, an online data resource that provides scans of the 
Congressional Record to the public.  

Link: [Hein-Online](https://home.heinonline.org/content/u-s-congressional-documents/)   

## Wiki
Our Wiki provides a semi-accurate timeline of the work and research being completed for this
project.  

## TODO   
1. Implement Cross-Validation 
	- compare cross-validated models with the models that already exist
	- check out perplexity
2. Create different models to compare to the Naive Bayes classifier  
	- SVM, Deceision Tree, NN  
	- Compare results and reasons for using each    
3. Modularize code and make runnable for different situations/create playbook  
4. Incorporate a visualization tool  

