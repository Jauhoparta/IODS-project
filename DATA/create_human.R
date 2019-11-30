# Tuomas Mäkelä
# Working on the UN development programme dataset from
# http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt
# Doing some data wrangling for next week now:
#
library(dplyr)
setwd("~/IODS-project")
# Reading data into memory


hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

#Now lets look at the data

str(hd)
str(gii)

#and summarize the variables:

summary(hd)
summary(gii)

# Renaming some of the difficult names of variables now (varible names Capitalized, to avoid error) and look at teh results.
# First table hd
hd<-rename(hd, HDI=Human.Development.Index..HDI.)
summary(hd)


hd<-rename(hd, GNIperc=Gross.National.Income..GNI..per.Capita)
hd<-rename(hd, Edumean=Mean.Years.of.Education)
hd<-rename(hd, Eduexp=Expected.Years.of.Education  )
hd<-rename(hd, Lifeexp=Life.Expectancy.at.Birth  )
hd<-rename(hd, GminusHDI=GNI.per.Capita.Rank.Minus.HDI.Rank)
summary(hd)

#Then table gii. again, taking names that are short and descripive
str(gii)
gii<-rename(gii, Gineq=Gender.Inequality.Index..GII.)
gii<-rename(gii, MMRat=Maternal.Mortality.Ratio )
gii<-rename(gii,Adbirth=Adolescent.Birth.Rate )
gii<-rename(gii,Repparl=Percent.Representation.in.Parliament )
gii<-rename(gii,Edfemale=Population.with.Secondary.Education..Female.)
gii<-rename(gii,Edmale=Population.with.Secondary.Education..Male.)
gii<-rename(gii,Labfem=Labour.Force.Participation.Rate..Female. )
gii<-rename(gii,Labmale=Labour.Force.Participation.Rate..Male. )
gii$Ratioed<-gii$Edfemale/gii$Edmale
gii$Ratiolab<-gii$Labfem/gii$Labmale
summary(gii)


# now joining the sets so that we end up with one larger set. Keeping only the data that are in both tables

human<-inner_join(hd, gii, by="Country")
write.csv(human, file="DATA/human.csv")
