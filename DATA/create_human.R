# Tuomas Mäkelä
# Working on the UN development programme dataset from
# http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt
# Doing some data wrangling for next week now:
#
library(dplyr)
library(stringr)
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

human_working<-read.csv("DATA/human.csv")

str(human_working)
dim(human_working)
colnames(human_working)
# The dataset consists of 20 variables again with the first variable only the row number. The variables are 
#[1] "X"         "HDI.Rank"  "Country"  
#[4] "HDI"       "Lifeexp"   "Eduexp"   
#[7] "Edumean"   "GNIperc"   "GminusHDI"
#[10] "GII.Rank"  "Gineq"     "MMRat"    
#[13] "Adbirth"   "Repparl"   "Edfemale" 
#[16] "Edmale"    "Labfem"    "Labmale"  
#[19] "Ratioed"   "Ratiolab"

# A brief description. HDI means the human development index, and HDI.rank is the ranking of the countries based on this.
# Eduexp and Edumean are expected and mean years of education
# GNIperc, GminusHDI and  refer to gross national product per capita and this minus the HDI.
# Gineq and GII.Rank are the gender inequality index and rank thereof,
# The MMRat is maternal mortality rate, Adbirth the adolescent birth rate and Repparl the percentage of women in parliament.
# Edfemale and Edmale respectively the % of 2nd degree education in female and male population.
# Labfem and Labmale again respectively the % of labour force
# The variables Ratioed and Ratiolab are constructed as ratios of females to males from the four previous variables.

str(human_working$GNIperc)

# It seems that the GNI is not quite clean, as some of the data is separated by a comma. Let's fix this

str_replace(human_working$GNIperc, pattern=",", replace ="")%>%as.numeric

# And select the variables needed:

keep_columns<-c("Country", "Edfemale","Eduexp", "Labfem", "Lifeexp", "GNIperc", "MMRat", "Adbirth", "Repparl")
human_working<-select(human_working, one_of(keep_columns))

# And throw out some missing data

human_working <- filter(human_working, complete.cases(human_working))

# The table contains at the end some information not related to countries:
tail(human_working, 10)

# Namely, the last 7 rows refer to regions not countries. Getting rid of them.
last<-nrow(human_working) - 7
human_working <- human_working[1:last, ]

# adding countries as rownames
rownames(human_working) <- human_working$Country
human_working<-select(human_working, -Country)

write.csv(human_working, "DATA/human.csv", row.names = TRUE)
