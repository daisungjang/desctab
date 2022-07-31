# desctab function by Daisung Jang and Dai Le 

# ABOUT DESCTAB:
Desctab is an R function used to rapidly generate a readily publishable correlation table in APA style. Desctab is user-friendly and helps writers save significant time on editing a correlation table for publications that require APA format. A major advantage of desctab is that users can supply their own filename, and the output will be an excel table. 

# HOW TO USE DESCTAB:
**Step 1:** Copy and paste the following R script:

require(RCurl)

desctab_url <-source("https://raw.githubusercontent.com/daisungjang/desctab/main/desctab.0.10.R")

eval(parse(text = getURL(desctab_url, ssl.verifypeer = FALSE)), envir=.GlobalEnv)

desctab(x)
 
**Step 2:** Replace x with the name of your dataset.

# EXAMPLE:
_In this example, we will work with ‘trees’  – a built-in dataset in R. This dataset includes the girth, height, and volume of 31 felled black cherry trees._

trees 

require(RCurl)

desctab_url <- source("https://raw.githubusercontent.com/daisungjang/desctab/main/desctab.R")

 	eval(parse(text = getURL(desctab_url, ssl.verifypeer = FALSE)), envir=.GlobalEnv)
  
 	desctab(trees)

An excel table should be generated as the following as a result.

<img width="451" alt="Picture1" src="https://user-images.githubusercontent.com/105834006/182022454-360d80a0-1809-43e2-bc17-19ca046b5bbd.png">
