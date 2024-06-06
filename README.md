# desctab

# About desctab:
Desctab is an R function that can quickly generate a publishable correlation table. Desctab is user-friendly and helps writers save significant time editing a correlation table for publications. A major advantage of desctab is that users can supply their own filename, and the output will be an Excel file in the working directory with a file name that includes the current time. 

# How to use desctab:
**Step 1:** Copy and paste the following R script:

> require(RCurl)
> 
> desctab_url <-source("https://raw.githubusercontent.com/daisungjang/desctab/main/desctab.R")
> 
> eval(parse(text = getURL(desctab_url, ssl.verifypeer = FALSE)), envir=.GlobalEnv)
> 
> desctab(x)
 
**Step 2:** Replace x with the name of your dataset.

# Example:
In this example, we will work with ‘trees’ – a built-in dataset in R. This dataset includes the girth, height, and volume of 31 felled black cherry trees.

> trees 
> 
> require(RCurl)
> 
> desctab_url <- source("https://raw.githubusercontent.com/daisungjang/desctab/main/desctab.R")
> 
> eval(parse(text = getURL(desctab_url, ssl.verifypeer = FALSE)), envir=.GlobalEnv)
> 
> desctab(trees)

An Excel file should be generated with the following as a result.

<img width="451" alt="Picture1" src="https://user-images.githubusercontent.com/105834006/182022454-360d80a0-1809-43e2-bc17-19ca046b5bbd.png">

# Shiny app:

Desctab is now available as a Shiny app: <a href = "https://ha2ifp-daisung-jang.shinyapps.io/desctab/">https://ha2ifp-daisung-jang.shinyapps.io/desctab/</a>

Daisung Jang and Dai Le
