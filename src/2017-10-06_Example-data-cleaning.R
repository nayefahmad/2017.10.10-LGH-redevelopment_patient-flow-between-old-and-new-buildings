

#**********************************
# Script to clean data for example dataset: 
#**********************************

library("dplyr")
library("lubridate")
library("tidyr")

# rm(list=ls())

# data cleaning script: 
source('data-cleaning_function.R')




#********************************
# Cleaning 4E data: -----------
#********************************

# losdata <- read.csv("\\\\vch.ca/departments/Projects (Dept VC)/Patient Flow Project/Coastal HSDA/2017 Requests/2017.10.04 LGH redevelopment - patient flow between old and new buildings/results/output from src/2017-10-10_LGH_4E-LOS_example-dataset.csv", 
#          na.strings = "NULL", 
#          stringsAsFactors = TRUE) 



losdata.4e <- read.csv("\\\\vch.ca/departments/Projects (Dept VC)/Patient Flow Project/Coastal HSDA/2017 Requests/2017.10.10 LGH redevelopment - patient flow between old and new buildings/results/output from src/2017-10-10_LGH_4E-LOS.csv", 
                    na.strings = "NULL", 
                    stringsAsFactors = TRUE) 

names(losdata.4e) <- tolower(names(losdata.4e))

losdata.4e.new <- 
      mutate(losdata.4e, 
             admissionnursingunitcode = as.factor(admissionnursingunitcode), 
             adjustedadmissiondate = mdy(adjustedadmissiondate), 
             adjusteddischargedate = mdy(adjusteddischargedate), 
             transferdate = mdy(transferdate)) %>% 
      rename(ad.unitcode = admissionnursingunitcode,
             from.unit = fromnursingunitcode, 
             to.unit = tonursingunitcode, 
             ad.date = adjustedadmissiondate, 
             dis.date = adjusteddischargedate, 
             t.date = transferdate) %>% 
      unite(col = id, 
            c(a.continuumid, accountnumber), 
            sep = "-") %>% 
      mutate(id = as.factor(id))

losdata.4e.test <- clean.los(losdata.4e)

identical(losdata.4e.new, losdata.4e.test)

str(losdata.4e.new)
# summary(losdata.4e)
# head(losdata.4e)

str(losdata.4e.test)

# save reformatted data: ----------------
write.csv(losdata.4e, file="\\\\vch.ca/departments/Projects (Dept VC)/Patient Flow Project/Coastal HSDA/2017 Requests/2017.10.04 LGH redevelopment - patient flow between old and new buildings/results/output from src/2017-10-10_LGH_4E-LOS-reformatted.csv", 
          row.names = FALSE)




#********************************
# Cleaning 6E data: -----------
#********************************

losdata.6e <- read.csv("\\\\vch.ca/departments/Projects (Dept VC)/Patient Flow Project/Coastal HSDA/2017 Requests/2017.10.10 LGH redevelopment - patient flow between old and new buildings/results/output from src/2017-10-10_LGH_6E-LOS.csv", 
                       na.strings = "NULL", 
                       stringsAsFactors = TRUE) 

names(losdata.6e) <- tolower(names(losdata.6e))

losdata.6e.new <- 
      mutate(losdata.6e, 
             admissionnursingunitcode = as.factor(admissionnursingunitcode), 
             adjustedadmissiondate = mdy(adjustedadmissiondate), 
             adjusteddischargedate = mdy(adjusteddischargedate), 
             transferdate = mdy(transferdate)) %>% 
      rename(ad.unitcode = admissionnursingunitcode,
             from.unit = fromnursingunitcode, 
             to.unit = tonursingunitcode, 
             ad.date = adjustedadmissiondate, 
             dis.date = adjusteddischargedate, 
             t.date = transferdate) %>% 
      unite(col = id, 
            c(a.continuumid, accountnumber), 
            sep = "-") %>% 
      mutate(id = as.factor(id))

losdata.6e.test <- clean.los(losdata.6e)

identical(losdata.6e.new, losdata.6e.test)

# str(losdata.6e)
# summary(losdata.6e)
# head(losdata.6e)

# save reformatted data: ----------------
write.csv(losdata.6e, file="\\\\vch.ca/departments/Projects (Dept VC)/Patient Flow Project/Coastal HSDA/2017 Requests/2017.10.10 LGH redevelopment - patient flow between old and new buildings/results/output from src/2017-10-10_LGH_6E-LOS-reformatted.csv", 
          row.names = FALSE)

      