
#**********************
# Code FOR REGRESSIGN AdmitRatio ~ DayOfWeek
#**********************

# Input .csv files with ED admit ratio and day of the week data sample


#**********************
# With Friday as the intercept
#**********************

xFile <- "2017-12-20_LGH_ED_Admit_Ratio.csv"
xData <-read.csv(paste0("G:/Projects (Dept VC)/Patient Flow Project/Coastal HSDA/2017 Requests/2017.10.10 LGH redevelopment - patient flow between old and new buildings/results/output from src/",xFile))
summary(lm(AdmitRatio ~ DayOfWeek, data=xData))
lm(AdmitRatio ~ DayOfWeek, data=xData)

xFile <- "2017-12-21_LGH_ED_Admit_Ratio_WeekDays.csv"
xData <-read.csv(paste0("G:/Projects (Dept VC)/Patient Flow Project/Coastal HSDA/2017 Requests/2017.10.10 LGH redevelopment - patient flow between old and new buildings/results/output from src/",xFile))
summary(lm(AdmitRatio ~ DayOfWeek, data=xData))
lm(AdmitRatio ~ DayOfWeek, data=xData)


xFile <- "2017-12-21_LGH_ED_Admit_Ratio_Sat_Sun.csv"
xData <-read.csv(paste0("G:/Projects (Dept VC)/Patient Flow Project/Coastal HSDA/2017 Requests/2017.10.10 LGH redevelopment - patient flow between old and new buildings/results/output from src/",xFile))
summary(lm(AdmitRatio ~ DayOfWeek, data=xData))
lm(AdmitRatio ~ DayOfWeek, data=xData)

# Categories to consider based on the results of the regression:
# Monday, Tuesday, Wednesday, Thursday, Friday
# Saturday, Sunday

