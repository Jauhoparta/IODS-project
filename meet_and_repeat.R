#Read the data into memory now.

BPRS<-read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep=" ", header=T)

rats<-read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header=T, sep="\t")

#Converting categorical variables into factors:
BPRS$treatment<-as.factor(BPRS$treatment)

BPRS$subject <- as.factor(BPRS$subject)
rats$ID<-as.factor(rats$ID)
rats$Group<-as.factor(rats$Group)

#Wrangling. initialize the required libraries
library(dplyr)
library(tidyr)



# Convert to long form both the datasets
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks,5,5)))


RATSL <- rats %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD,3,4))) 

# Now the data are in long form. this means that both for BPRSL (the long one) and RATSL, we have fewer variables than before.
# The variables are, for RATSL: ID, Groupl, Woéight and time while for BPRSL they are treatment, subject, bprsl and week. 
# The variable weeks is redundant since we already have the same info in week.

# The long version of the data allows us to do time dependent analysis on the datasets. The short form does not support our analysis.