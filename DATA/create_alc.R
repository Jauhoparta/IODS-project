#) Tuomas Mäkelä, 16.11. Data wranglin on the data set from https://archive.ics.uci.edu/ml/datasets/Student+Performance
library(dplyr)

#Making sure the working directory is correct
setwd("~/IODS-project")
Math <- read.csv("DATA/student-mat.csv", sep=";")
Por  <- read.csv("DATA/student-por.csv", sep=";")

# Looking at the data
str(Math)
str(Por)
dim(Math)
dim(Por)

# Now making one big table. First define the columns to stay the same in joining
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

# now selecting the data so the join_by are identical.

math_por <- inner_join(Math, Por, by = join_by, suffix=c(".math", ".por"))
str(math_por) 
dim(math_por)

#Seems we are left with 382 observations and now 53 variables instead of 33
#Now lets combine the duplicated data in the set:

#First take the identical columns and move them to a different table
Alc<-select(math_por, one_of(join_by))

unjoined<-colnames(Math)[!(colnames(Math)%in% join_by)]

#Now for a loop-de-loop (Not quite identical to data camp)
for(X in unjoined) {
  Doublecol<-select(math_por, starts_with(X))
  Y <- select(Doublecol, 1)[[1]]
  
  if(is.numeric(Y)){
    Alc[X] <- round(rowMeans(Doublecol))
  } else
    Alc[X]<-Y
  
}
#averaging over the weekday alcohol use and weekend alcohol use

alc <- mutate(Alc, alc_use = (Dalc + Walc) / 2)
#Creating a binary response for high consumption of alcohol
alc <- mutate(alc, high_use= alc_use>2)

glimpse(alc)
write.csv(alc, file="DATA/Alcohol.csv")
