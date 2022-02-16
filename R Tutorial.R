# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ---- Building dat ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# There is no explanation for following code, it is just the creation fake hospital data
# select everything in this section and run it, so that way you've created the dataframe: dat
# everytime you run this code, dat will be slightly different because we are sampling from normal and uniform distributions

PAT_ID = as.integer(seq(10,10000,10))
PAT_AGE = as.integer(round(rnorm(1000,50,10),0))
PAT_GENDER = as.factor(sample(c("MALE","FEMALE"), size = 1000, replace = TRUE))
PAT_ETHNICITY = as.factor(sample(c("WHITE", "BLACK", "INDIAN", "ASIAN", "AUSTRALIAN"), size = 1000, replace = TRUE))
DOCTOR = as.factor(sample(c("O'NEAL JAMES", "WEBBER, NATHAN", "HIGGENS, JOHN", "SMITH, DARIN", "HAMILTON, JOSEPH", "HEROOK, DAVID", "LONG, DANIEL", "NEWTON, GARY", "MURPHY, ERIN", "FINNIGAN, JENNIFER"), size = 1000, replace = TRUE))
PAT_SCHEDULED = sample(seq(c(ISOdate(2000,3,20)), by = "day", length.out = 1500), size = 1000)
PAT_SCHEDULED = PAT_SCHEDULED + abs(rnorm(1000, 3600 * 4, 3600 * 2))
PAT_SCHEDULED = PAT_SCHEDULED[order(PAT_SCHEDULED)]
PAT_ARRIVED = PAT_SCHEDULED + abs(rnorm(1000, 3600 * 24 * 7 * 2.5, 3600 * 24 * 5))
PAT_DEPARTED = PAT_ARRIVED + abs(sample(c(rnorm(500, 3600 * 14, 3600 * 4), rnorm(1000, 3600 * 24 * 4, 3600 * 24)), size = 1000))
PAT_WAITED_DAYS = difftime(PAT_ARRIVED, PAT_SCHEDULED, units = "days")
PAT_LOS_HOURS = difftime(PAT_DEPARTED, PAT_ARRIVED, units = "hours")
PRE_OPTIMIZATION = as.factor(c(rep("Yes",500), rep("No",500)))
PAT_ARRIVED[501:1000] = PAT_ARRIVED[501:1000] - (PAT_WAITED_DAYS[501:1000] * 0.15)
PAT_DEPARTED[501:1000] = PAT_DEPARTED[501:1000] - (PAT_WAITED_DAYS[501:1000] * 0.15)
PAT_DEPARTED[501:1000] = PAT_DEPARTED[501:1000] - (PAT_LOS_HOURS[501:1000] * 0.15)
PAT_WAITED_DAYS = as.numeric(difftime(PAT_ARRIVED, PAT_SCHEDULED, units = "days"))
PAT_LOS_HOURS = as.numeric(difftime(PAT_DEPARTED, PAT_ARRIVED, units = "hours"))
PAT_CLASS = as.factor(ifelse(PAT_LOS_HOURS < 24, "OUTPATIENT", "INPATIENT"))

dat = data.frame(PAT_ID, PAT_AGE, PAT_GENDER, PAT_ETHNICITY, PAT_CLASS, DOCTOR, PAT_SCHEDULED, PAT_ARRIVED, PAT_DEPARTED, PAT_WAITED_DAYS, PAT_LOS_HOURS, PRE_OPTIMIZATION)

rm(PAT_ID, PAT_AGE, PAT_GENDER, PAT_ETHNICITY, PAT_CLASS, DOCTOR, PAT_SCHEDULED, PAT_ARRIVED, PAT_DEPARTED, PAT_WAITED_DAYS, PAT_LOS_HOURS, PRE_OPTIMIZATION)

# here is a description of the data
# PAT_ID: Indentification number given to a patient once an appointment has been scheduled
# PAT_AGE: Age of the patient
# PAT_GENDER: Gender of the patient
# PAT_ETHNICITY: Ethnicity of the patient
# PAT_CLASS: Class of the patient: ethier inpatient or outpatient, inpatient is when a patient is expected to stay over night or longer, outpatient is when a patient is expected to be in and out within the same day
# DOCTOR: The doctor providing the service to the patient
# PAT_SCHEDULED: The date and time when the patient scheduled an appointment
# PAT_ARRIVED: The date and time when the patient arrived at the hospital
# PAT_DEPARTED: The date and time when the patient left the hospital
# PAT_WAITED_DAYS: The time in days that the patient had to wait between PAT_SCHEDULED and PAT_ARRIVED
# PAT_LOS_HOURS: The time in hours that the patient had to stay between PAT_ARRIVED and PAT_DEPARTED
# PRE_OPTIMIZATION: There was an optimization model implemented at the hospital to improve patient flow, this indicates whether or not (ie. yes or no) a patient was at the hospital before the optimization model was implemented

# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ---- Installing & Loading Packages -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# you will only have to install an R package once on your computer
# the following packages are popular for analytics, statistics, graphics, and data manipulation
# when a window pops up asking you to choose a 'CRAN mirror' the default selection will be the Cloud, that will work fine, so just press 'Ok'
# to know that a package was successfully installed look to the bottom of the print out for the phrase: package 'XYZ' successfully unpacked and MD5 sums checked
# for example: package 'plyr' successfully unpacked and MD5 sums checked

# install.packages("plyr")
install.packages("ggplot2")
install.packages("car")
install.packages("MASS")
# install.packages("Matrix")
# install.packages("rpart")
# install.packages("nlme")
install.packages("leaps")
install.packages("randomForest")
install.packages("psych")
# install.packages("effects")
# install.packages("scatterplot3d")
# install.packages("quantreg")
install.packages("foreach")
# install.packages("mvtnorm")
# install.packages("foreign")
# install.packages("gtools")
# install.packages("gdata")
# install.packages("lmtest")
# install.packages("survival")
install.packages("tseries")
# install.packages("gplots")
# install.packages("abind")
# install.packages("maps")
# install.packages("cluster")
# install.packages("SparseM")
install.packages("tree")
# install.packages("robustbase")
install.packages("AlgDesign")
# install.packages("FrF2")
install.packages("forecast")
# install.packages("plotrix")
# install.packages("matrixcalc")
# install.packages("modeltools")
# install.packages("relimp")
# install.packages("dplyr")
# install.packages("lattice")
install.packages("goftest")
install.packages("fitdistrplus")
install.packages("nortest")
# install.packages("mixtools")
install.packages("chron")
# install.packages("RODBC")
install.packages("gridExtra")
# install.packages("hexbin")
install.packages("GGally")
install.packages("triangle")
# install.packages("gstat")
# install.packages("Hmisc")
# install.packages("pastecs")
install.packages("ggmap")
install.packages("data.table")
# install.packages("EnvStats")
install.packages("nnet")
# install.packages("nnetpredint")
install.packages("fGarch")
install.packages("doParallel")

# install.packages("fGarch", lib = .libPaths(), destdir = .libPaths())


# lets look at loading packages
# you will have to do this once, everytime you open up the R application, ONLY IF you desire to use the functions in a particular package
# you may see a warning message print out after loading a package, don't be concerned, if you were able to sucessfully install a package then loading it will always work

require(plyr)
require(ggplot2)
require(car)
require(MASS)
require(Matrix)
require(rpart)
require(nlme)
require(leaps)
require(randomForest)
require(psych)
require(effects)
require(scatterplot3d)
require(quantreg)
require(foreach)
require(mvtnorm)
require(foreign)
require(gtools)
require(gdata)
require(lmtest)
require(survival)
require(tseries)
require(gplots)
require(abind)
require(maps)
require(cluster)
require(SparseM)
require(tree)
require(robustbase)
require(AlgDesign)
require(FrF2)
require(forecast)
require(plotrix)
require(matrixcalc)
require(tree)
require(modeltools)
require(relimp)
require(dplyr)
require(lattice)
require(goftest)
require(fitdistrplus)
require(nortest)
require(mixtools)
require(chron)
require(RODBC)
require(gridExtra)
require(hexbin)
require(parallel)
require(GGally)
require(triangle)
require(triangle)
require(gstat)
require(Hmisc)
require(pastecs)
require(ggmap)
require(data.table)

# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ---- Importing & Exporting Data ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# read.csv will open up a window for you to manually find, click on, and import a csv file into R (you have to have a csv file created and saved first)
# we set header = TRUE when our data has the first row as column names, otherwise we would set header = FALSE

csv = read.csv(file.choose(), header = TRUE)

# read.table will open up a window for you to manually find, click on, and import a text file into R (you have to have a text file created and saved first)
# we set header = TRUE when our data has the first row as column names, otherwise we would set header = FALSE

txt = read.table(file.choose(), header = TRUE)

# write.csv will open up a window for you to manually find, click on, and export data from R to a blank csv file (you have to create and save a blank csv file first)
# we are exporting the dataframe dat that we created, if you have another R object that you made, just delete dat and write in the name of your R object

write.csv(dat, file.choose())

# write.table will open up a window for you to manually find, click on, and export data from R to a blank text file (you have to create and save a blank text file first)
# we are exporting the dataframe dat that we created, if you have another R object that you made, just delete dat and write in the name of your R object

write.table(dat, file.choose())

# ----------------------------------------------------------------------------------------------------------------------------------
# ---- Importing Data from Teradata to R -------------------------------------------------------------------------------------------
# ---- This ONLY works for R, not RStudio. DO NOT install RODBC in RStudio ---------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------

require(RODBC)

# then you will create an object 'db' to create the connection between R and Teradata
# this will open up a window and you will have to follow two steps:
# click on CDISTeradatProd_LDAP and click OK
# if you don't see this then try the other available options
# type in your username and password and click OK

db = odbcDriverConnect()

# then you will create a dataframe object 'DF' which will contain the data you want from a created table
# INNOVATIONS_ANALYTICS.CMC_6AM_CENSUS is a created table in Teradata that I've worked on

DF = sqlQuery(db, "select * from INNOVATIONS_ANALYTICS.CMC_6AM_CENSUS")

# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ---- Changing Data Types -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# head is a function that will show all of the columns and the first 6 rows of a dataframe
# try this simple example to understand how head works

head(dat)

# : is an operator that returns all of the integers, from the integer on the left to the integer on the right of :
# try this simple example to understand how : works

1:10

# sapply is like a vectorized for-loop, so it run significantly faster than a for-loop
# sapply has two inputs: X, FUN --> sapply(X = ..., FUN = ...)
# input X is expected to be a set of numbers that will be iterated over
# input FUN is expected to be any function, such as mean() min() max() or a user defined function, for example: funtion(i) (max(i) - min(i))
# sapply computes the first iteration and stores it as the first entry in a vector, then computes the second iteration and stores it as the second entry in a vector, etc.
# try this simple example to understand how sapply works:

sapply(X = 1:4, FUN = function(i) (i + 0.5))

# colnames is a function that returns the header names of a dataframe, as a vector
# try this simple example to understand how colnames works

colnames(dat)

# alternatively you can use the function rownames for the names of rows
# try this simple example to understand how rownames works

rownames(dat)

# NCOL is a function that returns the number of columns in a dataframe or matrix
# try this simple example to understand how NCOL works

NCOL(dat)

# alternatively you can use the function NROW for the number of rows
# try this simple example to understand how NROW works

NROW(dat)

# $ is an operator that extracts a column from a dataframe by its name
# try this simple example to understand how $ works

dat$PAT_CLASS

# class is a function that returns the data type of an R object
# try these simple examples to understand how class works

class(dat)

class(dat$DOCTOR)

# c is a function that creates a vector
# try this simple example to understand how c works

c(1:4, "Red", 66, "Whaaaaat")

# cbind is a function that combines two or more R objects together via columns
# try this simple example to understand how cbind works

cbind(1:4, c("Red", "Blue", "Green", "Black"))

# alternatively you can use the function rbind to bind by rows
# try this simple example to understand how rbind works

rbind(1:4, c("Red", "Blue", "Green", "Black"))

# data.frame is a function that creates a data.frame data type
# try this simple example to understand how data.frame works

data.frame(1:4, c("Red", "Blue", "Green", "Black"))

# lets give the headers better names

data.frame("Numbers" = 1:4, "Colors" = c("Red", "Blue", "Green", "Black"))

# list is a function that creates a list of numbers, characters, words, sentences, vectors, data.frames, matrics, and/or lists (yes, lists of lists)
# this is great for organizing data by groups
# this is also great for representing something beyond two-dimensions (ie. one matrix won't do the job)
# try out a simple example to understand how list works

list(
  "Hospital_1" = data.frame("PAT_ID" = c(10, 20, 30), "LOS_HOURS" = c(4.4, 10, 1)), 
  "Hospital_2" = data.frame("PAT_ID" = c(100, 200, 300), "LOS_HOURS" = c(48, 77, 100)), 
  "Hospital_3" = data.frame("PAT_ID" = c(1000, 2000, 3000), "LOS_HOURS" = c(1, 0.5, 2))
)

# [] is an operator that accesses values in vectors, matrices, lists, arrays
# [] is also an alternative to $
# try these examples to understand how [] works

# lets just make this data frame that we've been using, an R object by giving it a name

IloveR = data.frame("Numbers" = 1:4, "Colors" = c("Red", "Blue", "Green", "Black"))
IloveR

# example 1: access the first column

IloveR[,1]

# example 2: access the second column

IloveR[,2]

# example 3: access the first row

IloveR[1,]

# example 4: access the second row

IloveR[2,]

# example 5: access the entry in the first row & second column

IloveR[1,2]

# example 6: access the entry in the third row & first column

IloveR[3,1]

# lets work with something 1 dimensional: a vector

x = c(1,6,"Yooo", "LOL", 55)
x

# example 7: access the first entry

x[1]

# example 8: access the forth entry

x[4]

# lets work with something 3 dimensional: a list of dataframes
# first lets create a list

GoPatriots = list(
  "Hospital_1" = data.frame("PAT_ID" = c(10, 20, 30), "LOS_HOURS" = c(4.4, 10, 1)), 
  "Hospital_2" = data.frame("PAT_ID" = c(100, 200, 300), "LOS_HOURS" = c(48, 77, 100)), 
  "Hospital_3" = data.frame("PAT_ID" = c(1000, 2000, 3000), "LOS_HOURS" = c(1, 0.5, 2))
)

GoPatriots

# example 9: access the second dataframe

GoPatriots[[2]]

# access the first row of the second data.frame

GoPatriots[[2]][1,]

# acess the second column of the third data.frame

GoPatriots[[3]][,2]

# acess the second row-second column entry of the first data.frame

GoPatriots[[1]][2,2]

# print is a function that prints a number or a string
# try these simple examples below to understand how print works

print(6)
print("Oh Hi Doggy")

# paste is a function that combines multiple numbers and/or strings into one string
# try these simple examples below to understand how paste works

paste("Oh", "Hi", "Doggy")
paste(4,2)

# if you want to remove the space that is inserted between all of the entries in paste(), add in the parameter sep: sep = ""

paste(4,2, sep = "")

# if you want to specifiy your own delimeter, for example a comma, change the parameter sep to: sep = ","

paste(4,2, sep = ",")

# below is a for-loop which iterates through a vector of numbers and performs any functions defined between the brackets: {}
# try this simple example to understand how a for-loop works

for(i in 1:4)
{
  print(paste("OMG! its a", i))
}

# you can create your own functions in R to automate a simple or complex task
# when you create your own function, you must give it inputs that require the neccessary information to perform your task
# below is a simple example of a function that returns the fibonacci sequence
# in case you didn't know, an example of the fibonacci sequence is 0, 1, 1, 2, 3, 5, 8
# so in that example we start with two numbers: 0 and 1, and then we add them together to get the third number, then add the third number to the second number to get the fourth number, and on so:
# 0, 1, 1, 2, 3, 5, 8 = (0), (1), (0 + 1), (1 + 1), (3 + 2), (5 + 3)

# every user defined function is defined by the function: function

fib = function(num1, num2, length.out)
{
  length.out = length.out - 2
  seqq = c(num1, num2)
  
  for(i in 1:length.out)
  {
    seqq = c(seqq, seqq[i] + seqq[i + 1])
  }
  
  return(seqq)
}

# try out some examples of our function fib

fib(num1 = 0, num2 = 1, length.out= 7)

fib(5, 7, 10)

# types is a function I created that will return the data types of each column of a dataframe
# everything used to create the function types, was explained above

types = function(dat)
{
  dat = data.frame(dat)
  
  Column = sapply(1:NCOL(dat), function(i)
    (
      colnames(dat)[i]
    ))
  
  Data_Type = sapply(1:NCOL(dat), function(i)
    (
      class(dat[,i])
    ))
  
  results = data.frame(cbind(Column, Data_Type))	
  results
}

# try this as an example

types(dat)

# here is an explanation for the data types you saw:
# integer: a number without any decimal places, any whole number
# numeric: a number that can have decimal places, any real number
# factor: a character, word, sentence, or number that is intended to be a categorial measure
# character example: 
# data was catured in a double blind study as to whether participants received medicine: A, B, C
# word example:
# data was catured on what gender a patient was: Male, Female
# sentence example:
# data was captured on what type of procedure a patient went through: Arthroplasty Knee Total, Arthroplasty Total Hip
# number example:
# data was captured on whether a patient died in the hospital or not: 1, 0
# POSIXct, POSIXt: a date-time value in the format: YYYY-MM-DD HH:MM:SS

# lets set all of the columns of dat to be character data types to show how to convert them back into proper data types

for(i in 1:NCOL(dat))
{
  dat[,i] = as.character(dat[,i])
}

# we can verify this change with types

types(dat)

# column 1: PAT_ID is an integer data type

dat[,1] = as.integer(dat[,1])

# column 2: PAT_AGE is an integer data type

dat[,2] = as.integer(dat[,2])

# column 3: PAT_GENDER is a factor data type

dat[,3] = as.factor(dat[,3])

# column 4: PAT_ETHNICITY is a factor data type

dat[,4] = as.factor(dat[,4])

# column 5: PAT_CLASS is a factor data type

dat[,5] = as.factor(dat[,5])

# column 6: DOCTOR is a factor data type

dat[,6] = as.factor(dat[,6])

# column 7: PAT_SCHEDULED is a date-time data type

dat[,7] = as.POSIXct(dat[,7])

# column 8: PAT_ARRIVED is a date-time data type

dat[,8] = as.POSIXct(dat[,8])

# column 9: PAT_DEPARTED is a date-time data type

dat[,9] = as.POSIXct(dat[,9])

# column 10: PAT_WAITED_DAYS is a numeric data type

dat[,10] = as.numeric(dat[,10])

# column 11: PAT_LOS_HOURS is a numeric data type

dat[,11] = as.numeric(dat[,11])

# column 12: PRE_OPTIMIZATION is a factor data type

dat[,12] = as.factor(dat[,12])

# we can verify these change with types

types(dat)

# ls is a function that returns all of the names of the R objects in the R work space
# try it

ls()

# rm is a function that removes R objects from the R work space, once you do this, you cant get those objects back unless you recreate them with your code again
# lets remove some R objects

rm(i, IloveR, x, fib, types)

# i guess we can remove this one too

rm(GoPatriots)

# verify we removed them

ls()

# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ---- Descriptive Statistic Tables --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# summary is a function that returns: the min, the 25th percentile (1st Qu.), the median, the mean, the 75th percentile (3rd Qu.), and the max --> for numeric data types
# summary is a function that returns: the number of observations of each level --> for factor data types

# heres a statistical summary of PAT_LOS_HOURS

summary(dat$PAT_LOS_HOURS)

# or alternatively

summary(dat[,11])

# summary doesn't include information on the number of observations (N) and standard deviation (Std Dev) for numeric data types, so lets add those in manually

c("N" = length(dat[,11]), summary(dat[,11]), "Std Dev" = sd(dat[,11]))

# lets make a simple function so we don't have to re-write "dat[,#]" 3 times if we want to look at another column

mysummary = function(dat)
{
  c("N" = length(dat), summary(dat), "Std Dev" = sd(dat))
}

# lets test it out

mysummary(dat[,11])

# lets try PAT_WAITED_DAYS

mysummary(dat[,10])

# lets look at a summary of a factor data type: PAT_ETHNICITY
# so we will see how many patients are of each ethnicity for the results

summary(dat[,4])

# lets look at PAT_CLASS

summary(dat[,5])

# alright now lets get a more detailed summary of PAT_LOS_HOURS by breaking it down by PAT_CLASS

# aggregate is a function for performing analysis on data by grouping
# aggregate has 3 inputs: x, by, FUN
# x is the data we want to perform analysis on, in our case: PAT_LOS_HOURS
# by is the data that we want to group x by, in our case: PAT_CLASS
# FUN is the function we want to perform to do whatever analysis we're interested in, in our case: mysummary
# notice that we use the list function when entering data into x and by
# this allows aggregate to perform analysis by grouping
# this allows us to give our data the proper names that we want to see in the output

aggregate(x = list("PAT_LOS_HOURS" = dat[,11]), by = list("PAT_CLASS" = dat[,5]), FUN = mysummary)

# An issue i've picked up on (and this is probably due to the way mysummary is made) is that the results are in two columns, one for the by (ie. PAT_CLASS) , and one for the analysis of x (ie. PAT_LOS_HOURS)
# the second column is a matrix of the 8 mysummary statistics which is a problem if we wanted to extract any of those statistics individually
# to better illustrate this issue, use types

types(aggregate(x = list("PAT_LOS_HOURS" = dat[,11]), by = list("PAT_CLASS" = dat[,5]), FUN = mysummary))

# look at what the second column returns

aggregate(x = list("PAT_LOS_HOURS" = dat[,11]), by = list("PAT_CLASS" = dat[,5]), FUN = mysummary)[,2]

# so i've created a function that will perform identical to aggregate but return the results into the proper number of columns

myaggregate = function(x, by, FUN)
{
  result = aggregate(x = x, by = by, FUN = FUN)
  
  name = c(colnames(result)[1:(NCOL(result) - 1)], colnames(result[,NCOL(result)]))
  result = data.frame(result[,1:(NCOL(result) - 1)], result[,NCOL(result)])
  colnames(result) = name
  
  return(result)
}

myaggregate(x = list("PAT_LOS_HOURS" = dat[,11]), by = list("PAT_CLASS" = dat[,5]), FUN = mysummary)

# lets look at PAT_LOS_HOURS by PRE_OPTIMIZATION

myaggregate(x = list("PAT_LOS_HOURS" = dat[,11]), by = list("PRE_OPTIMIZATION" = dat[,12]), FUN = mysummary)

# lets look at PAT_LOS_HOURS by PAT_CLASS and DOCTOR

myaggregate(x = list("PAT_LOS_HOURS" = dat[,11]), by = list("PAT_CLASS" = dat[,5], "DOCTOR" = dat[,6]), FUN = mysummary)

# lets look at PAT_LOS_HOURS by PRE_OPTIMIZATION, PAT_CLASS, and DOCTOR 

myaggregate(x = list("PAT_LOS_HOURS" = dat[,11]), by = list("PRE_OPTIMIZATION" = dat[,12], "PAT_CLASS" = dat[,5], "DOCTOR" = dat[,6]), FUN = mysummary)

# sample is a function that randomly samples from a data set
# sample has 3 inputs: x, size, replace
# x is the data we are sampling from
# size is how many samples we want
# replace is whether or not we are replacing samples we've already taken, replace can equal TRUE or FALSE, if you don't specify then replace = FALSE by default
# try these simple examples to understand how sample works

num = 1:10
num

sample(x = num, size = 5)

sample(x = num, size = 50, replace = TRUE)	

# table is a function that returns the number of observations for each duplicated value in the data
# try this simple example to understand how table works

table(sample(x = c("A","B","C"), size = 50, replace = TRUE))

# seq is a function that returns a sequence of numbers incremented by some specified value
# try this simple example to understand how seq works

seq(from = 0, to = 10, by = 1)

seq(from = 0, to = 10, by = 2)

# & is an operator that allows two logical statements to be combined, this is similar to the function AND() in excel
# & will evaluate both logical statements:
# if both statements are TRUE then it will return a TRUE else it will return FALSE
# lets try some examples

1 == 1 & 2 > 1

1 == 1 & 2 <= 1

# | is an operator that allows two logical statements to be combined, this is similar to the function OR() in excel
# | will evaluate both logical statements:
# if at least one statement is TRUE then it will return a TRUE else it will return FALSE
# lets try some examples

1 == 1 | 2 > 1

1 == 1 | 2 <= 1

1 > 1 | 2 <= 1

# lets track daily census
# mininum date of PAT_ARRIVED
min_date = as.Date(min(dat[,8]))

min_date

# maximum date of PAT_DEPARTED
max_date = as.Date(max(dat[,9]))

max_date

# all of the dates from min_date to max_date incremented by 1 day
DATE = seq(from = min_date, to = max_date, by = 1)

head(DATE)

# look at the code below starting with 'mat = sapply...'
# the first sapply is incrementing along the rows of DATE to create a column for each date in DATE
# the second sapply is incrementing along the rows of dat to create a row for each patient in dat
# the function nested inside both sapply's is checking to see if the date in DATE is between the PAT_ARRIVED and PAT_DEPARTED dates in dat

# lets run through two examples to show how the function inside both sapplys is working
# heres a PAT_ARRIVED date for the first patient in dat
as.Date(dat[1,8])	

# heres a PAT_DEPARTED date for the first patient in dat
as.Date(dat[1,9])	

# heres the first date in DATE
DATE[1]

# we can already see whether the first patient in dat was or wasn't in the hospital on the first date in DATE
# lets prove it with the function inside both sapplys

as.Date(dat[1,8]) <= DATE[1] & as.Date(dat[1,9]) >= DATE[1]

# lets try the 18th date in DATE
DATE[18]

# we can already see whether the first patient was in the hospital during the 18th date
# lets prove it

as.Date(dat[1,8]) <= DATE[18] & as.Date(dat[1,9]) >= DATE[18]

# as you can see the result is a TRUE or a FALSE, but we would like a 1 or a 0 respectively, to track daily census
# so lets make the result into a number with as.numeric

as.numeric(as.Date(dat[1,8]) <= DATE[1] & as.Date(dat[1,9]) >= DATE[1])
as.numeric(as.Date(dat[1,8]) <= DATE[18] & as.Date(dat[1,9]) >= DATE[18])

# the final result will be a matrix of 1's and 0's to indicate that a patient in row-i was or was not in the hospital during a date in column-j

# WARNING: this takes alot of computing power because the result is a 1000 by 1505 matrix
# DISCLAIMER: feel free to not run this function and end this part of the tutorial
# ADVICE: if you run this code and decide that its taking too long, just hit the 'Esc' key and that should stop the function, otherwise open up the task manager with Ctrl+Shift+Esc and end the R application

mat = sapply(1:NROW(DATE), function(j)
  (
    sapply(1:NROW(dat), function(i) 
      (
        as.numeric(as.Date(dat[i,8]) <= DATE[j] & as.Date(dat[i,9]) >= DATE[j])
      ))
  ))

# notice the function colSums below
# colSums(mat) is summing all the rows in each column
# in our case we are summing all of the patients in each date, if a patient was in the hospital on that date, then we are adding 1, otherwise we are adding 0

dat2 = data.frame(DATE, "CENSUS" = colSums(mat))

mysummary(dat2[,2])

# lets remove some R objects

rm(DATE, max_date, min_date, mysummary, myaggregate, num)

rm(mat, dat2)

# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ---- Graphics ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ dev.off()

# the most popular and widely used R graphics come from the package: ggplot2
# so lets load that in the workspace

require(ggplot2)

# ggplot is the first function required for any kind of plot
# it has two inputs: a dataframe, and the function aes
# aes stands for aesthetics
# aes has multiple inputs, but right now we'll focus on the two main ones, x and y
# x is the data we want to see on the x axis
# y is the data we want to see on the y-axis
# lets start off with creating a plot about length of stay, we'll call the object LOS
# the data will come from dat
# the x axis will be the date which the patient arrived
# the y axis will be how long the patient stayed at the hospital

LOS = ggplot(data = dat, aes(x = PAT_ARRIVED, y = PAT_LOS_HOURS))
LOS

# lets do a line plot of this data first
# the function to create a line plot is geom_line()
# this function has inputs but for the sake of a basic line plot, it requires nothing
# notice that we just use the addition sign to add elements to our object LOS

LOS = LOS + geom_line()
LOS

# notice that the titles on the x axis and y axis take the header names, lets change those to something more presentable
# labs is a function that will change the axis labels

LOS = LOS + labs(x = "Time", y = "Hours")
LOS

# a title would be nice so lets add that in
# ggtitle is a function that will give our plot a title

LOS = LOS + ggtitle("Patient Length of Stay Time Series")
LOS

# some color other than black would be nice
# here are some R colors we could choose from: http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf
# lets go back to geom_line() and add in the input: color

LOS = LOS + geom_line(color = "cornflowerblue")
LOS

# the font sizes look a little small so lets increase those
# for this we use the function theme
# theme has many inputs but we're only interested in three:
# plot.title, to handle the plot title font size
# axis.title, to handle the axis title font size
# axis.text, to handle the axis label font size

LOS = LOS + theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20))	
LOS

# lets add a linear trendline to see the direction in which LOS changes over time
# geom_smooth is a function that can add linear, quadractic, or n-polynomial degree trendlines to give a smoother representation of data 
# since we want a linear trend, our method of choice will be lm, which stands for linear model
# se stands for standard error, we are setting se to FALSE because we don't want to see the standard error of prediction, we aren't predicting anything here so to include it wouldn't be useful

LOS = LOS + geom_smooth(method = "lm", se = FALSE)
LOS

# we can see a step downward halfway through the data
# this may be due to the PRE_OPTIMIZATION factor, so lets include that visual
# we are about to make a change inside the aes function which is a fundamental change, so lets run through all the code from the beginning
# the input were adding inside of aes is: color
# color is an input that requires a factor data type
# color is used to set different colors to each of the levels in a factor

LOS = ggplot(data = dat, aes(x = PAT_ARRIVED, y = PAT_LOS_HOURS, color = PRE_OPTIMIZATION)) +
  geom_line() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(x = "Time", y = "Hours") +
  ggtitle("Patient Length of Stay Time Series") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20))

LOS

# lets remove the trendlines and let the coloring of PRE_OPTIMIZATION define the visual we're seeing here

LOS = ggplot(data = dat, aes(x = PAT_ARRIVED, y = PAT_LOS_HOURS, color = PRE_OPTIMIZATION)) +
  geom_line() +
  labs(x = "Time", y = "Hours") +
  ggtitle("Patient Length of Stay Time Series") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20))

LOS

# notice the legend that appeared, lets adjust a few things about that legend:
# change the title to something more appropriate for presentation
# increase the size of the fonts as well as the keys
# we can do most of this by adding more inputs into the function theme: legend.title, legend.text, legend.key.size
# legend.title will handle the legend title font size
# legend.text will handle the font size of the text next to the keys
# legend.key.size requires the function unit
# the first input of unit indicates the quantity value
# the second input of indicates the unit measurement
# so in our case we want the legend keys to be sized 0.5 inch by 0.5 inch
# we will need to add in the input: color, into the function labs to specify how we want our color to be labeled in the legend

LOS = ggplot(data = dat, aes(x = PAT_ARRIVED, y = PAT_LOS_HOURS, color = PRE_OPTIMIZATION)) +
  geom_line() +
  labs(x = "Time", y = "Hours", color = "Pre-Optimization") +
  ggtitle("Patient Length of Stay Time Series") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), legend.title = element_text(size = 20), legend.text = element_text(size = 20), legend.key.size = unit(.5, "in"))

LOS

# there seems to be alot of white space taken up on the right so adjusting the position of the legend would be beneficial
# we can do this by adding the input: legend.position, to the function theme
# notice we chose to put the legend at the top, we could've chosen: "top", "bottom", "left", or "none" --> "right" is the default so theres no need to specify it if we wanted it on the right
# "none" would remove the legend

LOS = ggplot(data = dat, aes(x = PAT_ARRIVED, y = PAT_LOS_HOURS, color = PRE_OPTIMIZATION)) +
  geom_line() +
  labs(x = "Time", y = "Hours", color = "Pre-Optimization") +
  ggtitle("Patient Length of Stay Time Series") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), legend.title = element_text(size = 20), legend.text = element_text(size = 20), legend.key.size = unit(.5, "in"), legend.position = "top")

LOS

# lets add another dimension to our LOS object, PAT_ETHNICITY
# we will add the function facet_wrap() to create multiple plots for each level in PAT_ETHNICITY
# facet_wrap() has multiple inputs but the minimum is ~
# ~ is an operator that defines how the data should be broken down by, in our case: PAT_ETHNICITY
# we also need to add in another intput to aes: group
# the group input allows PRE_OPTIMIZATION to be used in multiple graphs, in our case: PAT_ETHNICITY

LOS2 = ggplot(data = dat, aes(x = PAT_ARRIVED, y = PAT_LOS_HOURS, color = PRE_OPTIMIZATION, group = PRE_OPTIMIZATION)) +
  geom_line() +
  facet_wrap(~PAT_ETHNICITY) +
  labs(x = "Time", y = "Hours", color = "Pre-Optimization") +
  ggtitle("Patient Length of Stay Time Series By Ethnicity") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), legend.title = element_text(size = 20), legend.text = element_text(size = 20), legend.key.size = unit(.5, "in"), legend.position = "top")

LOS2

# instead of coloring PRE_OPTIMIZATION, we could give each PAT_ETHNICITY its own color

LOS2 = ggplot(data = dat, aes(x = PAT_ARRIVED, y = PAT_LOS_HOURS, color = PAT_ETHNICITY)) +
  geom_line() +
  facet_wrap(~PAT_ETHNICITY) +
  labs(x = "Time", y = "Hours", color = "Ethnicity") +
  ggtitle("Patient Length of Stay Time Series By Ethnicity") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), legend.title = element_text(size = 20), legend.text = element_text(size = 20), legend.key.size = unit(.5, "in"), legend.position = "top")

LOS2

# the colors that were given by default may not be to your liking
# lets manually pick our own colors by using the function scale_color_manual to change the colors corresponding to the color input in aes
# given that color for us is PAT_ETHNICITY and PAT_ETHNICITY has five levels: ASIAN, AUSTRALIAN, BLACK, INDIAN, & WHITE, we must give scale_color_manual a vector of five colors

LOS2 = ggplot(data = dat, aes(x = PAT_ARRIVED, y = PAT_LOS_HOURS, color = PAT_ETHNICITY)) +
  geom_line() +
  facet_wrap(~PAT_ETHNICITY) +
  scale_color_manual(values = c("navyblue", "springgreen3", "tomato", "purple", "lightsalmon3")) +
  labs(x = "Time", y = "Hours", color = "Ethnicity") +
  ggtitle("Patient Length of Stay Time Series By Ethnicity") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), legend.title = element_text(size = 20), legend.text = element_text(size = 20), legend.key.size = unit(.5, "in"), legend.position = "top")

LOS2

# given that each graph has its own title, a legend seems redundant
# so lets remove that by setting legend.position = "none"

LOS2 = ggplot(data = dat, aes(x = PAT_ARRIVED, y = PAT_LOS_HOURS, color = PAT_ETHNICITY)) +
  geom_line() +
  facet_wrap(~PAT_ETHNICITY) +
  scale_color_manual(values = c("navyblue", "springgreen3", "tomato", "purple", "lightsalmon3")) +
  labs(x = "Time", y = "Hours", color = "Ethnicity") +
  ggtitle("Patient Length of Stay Time Series By Ethnicity") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), legend.title = element_text(size = 20), legend.text = element_text(size = 20), legend.key.size = unit(.5, "in"), legend.position = "none")

LOS2

# the title of each graph looks small so lets increase the font size of them
# these titles are actually called strips
# we can increase the strip font size by adding another intput into theme: strip.text

LOS2 = ggplot(data = dat, aes(x = PAT_ARRIVED, y = PAT_LOS_HOURS, color = PAT_ETHNICITY)) +
  geom_line() +
  facet_wrap(~PAT_ETHNICITY) +
  scale_color_manual(values = c("navyblue", "springgreen3", "tomato", "purple", "lightsalmon3")) +
  labs(x = "Time", y = "Hours", color = "Ethnicity") +
  ggtitle("Patient Length of Stay Time Series By Ethnicity") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), legend.title = element_text(size = 20), legend.text = element_text(size = 20), legend.key.size = unit(.5, "in"), legend.position = "none", strip.text = element_text(size = 18))

LOS2

# facet_wrap has another two inputs that can be included: nrow, ncol
# these inputs indicate the number of rows and number of columns we want to see plotted
# lets look at just one row

LOS2 = ggplot(data = dat, aes(x = PAT_ARRIVED, y = PAT_LOS_HOURS, color = PAT_ETHNICITY)) +
  geom_line() +
  facet_wrap(~PAT_ETHNICITY, nrow = 1) +
  scale_color_manual(values = c("navyblue", "springgreen3", "tomato", "purple", "lightsalmon3")) +
  labs(x = "Time", y = "Hours", color = "Ethnicity") +
  ggtitle("Patient Length of Stay Time Series By Ethnicity") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text.x = element_text(size = 14), axis.text.y = element_text(size = 20), legend.title = element_text(size = 20), legend.text = element_text(size = 20), legend.key.size = unit(.5, "in"), legend.position = "none", strip.text = element_text(size = 18))

LOS2

# facet_wrap has another input: scales
# scales indicates whether or not each plot should have its own x scale, y scale, or x & y scale.. or if all plots should have the same x & y scale
# if you want each plot to have its own x scale then: scales = "free_x"
# if you want each plot to have its own y scale then: scales = "free_y"
# if you want each plot to have its own x & y scale then: scales = "free"
# by default each plot has the same x & y scale: scales = "fixed"
# lets do free so we can see an independent x-axis and y-axis on each plot

LOS2 = ggplot(data = dat, aes(x = PAT_ARRIVED, y = PAT_LOS_HOURS, color = PAT_ETHNICITY)) +
  geom_line() +
  facet_wrap(~PAT_ETHNICITY, scales = "free") +
  scale_color_manual(values = c("navyblue", "springgreen3", "tomato", "purple", "lightsalmon3")) +
  labs(x = "Time", y = "Hours", color = "Ethnicity") +
  ggtitle("Patient Length of Stay Time Series By Ethnicity") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), legend.title = element_text(size = 20), legend.text = element_text(size = 20), legend.key.size = unit(.5, "in"), legend.position = "none", strip.text = element_text(size = 18))

LOS2

# lets look at barcharts now
# barcharts are great for displaying summary statistics so lets first create some summary statistics using mysummary and myaggregate

mysummary = function(dat)
{
  c("N" = length(dat), summary(dat), "Std Dev" = sd(dat))
}

myaggregate = function(x, by, FUN)
{
  result = aggregate(x = x, by = by, FUN = FUN)
  
  name = c(colnames(result)[1:(NCOL(result) - 1)], colnames(result[,NCOL(result)]))
  result = data.frame(result[,1:(NCOL(result) - 1)], result[,NCOL(result)])
  colnames(result) = name
  
  return(result)
}

# lets look at mean length of stay for each DOCTOR

dat3 = myaggregate(x = list("PAT_LOS_HOURS" = dat[,11]), by = list("DOCTOR" = dat[,6]), FUN = mysummary)

dat3

# geom_bar is a function that creates bar charts
# we will add in the input: stat = "identity" to plot the values given in y, in our case: Mean
# by default geom_bar() wants to plot the count of x, in our case: DOCTOR
# we will add the input: fill, to fill the color of the bars based on the levels of DOCTOR
# we will set legend.position = "none" to save on space and because the information is taken care of by the x-axis

LOS3 = ggplot(data = dat3, aes(x = DOCTOR, y = Mean, fill = DOCTOR)) +
  geom_bar(stat = "identity") +
  labs(x = "Doctor", y = "Hours", fill = "Doctor") +
  ggtitle("Patient Mean Length of Stay By Doctor") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text.x = element_text(size = 14), axis.text.y = element_text(size = 20), legend.title = element_text(size = 20), legend.text = element_text(size = 20), legend.key.size = unit(.5, "in"), legend.position = "none")

LOS3

# there is overlap on some of the doctor names
# lets rotate the x-axis labels to prevent this overlap
# we can do this by adding the input: axis.text.x, to theme
# axis.text.x uses the function element_text to specify the angle we want to rotate the text in the x-axis
# the input angle can take any angle: negative or positive
# we will also set the input hjust, to hjust = 1 to right adjust the x-axis text horizontally, this is so the labels align better
# the input hjust can take a value between 0 and 1 --> 0 means left adjusted, 0.5 means centered, 1 means right adjusted

LOS3 = ggplot(data = dat3, aes(x = DOCTOR, y = Mean, fill = DOCTOR)) +
  geom_bar(stat = "identity") +
  labs(x = "Doctor", y = "Hours", fill = "Doctor") +
  ggtitle("Patient Mean Length of Stay By Doctor") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text.y = element_text(size = 20), legend.title = element_text(size = 20), legend.text = element_text(size = 20), legend.key.size = unit(.5, "in"), legend.position = "none", axis.text.x = element_text(size = 14, angle = 45, hjust = 1))

LOS3

# lets look at mean length of stay for each PAT_CLASS by PRE_OPTIMIZATION

dat4 = myaggregate(x = list("PAT_LOS_HOURS" = dat[,11]), by = list("PRE_OPTIMIZATION" = dat[,12], "PAT_CLASS" = dat[,5]), FUN = mysummary)

dat4

# we will set fill = PRE_OPTIMIZATION so we can let the fill color show the difference

LOS4 = ggplot(data = dat4, aes(x = PAT_CLASS, y = Mean, fill = PRE_OPTIMIZATION)) +
  geom_bar(stat = "identity") +
  labs(x = "Class", y = "Hours", fill = "Pre-Optimization") +
  ggtitle("Patient Mean Length of Stay By Patient Class") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), legend.title = element_text(size = 20), legend.text = element_text(size = 20), legend.key.size = unit(.5, "in"), legend.position = "top")

LOS4

# geom_bar() by default will stack colors so we need to set position = "dodge" to place fill colors side-by-side

LOS4 = ggplot(data = dat4, aes(x = PAT_CLASS, y = Mean, fill = PRE_OPTIMIZATION)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(x = "Class", y = "Hours", fill = "Pre-Optimization") +
  ggtitle("Patient Mean Length of Stay By Patient Class") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), legend.title = element_text(size = 20), legend.text = element_text(size = 20), legend.key.size = unit(.5, "in"), legend.position = "top")

LOS4

# lets look at mean length of stay for each PAT_CLASS by PRE_OPTIMIZATION and DOCTOR

dat5 = myaggregate(x = list("PAT_LOS_HOURS" = dat[,11]), by = list("PRE_OPTIMIZATION" = dat[,12], "PAT_CLASS" = dat[,5], "DOCTOR" = dat[,6]), FUN = mysummary)

dat5

LOS5 = ggplot(data = dat5, aes(x = PAT_CLASS, y = Mean, fill = PRE_OPTIMIZATION)) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_wrap(~DOCTOR, scales = "free_x") +
  labs(x = "Class", y = "Hours", fill = "Pre-Optimization") +
  ggtitle("Patient Mean Length of Stay By Patient Class & Doctor") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text.x = element_text(size = 16), axis.text.y = element_text(size = 18), legend.title = element_text(size = 20), legend.text = element_text(size = 20), legend.key.size = unit(.5, "in"), legend.position = "top", strip.text = element_text(size = 16))

LOS5

# there is alot of white space in the bottom right corner of the plot, so lets place the legend over there to give the graphics more space
# we can manually choose the legend position by setting legend.postion = c(num1, num2)
# num1 represents horizontal placement, where 0 is far left and 1 is far right
# num2 represents vertical placement, where 0 is bare bottom and 1 is up top
# lets also change the direction of the legend keys so that way they are shown in a horizontal fashion
# we do this by setting legend.direction = "horizontal" in theme
# by default legend.direction = "vertical"

LOS5 = ggplot(data = dat5, aes(x = PAT_CLASS, y = Mean, fill = PRE_OPTIMIZATION)) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_wrap(~DOCTOR, scales = "free_x") +
  labs(x = "Class", y = "Hours", fill = "Pre-Optimization") +
  ggtitle("Patient Mean Length of Stay By Patient Class & Doctor") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text.x = element_text(size = 16), axis.text.y = element_text(size = 18), legend.title = element_text(size = 20), legend.text = element_text(size = 20), legend.key.size = unit(.5, "in"), legend.position = c(.75, .05), legend.direction = "horizontal", strip.text = element_text(size = 16))

LOS5

# lets look at boxplots now
# we acheive boxplots using geom_boxplot()
# lets do a boxplot of length of stay by GENDER
# notice the input: notch, in geom_boxplot
# this notch is an approximate 95% Confidence Interval about the median
# a notch is useful when comparing two or more boxplots, if two notches overlap then that indicates little difference between the two sets of data

LOS6 = ggplot(data = dat, aes(x = PAT_GENDER, y = PAT_LOS_HOURS, fill = PAT_GENDER)) +
  geom_boxplot(notch = TRUE) +
  labs(x = "Gender", y = "Hours") +
  ggtitle("Patient Length of Stay By Gender") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), legend.position = "none")

LOS6

# a better look at boxplots may be horizontal rather than vertical
# we can acheive this by adding in the function coord_flip which flips the cooridinate axes

LOS6 = ggplot(data = dat, aes(x = PAT_GENDER, y = PAT_LOS_HOURS, fill = PAT_GENDER)) +
  geom_boxplot(notch = TRUE) +
  labs(x = "Gender", y = "Hours") +
  ggtitle("Patient Length of Stay By Gender") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), legend.position = "none") +
  coord_flip()

LOS6

# lets look at length of stay by GENDER & PAT_ETHNICITY

LOS7 = ggplot(data = dat, aes(x = PAT_GENDER, y = PAT_LOS_HOURS, fill = PAT_GENDER)) +
  geom_boxplot(notch = TRUE) +
  facet_wrap(~PAT_ETHNICITY) +
  labs(x = "Gender", y = "Hours") +
  ggtitle("Patient Length of Stay By Gender & Ethnicity") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), legend.position = "none", strip.text = element_text(size = 18)) +
  coord_flip()

LOS7

# lets look at an alternative to boxplots: violin plots
# violin plots show a smooth representation of where the data is sitting
# lets look at the length of stay by GENDER & PAT_ETHNICITY
# to acheive violin plots we will use the function geom_violin 
# we will also add in the input: alpha, which takes on a value between 0 and 1 to represent transparency

LOS7 = ggplot(data = dat, aes(x = PAT_GENDER, y = PAT_LOS_HOURS, fill = PAT_GENDER)) +
  geom_violin(alpha = 0.25) +
  facet_wrap(~PAT_ETHNICITY) +
  labs(x = "Gender", y = "Hours") +
  ggtitle("Patient Length of Stay By Gender & Ethnicity") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), legend.position = "none", strip.text = element_text(size = 18)) +
  coord_flip()

LOS7

# lets include another function: geom_jitter
# this will show us data points on where the data is sitting within the violin plot
# we will add the input color to aes to correspond to the color of the points in the jitter plot, while the fill corresponds to the fill color of the violin plot
# we will add the input alpha to geom_jitter with a higher value so the points are more visible than the violin plot
# the value in using alpha is that when points overlap there will be a darker color which shows density

LOS7 = ggplot(data = dat, aes(x = PAT_GENDER, y = PAT_LOS_HOURS, fill = PAT_GENDER, color = PAT_GENDER)) +
  geom_violin(alpha = 0.25) +
  geom_jitter(alpha = 0.5) +
  facet_wrap(~PAT_ETHNICITY) +
  labs(x = "Gender", y = "Hours") +
  ggtitle("Patient Length of Stay By Gender & Ethnicity") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), legend.position = "none", strip.text = element_text(size = 18)) +
  coord_flip()

LOS7

# lets play with colors by giving the violin fill color a lighter shade of blue and red, and giving the point color of the jitter plot a darker shade of blue and red
# we will use scale_fill_manual to give the lighter shade of blue and red to the violin plot
# there are two levels in our fill variable: PAT_GENDER, so we will need a vector of two colors
# we will use scale_color_manual to give the darker shade of blue and red to the jitter plot
# there are two levels in our color variable: PAT_GENDER, so we will need a vector of two colors

LOS7 = ggplot(data = dat, aes(x = PAT_GENDER, y = PAT_LOS_HOURS, fill = PAT_GENDER, color = PAT_GENDER)) +
  geom_violin(alpha = 0.25) +
  geom_jitter(alpha = 0.33) +
  scale_fill_manual(values = c("cornflowerblue", "indianred")) +
  scale_color_manual(values = c("blue", "red")) +
  facet_wrap(~PAT_ETHNICITY) +
  labs(x = "Gender", y = "Hours") +
  ggtitle("Patient Length of Stay By Gender & Ethnicity") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), legend.position = "none", strip.text = element_text(size = 18)) +
  coord_flip()

LOS7

# lets reduce the amount of spread from the jitter points
# we can acheive this by including the input: width

LOS7 = ggplot(data = dat, aes(x = PAT_GENDER, y = PAT_LOS_HOURS, fill = PAT_GENDER, color = PAT_GENDER)) +
  geom_violin(alpha = 0.25) +
  geom_jitter(alpha = 0.33, width = 0.5) +
  scale_fill_manual(values = c("cornflowerblue", "indianred")) +
  scale_color_manual(values = c("blue", "red")) +
  facet_wrap(~PAT_ETHNICITY) +
  labs(x = "Gender", y = "Hours") +
  ggtitle("Patient Length of Stay By Gender & Ethnicity") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), legend.position = "none", strip.text = element_text(size = 18)) +
  coord_flip()

LOS7

# lets look at histograms
# we acheive histograms using geom_histogram

LOS8 = ggplot(data = dat, aes(x = PAT_LOS_HOURS)) +
  geom_histogram() +
  labs(x = "Hours", y = "Frequency") +
  ggtitle("Patient Length of Stay") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20))

LOS8

# lets adjust the binwidth to better see the distribution
# also lets add in a colored outline to better see the bars

LOS8 = ggplot(data = dat, aes(x = PAT_LOS_HOURS)) +
  geom_histogram(color = "white", binwidth = 5) +
  labs(x = "Hours", y = "Frequency") +
  ggtitle("Patient Length of Stay") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20))

LOS8

# it would be easier to interpret the histogram if the x-axis increment fell in line with the binwidth
# we can acheive this using scale_x_continuous
# scale_x_continuous has an input breaks, this input requires a vector with every single label that we want to see
# in our case we can create a sequence of numbers from 0 to 170 incremented by 10 to align with the min of the data, max of the data, and binwidth of the histogram

LOS8 = ggplot(data = dat, aes(x = PAT_LOS_HOURS)) +
  geom_histogram(color = "white", binwidth = 5) +
  scale_x_continuous(breaks = seq(from = 0, to = 170, by = 10)) + 
  labs(x = "Hours", y = "Frequency") +
  ggtitle("Patient Length of Stay") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20))

LOS8

# lets add a little more color to our histogram
# we can add the input fill to geom_histogram for specifying just one color

LOS8 = ggplot(data = dat, aes(x = PAT_LOS_HOURS)) +
  geom_histogram(fill = "indianred", color = "white", binwidth = 5) +
  scale_x_continuous(breaks = seq(from = 0, to = 170, by = 10)) + 
  labs(x = "Hours", y = "Frequency") +
  ggtitle("Patient Length of Stay") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20))

LOS8

# lets look at density plots
# we acheieve density plots with geom_density
# notice in aes we used '..count..' for the y input, this will make the y-axis into a count value (like a histogram) instead of a density value (which is harder to interpret)
# the input bw in geom_density is the bandwidth input, similar to the input: binwidth, for geom_histogram
# it is important to note that the height of the frequency axis for geom_density will be less than or equal to the height of the geom_histogram frequency axis
# any bar in the histogram represents the frequency for multiple numbers
# any point on the line in the density plot represents the frequency for one number
# the only time the height of the frequnecy axis for a density plot and a histogram matches is when the data is integer and the binwidth is equal to the increment of the integer data
# an example of this would be: our data is AGE_IN_YEARS and the binwidth is 1 year)
# therefore each bar in the histogram represents one number (one year), not multiple numbers

LOS9 = ggplot(data = dat, aes(x = PAT_LOS_HOURS, y = ..count..)) +
  geom_density(bw = 5) +
  labs(x = "Hours", y = "Frequency") +
  ggtitle("Patient Length of Stay") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20))

LOS9

# this double peak is likely due to the factor PAT_CLASS
# so lets add in some color to see if we can distinguish this
# we do this by specifying PAT_CLASS as the color and fill input in aes
# we will also add in the input: alpha, in geom_density which takes on a value between 0 and 1 to represent transparency

LOS9 = ggplot(data = dat, aes(x = PAT_LOS_HOURS, y = ..count.., color = PAT_CLASS, fill = PAT_CLASS)) +
  geom_density(bw = 5, alpha = 0.25) +
  labs(x = "Hours", y = "Frequency", color = "Class", fill = "Class") +
  ggtitle("Patient Length of Stay By Class") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), legend.title = element_text(size = 20), legend.text = element_text(size = 20), legend.key.size = unit(.5, "in"), legend.position = "top")

LOS9

# lets change up the colors
# we do this by using the functions scale_fill_manual to change the colors corresponding to the fill input in aes, and by using the functions scale_color_manual to change the colors corresponding to the color input in aes
# given that color for us is PAT_CLASS and PAT_CLASS has two levels: Inpatient & Outpatient, we must give scale_color_manual a vector of two colors
# given that fill for us is PAT_CLASS and PAT_CLASS has two levels: Inpatient & Outpatient, we must give scale_fill_manual a vector of two colors
# these functions will work in the previous graphs as well for changing the color of aes inputs: fill and color

LOS9 = ggplot(data = dat, aes(x = PAT_LOS_HOURS, y = ..count.., color = PAT_CLASS, fill = PAT_CLASS)) +
  geom_density(bw = 5, alpha = 0.25) +
  scale_fill_manual(values = c("cornflowerblue", "forestgreen")) +
  scale_color_manual(values = c("cornflowerblue", "forestgreen")) +
  labs(x = "Hours", y = "Frequency", color = "Class", fill = "Class") +
  ggtitle("Patient Length of Stay By Class") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), legend.title = element_text(size = 20), legend.text = element_text(size = 20), legend.key.size = unit(.5, "in"), legend.position = "top")

LOS9

# lets look at scatterplots
# we acheive scatterplots with the function geom_point
# lets see if there's a relationship between PAT_LOS_HOURS and PAT_WAITED_DAYS

LOS10 = ggplot(data = dat, aes(x = PAT_LOS_HOURS, y = PAT_WAITED_DAYS)) +
  geom_point() +
  labs(x = "Stay (Hours)", y = "Wait (Days)") +
  ggtitle("Patient Length of Stay v. Waiting for Appointment") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20))

LOS10

# there doesn't seem to be a linear or polynomial relationship but there are two distinct groups, this may be due to PAT_CLASS
# so lets color points based on PAT_CLASS

LOS10 = ggplot(data = dat, aes(x = PAT_LOS_HOURS, y = PAT_WAITED_DAYS, color = PAT_CLASS)) +
  geom_point() +
  scale_color_manual(values = c("blue", "forestgreen")) +
  labs(x = "Stay (Hours)", y = "Wait (Days)", color = "Class") +
  ggtitle("Patient Length of Stay v. Waiting for Appointment By Class") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), legend.title = element_text(size = 20), legend.text = element_text(size = 20), legend.key.size = unit(.5, "in"), legend.position = "top")

LOS10

# now when data is clustered together tight, take advantage of the color input in geom_point and use the function alpha to give transparency to the data points
# this will then show darker color for points that overlap and lighter color for points that stand alone

LOS11 = ggplot(data = dat, aes(x = PAT_LOS_HOURS, y = PAT_WAITED_DAYS, color = PAT_CLASS)) +
  geom_point(alpha = 0.33) +
  scale_color_manual(values = c("blue", "darkgreen")) +
  labs(x = "Stay (Hours)", y = "Wait (Days)", color = "Class") +
  ggtitle("Patient Length of Stay v. Waiting for Appointment By Class") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), legend.title = element_text(size = 20), legend.text = element_text(size = 20), legend.key.size = unit(.5, "in"), legend.position = "top")

LOS11

# another alternative to handling tight data in scatterplots is to do a hexbin scatterplot
# hexbins are hexgonal symbols replacing the points to give a smoother representation of the density of tight data
# if you want: increase the number of bins to make smaller hexagons by using the input: bins, in geom_hex

require(hexbin)

LOS12 = ggplot(data = dat, aes(x = PAT_LOS_HOURS, y = PAT_WAITED_DAYS)) +
  geom_hex(bins = 30) +
  labs(x = "Stay (Hours)", y = "Wait (Days)", fill = "Frequency") +
  ggtitle("Patient Length of Stay v. Waiting for Appointment") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), legend.title = element_text(size = 20), legend.text = element_text(size = 20), legend.key.size = unit(.5, "in"))

LOS12

# ifelse statements work similar to the IF function in excel
# try this simple example to understand how the ifelse function works

ifelse(1 > 2, "yes", "no")

# lets look at pie charts
# pie charts are a way to graph proportions as an alternative to barplots
# let look at the proportions of PAT_AGE
# first we need to pick categories to put PAT_AGE into, lets go with: 20's, 30's, ... , 80's

name = c("20's", "30's", "40's", "50's", "60's", "70's", "80's")

# now lets group all the data into one of the seven categories using nested ifelse statements

factors = as.factor(ifelse(dat[,2] < 30, name[1], 
                           ifelse(dat[,2] < 40, name[2], 
                                  ifelse(dat[,2] < 50, name[3], 
                                         ifelse(dat[,2] < 60, name[4], 
                                                ifelse(dat[,2] < 70, name[5], 
                                                       ifelse(dat[,2] < 80, name[6], name[7])))))))

# here is what the data should look like when plotting proportions

dat6 = data.frame("factors" = names(summary(factors)), "counts" = summary(factors), row.names = 1:length(levels(factors)))
dat6

# we acheive pie charts with the functions geom_bar and coord_polar
# coord_polar require the input: theta
# theta corresponds to the variable in aes that we want to be the data plotted

AGE = ggplot(data = dat6, aes(x = "", y = counts, fill = factors)) +
  geom_bar(stat = "identity") +
  coord_polar(theta = "y") +
  labs(fill = "Age Groups") +
  ggtitle("Patient Age") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 18), legend.title = element_text(size = 20), legend.text = element_text(size = 20), legend.key.size = unit(.5, "in"), legend.position = "top")

AGE

# to get rid of that open hole in the middle, set the input: width = 1 in geom_bar

AGE = ggplot(data = dat6, aes(x = "", y = counts, fill = factors)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar(theta = "y") +
  labs(fill = "Age Groups") +
  ggtitle("Patient Age") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 18), legend.title = element_text(size = 20), legend.text = element_text(size = 20), legend.key.size = unit(.5, "in"), legend.position = "top")

AGE

# the colors that ggplot chooses for you may not be to your liking so lets look at some different color palettes from the package: RColorBrewer

require(RColorBrewer)

# to see information on all the color brewers run the code below
# the following columns you will see are: maxcolors, category, colorblind
# maxcolors is the maximum number of colors this pallete can plot, but this can be overridden with a function: colorRampPalette
# colorRampPalette will add granularity to the color set to allow for any number of colors
# category has 3 levels div (Diverging), qual (Qualitative), seq(Sequential)
# div is intended for data that requires emphaiss on low, medium, or high values
# qual is intended for data that requires clear distinction between all categories
# seq is intended for data that requires order, so colors progress in shade from low to high values
# colorblind is TRUE or FALSE indicating the color set is colorblind friendly or not

brewer.pal.info

# to see the color palettes run the following code

display.brewer.all()

# in our case we should be interested in div color palettes to make a distinction between age groups
# my personal favorite is: Paired
# we will use the function scale_fill_manual to give colors to the input fill in the function aes
# now I'm going to use the functions: brewer.pal and colorRampPalette, together so you know the code for any number of colors you may need
# brewer.pal has two inputs: n, name
# n is the number of colors you need --> we will choose the maxcolors value (given in brewer.pal.info) and let colorRampPalette choose the correct number we need
# name is the name of the color palette that we want to use
# colorRampPalette requires one input, the set of colors to add granularity to if necessary
# outside of the function colorRampPalette, we will specify the number of colors we need
# here is the code to combine brewer.pal and colorRampPalette
# if you run this code then you will see the all the color codes that will be used

colorRampPalette(brewer.pal(n = 12, name = "Paired"))(7)

# heres the pie chart using the Paried color palette

AGE = ggplot(data = dat6, aes(x = "", y = counts, fill = factors)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar(theta = "y") +
  labs(fill = "Age Groups") +
  scale_fill_manual(values = colorRampPalette(brewer.pal(n = 12, name = "Paired"))(7)) +
  ggtitle("Patient Age") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), legend.title = element_text(size = 20), legend.text = element_text(size = 20), legend.key.size = unit(.5, "in"), legend.position = "top")

AGE

# finally lets remove the axis labels
# we can acheieve this by adding the following inputs into theme:
# axis.title.x = element_blank(), to remove the x axis title
# axis.title.y = element_blank(), to remove the y axis title
# axis.ticks.y = element_blank(), to remove the x axis ticks

# other functions we don't need to use, but so you know the full set, are:
# axis.text.x = element_blank(), to remove the x axis text labels
# axis.tick.x = element_blank(), to remove the x axis ticks
# axis.text.y = element_blank(), to remove the y axis text labels

AGE = ggplot(data = dat6, aes(x = "", y = counts, fill = factors)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar(theta = "y") +
  labs(fill = "Age Groups") +
  scale_fill_manual(values = colorRampPalette(brewer.pal(n = 12, name = "Paired"))(7)) +
  ggtitle("Patient Age") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), legend.title = element_text(size = 20), legend.text = element_text(size = 20), legend.key.size = unit(.5, "in"), legend.position = "top", axis.title.x = element_blank(), axis.title.y = element_blank(), axis.ticks.y = element_blank())

AGE

# now lets look at the same data but in terms of just a barplot

AGE2 = ggplot(data = dat6, aes(x = factors, y = 100* (counts / sum(counts)), fill = factors)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(x = "Age Groups", y = "Percentage") +
  scale_fill_manual(values = colorRampPalette(brewer.pal(n = 12, name = "Paired"))(7)) +
  ggtitle("Patient Age") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), legend.title = element_text(size = 20), legend.text = element_text(size = 20), legend.key.size = unit(.5, "in"), legend.position = "none")

AGE2

# lets look at waffle plots
# waffle plots are an alternative to pie charts and barplots when it comes to graphing proportions
# waffle plots show you every data point as a square to give you an idea on how proportions are spread out

# here is a function I found online to do waffle plots

waffles = function(factors, counts, rows, plot_title = "", strip_title = "", legend_title = "", legend_position = "top", legend_rows = "", legend_cols = "")
{
  require(ggplot2)
  require(RColorBrewer)
  
  waffle = expand.grid(y = 1:rows, x = seq_len(ceiling(sum(counts) / rows)))
  factors = rep(as.character(factors), counts)
  waffle$key = c(factors, rep(NA, nrow(waffle) - length(factors)))
  waffle$strip = rep(strip_title, NROW(waffle))
  
  wplot = ggplot(waffle, aes(x = x, y = y, fill = factor(key))) + 
    geom_tile(color = "white") +
    labs(fill = legend_title) + 
    scale_fill_manual(values = colorRampPalette(brewer.pal(12, "Paired"))(length(counts))) +
    scale_x_discrete(expand = c(.01, .01)) +
    scale_y_discrete(expand = c(.01, .01)) +
    theme(plot.title = element_text(size = 20), strip.text = element_text(size = 20), legend.position = legend_position, axis.title.x = element_blank(), axis.title.y = element_blank(), legend.title = element_text(size = 20), legend.text = element_text(size = 20), legend.key.size = unit(.5, "in"))
  
  if(plot_title != "")(wplot = wplot + ggtitle(plot_title))
  if(strip_title != "")(wplot = wplot + facet_wrap(~strip))
  if(legend_rows != "")(wplot = wplot + guides(fill = guide_legend(nrow = legend_rows)))
  if(legend_cols != "")(wplot = wplot + guides(fill = guide_legend(nrow = legend_cols)))
  
  return(wplot)
}

# waffles is a function that requires a minimum of three inputs:
# the factors you want to plots
# the counts of those factors
# the number of rows you want to plot

# additional inputs include:
# a plot title
# a strip title
# a legend title
# the legend position
# the number of rows for the legend
# the number of columns for the legend

# heres the minimum
# if the squares look more like rectangles then adjust the number of rows

waffles(factors = dat6[,1], counts = dat6[,2], rows = 20)

# lets place the legend as one row

waffles(factors = dat6[,1], counts = dat6[,2], rows = 20, legend_rows = 1)

# lets try different title options

waffles(factors = dat6[,1], counts = dat6[,2], rows = 20, legend_rows = 1, plot_title = "Patient Age")

waffles(factors = dat6[,1], counts = dat6[,2], rows = 20, legend_rows = 1, strip_title = "Patient Age")

# lets use the strip title option and put the legend on the bottom

AGE3 = waffles(factors = dat6[,1], counts = dat6[,2], rows = 20, legend_rows = 1, strip_title = "Patient Age", legend_title = "Age Groups", legend_position = "bottom")

AGE3

# lets remove some R objects

rm(AGE, AGE2, AGE3, dat3, dat4, dat5, dat6, factors, LOS, LOS10, LOS11, LOS12, LOS2, LOS3, LOS4, LOS5, LOS6, LOS7, LOS8, LOS9, name, waffles, myaggregate, mysummary) 

# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ---- Statistical Testing -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# in statistical testing we are looking for significant differences between groups of data
# it is important to remember that any significant differences found, are valuable patterns, but just patterns
# statistical testing DOES NOT prove or disprove causality
# statistical testing WITH experimental design DOES find strong or weak evidence of causality

# t.test is a function that performs the T-Test
# This is a statistical test that requires the data to take on real values (integer and/or decimal) 
# This is a statistical test that requires the data to come from a normal distribution
# the closer your data follows a normal distribution, the more relevant the results of a T-Test is
# t.test takes on a handful of inputs but the 3 ones we will cover are: formula, data, conf.level
# formula follows this format: x ~ y
# x is the column of data we are analyzing
# y is the column of data that will flag which of the two groups x belongs to
# data is the data.frame with the columns x and y in the input formula
# conf.level is the confidence level of our test: a value between (BUT NOT INCLUDING) 0 and 1
# typically confidence levels should be between .95 and .99
# the higher the conf.level, the more difficult it is to pass the test --> passing a more difficult test indicates stronger evidence of causality

# lets see if PAT_WAITED_DAYS follows a normal distribution

require(ggplot2)

# take a look at a histogram

ggplot(data = dat, aes(x = PAT_WAITED_DAYS)) +
  geom_histogram(binwidth = 2, color = "white", fill = "cornflowerblue") +
  scale_x_continuous(breaks = seq(from = 0, to = 32, by = 2)) + 
  labs(x = "Days", y = "Frequency") +
  ggtitle("Patient Wait Time for Appointment") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20))

# take a look at a density plot

ggplot(data = dat, aes(x = PAT_WAITED_DAYS, y = ..count..)) +
  geom_density(bw = 2, color = "cornflowerblue", fill = "cornflowerblue", alpha = 0.25) +
  labs(x = "Days", y = "Frequency") +
  ggtitle("Patient Wait Time for Appointment") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20))

# another graphical way to validate normality is with a normal qqplot
# a qqplot stands for a quantile-quantile plot
# this a scatterplot of the quantiles of your data v. the theoretical quantiles of a normal distribution
# if there is a strong linear relationship along the qqline, then the qqplot provides strong evidence for your data coming from a noraml distribution

# here is a function i found online that produces qqplots using ggplot graphics
# the function takes on many inputs:
# x, the data you want to to test against a distribution
# distribution, the R name for any avaiable distribution in R
# by default it is set to "norm" which is the R name for the normal distribution
#..., this is meant for distributions which require additional inputs
# for example if we were to set distribtuion = "chisq"
# then we would need to include a parameter for the degrees of freedom, for example: df = 24
# so we would write out the following:
# ggqq(x = mydata, distribution = "chisq", df = 24)
# conf, the confidence level for the confidence interval that will be plotted about the qqline
# probs, the percentile pair that the qqline will be drawn between
# the standard percentile pair is 0.25 and 0.75, corresponding to the 1st and 3rd quartile respectively
# note, if TRUE then a note regarding probs is included in the plot, if FALSE then no note is included
# alpha, the transparency value of the data points in the qqplot
# can take a value between 0 and 1, where 0 is absolute transparency and 1 is no transparency
# main, the plot title
# xlab, the x axis label
# ylab, the y axis label

ggqq = function(x, distribution = "norm", ..., conf = 0.95, probs = c(0.25, 0.75), alpha = 0.33, basefont = 20, main = "", xlab = "\nTheoretical Quantiles", ylab = "Empirical Quantiles\n")
{
  require(ggplot2)
  
  # compute the sample quantiles and theoretical quantiles
  q.function = eval(parse(text = paste0("q", distribution)))
  d.function = eval(parse(text = paste0("d", distribution)))
  x = na.omit(x)
  ord = order(x)
  n = length(x)
  P = ppoints(length(x))
  df = data.frame(ord.x = x[ord], z = q.function(P, ...))
  
  # compute the quantile line
  Q.x = quantile(df$ord.x, c(probs[1], probs[2]))
  Q.z = q.function(c(probs[1], probs[2]), ...)
  b = diff(Q.x) / diff(Q.z)
  coef = c(Q.x[1] - (b * Q.z[1]), b)
  
  # compute the confidence interval band
  zz = qnorm(1 - (1 - conf) / 2)
  SE = (coef[2] / d.function(df$z, ...)) * sqrt(P * (1 - P) / n)
  fit.value = coef[1] + (coef[2] * df$z)
  df$upper = fit.value + (zz * SE)
  df$lower = fit.value - (zz * SE)
  
  
  # plot the qqplot
  p = ggplot(df, aes(x = z, y = ord.x)) + 
    geom_point(color = "blue", alpha = alpha) +
    geom_abline(intercept = coef[1], slope = coef[2], size = 1) +
    geom_ribbon(aes(ymin = lower, ymax = upper), alpha = 0.1) +
    coord_cartesian(ylim = c(min(df$ord.x), max(df$ord.x))) + 
    labs(x = xlab, y = ylab) +
    theme_light(base_size = basefont) +
	theme(legend.position = "none")
  
  
  # conditional additions
  if(main != "")(p = p + ggtitle(main))
  
  return(p)
}

# take a look at a qqplot
# notice the \n syntax, this is how you insert an indent to start a new line

ggqq(x = dat$PAT_WAITED_DAYS, main = "Normal QQ-Plot:\nPatient Wait Time for Appointment", xlab = "\nTheoretical Quantiles:\nStandard Normal", ylab = "Empirical Quantiles:\nTime (Days)\n")

# a simple way to check for normality is to see if PAT_WAITED_DAYS follows the characteristics of a normal distribution where:
# 68% of the data is within 1 standard deviation of the mean
# 95% of the data is within 2 standard deviations of the mean
# 99.7% of the data is within 3 standard deviations of the mean

mydat = dat$PAT_WAITED_DAYS

LSD1 = mean(mydat) - sd(mydat)
USD1 = mean(mydat) + sd(mydat)
LSD2 = mean(mydat) - (2 * sd(mydat))
USD2 = mean(mydat) + (2 * sd(mydat))
LSD3 = mean(mydat) - (3 * sd(mydat))
USD3 = mean(mydat) + (3 * sd(mydat))

percent_SD1 = length(which(mydat >= LSD1 & mydat <= USD1)) / length(mydat)
percent_SD2 = length(which(mydat >= LSD2 & mydat <= USD2)) / length(mydat)
percent_SD3 = length(which(mydat >= LSD3 & mydat <= USD3)) / length(mydat)

percent_SD1
percent_SD2
percent_SD3

# now lets run a two statistical tests to test for normality
# the first one we will look at is one of the most popular: the shapiro-wilk test
# this test is run by the function shaprio.test
# this function requires one input, x, this is the data that we are testing if it comes from a normal distribution
# this function is limited to 5000 data points
# before we run the test lets go over the hypothesis test
# every statistical test has a hypothesis, and that must be understood first before the results can be understood
# for the shapiro-wilks test we have two hypothesis, the null and the alternative
# the null: the data comes from a normal distribution
# the alternative: the data doesn't come from a noraml distribution
# every hypothesis test result is ultimately decided by the p-value
# the p-value corresponds to your level of confidence
# for example, if our level of confidence is 0.95 then the deciding p-value value is 0.05 --> if p-value < 0.05 then reject null else fail to reject null
# for example, if our level of confidence is 0.99 then the deciding p-value value is 0.01 --> if p-value < 0.01 then reject null else fail to reject null
# lets run the shapiro.test function, 

shapiro.test(x = dat$PAT_WAITED_DAYS)

# the second one we will run is the anderson-darling test
# this test is not limited by data points
# this function requires one input, x, this is the data that we are testing if it comes from a normal distribution
# for the anderson-darling test we have two hypothesis, the null and the alternative
# the null: the data comes from a normal distribution
# the alternative: the data doesn't come from a noraml distribution
# the p-value corresponds to your level of confidence
# for example, if our level of confidence is 0.95 then the deciding p-value value is 0.05 --> if p-value < 0.05 then reject null else fail to reject null
# for example, if our level of confidence is 0.99 then the deciding p-value value is 0.01 --> if p-value < 0.01 then reject null else fail to reject null

require(nortest)
ad.test(x = dat$PAT_WAITED_DAYS)

# now remember that these tests provide evidence, not proof, so don't take the results of these tests as fact
# to signify the difference between evidence and fact, lets run a little experiment

# rnorm is a function that randomly samples from a normal distribution
# rnorm has 3 key inputs:
# n is the number of samples
# mean is the mean of the normal distribution we're sampling from
# sd is the standard deviation of the normal distribution we're sampling from
# try out this simple example to understand how rnorm works

rnorm(n = 10, mean = 100, sd = 10)

# i want you to run this code multiple times, sooner than later you'll find that it says that your sample of 1000 data points doesn't come from a normal distribution.. even though you randomly sampled from a normal distribution

shapiro.test(rnorm(n = 1000, mean = 100, sd = 10))

# try it with ad.test too

ad.test(x = rnorm(n = 1000, mean = 100, sd = 10))

# so it is important to use graphics as well as tests when making statistical decisions
# lets assume a normal distribution

# lets see if there is a significant difference in PAT_WAITED_DAYS due to PRE_OPTIMIZATION
# for the T-test we have two hypothesis, the null and the alternative
# the null: the difference in means of the two samples is zero
# the alternative: the difference in means of the two samples is not zero
# the p-value corresponds to your level of confidence
# for example, if our level of confidence is 0.95 then the deciding p-value value is 0.05 --> if p-value < 0.05 then reject null else fail to reject null
# for example, if our level of confidence is 0.99 then the deciding p-value value is 0.01 --> if p-value < 0.01 then reject null else fail to reject null
# the key information in the T-test is:
# a p-value
# a confidence interval of the difference in means
# the mean of each group

t.test(formula = PAT_WAITED_DAYS ~ PRE_OPTIMIZATION, data = dat, conf.level = 0.99)

# what if we only wanted to look at this difference for just inpatient
# then we would subset the data in the following
# this is specifying a condition on the rows of dat
# the condition is only keep the rows that have a PAT_CLASS equal to INPATIENT

dat[dat$PAT_CLASS == "INPATIENT",]

# an alternative way to subset dat in the same way is
# this is specifying a condition on the rows of dat
# the condition is only keep the rows that have a PAT_CLASS not equal to OUTPATIENT

dat[dat$PAT_CLASS != "OUTPATIENT",]

# lets run the test for only inpatient

t.test(formula = PAT_WAITED_DAYS ~ PRE_OPTIMIZATION, data = dat[dat$PAT_CLASS == "INPATIENT",], conf.level = 0.99)

# now what if we only wanted to look at this difference for just inpatient and doctor O'NEAL JAMES
# we would subset the dat in the following
# this is specifying a condition on the rows of dat
# the condition is only keep the rows that have a PAT_CLASS equal to INPATIENT and DOCTOR equal to O'NEAL JAMES

dat[dat$PAT_CLASS == "INPATIENT" & dat$DOCTOR == "O'NEAL JAMES",]

# lets run the test for only inpatient and doctor O'NEAL JAMES

t.test(formula = PAT_WAITED_DAYS ~ PRE_OPTIMIZATION, data = dat[dat$PAT_CLASS == "INPATIENT" & dat$DOCTOR == "O'NEAL JAMES",], conf.level = 0.95)

# now what if we only wanted to look at this difference for just inpatient and doctors O'NEAL JAMES and WEBBER, NATHAN
# we would subset the dat in the following
# this is specifying a condition on the rows of dat
# the condition is only keep the rows that have a PAT_CLASS equal to INPATIENT and DOCTOR equal to O'NEAL JAMES or WEBBER, NATHAN

dat[dat$PAT_CLASS == "INPATIENT" & (dat$DOCTOR == "O'NEAL JAMES" | dat$DOCTOR == "WEBBER, NATHAN"),]

# lets run the test for only inpatient and doctors O'NEAL JAMES and WEBBER, NATHAN

t.test(formula = PAT_WAITED_DAYS ~ PRE_OPTIMIZATION, data = dat[dat$PAT_CLASS == "INPATIENT" & (dat$DOCTOR == "O'NEAL JAMES" | dat$DOCTOR == "WEBBER, NATHAN"),], conf.level = 0.95)

# lappy is very similar to sapply: the difference is that sapply creates a vector, whereas lapply creates a list
# lapply is like a vectorized for-loop, so it run significantly faster than a for-loop
# lapply has two inputs: X, FUN --> lapply(X = ..., FUN = ...)
# input X is expected to be a set of numbers that will be iterated over
# input FUN is expected to be any function, such as mean() min() max() or a user defined function, for example: funtion(i) (max(i) - min(i))
# lapply computes the first iteration and stores it as the first entry in a list, then computes the second iteration and stores it as the second entry in a list, etc.
# try this simple example to understand how lapply works:

lapply(X = 1:4, FUN = function(i) (i + 0.5))

# compare lapply to sapply

sapply(X = 1:4, FUN = function(i) (i + 0.5))

# now what if we want to look at this difference for just inpatient, for each doctor individually
# there are 10 doctors so we could write out ten lines of code for the 10 T-tests we want to do
# but we will use lapply instead, to save time and effort

# we are assigning this code to an object name because we will need to assign the doctor names to each list element
tTest_By_Doctor = lapply(X = levels(dat$DOCTOR), FUN = function(i) t.test(formula = PAT_WAITED_DAYS ~ PRE_OPTIMIZATION, data = dat[dat$PAT_CLASS == "INPATIENT" & dat$DOCTOR == i,], conf.level = 0.95))

# make the names of the list elements, the doctor names
names(tTest_By_Doctor) = levels(dat$DOCTOR)

# take a look at the results
tTest_By_Doctor

# what if we were only interested in this difference for any patient, and only for doctors: 
# HAMILTON, JOSEPH 
# HEROOK, DAVID
# HIGGENS, JOHN
# MURPHY, ERIN
# we can still use lapply in the following way

tTest_By_Doctor2 = lapply(X = c("HAMILTON, JOSEPH", "HEROOK, DAVID", "HIGGENS, JOHN", "MURPHY, ERIN"), FUN = function(i) t.test(formula = PAT_WAITED_DAYS ~ PRE_OPTIMIZATION, data = dat[dat$DOCTOR == i,], conf.level = 0.95))
names(tTest_By_Doctor2) = c("HAMILTON, JOSEPH", "HEROOK, DAVID", "HIGGENS, JOHN", "MURPHY, ERIN")

tTest_By_Doctor2

# lets look at PAT_LOS_HOURS
# lets see if PAT_LOS_HOURS follows a normal distribution

# take a look at a histogram

ggplot(data = dat, aes(x = PAT_LOS_HOURS)) +
  geom_histogram(binwidth = 5, color = "white", fill = "cornflowerblue") +
  scale_x_continuous(breaks = seq(from = 0, to = 170, by = 10)) + 
  labs(x = "Hours", y = "Frequency") +
  ggtitle("Patient Length of Stay") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20))

# the histogram clearly shows this data is not normally distributed
# but for the sake of better understanding what normal distributions don't look like, we will look at the density plot and qqplot as well

# take a look at a density plot

ggplot(data = dat, aes(x = PAT_LOS_HOURS, y = ..count..)) +
  geom_density(bw = 5, color = "cornflowerblue", fill = "cornflowerblue", alpha = 0.25) +
  labs(x = "Hours", y = "Frequency") +
  ggtitle("Patient Wait Time for Appointment") +
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20))

# take a look at a qqplot

ggqq(x = dat$PAT_LOS_HOURS)

# given that the data is not normally distributed we will use the wilcox.test function instead of t.test

# wilcox.test is a function that performs the wilcoxon rank sum test
# This is a statistical test that requires the data to take on real values (integer and/or decimal) 
# This is a statistical test that DOES NOT require the data to come from a particular statistical distribution
# wilcox.test takes on a handful of inputs but the 4 ones we will cover are: formula, data, conf.level, conf.int
# formula follows this format: x ~ y
# x is the column of data we are analyzing
# y is the column of data that will flag which of the two groups x belongs to
# data is the data.frame with the columns x and y in the input formula
# conf.level is the confidence level of our test: a value between (BUT NOT INCLUDING) 0 and 1
# typically confidence levels should be between .95 and .99
# the higher the conf.level, the more difficult it is to pass the test --> passing a more difficult test indicates stronger evidence of causality
# conf.int takes on a value of TRUE or FALSE to indicate if a confidence interval should be computed
# by default conf.int = FALSE

# lets see if there is a significant difference in PAT_LOS_HOURS due to PRE_OPTIMIZATION
# for the wilcoxon rank sum test we have two hypothesis, the null and the alternative
# the null: the true location shift is equal to 0
# the alternative: the true location shift is not equal to 0
# the p-value corresponds to your level of confidence
# for example, if our level of confidence is 0.95 then the deciding p-value value is 0.05 --> if p-value < 0.05 then reject null else fail to reject null
# for example, if our level of confidence is 0.99 then the deciding p-value value is 0.01 --> if p-value < 0.01 then reject null else fail to reject null
# the key information in the wilcoxon rank sum test is:
# a p-value
# a confidence interval of the difference in location
# difference in location
# this is similar to the difference in medians of the two populations

wilcox.test(formula = PAT_LOS_HOURS ~ PRE_OPTIMIZATION, data = dat, conf.int = TRUE, conf.level = 0.99)

# i won't get into subsetting data and using lapply with the wilcox.test because it is the same exact format for the t.test
# all you would have to do is:
# replace t.test with wilcox.test
# replace PAT_WAITED_DAYS with PAT_LOS_HOURS
# remember to include conf.int = TRUE as an input in wilcox.test

# lets see if there has been a change in the frequency of inpatients and/or outpatients (ie. PAT_CLASS) due to PRE_OPTIMIZATION
# to do this we would use the chisq.test function

# chisq.test is a function that performs the chi-squared test
# This is a statistical test that requires a large sample size: at least 30 data points
# chisq.test takes on two inputs: x, y
# x is the first factor
# y is the second factor

# for the chi-squared test we have two hypothesis, the null and the alternative
# the null: there is no change in any frequency
# the alternative: there is change in at least one frequency
# the p-value corresponds to your level of confidence
# for example, if our level of confidence is 0.95 then the deciding p-value value is 0.05 --> if p-value < 0.05 then reject null else fail to reject null
# for example, if our level of confidence is 0.99 then the deciding p-value value is 0.01 --> if p-value < 0.01 then reject null else fail to reject null
# the key information in the chi-squared test is:
# a p-value
# observed counts
# expected counts

chisq = chisq.test(x = dat$PAT_CLASS, y = dat$PRE_OPTIMIZATION)
chisq = list("RESULTS" = chisq, "OBSERVED COUNTS" = chisq$observed, "EXPECTED COUNTS" = chisq$expected)

chisq

# another test for tracking the change in frequencies is fishers exact test
# this test is only intended for small sample sizes, so for us this test is irrelevent
# but for the sake of learning we will cover it

# lets see if there has been a change in the frequency of inpatients and/or outpatients (ie. PAT_CLASS) due to PRE_OPTIMIZATION
# to do this we would use the fisher.test function

# fisher.test is a function that performs the fishers exact test
# This is a statistical test that requires a small sample size: less than 30 data points
# fisher.test takes on three inputs: x, y, conf.int
# x is the first factor
# y is the second factor
# conf.level is the confidence level of our test: a value between (BUT NOT INCLUDING) 0 and 1
# typically confidence levels should be between .95 and .99
# the higher the conf.level, the more difficult it is to pass the test --> passing a more difficult test indicates stronger evidence of causality 

# for the fishers exact test we have two hypothesis, the null and the alternative
# the null: the true odds ratio is equal to 1
# the alternative: the true odds ratio is not equal to 1
# the p-value corresponds to your level of confidence
# for example, if our level of confidence is 0.95 then the deciding p-value value is 0.05 --> if p-value < 0.05 then reject null else fail to reject null
# for example, if our level of confidence is 0.99 then the deciding p-value value is 0.01 --> if p-value < 0.01 then reject null else fail to reject null
# the key information in the fishers exact test is:
# a p-value
# a confidence interval of the odds ratio (we only get this if we are dealing with a 2 by 2 case --> two factors each with two levels)
# the odds ratio
# this is a ratio comparing input x across input y, an odds ratio of 1 would indicate no change in x across y
# lets use some data as an example (Note: remember that dat is created randomly so you probably don't have the following numbers)
#              		dat$PRE_OPTIMIZATION
#	dat$PAT_CLASS  	No Yes
#		INPATIENT  	323 332
#	   OUTPATIENT 	177 168
# odds ratio =~ (count(INPATIENT & No) / count(INPATIENT & Yes)) / (count(OUTPATIENT & No) / count(OUTPATIENT & Yes))
# odds ratio =~ (323 / 332) / (177 / 168) =~ 0.9234225

fisher.test(x = dat$PAT_CLASS, y = dat$PRE_OPTIMIZATION, conf.level = 0.95)

# lets remove some R objects

rm(chisq, tTest_By_Doctor, tTest_By_Doctor2, ggqq, mydat, LSD1, LSD2, LSD3, USD1, USD2, USD3, percent_SD1, percent_SD2, percent_SD3)

# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ---- Fitting Distributions ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# ---- standard distribution fitting -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# lets try to fit a distribution for PAT_WAITED_DAYS
# we will use the descdist() function below to plot our data against other statistical distributions
# this function takes on two inputs: data, discrete
# data is the data we are looking to fit a distribution for
# discrete can take a value of TRUE or FALSE to indicate whether or not our data is discrete (ie. integer)
# the output is a graph of kurtosis (a value indicating the vertical sharpness of a distribution) v. skewness (a value indicating the horizontal shift of a distribution)
# our data is plotted as a blue dot whereas the other statistical distributions are plotted as other symbols or lines
# the point of the this graph is to find which distribution(s) our data is plotted closest to

require(fitdistrplus)

descdist(data = dat$PAT_WAITED_DAYS, discrete = FALSE)

# clearly our data is plotted closest to the normal distribution
# now we will use the fitdist function to estimate the distribution parameters of a normal distribution for our data
# fitdist takes two inputs: data, distr
# data is the data we are looking to estimate parameters for
# distr is the name of the distribution we are looking to estimate parameters for
# the output will give the paramenter estimates as well as the std. error of those estimates

fit.norm = fitdist(data = dat$PAT_WAITED_DAYS, distr = "norm")

# lets do some goodness of fit testing to find strong evidence that our data actually comes from the fitted distribution

# lets do graphic goodness of fit testing
# plotting the fitdist() objects allows us to see graphically how well each distribution fits against the data
# continuous distribution fits offer 4 plots: histogram, qq-plot, cdf plot, and a pp-plot
# in the histogram we are looking for the edges of histogram bars to follow the density curve with minimal deviation
# in the qq-plot, cdf plot, and pp-plot we are looking for the datapoints to follow the line with minimal deviation
# discrete distribution fits offer 2 plots: density plot and cdf plot
# in the density plot we are looking for the edges of the two distribtuions to stay together with minimal deviation 
# in the cdf plot we are looking for the datapoints to follow the line with minimal deviation

plot(fit.norm)

# numeric goodness of fit test: Kolmogorov-Smirnov Test
# to run this test for our data and fitted distribution, we will use the function ks.test
# the ks.test function has 3 or more inputs
# the first input is your data
# the second input is the probability density function of the distribution your comparing your data to
# the 3rd or more input(s) is/are the parameter(s) that describe(s) the distribution your comparing your data to
# for the Kolmogorov-Smirnov Test we have two hypothesis, the null and the alternative
# the null: the data follows the specified distribution
# the alternative: the data doesn't follow the specified distribution
# the p-value corresponds to your level of confidence
# for example, if our level of confidence is 0.95 then the deciding p-value value is 0.05 --> if p-value < 0.05 then reject null else fail to reject null
# for example, if our level of confidence is 0.99 then the deciding p-value value is 0.01 --> if p-value < 0.01 then reject null else fail to reject null
# the key information in the Kolmogorov-Smirnov Test is:
# a p-value

ks.test(dat$PAT_WAITED_DAYS, pnorm, fit.norm$estimate[1], fit.norm$estimate[2])

# other distributions that can be fit if applicable to the data are below

# the error codes you should expect to see coming are for all the discrete distributions and the beta distribution
# the error codes for the discrete distributions are because PAT_WAITED_DAYS is not an integer
# the error code for the beta distribution is because PAT_WAITED_DAYS does not take values between 0 and 1
# despite these error codes, it is important for you to know the proper formats for fitting all of these different distributions

# if you run into error codes that are unexpected, then try a different method by including the input method = "mme"
# the default: method = "mle"
# for example: fitdist(data = dat$PAT_WAITED_DAYS, distr = "norm", method = "mme")
# if that other method doesn't work then look online as to what type of data the distribution is intended to represent, to see if its a data issue

# discrete distributions:
# poisson distribution
fit.pois = fitdist(data = dat$PAT_WAITED_DAYS, distr = "pois")
# geometric distribution
fit.geom = fitdist(data = dat$PAT_WAITED_DAYS, distr = "geom")
# negative binomial distribution
fit.nbinom = fitdist(data = dat$PAT_WAITED_DAYS, distr = "nbinom")

# continuous distributions:
# gamma distribution
fit.gamma = fitdist(data = dat$PAT_WAITED_DAYS, distr = "gamma")
# beta distribution
fit.beta = fitdist(data = dat$PAT_WAITED_DAYS, distr = "beta")
# exponential distribution
fit.exp = fitdist(data = dat$PAT_WAITED_DAYS, distr = "exp")
# logistic distribution
fit.logis = fitdist(data = dat$PAT_WAITED_DAYS, distr = "logis")
# lognormal distribution
fit.lnorm = fitdist(data = dat$PAT_WAITED_DAYS, distr = "lnorm")
# weibull distribution
fit.weibull = fitdist(data = dat$PAT_WAITED_DAYS, distr = "weibull")
# uniform distribtuion
fit.unif = fitdist(data = dat$PAT_WAITED_DAYS, distr = "unif")
# cauchy distribution
fit.cauchy = fitdist(data = dat$PAT_WAITED_DAYS, distr = "cauchy")

# graphic goodness of fit tests for the above other distributions

# discrete distributions:
# poisson distribution
plot(fit.pois)
# geometric
plot(fit.geom)
# negative binomial distribution
plot(fit.nbinom)

# continuous distributions:
# gamma distribution
plot(fit.gamma)
# beta distribution
plot(fit.beta)
# exponential distribution
plot(fit.exp)
# logistic distribution
plot(fit.logis)
# lognormal distribution
plot(fit.lnorm)
# weibull distribution
plot(fit.weibull)
# uniform distribtuion
plot(fit.unif)
# cauchy distribution
plot(fit.cauchy)

# numeric goodness of fit tests for the above other distributions

# discrete distributions:
# poisson distribution
ks.test(dat$PAT_WAITED_DAYS, ppois, fit.pois$estimate[1])
# geometric
ks.test(dat$PAT_WAITED_DAYS, pgeom, fit.geom$estimate[1])
# negative binomial distribution
ks.test(dat$PAT_WAITED_DAYS, pnbinom, fit.nbinom$estimate[1], fit.nbinom$estimate[2])

# continuous distributions:
# gamma distribution
ks.test(dat$PAT_WAITED_DAYS, pgamma, fit.gamma$estimate[1], fit.gamma$estimate[2])
# beta distribution
ks.test(dat$PAT_WAITED_DAYS, pbeta, fit.beta$estimate[1], fit.beta$estimate[2])
# exponential distribution
ks.test(dat$PAT_WAITED_DAYS, pexp, fit.exp$estimate[1])
# logistic distribution
ks.test(dat$PAT_WAITED_DAYS, plogis, fit.logis$estimate[1], fit.logis$estimate[2])
# lognormal distribution
ks.test(dat$PAT_WAITED_DAYS, plnorm, fit.lnorm$estimate[1], fit.lnorm$estimate[2])
# weibull distribution
ks.test(dat$PAT_WAITED_DAYS, pweibull, fit.weibull$estimate[1], fit.weibull$estimate[2])
# uniform distribtuion
ks.test(dat$PAT_WAITED_DAYS, punif, fit.unif$estimate[1], fit.unif$estimate[2])
# cauchy distribution
ks.test(dat$PAT_WAITED_DAYS, pcauchy, fit.cauchy$estimate[1], fit.cauchy$estimate[2])

# after seeing the results of the other fits, lets consider weibull and logistic distributions as canidates
# so we will use the function gofstat to numerically compare these three canidates 
# when looking at these numbers:
# compare numbers column to column
# the lower the value the better

gofstat(f = list(fit.norm, fit.weibull, fit.logis))

# lets get some samples from our three theoretical distributions we just fit and get a summary on the R^2, MAE, and RSME of our data compared to these three theoretical distributions
# sampledist is a function i created to randomly sample from any statistical distribution, and then compute the R^2, MAE, and RSME between the distribution and your data
# sampledist takes at least 3 values: dat, distribution, num
# dat is the data we want to compare againast a theoretical distribution
# distribution, the name for any available distribution in R
# by default it is set to "norm" which is the name for the normal distribution
#..., this is meant for distributions which require additional inputs
# for example if we were to set distribtuion = "chisq"
# then we would need to include a parameter for the degrees of freedom, for example: df = 24
# so we would write out the following:
# sampledist(dat = mydata, distribution = "chisq", df = 24)
# num is the number of samples to create
# we are looking for R^2 values at least .9 and as close to 1
# we are looking for MAE and RSME to have similar values and be "small"
# "small" is dependent on the data you're dealing with

sampledist = function(dat, distribution = "norm", ..., num = 1000)
{
  r.function = eval(parse(text = paste0("r", distribution)))
  
  mydata = dat[order(dat)]
  
  mysamples = apply(sapply(1:num, function(i)
    (
      r.function(n = length(dat), ...)
    )), 2, sort)
  
  Rsq = sapply(1:num, function(i)
    (
      cor(mysamples[,i], mydata)
    ))^2
  
  MAE = sapply(1:num, function(i)
    (
      mean(abs(mysamples[,i] - mydata))
    ))
  
  RMSE = sapply(1:num, function(i)
    (
      sd(mysamples[,i] - mydata)
    ))
  
  results = data.frame(Rsq, MAE, RMSE)
  return(results)
}

# sample 10,000 times

sample.norm1 = sampledist(dat = dat$PAT_WAITED_DAYS, mean = fit.norm$estimate[1], sd = fit.norm$estimate[2], num = 10000)
sample.weibull1 = sampledist(dat = dat$PAT_WAITED_DAYS, distribution = "weibull", shape = fit.weibull$estimate[1], scale = fit.weibull$estimate[2], num = 10000)
sample.logis1 = sampledist(dat = dat$PAT_WAITED_DAYS, distribution = "logis", location = fit.logis$estimate[1], scale = fit.logis$estimate[2], num = 10000)

# compare the following summaries

summary.norm1 = data.frame(c("Rsq", "MAE", "RMSE"), rbind(summary(sample.norm1[,1]), summary(sample.norm1[,2]), summary(sample.norm1[,3])))
colnames(summary.norm1) = c("Metric", names(summary(sample.norm1[,1])))
summary.norm1

# ------------------------------

summary.weibull1 = data.frame(c("Rsq", "MAE", "RMSE"), rbind(summary(sample.weibull1[,1]), summary(sample.weibull1[,2]), summary(sample.weibull1[,3])))
colnames(summary.weibull1) = c("Metric", names(summary(sample.weibull1[,1])))
summary.weibull1

# ------------------------------

summary.logis1 = data.frame(c("Rsq", "MAE", "RMSE"), rbind(summary(sample.logis1[,1]), summary(sample.logis1[,2]), summary(sample.logis1[,3])))
colnames(summary.logis1) = c("Metric", names(summary(sample.logis1[,1])))
summary.logis1

# compare the following histograms

p1 = ggplot(sample.norm1, aes(x = Rsq)) + 
  geom_histogram(color = "white", fill = "cornflowerblue") +
  ggtitle("Coefficient of Determination") + 
  labs(x = "\nR^2", y = "Frequency") + 
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), axis.text.x = element_text(hjust = .75))

p2 = ggplot(sample.norm1, aes(x = MAE)) + 
  geom_histogram(color = "white", fill = "indianred") +
  ggtitle("Mean Absolute Error") + 
  labs(x = "\nSurgeries per Week", y = "Frequency") + 
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20))

p3 = ggplot(sample.norm1, aes(x = RMSE)) + 
  geom_histogram(color = "white", fill = "forestgreen") +
  ggtitle("Root Mean Square Error") + 
  labs(x = "\nSurgeries per Week", y = "Frequency") + 
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), axis.text.x = element_text(hjust = .75))

grid.arrange(p1, p2, p3, ncol = 3)
rm(p1, p2, p3)

sample.norm1_Plot = recordPlot()

# ------------------------------

p1 = ggplot(sample.weibull1, aes(x = Rsq)) + 
  geom_histogram(color = "white", fill = "cornflowerblue") +
  ggtitle("Coefficient of Determination") + 
  labs(x = "\nR^2", y = "Frequency") + 
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), axis.text.x = element_text(hjust = .75))

p2 = ggplot(sample.weibull1, aes(x = MAE)) + 
  geom_histogram(color = "white", fill = "indianred") +
  ggtitle("Mean Absolute Error") + 
  labs(x = "\nSurgeries per Week", y = "Frequency") + 
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20))

p3 = ggplot(sample.weibull1, aes(x = RMSE)) + 
  geom_histogram(color = "white", fill = "forestgreen") +
  ggtitle("Root Mean Square Error") + 
  labs(x = "\nSurgeries per Week", y = "Frequency") + 
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), axis.text.x = element_text(hjust = .75))

grid.arrange(p1, p2, p3, ncol = 3)
rm(p1, p2, p3)

sample.weibull1_Plot = recordPlot()

# ------------------------------

p1 = ggplot(sample.logis1, aes(x = Rsq)) + 
  geom_histogram(color = "white", fill = "cornflowerblue") +
  ggtitle("Coefficient of Determination") + 
  labs(x = "\nR^2", y = "Frequency") + 
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), axis.text.x = element_text(hjust = .75))

p2 = ggplot(sample.logis1, aes(x = MAE)) + 
  geom_histogram(color = "white", fill = "indianred") +
  ggtitle("Mean Absolute Error") + 
  labs(x = "\nSurgeries per Week", y = "Frequency") + 
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20))

p3 = ggplot(sample.logis1, aes(x = RMSE)) + 
  geom_histogram(color = "white", fill = "forestgreen") +
  ggtitle("Root Mean Square Error") + 
  labs(x = "\nSurgeries per Week", y = "Frequency") + 
  theme(plot.title = element_text(size = 20), axis.title = element_text(size = 20), axis.text = element_text(size = 20), axis.text.x = element_text(hjust = .75))

grid.arrange(p1, p2, p3, ncol = 3)
rm(p1, p2, p3)

sample.logis1_Plot = recordPlot()

# ---- normal mixture distribution fitting -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# lets fit a normal mixture distribtuion for PAT_LOS_HOURS
# normalmixEM is a function that estimates the parameters for a normal mixture distribution
# normalmixEM has two main inputs: x, k
# x is the data we are looking to fit a normal mixture distribution for
# k indicates how many normal distribution are mixed together
# the parameters being estimated are k-many means 'mu', k-many standard deviations 'sigma', and k-many mixtures 'lam'
# the mixture 'lam' indicates what proportion of the distribution is not overlapping another

require(mixtools)

mix.norm = normalmixEM(x = dat$PAT_LOS_HOURS, k = 2)

# lets do some simple graphic goodness of fit testing
# the plot will show a histogram of the data, a red and green density curve of the two mixed normal distributions
# we are looking for the edges of the density curve, and edges of the histogram to align with minimal deviation

plot(mix.norm, which = 2)

# this summary shows the 3 parameters for each normal distribution

summary(mix.norm)

# the normalmixEM() function is an iterative improving algorthm so the initial starting estimates for the parameters matter
# now the results shown in the plot look good, but its important to know how to give intial starting points whenever the algorthm doesn't perform as expected
# lam1 and lam2 are the proportions of the data below and above the dip respectively
# mu1 and mu2 are the means of the data below and above the dip respectively
# sig1 and sig2 are the standard deviations of the data below and above the dip respectively
# looking at the data, 24 hours seems to be the point where the dip is at its lowest

# length is a function that counts how many elements are in a vector
# try this simple example to understand how length works

length(c("a","b","c","d"))

# lets comute the lam's, mu's, and sig's

lam1 = length(dat$PAT_LOS_HOURS[dat$PAT_LOS_HOURS < 24]) / length(dat$PAT_LOS_HOURS)
lam2 = 1 - lam1
mu1 = mean(dat$PAT_LOS_HOURS[dat$PAT_LOS_HOURS < 24])
mu2 = mean(dat$PAT_LOS_HOURS[dat$PAT_LOS_HOURS >= 24])
sig1 = sd(dat$PAT_LOS_HOURS[dat$PAT_LOS_HOURS < 24])
sig2 = sd(dat$PAT_LOS_HOURS[dat$PAT_LOS_HOURS >= 24])

# we now rerun the normalmixEM() function with the est starting values for the paramters

mix.norm2 = normalmixEM(x = dat$PAT_LOS_HOURS, k = 2, lambda = c(lam1, lam2), mu = c(mu1, mu2), sigma = c(sig1, sig2))

# lets do some simple graphic goodness of fit testing

plot(mix.norm2, which = 2)

# these are the parameters that were estimated

summary(mix.norm2)

# the results are similar if not identical, so we'll stick with the first mixture we ran

rm(mix.norm2)

# lets do further graphical goodness of fit testing
# lets make a series of QQ-plots to compare our data up against a set of random samples from our theoretical normal distribution
# I made a function called mixnormQQ that will randomly sample datapoints from a theoretical normal mixture distribution and plot them up against the data we are looking to fit the normal mixture distribution for
# the actual data and sampled data are all ordered from lowest to highest before plotting, which is a key characteristic of a qqplot
# mixnormQQ has four inputs: mixnorm, dat, num, plot_title
# mixnorm is the object made from the function normalmixEM
# dat is the data we are looking to fit the normal mixture distribution for
# num is the number of scatterplots to create
# plot_title is an optional title for the plot
# what we want to see is a strong linear relationship in each plot, along the diagonal line
# this would be supporting evidence that our data comes from this normal mixture distribution

mixnormQQ = function(mixnorm, dat, num = 9, plot_title = "", basefont = 20)
{
  mixnormSample = function(mixnorm)
  {
    size = NROW(mixnorm$posterior)
    lam = mixnorm$lambda
    mu = mixnorm$mu
    sig = mixnorm$sigma
    
    groups = sample(length(lam), size, replace = TRUE, prob = lam)
    results = rnorm(size, mu[groups], sig[groups])
    return(results)
  }
  
  DF = data.frame("mydata" = rep(dat[order(dat)], num), "mysample" = rep(0, num * length(dat)), "it" = rep(0, num * length(dat)))
  
  for(i in 1:num)
  {
    from = (((i - 1) * length(dat)) + 1)
    to = (i * length(dat))
    mysample = mixnormSample(mixnorm = mixnorm)
    
    DF[from:to, 2] = mysample[order(mysample)]
    DF[from:to, 3] = rep(paste("Iteration", i), length(dat))
  }
  
  require(ggplot2)
  p = ggplot(DF, aes(x = mysample, y = mydata)) +
    geom_point(color = "blue", alpha = 0.33) + 
    facet_wrap(~it) +
    geom_abline(slope = 1, size = 1) + 
    labs(x = "Theoretical Sample", y = "Data Sample") +
    theme_light(base_size = basefont) +
	theme(legend.position = "none")
  if(plot_title != "")(p = p + ggtitle(plot_title))
  
  return(p)
}

mixnormQQ(mixnorm = mix.norm, dat = dat$PAT_LOS_HOURS, num = 9)

# lets make a series of density plots to compare our data up against a set of random samples from our theoretical normal distribution
# I made a function called mixnormDensity that will randomly sample datapoints from a theoretical normal mixture distribution and plot them up against the data we are looking to fit the normal mixture distribution for
# mixnormDensity has four inputs: mixnorm, dat, num, plot_title
# mixnorm is the object made from the function normalmixEM
# dat is the data we are looking to fit the normal mixture distribution for
# num is the number of density plots to create
# plot_title is an optional title for the plot
# what we want to see is the edges of the two distributions in each plot to stay on top of eachother
# this would be supporting evidence that our data comes from this normal mixture distribution

mixnormDensity = function(mixnorm, dat, num = 9, plot_title = "", basefont = 20)
{
  mixnormSample = function(mixnorm)
  {
    size = NROW(mixnorm$posterior)
    lam = mixnorm$lambda
    mu = mixnorm$mu
    sig = mixnorm$sigma
    
    groups = sample(length(lam), size, replace = TRUE, prob = lam)
    results = rnorm(size, mu[groups], sig[groups])
    return(results)
  }
  
  DF = data.frame("mydata" = c(dat, mixnormSample(mixnorm = mixnorm)), "type" = c(rep("Actual", length(dat)), rep("Sample", length(dat))), "it" = rep(paste("Iteration", 1), 2 * length(dat)))
  
  for(i in 2:num)
  {
    from = (((i - 1) * 2 * length(dat)) + 1)
    to = (i * 2 * length(dat))
    
    DF[from:to, 1] = c(dat, mixnormSample(mixnorm = mixnorm))
    DF[from:to, 2] = c(rep("Actual", length(dat)), rep("Sample", length(dat)))
    DF[,3] = as.character(DF[,3])
    DF[from:to, 3] = rep(paste("Iteration", i), 2 * length(dat))
  }
  
  DF[,3] = as.factor(DF[,3])
  
  require(ggplot2)
  
  p = ggplot(DF, aes(x = mydata, y = ..count.., color = type, fill = type)) +
    geom_density(alpha = 0.25) + 
    scale_fill_manual(values = c("blue", "sienna1")) +
    scale_color_manual(values = c("blue", "sienna1")) +
    facet_wrap(~it) +
    labs(y = "Frequency", color = "Data", fill = "Data") +
    theme_light(base_size = basefont) +
	theme(legend.position = "none")
	
  if(plot_title != "")(p = p + ggtitle(plot_title))
  
  return(p)
}

mixnormDensity(mixnorm = mix.norm, dat = dat$PAT_LOS_HOURS, num = 9)

# lets do numeric goodness of fit testing
# the pmnorm function below will compute the probability density function of our normal mixture distribution
# this is neccessary to run the ks.test

pmnorm = function(x, lam, mu, sig)
{
  mat1 = cbind(lam, mu, sig)
  mat2 = apply(mat1, 1, function(y)(y[1] * pnorm(x, y[2], y[3])))
  cdf = rowSums(mat2)
  return(cdf)
}

# the ks.test function has 3 or more inputs
# the first input is your data
# the second input is the probability density function of the distribution your comparing your data to
# the 3rd or more input(s) is/are the parameter(s) that describe(s) the distribution your comparing your data to
# for the Kolmogorov-Smirnov Test we have two hypothesis, the null and the alternative
# the null: the data follows the specified distribution
# the alternative: the data doesn't follow the specified distribution
# the p-value corresponds to your level of confidence
# for example, if our level of confidence is 0.95 then the deciding p-value value is 0.05 --> if p-value < 0.05 then reject null else fail to reject null
# for example, if our level of confidence is 0.99 then the deciding p-value value is 0.01 --> if p-value < 0.01 then reject null else fail to reject null
# the key information in the Kolmogorov-Smirnov Test is:
# a p-value

# when we use pmnorm and ks.test together we have 5 inputs: the data, pmnorm, lam, mu, sig
# the data is the data we are looking to fit a normal mixture distribution for
# pmnorm is the function from above that will create the probability distribution function of our normal mixture distribution
# lam requires the lambda information from our object made from the function normalmixEM
# we extract this with a $ operator --> $lambda
# mu requires the mu information from our object made from the function normalmixEM
# we extract this with a $ operator --> $mu
# sig requires the sigma information from our object made from the function normalmixEM
# we extract this with a $ operator --> $sigma

ks.test(dat$PAT_LOS_HOURS, pmnorm, lam = mix.norm$lambda, mu = mix.norm$mu, sig = mix.norm$sigma)

# ---- empirical distribution fitting ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# in cases where a standard or normal mixture distribution cannot be fit, an empirical distribution is a last resort
# here is a function I made that returns an empirical cdf table and plot of your data
# emp has three inputs: dat, incr, plot_title
# dat is the data we want an empirical distribution for
# incr is how the values of the data should be incremented for the empirical distribution
# plot_title is the title for the cdf plot

emp = function(dat, incr, plot_title = "Empirical Cumulative Distribution Function", basefont = 20)
{
  # sequence desired based on the value of incr
  from = floor(min(dat))
  to = ceiling(max(dat))
  values = seq(from = from, to = to, by = incr)
  
  # ensure the first value corresponds to 0 probability
  if(values[1] == min(dat))(values = c(values[1] - incr, values))
  # ensure the last value corresponds to 1 probability
  if(values[length(values)] < max(dat))(values[length(values) + 1] = values[length(values)] + incr)
  
  # create empirical cdf table
  fit = ecdf(dat)
  empTable = data.frame(values, "cdf" = fit(values))
  
  # create empirical cdf plot
  require(ggplot2)
  
  empPlot = ggplot(data = empTable, aes(x = values, y = cdf)) +
    geom_point() +
    geom_line() +
    geom_hline(yintercept = 0, linetype = "dashed") +
    geom_hline(yintercept = 1, linetype = "dashed") +
    labs(x = "\nx", y = "Fn(x)\n") +
    ggtitle(plot_title) +
    theme_light(base_size = basefont) +
	theme(legend.position = "none")
	
  # provide the results
  print(empPlot)
  return(empTable)
}

fit.emp = emp(dat = dat$PAT_LOS_HOURS, incr = 4)
fit.emp

# lets remove some R objects

rm(emp, fit.cauchy, fit.emp, fit.exp, fit.gamma, fit.lnorm, fit.logis, fit.norm, fit.unif, fit.weibull, lam1, lam2, mix.norm, mixnormDensity, mixnormQQ, mu1, mu2, pmnorm, sig1, sig2, sampledist)

# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ---- Linear Regression Analysis ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

rm(dat)

# ---- modeling data ----------------------------------------------------------------------------------------------------------------

require(triangle)

# our response variable that we want to predict will be normally distributed
# we will sort this from low to high so that way clear relationships can be seen between variables
ynorm = sort(rnorm(n = 200, mean = 100, sd = 8)) 
# add some noise to the variable so the relationships aren't too precise
ynorm = ynorm + (ynorm * sample(x = seq(from = .9, to = 1.1, by = .001), size = 200, replace = TRUE))

# lets have a bimodal distribution (normal mixture) as one of the predictor variables
# we will sort this from low to high so that way clear relationships can be seen between variables
xnorms = sort(c(rnorm(n = 100, mean = 75, sd = 10), rnorm(n = 100, mean = 125, sd = 10)))

# lets have an exponential distribution skewed to the right as one of the predictor variables
# we will sort this from low to high so that way clear relationships can be seen between variables
xexp = sort(rexp(n = 200, rate = 1/33)) + 10
# add some noise to the variable so the relationships aren't too precise
xexp = xexp + (xexp * sample(x = seq(from = .9, to = 1.1, by = .001), size = 200, replace = TRUE))

# lets have an exponential distribution skewed to the left as one of the predictor variables
# we will sort this from low to high so that way clear relationships can be seen between variables
xrexp = sort(rexp(n = 200, rate = 1/33)) + 10
# add some noise to the variable so the relationships aren't too precise
xrexp = xrexp + (xrexp * sample(x = seq(from = .9, to = 1.1, by = .001), size = 200, replace = TRUE))
xrexp = sort(-xrexp) + 1000

# lets have a triangular distribution as one of the predictor variables
# we will sort this from low to high so that way clear relationships can be seen between variables
xtriangle = sort(rtriangle(n = 200, a = 50, b = 150))
# add some noise to the variable so the relationships aren't too precise
xtriangle = xtriangle + (xtriangle * sample(x = seq(from = .9, to = 1.1, by = .001), size = 200, replace = TRUE))

# lets have a cauchy distribution as one of the predictor variables
# we will sort this from low to high so that way clear relationships can be seen between variables
xcauchy = sort(rcauchy(n = 200, location = 500, scale = 1/2))

# lets have a uniform distribution as one of the predictor variables
# we will sort this from low to high so that way clear relationships can be seen between variables
xunif = sort(runif(n = 200, min = 200, max = 325))

# lets have a beta distribution with a large dip in the center as one of the predictor variables
# we will sort this from low to high so that way clear relationships can be seen between variables
xbeta = sort((rbeta(n = 200, shape1 = 1/3, shape2 = 1/3) + 1) * 150)

# lets add some categorical variables as predictor variables, with their probabiltiy of occurence based on a beta distribution
cat1 = sort(sample(x = c("A", "B", "C", "D"), size = 200, replace = TRUE, prob = rbeta(4,20,10)))
cat2 = sort(sample(x = c("Low", "Medium", "High"), size = 200, replace = TRUE, prob = rbeta(3,5,10)))
cat3 = as.factor(sort(sample(x = c(0, 1), size = 200, replace = TRUE, prob = rbeta(2,8,2))))

# create the data set of 200 total observations for each variable
dat = data.frame(ynorm, xnorms, xexp, xrexp, xtriangle, xcauchy, xunif, xbeta, cat1, cat2, cat3)

# ---- prediction data ----------------------------------------------------------------------------------------------------------------

# lets create another data set sampled the same way as the previous BUT make it 1000 observations so that way the true relationships between all the variables are clear
# the goal here is to see how well we can model with 200 data points to predict the next 1000 data points

ynorm = sort(rnorm(n = 1000, mean = 100, sd = 8)) 
ynorm = ynorm + (ynorm * sample(x = seq(from = .9, to = 1.1, by = .001), size = 1000, replace = TRUE))

xnorms = sort(c(rnorm(n = 500, mean = 75, sd = 10), rnorm(n = 500, mean = 125, sd = 10)))

xexp = sort(rexp(n = 1000, rate = 1/33)) + 10
xexp = xexp + (xexp * sample(x = seq(from = .9, to = 1.1, by = .001), size = 1000, replace = TRUE))

xrexp = sort(rexp(n = 1000, rate = 1/33)) + 10
xrexp = xrexp + (xrexp * sample(x = seq(from = .9, to = 1.1, by = .001), size = 1000, replace = TRUE))
xrexp = sort(-xrexp) + 1000

xtriangle = sort(rtriangle(n = 1000, a = 50, b = 150))
xtriangle = xtriangle + (xtriangle * sample(x = seq(from = .9, to = 1.1, by = .001), size = 1000, replace = TRUE))

xcauchy = sort(rcauchy(n = 1000, location = 500, scale = 1/2))

xunif = sort(runif(n = 1000, min = 200, max = 325))

xbeta = sort((rbeta(n = 1000, shape1 = 1/3, shape2 = 1/3) + 1) * 150)

cat1 = sort(sample(x = c("A", "B", "C", "D"), size = 1000, replace = TRUE, prob = rbeta(4, 20, 10)))
cat2 = sort(sample(x = c("Low", "Medium", "High"), size = 1000, replace = TRUE, prob = rbeta(3, 5, 10)))
cat3 = as.factor(sort(sample(x = c(0, 1), size = 1000, replace = TRUE, prob = rbeta(2, 8, 2))))

future = data.frame(ynorm, xnorms, xexp, xrexp, xtriangle, xcauchy, xunif, xbeta, cat1, cat2, cat3)

rm(ynorm, xnorms, xexp, xrexp, xtriangle, xcauchy, xunif, xbeta, cat1, cat2, cat3)

# ---- check out the pairs plot of the data to see what relationships are present -----------------------------------------

require(GGally)
require(ggplot2)

# https://cran.r-project.org/web/packages/GGally/GGally.pdf

# heres what our modeling data looks like (ONLY for the response variable v. numeric predictor variables)
# the first column of scatterplots represent the relationship between our response variable and the other predictor variables
# we want to see relationships here
# the scatterplots other than the first column represent the relationships between all predictor vairables
# we don't want to see relationships here
# the plots along the diagonal show the distribution of all the variables
# the first row of correlation values show the correlation between the response variable and all the predictor variables
# the correlations values other than the first row represent tthe correlations between all predictor vairables

ggpairs(dat, columns = colnames(dat[,1:8]))

# let remove some outliers in xcauchy

plot(x = dat$ynorm, y = dat$xcauchy)

dat = dat[-which(dat$xcauchy == min(dat$xcauchy)),]
dat = dat[-which(dat$xcauchy == max(dat$xcauchy)),]

# heres what our modeling data looks like (ONLY for the response variable v. categorical predictor variables)
# the first column is histograms: representing the distribtuion of the repsonse variable in each level of the predictor variables
# we want to see a central difference between each level of the predictor variables
# the first row is boxplots: representing the distribution of each level of the predictor variables across the distribtuion of the response variable
# we want to see a difference in the positioning of the boxplots for each plot
# the plots along the diagonal show the distribution of all the variables
# the remaining plots show the distribution of each level of the predictors variables across each level of the other predictor variables

ggpairs(dat, columns = colnames(dat[,c(1,9:11)]))

# increasing the size of the correlation values

ggpairs(dat,  
        columns = colnames(dat[,1:8]),
        upper = list(continuous = wrap(ggally_cor, size = 8, color = "black")))

# line smoothing on the scatterplots

ggpairs(dat, 
        columns = colnames(dat[,1:8]),
        lower = list(continuous = wrap(ggally_smooth_loess, color = "cornflowerblue", alpha = 1/3)))

# coloring the density plots

ggpairs(dat,
        columns = colnames(dat[,1:8]),
        diag = list(continuous = wrap(ggally_densityDiag, fill = "black", alpha = 1/3)))

# diagonal histograms

ggpairs(dat,
        columns = colnames(dat[,1:8]),
        diag = list(continuous = wrap(ggally_barDiag, fill = "black", color = "white")))

# coloring by a categorical variable on all plots

ggpairs(dat, 
        columns = colnames(dat[,1:8]), 
        mapping = aes(color = cat1, fill = cat1))

# coloring by a categorical variable on just the scatterplots

ggpairs(dat, 
        columns = colnames(dat[,1:8]), 
        lower = list(mapping = aes(color = cat1)))

# final preferred plot

plot_pairs = ggpairs(dat, 
					 columns = colnames(dat[,1:8]), 
        			 lower = list(mapping = aes(color = cat1)), 
        			 upper = list(continuous = wrap(ggally_cor, size = 6, color = "black")),
        			 diag = list(continuous = wrap(ggally_densityDiag, fill = "black", alpha = 1/3)))

plot_pairs

# ---- lets run some anova tests to see which variables should be of interest -----------------------------------------

list_anova = lapply(2:NCOL(dat), function(i) anova(lm(dat[,1] ~ dat[,i])))
names(list_anova) = colnames(dat[,2:NCOL(dat)])

list_anova

# all variables are significant so we will consider all of them in our modeling process

rm(list_anova)

# ---- lets create all possible regression models up to main effects with our variables of interest -----------------------------------------

# lets create two way interaction models

# create all possible 2-way pairs
x = expand.grid(1:NCOL(dat), 1:NCOL(dat))

# remove all pairs that have variables interacting with themselves
x = x[which(x[,1] != x[,2]),]

# remove all pairs that have categorical variables interacting with eachother
x = x[-which((x[,1] == 9 | x[,1] == 10 | x[,1] == 11) & 
			 (x[,2] == 9 | x[,2] == 10 | x[,2] == 11)),]

# remove all pairs with the reponse variable
x = x[which(x[,1] != 1),]
x = x[which(x[,2] != 1),]

# remove all duplicate pairs
y = data.frame(t(apply(X = x, MARGIN = 1,FUN = sort)))
x = x[!duplicated(y),]
rm(y)

# create a group of interactions that involve only numeric variables
x1 = x[which(x[,1] < 9),]

# create 3 groups of interactions between the numeric variables and each of the 3 categorical variables
x2 = x[which(x[,1] == 9),]
x3 = x[which(x[,1] == 10),]
x4 = x[which(x[,1] == 11),]

# show the interactions in each group
rownames(x1) = 1:NROW(x1)
x1$Var1Var2 = paste(colnames(dat)[x1[,1]], ":", colnames(dat)[x1[,2]], sep = "")

rownames(x2) = 1:NROW(x2)
x2$Var1Var2 = paste(colnames(dat)[x2[,1]], ":", colnames(dat)[x2[,2]], sep = "")

rownames(x3) = 1:NROW(x3)
x3$Var1Var2 = paste(colnames(dat)[x3[,1]], ":", colnames(dat)[x3[,2]], sep = "")

rownames(x4) = 1:NROW(x4)
x4$Var1Var2 = paste(colnames(dat)[x4[,1]], ":", colnames(dat)[x4[,2]], sep = "")

# look at our 4 linear model groups

x1
x2
x3
x4

rm(x, x1, x2, x3, x4)

# lets create all possible regression models for each of the 4 groups

require(leaps)

# regsubsets is a function that creates smaller linear models derived from a larger linear model
# there will be a one variable model, a two variable model, ..., and a N variable model, where N is the total number of terms in the given larger model
# regsubsets takes on a variety of inputs:
	# the first input is the larger linear model that includes all possible terms to create smaller linear models from
	# data is the data frame that the variables in the larger linear model belong to
	# nbest is how many models you want for each smaller model
		# if nbest = 1, then it will return the best one variable model, the best two variable model, ..., and the best N variable model
		# if nbest = 2 then it will return the top two one variable models, the top two two variable models, ..., and the top two N variable models 
	# nvmax is the maximum number of smaller models to evalute
		# this is set to 8 by default, but we are interested in the maximum number of smaller models so we set nvmax = NULL
	# method is how regsubets goes about creating models
		# method can equal "exhaustive", "backward", "forward", or "seqrep", to do exhaustive search, forward or backward stepwise, or sequential replacement respectively
	# really.big is an input that must be set to TRUE if we are doing an exhaustive search and if the total number of possible variables to add to any of the smaller models is greater than 50
		# by default it is set to FALSE, but we will set it to TRUE just incase we need to evaluate more than 50 variables

apr1 = regsubsets(ynorm ~ xnorms + xexp + xrexp + xtriangle + xcauchy + 
						  xunif + xbeta + xexp:xnorms + xrexp:xnorms + 
						  xtriangle:xnorms + xcauchy:xnorms + xunif:xnorms + 
						  xbeta:xnorms + xrexp:xexp + xtriangle:xexp + 
						  xcauchy:xexp + xunif:xexp + xbeta:xexp + 
						  xtriangle:xrexp + xcauchy:xrexp + xunif:xrexp + 
						  xbeta:xrexp + xcauchy:xtriangle + xunif:xtriangle + 
						  xbeta:xtriangle + xunif:xcauchy + xbeta:xcauchy + xbeta:xunif,
				 data = dat,
				 nbest = 1,      
				 nvmax = NULL,
				 method = "exhaustive",
				 really.big = TRUE)

apr2 = regsubsets(ynorm ~ xnorms + xexp + xrexp + xtriangle + xcauchy + xunif + 
						  xbeta + cat1:xnorms + cat1:xexp + cat1:xrexp + cat1:xtriangle + 
						  cat1:xcauchy + cat1:xunif + cat1:xbeta,
				 data = dat,
				 nbest = 1,      
				 nvmax = NULL,
				 method = "exhaustive",
				 really.big = TRUE)
			
apr3 = regsubsets(ynorm ~ xnorms + xexp + xrexp + xtriangle + xcauchy + xunif + 
						  xbeta + cat2:xnorms + cat2:xexp + cat2:xrexp + cat2:xtriangle + 
						  cat2:xcauchy + cat2:xunif + cat2:xbeta,
				 data = dat,
				 nbest = 1,      
				 nvmax = NULL,
				 method = "exhaustive",
				 really.big = TRUE)
				 
apr4 = regsubsets(ynorm ~ xnorms + xexp + xrexp + xtriangle + xcauchy + xunif + 
						  xbeta + cat3:xnorms + cat3:xexp + cat3:xrexp + cat3:xtriangle + 
						  cat3:xcauchy + cat3:xunif + cat3:xbeta,
				 data = dat,
				 nbest = 1,      
				 nvmax = NULL,
				 method = "exhaustive",
				 really.big = TRUE)

# the following function creates 4 bar plots: RSS, AdjR2, Cp, and BIC, for every model in a regsubsets object
# this function has one input, x
	# x requires a regsubets object

regsubplots = function(x, basefont = 20)
{
	apr = x
	apr = summary(apr)

	apr_dat = data.frame("Model" = 1:NROW(apr$which), 
						 apr$which, 
						 "RSS" = apr$rss, 
						 "AdjR2" = apr$adjr2, 
						 "Cp" = apr$cp, 
						 "BIC" = apr$bic)

	for(i in 2:(NCOL(apr_dat) - 4))
	{
		apr_dat[,i] = factor(apr_dat[,i], levels = c("TRUE", "FALSE"))
	}
	apr_dat$Model = factor(apr_dat$Model, levels = 1:NROW(apr_dat))
	
	require(ggplot2)
	require(RColorBrewer)

	apr_plot = list("RSS" = ggplot(apr_dat, aes(x = Model, y = RSS, color = RSS, fill = RSS)) +
						geom_bar(stat = "identity", position = "identity") +
						scale_color_gradientn(colors = colorRampPalette(brewer.pal(n = 11, name = "BrBG"))(NROW(apr_dat))) + 
		   				scale_fill_gradientn(colors = colorRampPalette(brewer.pal(n = 11, name = "BrBG"))(NROW(apr_dat))) + 
		   				ggtitle("RSS By Model") +  
		   				theme_light(base_size = basefont) +
						theme(legend.position = "none"),
				
				"AdjR2" = ggplot(apr_dat, aes(x = Model, y = AdjR2, color = AdjR2, fill = AdjR2)) +
						geom_bar(stat = "identity", position = "identity") +
						scale_color_gradientn(colors = colorRampPalette(brewer.pal(n = 11, name = "BrBG"))(NROW(apr_dat))) + 
		   				scale_fill_gradientn(colors = colorRampPalette(brewer.pal(n = 11, name = "BrBG"))(NROW(apr_dat))) + 
		   				ggtitle("AdjR2 By Model") +  
		   				theme_light(base_size = basefont) +
						theme(legend.position = "none"),
				
				"Cp" = ggplot(apr_dat, aes(x = Model, y = Cp, color = Cp, fill = Cp)) +
						geom_bar(stat = "identity", position = "identity") +
						scale_color_gradientn(colors = colorRampPalette(brewer.pal(n = 11, name = "BrBG"))(NROW(apr_dat))) + 
		   				scale_fill_gradientn(colors = colorRampPalette(brewer.pal(n = 11, name = "BrBG"))(NROW(apr_dat))) + 
		   				ggtitle("Cp By Model") +  
		   				theme_light(base_size = basefont) +
						theme(legend.position = "none"),
				
				"BIC" = ggplot(apr_dat, aes(x = Model, y = BIC, color = BIC, fill = BIC)) +
						geom_bar(stat = "identity", position = "identity") +
						scale_color_gradientn(colors = colorRampPalette(brewer.pal(n = 11, name = "BrBG"))(NROW(apr_dat))) + 
		   				scale_fill_gradientn(colors = colorRampPalette(brewer.pal(n = 11, name = "BrBG"))(NROW(apr_dat))) + 
		   				ggtitle("BIC By Model") +  
		   				theme_light(base_size = basefont) +
						theme(legend.position = "none"))

	return(list("dat" = apr_dat, "plots" = apr_plot))
}

# lets look at the results for the numeric interaction models

require(gridExtra)

apr1 = regsubplots(x = apr1)

grid.arrange(apr1$plots[[1]], 
			 apr1$plots[[2]], 
			 apr1$plots[[3]], 
			 apr1$plots[[4]],  
			 ncol = 2)

# lets extract models 6 through 12 given that these are good canidates

apr1_models = lapply(6:12, function(i) data.frame("Terms" = colnames(apr1$dat[i, which(apr1$dat[i,] == "TRUE")])[-1]))			 
names(apr1_models) = paste("Model_", 6:12, sep = "")
apr1_models

# lets look at the results for one of the categorical interaction models

apr2 = regsubplots(x = apr2)

grid.arrange(apr2$plots[[1]], 
			 apr2$plots[[2]], 
			 apr2$plots[[3]], 
			 apr2$plots[[4]],  
			 ncol = 2)

# lets extract models 8 through 12 given that these are good canidates

apr2_models = lapply(8:12, function(i) data.frame("Terms" = colnames(apr2$dat[i, which(apr2$dat[i,] == "TRUE")])[-1]))			 
names(apr2_models) = paste("Model_", 8:12, sep = "")
apr2_models

# lets look at the results for another one of the categorical interaction models

apr3 = regsubplots(x = apr3)
	 
grid.arrange(apr3$plots[[1]], 
			 apr3$plots[[2]], 
			 apr3$plots[[3]], 
			 apr3$plots[[4]],  
			 ncol = 2)

# lets extract models 5 through 9 given that these are good canidates

apr3_models = lapply(5:9, function(i) data.frame("Terms" = colnames(apr3$dat[i, which(apr3$dat[i,] == "TRUE")])[-1]))			 
names(apr3_models) = paste("Model_", 5:9, sep = "")
apr3_models

# lets look at the results for the final categorical interaction models

apr4 = regsubplots(x = apr4)
	 
grid.arrange(apr4$plots[[1]], 
			 apr4$plots[[2]], 
			 apr4$plots[[3]], 
			 apr4$plots[[4]],  
			 ncol = 2)

# lets extract models 5 through 9 given that these are good canidates
			 
apr4_models = lapply(5:9, function(i) data.frame("Terms" = colnames(apr4$dat[i, which(apr4$dat[i,] == "TRUE")])[-1]))			 
names(apr4_models) = paste("Model_", 5:9, sep = "")
apr4_models

# lets take a look at all of the variables used in the median size model for each of the four groups, to come up with terms to choose from

apr1_models[[round(length(apr1_models)/2,0)]]
apr2_models[[round(length(apr2_models)/2,0)]]
apr3_models[[round(length(apr3_models)/2,0)]]
apr4_models[[round(length(apr4_models)/2,0)]]

rm(apr1_models, apr2_models, apr3_models, apr4_models, apr1, apr2, apr3, apr4)

# the following regsubsets object will evaluate all of the variables used in the median size model from apr1, apr2, ap3, and apr4

apr = regsubsets(ynorm ~ xexp + xunif + xnorms + xcauchy + xtriangle + xexp:cat1 + xexp:xunif + 
						 xexp:xbeta + xbeta:cat1 + xunif:cat3 + xexp:xcauchy + 
						 xcauchy:cat2 + xcauchy:cat3 + xcauchy:xunif + xexp:xtriangle + 
						 xtriangle:cat1 + xtriangle:cat3 + xrexp:xtriangle,
				 data = dat,
				 nbest = 1,      
				 nvmax = NULL,
				 method = "exhaustive",
				 really.big = TRUE)	 
				 
apr = regsubplots(x = apr)

grid.arrange(apr$plots[[1]], 
			 apr$plots[[2]], 
			 apr$plots[[3]], 
			 apr$plots[[4]],  
			 ncol = 2)

# lets extract 4 models based on the 4 criterion in the plots: RSS, AdjR2, Cp, BIC

apr_models = lapply(c(20, 14, 8, 4), function(i) data.frame("Terms" = colnames(apr$dat[i, which(apr$dat[i,] == "TRUE")])[-1]))			 
names(apr_models) = paste("Model_", c("RSS", "AdjR2", "Cp", "BIC"), sep = "")
apr_models

rm(apr, apr_models)

# ---- lets look at the residuals for the models of interest -----------------------------------------

rsslm = lm(ynorm ~ xexp + xunif + xcauchy + xtriangle + xexp:cat1 + 
				   xexp:xunif + xexp:xbeta + cat1:xbeta + xunif:cat3 + 
				   xexp:xcauchy + xcauchy:cat2 + xunif:xcauchy + xtriangle:cat1 + 
				   xtriangle:cat3 + xtriangle:xrexp,
		   data = dat)

adjr2lm = lm(ynorm ~ xexp + xunif + xcauchy + xexp:cat1 + xexp:xunif + 
					 cat1:xbeta + xunif:cat3 + xexp:xcauchy + xunif:xcauchy + 
					 xtriangle:cat1,
			 data = dat)
			 
cplm = lm(ynorm ~ xexp + xcauchy + xexp:cat1 + 
				  cat1:xbeta + xexp:xtriangle + 
				  xtriangle:cat1, 
		  data = dat)

biclm = lm(ynorm ~ xunif + xcauchy + cat1:xbeta + xtriangle:cat1, 
		   data = dat)

# plotslm is a function that returns 6 diagnostic plots to visually see how well the residuals are behaving
# plotslm takes on at least 1 input: model, this is the model we wan tresidual diagnostics for
# the other inputs include:
	# binwidth --> the size of the bins in the historgram plot
	# from --> the first tick value to be plotted on the x axis of the histogram
	# to --> the last tick value to be plotted on the x axis of the histogram
	# by --> the increment between all ticks on the x axis of the histogram

plotslm = function(model, binwidth = NULL, from = NULL, to = NULL, by = NULL, n = NULL, basefont = 20)
{
	require(ggplot2)
	require(MASS)
	
    rvfPlot = ggplot(model, aes(x = .fitted, y = .resid)) + 
			  geom_point(na.rm = TRUE) +
			  stat_smooth(method = "loess", se = FALSE, na.rm = TRUE, color = "blue") +
			  geom_hline(yintercept = 0, col = "red", linetype = "dashed") +
			  xlab("Fitted values") +
			  ylab("Residuals") +
			  ggtitle("Residual vs Fitted Plot") + 
			  theme_light(base_size = basefont) +
			  theme(legend.position = "none")
    
	ggqq = function(x, distribution = "norm", ..., conf = 0.95, probs = c(0.25, 0.75), note = TRUE, alpha = 0.33, main = "", xlab = "\nTheoretical Quantiles", ylab = "Empirical Quantiles\n")
	{
		# compute the sample quantiles and theoretical quantiles
		q.function = eval(parse(text = paste0("q", distribution)))
  		d.function = eval(parse(text = paste0("d", distribution)))
  		x = na.omit(x)
  		ord = order(x)
  		n = length(x)
  		P = ppoints(length(x))
  		DF = data.frame(ord.x = x[ord], z = q.function(P, ...))
  
  		# compute the quantile line
  		Q.x = quantile(DF$ord.x, c(probs[1], probs[2]))
  		Q.z = q.function(c(probs[1], probs[2]), ...)
  		b = diff(Q.x) / diff(Q.z)
  		coef = c(Q.x[1] - (b * Q.z[1]), b)
  
  		# compute the confidence interval band
  		zz = qnorm(1 - (1 - conf) / 2)
  		SE = (coef[2] / d.function(DF$z, ...)) * sqrt(P * (1 - P) / n)
  		fit.value = coef[1] + (coef[2] * DF$z)
  		DF$upper = fit.value + (zz * SE)
  		DF$lower = fit.value - (zz * SE)
  
  		# plot the qqplot
  		p = ggplot(DF, aes(x = z, y = ord.x)) + 
    		geom_point(color = "black", alpha = alpha) +
    		geom_abline(intercept = coef[1], slope = coef[2], size = 1, color = "blue") +
    		geom_ribbon(aes(ymin = lower, ymax = upper), alpha = 0.15) +
    		coord_cartesian(ylim = c(min(DF$ord.x), max(DF$ord.x))) + 
    		labs(x = xlab, y = ylab) +
    		theme_light(base_size = basefont) +
			theme(legend.position = "none")
						
  		# conditional additions
  		if(main != "")(p = p + ggtitle(main))
  		
  		return(p)
	}

    qqPlot = ggqq(stdres(model), 
				  alpha = 1,				  
				  main = "Normal Q-Q Plot", 
				  xlab = "Theoretical Quantiles", 
				  ylab = "Standardized Residuals")
    
    rvtPlot = ggplot(data.frame("x" = 1:length(model[[2]]), "y" = model[[2]]), aes(x = x, y = y)) + 
			  geom_line(na.rm = TRUE) +
			  geom_hline(yintercept = 0, col = "red", linetype = "dashed") +
			  xlab("Obs. Number") +
			  ylab("Residuals") +
			  ggtitle("Residual Time Series") + 
			  theme_light(base_size = basefont) +
			  theme(legend.position = "none")
    
    cvlPlot = ggplot(model, aes(x = .hat, y = .cooksd)) +
			  geom_point(na.rm = TRUE) +
			  stat_smooth(method = "loess", se = FALSE, na.rm = TRUE, color = "blue") +
			  xlab("Leverage") +
			  ylab("Cook's Distance") +
			  ggtitle("Cook's Distance vs Leverage") +
			  geom_abline(slope = seq(0,3,0.5), color = "black", linetype = "dashed") + 
			  theme_light(base_size = basefont) +
			  theme(legend.position = "none")
	
	test = t.test(model$residuals)
	
	CI = data.frame("x" = test$estimate, 
					"LCB" = test$conf.int[1], 
					"UCB" = test$conf.int[2], 
					row.names = 1)
	
	histPlot = ggplot(DF, aes(x = residual)) +
			   geom_histogram(color = "white", fill = "black", binwidth = binwidth) +
			   geom_segment(data = CI, aes(x = LCB, xend = LCB, y = 0, yend = Inf), color = "blue") +
			   geom_segment(data = CI, aes(x = UCB, xend = UCB, y = 0, yend = Inf), color = "blue") +
			   annotate("text", x = CI$x, y = -10, 
						label = "T-Test C.I.", size = 5, 
						color = "blue", fontface = 2) + 
			    ggtitle("Residual Histogram") +
			   labs(x = "Residuals", y = "Frequency") +
	 		   theme_light(base_size = basefont) +
			   theme(legend.key.size = unit(.25, "in"),
					 legend.position = "bottom")
	
	if(class(from) != "NULL" & class(to) != "NULL" & class(by) != "NULL") (histPlot = histPlot + scale_x_continuous(breaks = seq(from = from, to = to, by = by)))
	
	ggacf = function(x, n = NULL, conf.level = 0.95, main = "", basefont = 20) 
	{
		if(class(n) == "NULL")
		{
			n = length(x) - 2
		}
	
		ciline = qnorm((1 - conf.level) / 2) / sqrt(length(x))
		bacf = acf(x, lag.max = n, plot = FALSE)
		bacfdf = with(bacf, data.frame(lag, acf))
	
		p = ggplot(bacfdf, aes(x = lag, y = acf)) + 
			geom_bar(stat = "identity", position = "dodge", fill = "black") +
			geom_hline(yintercept = -ciline, color = "blue", size = 1) +
			geom_hline(yintercept = ciline, color = "blue", size = 1) +
			geom_hline(yintercept = 0, color = "red", size = 1) +
			labs(x = "Lag", y = "Autocorrelation") +
			ggtitle(main) +
			theme_light(base_size = basefont) +
			theme(legend.position = "none")

		return(p)
	}

	acfPlot = ggacf(x = model[[2]], main = "ACF Plot of Residuals", basefont = basefont, n = n)
	
    return(list("rvfPlot" = rvfPlot, 
				"qqPlot" = qqPlot, 
				"rvtPlot" = rvtPlot, 
				"cvlPlot" = cvlPlot, 
				"histPlot" = histPlot, 
				"acfPlot" = acfPlot))
}

# termplots is a function that returns the residuals of the model due to each of the continuous main effects
# termplots takes on two inputs:
	# dat, the dataframe that built the model
	# model, the model that you want to see the partial residauls of

termplots = function(dat, model, basefont = 20)
{
	require(ggplot2)
	
	vars = names(model$coefficients)[which(names(model$coefficients) %in% names(dat))]
	pterms = predict(model, type = "terms")
	pres = apply(pterms, 2, function(i) i + resid(model))
	DF = lapply(1:length(vars), function(i) data.frame("x" = model$model[,(i + 1)], "y" = pres[,i]))
	ablines = lapply(1:length(vars), function(i) lm(pres[,i] ~ model$model[,(i + 1)]))
	
	p = lapply(1:length(DF), function(i)
										ggplot(DF[[i]], aes(x = x, y = y)) + 
										geom_point(color = "black") +
										geom_abline(intercept = ablines[[i]]$coefficients[[1]], slope = ablines[[i]]$coefficients[[2]], size = 1, color = "blue") +
										labs(x = vars[i], y = "Partial Residuals") +
										ggtitle(paste0("Partial Residuals of ", vars[i])) +
										theme_light(base_size = basefont) +
										theme(legend.position = "none")
	
	return(p)
}

# testslm is a function that tests the 6 major assumptions of a linear model
# testslm take on two inputs:
	# model, the model that you want to test the 6 assumptions for
	# LAG, the lag that you want to test up to in the durbin watson test 

testslm = function(LM, LAG = 1)
{
    tab1 = t.test(LM$residuals)
    
	require(car)
    tab2 = ncvTest(LM)
	
	if(length(LM$residuals) > 5000)
	{
		require(nortest)
		tab3 = ad.test(x = LM$residuals)
	} else
	{
		tab3 = shapiro.test(LM$residuals)
	}
	
    tab4 = durbinWatsonTest(LM, LAG)
    tab5 = summary(LM)
    
	if(length(LM[[1]][which(names(LM[[1]]) != "(Intercept)")]) > 1)
	{
		tab6 = vif(LM)
		
		Results = list("Assumption 1 - Residuals have an Expected Value of Zero - Zero Within CI" = tab1, 
					   "Assumption 2 - Residuals have Constant Variance - P-Value > 0.05" = tab2,
					   "Assumption 3 - Residuals are Normally Distributed - P-Value > 0.05" = tab3,
					   "Assumption 4 - Residuals are Uncorrelated - P-value > 0.05" = tab4,
					   "Assumption 5 - The Relationship between the Response and Regressors is Correct - All P-Value < 0.1" = tab5,
					   "Assumption 6 - The Regressors are Independent - All vif < 10" = tab6)
	} else
	{
		Results = list("Assumption 1 - Residuals have an Expected Value of Zero - Zero Within CI" = tab1,
					   "Assumption 2 - Residuals have Constant Variance - P-Value > 0.05" = tab2,
					   "Assumption 3 - Residuals are Normally Distributed - P-Value > 0.05" = tab3,
					   "Assumption 4 - Residuals are Uncorrelated - P-value > 0.05" = tab4,
					   "Assumption 5 - The Relationship between the Response and Regressors is Correct - All P-Value < 0.1" = tab5)
	}
	
    return(Results)
}

# statslm is a function that returns 3 statistics for a model, AIC, BIC, R2-Pred
# statslm take on one input:
	# model, the model that you want the 3 statistics of

statslm = function(model)
{
    # Calculate the Predictive Residuals of 'model'
    PR = residuals(model)/(1 - lm.influence(model)$hat)
    
    # Calculate the Predicted Residual Sum of Squares
    PRESS=sum(PR^2)
    
    # Calculate the Total Sum of Squares
    TSS=sum(anova(model)$"Sum Sq")
    
    # Summary
    return(list("Prediction" = c("R^2-Pred" = round(1 - (PRESS/TSS), 4)),
				"Fitness" = c("AIC" = AIC(model),
							  "BIC" = BIC(model))))
}

require(gridExtra)

# ---- rsslm residuals ---------------------------------------------------

rsslm = list("model" = rsslm, 
			 "resplots" = plotslm(rsslm, binwidth = 2), 
			 "termplots" = termplots(dat = dat, model = rsslm),
			 "tests" = testslm(rsslm),
			 "stats" = statslm(rsslm))

# residual plots
grid.arrange(rsslm$resplots[[1]], 
			 rsslm$resplots[[2]], 
			 rsslm$resplots[[3]], 
			 rsslm$resplots[[4]], 
			 rsslm$resplots[[5]], 
			 rsslm$resplots[[6]], 
			 ncol = 3)

# partial residual plots
grid.arrange(rsslm$termplots[[1]], 
			 rsslm$termplots[[2]], 
			 rsslm$termplots[[3]], 
			 rsslm$termplots[[4]], 
			 ncol = 2)

# model tests for 6 major assumptions
rsslm$tests

# model statistics
rsslm$stats

# ---- adjr2lm residuals ---------------------------------------------------

adjr2lm = list("model" = adjr2lm, 
			   "resplots" = plotslm(adjr2lm, binwidth = 2), 
			   "termplots" = termplots(dat = dat, model = adjr2lm), 
			   "tests" = testslm(adjr2lm),
			   "stats" = statslm(adjr2lm))

# residual plots
grid.arrange(adjr2lm$resplots[[1]], 
			 adjr2lm$resplots[[2]], 
			 adjr2lm$resplots[[3]], 
			 adjr2lm$resplots[[4]], 
			 adjr2lm$resplots[[5]], 
			 adjr2lm$resplots[[6]], 
			 ncol = 3)

# partial residual plots
grid.arrange(adjr2lm$termplots[[1]], 
			 adjr2lm$termplots[[2]], 
			 adjr2lm$termplots[[3]], 
			 ncol = 2)

# model tests for 6 major assumptions
adjr2lm$tests

# model statistics
adjr2lm$stats

# ---- cplm residuals ---------------------------------------------------

cplm = list("model" = cplm, 
			"resplots" = plotslm(cplm, binwidth = 2), 
			"termplots" = termplots(dat = dat, model = cplm), 
			"tests" = testslm(cplm),
			"stats" = statslm(cplm))

# residual plots
grid.arrange(cplm$resplots[[1]], 
			 cplm$resplots[[2]], 
			 cplm$resplots[[3]], 
			 cplm$resplots[[4]], 
			 cplm$resplots[[5]], 
			 cplm$resplots[[6]], 
			 ncol = 3)

# partial residual plots
grid.arrange(cplm$termplots[[1]], 
			 cplm$termplots[[2]], 
			 ncol = 2)

# model tests for 6 major assumptions
cplm$tests

# model statistics
cplm$stats

# ---- biclm residuals ---------------------------------------------------

biclm = list("model" = biclm, 
			 "resplots" = plotslm(biclm, binwidth = 2), 
			 "termplots" = termplots(dat = dat, model = biclm), 
			 "tests" = testslm(biclm),
			 "stats" = statslm(biclm))

# residual plots
grid.arrange(biclm$resplots[[1]], 
			 biclm$resplots[[2]], 
			 biclm$resplots[[3]], 
			 biclm$resplots[[4]], 
			 biclm$resplots[[5]], 
			 biclm$resplots[[6]], 
			 ncol = 3)

# partial residual plots
grid.arrange(biclm$termplots[[1]], 
			 biclm$termplots[[2]], 
			 ncol = 2)

# model tests for 6 major assumptions
biclm$tests

# model statistics
biclm$stats

# ---- lets try some transformations and look at the residuals -----------------------------------------



# ---- lets have the remaining models predict the future data ---------------------------------



# ---- final model of choice -------------------------------------------------------------------------------------------



































# lets run some transformations on all of the continuous predictor variables to see if we can create a stronger linear realtionship between them and the response
# here is a function i created that takes in one input: dat
# dat is the dataframe of data
# the first column of dat must be the response variable
# the other columns of dat must be the continuous predictor variables

Transform = function(dat)
{
  dat = data.frame(dat)
  
  Results = sapply(2:NCOL(dat), function(i) c(
    round(cor(dat[,1], logb(dat[,i], exp(1)))^2, 4),
    round(cor(dat[,1], logb(dat[,i], 10))^2, 4),
    round(cor(dat[,1], exp(dat[,i]))^2, 4),
    round(cor(dat[,1], sqrt(dat[,i]))^2, 4),
    round(cor(dat[,1], 1/dat[,i])^2, 4),
    round(cor(dat[,1], dat[,i]^2)^2, 4),
    round(cor(dat[,1], dat[,i]^3)^2, 4),
    round(cor(logb(dat[,1], exp(1)), logb(dat[,i], 10))^2, 4),
    round(cor(logb(dat[,1], exp(1)), exp(dat[,i]))^2, 4),
    round(cor(logb(dat[,1], exp(1)), sqrt(dat[,i]))^2, 4),
    round(cor(logb(dat[,1], exp(1)), 1/dat[,i])^2, 4),
    round(cor(logb(dat[,1], exp(1)), dat[,i]^2)^2, 4),
    round(cor(logb(dat[,1], exp(1)), dat[,i]^3)^2, 4),
    round(cor(logb(dat[,1], 10), logb(dat[,i], exp(1)))^2, 4),
    round(cor(logb(dat[,1], 10), exp(dat[,i]))^2, 4),
    round(cor(logb(dat[,1], 10), sqrt(dat[,i]))^2, 4),
    round(cor(logb(dat[,1], 10), 1/dat[,i])^2, 4),
    round(cor(logb(dat[,1], 10), dat[,i]^2)^2, 4),
    round(cor(logb(dat[,1], 10), dat[,i]^3)^2, 4),
    round(cor(exp(dat[,1]), logb(dat[,i], exp(1)))^2, 4),
    round(cor(exp(dat[,1]), logb(dat[,i], 10))^2, 4),
    round(cor(exp(dat[,1]), sqrt(dat[,i]))^2, 4),
    round(cor(exp(dat[,1]), 1/dat[,i])^2, 4),
    round(cor(exp(dat[,1]), dat[,i]^2)^2, 4),
    round(cor(exp(dat[,1]), dat[,i]^3)^2, 4),
    round(cor(sqrt(dat[,1]), logb(dat[,i], exp(1)))^2, 4),
    round(cor(sqrt(dat[,1]), logb(dat[,i], 10))^2, 4),
    round(cor(sqrt(dat[,1]), exp(dat[,i]))^2, 4),
    round(cor(sqrt(dat[,1]), 1/dat[,i])^2, 4),
    round(cor(sqrt(dat[,1]), dat[,i]^2)^2, 4),
    round(cor(sqrt(dat[,1]), dat[,i]^3)^2, 4),
    round(cor(1/dat[,1], logb(dat[,i], exp(1)))^2, 4),
    round(cor(1/dat[,1], logb(dat[,i], 10))^2, 4),
    round(cor(1/dat[,1], exp(dat[,i]))^2, 4),
    round(cor(1/dat[,1], sqrt(dat[,i]))^2, 4),
    round(cor(1/dat[,1], dat[,i]^2)^2, 4),
    round(cor(1/dat[,1], dat[,i]^3)^2, 4),
    round(cor(dat[,1]^2, logb(dat[,i], exp(1)))^2, 4),
    round(cor(dat[,1]^2, logb(dat[,i], 10))^2, 4),
    round(cor(dat[,1]^2, exp(dat[,i]))^2, 4),
    round(cor(dat[,1]^2, sqrt(dat[,i]))^2, 4),
    round(cor(dat[,1]^2, dat[,i]^2)^2, 4),
    round(cor(dat[,1]^2, dat[,i]^3)^2, 4),
    round(cor(dat[,1]^3, logb(dat[,i], exp(1)))^2, 4),
    round(cor(dat[,1]^3, logb(dat[,i], 10))^2, 4),
    round(cor(dat[,1]^3, exp(dat[,i]))^2, 4),
    round(cor(dat[,1]^3, sqrt(dat[,i]))^2, 4),
    round(cor(dat[,1]^3, 1/dat[,i])^2, 4),
    round(cor(dat[,1]^3, dat[,i]^2)^2, 4),
    round(cor(logb(dat[,1], exp(1)), dat[,i])^2, 4),
    round(cor(logb(dat[,1], 10), dat[,i])^2, 4),
    round(cor(exp(dat[,1]), dat[,i])^2, 4),
    round(cor(sqrt(dat[,1]), dat[,i])^2, 4),
    round(cor(1/dat[,1], dat[,i])^2, 4),
    round(cor(dat[,1]^2, dat[,i])^2, 4),
    round(cor(dat[,1]^3, dat[,i])^2, 4)))
  
  Results = data.frame(Results)
  
  rnames = c("cor(Response, logb(Predictor, exp(1)))^2",
             "cor(Response, logb(Predictor, 10))^2",
             "cor(Response, exp(Predictor))^2",
             "cor(Response, sqrt(Predictor))^2",
             "cor(Response, 1/Predictor)^2",
             "cor(Response, Predictor^2)^2",
             "cor(Response, Predictor^3)^2",
             "cor(logb(Response, exp(1)), logb(Predictor, 10))^2",
             "cor(logb(Response, exp(1)), exp(Predictor))^2",
             "cor(logb(Response, exp(1)), sqrt(Predictor))^2",
             "cor(logb(Response, exp(1)), 1/Predictor)^2",
             "cor(logb(Response, exp(1)), Predictor^2)^2",
             "cor(logb(Response, exp(1)), Predictor^3)^2",
             "cor(logb(Response, 10), logb(Predictor, exp(1)))^2",
             "cor(logb(Response, 10), exp(Predictor))^2",
             "cor(logb(Response, 10), sqrt(Predictor))^2",
             "cor(logb(Response, 10), 1/Predictor)^2",
             "cor(logb(Response, 10), Predictor^2)^2",
             "cor(logb(Response, 10), Predictor^3)^2",
             "cor(exp(Response), logb(Predictor, exp(1)))^2",
             "cor(exp(Response), logb(Predictor, 10))^2",
             "cor(exp(Response), sqrt(Predictor))^2",
             "cor(exp(Response), 1/Predictor)^2",
             "cor(exp(Response), Predictor^2)^2",
             "cor(exp(Response), Predictor^3)^2",
             "cor(sqrt(Response), logb(Predictor, exp(1)))^2",
             "cor(sqrt(Response), logb(Predictor, 10))^2",
             "cor(sqrt(Response), exp(Predictor))^2",
             "cor(sqrt(Response), 1/Predictor)^2",
             "cor(sqrt(Response), Predictor^2)^2",
             "cor(sqrt(Response), Predictor^3)^2",
             "cor(1/Response, logb(Predictor, exp(1)))^2",
             "cor(1/Response, logb(Predictor, 10))^2",
             "cor(1/Response, exp(Predictor))^2",
             "cor(1/Response, sqrt(Predictor))^2",
             "cor(1/Response, Predictor^2)^2",
             "cor(1/Response, Predictor^3)^2",
             "cor(Response^2, logb(Predictor, exp(1)))^2",
             "cor(Response^2, logb(Predictor, 10))^2",
             "cor(Response^2, exp(Predictor))^2",
             "cor(Response^2, sqrt(Predictor))^2",
             "cor(Response^2, 1/Predictor)^2",
             "cor(Response^2, Predictor^3)^2",
             "cor(Response^3, logb(Predictor, exp(1)))^2",
             "cor(Response^3, logb(Predictor, 10))^2",
             "cor(Response^3, exp(Predictor))^2",
             "cor(Response^3, sqrt(Predictor))^2",
             "cor(Response^3, 1/Predictor)^2",
             "cor(Response^3, Predictor^2)^2",
             "cor(logb(Response, exp(1)), Predictor)^2",
             "cor(logb(Response, 10), Predictor)^2",
             "cor(exp(Response), Predictor)^2",
             "cor(sqrt(Response), Predictor)^2",
             "cor(1/Response, Predictor)^2",
             "cor(Response^2, Predictor)^2",
             "cor(Response^3, Predictor)^2")
  
  cnames = colnames(dat[,2:NCOL(dat)])
  
  rownames(Results) = rnames
  colnames(Results) = cnames
    
  Results = lapply(1:NCOL(Results), function(i) list(
    "Results" = data.frame("Transformation" = rownames(Results)[order(Results[,i], decreasing = TRUE)], "Rsq" = Results[order(Results[,i], decreasing = TRUE),i]),
    "Baseline" = data.frame("Transformation" = "cor(Response, Predictor)^2", "Rsq" = round(cor(dat[,1], dat[,i + 1])^2, 4))))
  
  names(Results) = cnames
  
  for(i in 1:length(Results))
  {
	Results[[i]][[1]] = Results[[i]][[1]][which(Results[[i]][[1]][,2] > Results[[i]][[2]][,2]),]
  }
  
  return(Results)
}

trans = Transform(dat[,1:(NCOL(dat) - 3)])
trans

# lets try out some of the suggested transformations

dat2 = dat
dat2$ynorm = 1/dat2$ynorm
dat2$xexp = logb(dat2$xexp, exp(1))
dat2$xrexp = dat2$xrexp^3
colnames(dat2) = c("ynorm_p_1", "xnorms", "ln_xexp", "xrexp_p3", "xtriangle", "xcauchy", "xunif", "xbeta", "cat1", "cat2", "cat3")

plot_pairs2 = ggpairs(dat2, 
					 columns = colnames(dat2[,1:8]), 
        			 lower = list(mapping = aes(color = cat1)), 
        			 upper = list(continuous = wrap(ggally_cor, size = 6, color = "black")),
        			 diag = list(continuous = wrap(ggally_densityDiag, fill = "black", alpha = 1/3)))

plot_pairs2

dat3 = dat
dat3$xexp = logb(dat3$xexp, exp(1))
colnames(dat3) = c("ynorm", "xnorms", "ln_xexp", "xrexp", "xtriangle", "xcauchy", "xunif", "xbeta", "cat1", "cat2", "cat3")

plot_pairs3 = ggpairs(dat3, 
					 columns = colnames(dat3[,1:8]), 
        			 lower = list(mapping = aes(color = cat1)), 
        			 upper = list(continuous = wrap(ggally_cor, size = 6, color = "black")),
        			 diag = list(continuous = wrap(ggally_densityDiag, fill = "black", alpha = 1/3)))

plot_pairs3

# lets put our plots and data frames into lists

list_pairs = list("plot_pairs" = plot_pairs,
				  "plot_pairs2" = plot_pairs2,
				  "plot_pairs3" = plot_pairs3)

list_dat = list("dat" = dat,
				"dat2" = dat2,
				"dat3" = dat3)

rm(dat, dat2, dat3, plot_pairs, plot_pairs2, plot_pairs3, trans, Transform)






# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ---- Logistic Regression Analysis --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ---- Polynomial Regression Analysis ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ---- Stepwise Regression Analysis --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ---- Ridge Regression Analysis -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ---- Lasso Regression Analysis -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ---- ElasticNet Regression Analysis ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ---- Random Forest Regression Analysis ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




# https://www.analyticsvidhya.com/blog/2015/08/comprehensive-guide-regression/



# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ---- Using data.table --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# ---- creating a data.table --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

require(data.table)

PAT_ID = as.integer(seq(10,10000,10))
PAT_AGE = as.integer(round(rnorm(1000,50,10),0))
PAT_GENDER = as.factor(sample(c("MALE","FEMALE"), size = 1000, replace = TRUE))
PAT_ETHNICITY = as.factor(sample(c("WHITE", "BLACK", "INDIAN", "ASIAN", "AUSTRALIAN"), size = 1000, replace = TRUE))
DOCTOR = as.factor(sample(c("O'NEAL JAMES", "WEBBER, NATHAN", "HIGGENS, JOHN", "SMITH, DARIN", "HAMILTON, JOSEPH", "HEROOK, DAVID", "LONG, DANIEL", "NEWTON, GARY", "MURPHY, ERIN", "FINNIGAN, JENNIFER"), size = 1000, replace = TRUE))
PAT_SCHEDULED = sample(seq(c(ISOdate(2000,3,20)), by = "day", length.out = 1500), size = 1000)
PAT_SCHEDULED = PAT_SCHEDULED + abs(rnorm(1000, 3600 * 4, 3600 * 2))
PAT_SCHEDULED = PAT_SCHEDULED[order(PAT_SCHEDULED)]
PAT_ARRIVED = PAT_SCHEDULED + abs(rnorm(1000, 3600 * 24 * 7 * 2.5, 3600 * 24 * 5))
PAT_DEPARTED = PAT_ARRIVED + abs(sample(c(rnorm(500, 3600 * 14, 3600 * 4), rnorm(1000, 3600 * 24 * 4, 3600 * 24)), size = 1000))
PAT_WAITED_DAYS = difftime(PAT_ARRIVED, PAT_SCHEDULED, units = "days")
PAT_LOS_HOURS = difftime(PAT_DEPARTED, PAT_ARRIVED, units = "hours")
PRE_OPTIMIZATION = as.factor(c(rep("Yes",500), rep("No",500)))
PAT_ARRIVED[501:1000] = PAT_ARRIVED[501:1000] - (PAT_WAITED_DAYS[501:1000] * 0.15)
PAT_DEPARTED[501:1000] = PAT_DEPARTED[501:1000] - (PAT_WAITED_DAYS[501:1000] * 0.15)
PAT_DEPARTED[501:1000] = PAT_DEPARTED[501:1000] - (PAT_LOS_HOURS[501:1000] * 0.15)
PAT_WAITED_DAYS = as.numeric(difftime(PAT_ARRIVED, PAT_SCHEDULED, units = "days"))
PAT_LOS_HOURS = as.numeric(difftime(PAT_DEPARTED, PAT_ARRIVED, units = "hours"))
PAT_CLASS = as.factor(ifelse(PAT_LOS_HOURS < 24, "OUTPATIENT", "INPATIENT"))

dat = data.table(PAT_ID, PAT_AGE, PAT_GENDER, PAT_ETHNICITY, PAT_CLASS, DOCTOR, PAT_SCHEDULED, PAT_ARRIVED, PAT_DEPARTED, PAT_WAITED_DAYS, PAT_LOS_HOURS, PRE_OPTIMIZATION)

rm(PAT_ID, PAT_AGE, PAT_GENDER, PAT_ETHNICITY, PAT_CLASS, DOCTOR, PAT_SCHEDULED, PAT_ARRIVED, PAT_DEPARTED, PAT_WAITED_DAYS, PAT_LOS_HOURS, PRE_OPTIMIZATION)

# print the data table, by default it only shows the first 5 and last 5 rows

print(dat, nrow = NROW(dat))

# ---- subsetting --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# subset rows

dat[1:6,]

# subset rows and columns

dat[1:6, PAT_GENDER]

# subset multiple columns

dat[, .(PAT_AGE, PAT_GENDER)]

# subset with conditions

	# returns a table meeting condition
dat[PAT_ETHNICITY == "WHITE"]

	# returns a vector of logicals identifying which observations do/don't meet the condition - like which
dat[, PAT_ETHNICITY == "WHITE"]

	# multiple conditions
dat[PAT_ETHNICITY %in% c("WHITE", "INDIAN")]

# summarize an entire column

dat[, summary(PAT_LOS_HOURS)]

# summarize multiple columns

dat[, .("MEASURE" = names(summary(PAT_LOS_HOURS)), 
		"LOS" = summary(PAT_LOS_HOURS), 
		"WAIT" = summary(PAT_WAITED_DAYS))]

# ---- aggregating--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# aggregate using mean

dat[, .("MEAN.LOS" = mean(PAT_LOS_HOURS)), 
	  by = .(PAT_GENDER, DOCTOR)]

# aggregate using .N --> same as table()
	  
dat[,.N, by = .(DOCTOR, PAT_GENDER)]

# aggregate using summary

dat[, .("MEASURE" = names(summary(PAT_LOS_HOURS)), 
		"SUMMARY.LOS" = summary(PAT_LOS_HOURS)), 
	  by = .(PAT_GENDER, DOCTOR)]

# ---- updating columns --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# change id values

dat[,PAT_ID := 1:1000]
dat[,PAT_ID := seq(10, 10 * 1000, 10)]

# remove columns

dat[, PAT_ID := NULL]

# re-order position of columns

setcolorder(dat, c("PAT_GENDER", "PAT_ETHNICITY", "PAT_CLASS", "DOCTOR", "PAT_AGE", "PAT_SCHEDULED", "PAT_ARRIVED", "PAT_DEPARTED", "PAT_WAITED_DAYS", "PAT_LOS_HOURS", "PRE_OPTIMIZATION"))

# re-name columns

setnames(dat, "PAT_GENDER", "GENDER")
setnames(dat, c("GENDER", "DOCTOR"), c("PAT_GENDER", "PAT_DOCTOR"))

# convert between data.frames and data.tables

data.frame(dat)

data.table(dat)

# add columns

dat[,PAT_ID := 1:1000]

# ---- joins --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# creating new data tables 

dat2 = data.table(dat[,.(PAT_ID)])
dat2[,PAT_ID := seq(10, 10 * 1000, 5)]


# setting column keys on which to join

setkey(dat, PAT_ID)
setkey(dat2, PAT_ID)

# inner join

dat[dat2, nomatch = 0]

# right join

dat[dat2]

# ---- shift --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# lag 1

dat2[,PAT_ID_LAG1 := shift(PAT_ID, 1)]

# lag 3

dat2[,PAT_ID_LAG3 := shift(PAT_ID, 3)]

# forward lag 1

dat2[,PAT_ID_LAG1_FORWARD := shift(PAT_ID, 1, type = "lead")]

# forward lag 3

dat2[,PAT_ID_LAG3_FORWARD := shift(PAT_ID, 3, type = "lead")]


# ---- melt, dcast --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# ftp://cran.r-project.org/pub/R/web/packages/data.table/vignettes/datatable-reshape.html
