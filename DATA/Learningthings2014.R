#Tuomas Mäkelä 6.11. Learning data set of much WOW.
library(dplyr)
Opiskelu<-read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", header=T, sep="\t")

#Data on learning with 60 variables and 183 observations in each variable. 
#Data points integers 1 to 5 for  all except the four last variables.

#Now excluding all of the zero point test scores 
Opiskelu<-Opiskelu[Opiskelu$Points>0,]
 
#Defining sums of variables
 
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28") 

#Now making new interesting variables, with mean observations of some variables.
deep_columns <- select(Opiskelu, one_of(deep_questions))
Opiskelu$deep <- rowMeans(deep_columns)
surface_columns <- select(Opiskelu, one_of(surface_questions))
Opiskelu$surf <- rowMeans(surface_columns)
strategic_columns <- select(Opiskelu, one_of(strategic_questions))
Opiskelu$stra<-rowMeans(strategic_columns)             


keep_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")
Opiskelu<-select(Opiskelu, one_of(keep_columns))
Opiskelu$Attitude<-Opiskelu$Attitude/10
