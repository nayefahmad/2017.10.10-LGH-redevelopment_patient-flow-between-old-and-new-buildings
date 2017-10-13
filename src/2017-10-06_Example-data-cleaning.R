

#**********************************
# Script to clean data for example dataset: 
#**********************************

library("dplyr")
library("lubridate")
library("tidyr")

# rm(list=ls())


#**********************************
# TODO: 
#**********************************


# import data cleaning functoin: ------
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

losdata.4e <- clean.los(losdata.4e)

# str(losdata.4e)
# summary(losdata.4e)
# head(losdata.4e)


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

losdata.6e <- clean.los(losdata.6e)

# str(losdata.6e)
# summary(losdata.6e)
# head(losdata.6e)

# save reformatted data: ----------------
write.csv(losdata.6e, file="\\\\vch.ca/departments/Projects (Dept VC)/Patient Flow Project/Coastal HSDA/2017 Requests/2017.10.10 LGH redevelopment - patient flow between old and new buildings/results/output from src/2017-10-10_LGH_6E-LOS-reformatted.csv", 
          row.names = FALSE)





#********************************
# Cleaning 6W data: -----------
#********************************

losdata.6w <- read.csv("\\\\vch.ca/departments/Projects (Dept VC)/Patient Flow Project/Coastal HSDA/2017 Requests/2017.10.10 LGH redevelopment - patient flow between old and new buildings/results/output from src/2017-10-10_LGH_6W-LOS.csv", 
                       na.strings = "NULL", 
                       stringsAsFactors = TRUE) 

names(losdata.6w) <- tolower(names(losdata.6w))

losdata.6w <- clean.los(losdata.6w)

# str(losdata.6w)
# summary(losdata.6w)
# head(losdata.6w)

# save reformatted data: ----------------
write.csv(losdata.6w, file="\\\\vch.ca/departments/Projects (Dept VC)/Patient Flow Project/Coastal HSDA/2017 Requests/2017.10.10 LGH redevelopment - patient flow between old and new buildings/results/output from src/2017-10-10_LGH_6W-LOS-reformatted.csv", 
          row.names = FALSE)




#********************************
# Cleaning 4W data: -----------
#********************************

# note: input csv may have to be processed manually first: empty rows 
#     after SSLTC rows. 

losdata.4w <- read.csv("\\\\vch.ca/departments/Projects (Dept VC)/Patient Flow Project/Coastal HSDA/2017 Requests/2017.10.10 LGH redevelopment - patient flow between old and new buildings/results/output from src/2017-10-10_LGH_4W-LOS.csv", 
                       na.strings = "NULL", 
                       stringsAsFactors = TRUE) 

names(losdata.4w) <- tolower(names(losdata.4w))

losdata.4w <- clean.los(losdata.4w)

# str(losdata.4w)
# summary(losdata.4w)
# head(losdata.4w)

# save reformatted data: ----------------
write.csv(losdata.4w, file="\\\\vch.ca/departments/Projects (Dept VC)/Patient Flow Project/Coastal HSDA/2017 Requests/2017.10.10 LGH redevelopment - patient flow between old and new buildings/results/output from src/2017-10-10_LGH_4W-LOS-reformatted.csv", 
          row.names = FALSE)
