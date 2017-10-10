

#**********************************
# Script to clean data for example dataset: 
#**********************************

library("dplyr")
library("lubridate")
library("tidyr")

# rm(list=ls())

# losdata <- read.csv("\\\\vch.ca/departments/Projects (Dept VC)/Patient Flow Project/Coastal HSDA/2017 Requests/2017.10.04 LGH redevelopment - patient flow between old and new buildings/results/output from src/2017-10-10_LGH_4E-LOS_example-dataset.csv", 
#          na.strings = "NULL", 
#          stringsAsFactors = TRUE) 

losdata <- read.csv("\\\\vch.ca/departments/Projects (Dept VC)/Patient Flow Project/Coastal HSDA/2017 Requests/2017.10.04 LGH redevelopment - patient flow between old and new buildings/results/output from src/2017-10-10_LGH_4E-LOS.csv", 
                    na.strings = "NULL", 
                    stringsAsFactors = TRUE) 

names(losdata) <- tolower(names(losdata))

losdata <- 
      mutate(losdata, 
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

# str(losdata)
# summary(losdata)
# head(losdata)

# save reformatted data: ----------------
write.csv(losdata, file="\\\\vch.ca/departments/Projects (Dept VC)/Patient Flow Project/Coastal HSDA/2017 Requests/2017.10.04 LGH redevelopment - patient flow between old and new buildings/results/output from src/2017-10-10_LGH_4E-LOS-reformatted.csv", 
          row.names = FALSE)

      