

#****************************************
# Analysis of LOS data for 4E, 6E, 6W
#****************************************

library("ggplot2")
library("dplyr")

# rm(list=ls())


# todo: -------------------
# > why 58 NAs for 4E data? 
# > update mean, median, title, date on graph 
# > rearrange median and mean in subtitle 
# ******************************


# ****************************** 
# pull in clean data: 
source("2017-10-06_Example-data-cleaning.R")
# str(losdata)

# pull in function to calculate LOS: 
source("los_function.R")

# ******************************


# ******************************
# Analysis for 4E ---------------
# ******************************

# split data by unique encounter: 
split.losdata.4e <- split(losdata.4e, losdata.4e$id)
# str(split.losdata)

# apply los.fn, then combine results into a vector: 
# lapply(split.losdata, los.fn)  %>% unlist # %>% unname %>% str

los.4e <- lapply(split.losdata.4e, los.fn)  %>% unlist %>% unname 
str(los.4e)
summary(los.4e)

# what is the average LOS? -------------
avg.los.4e <- mean(los.4e, na.rm = TRUE) %>% print 
median.los.4e <- quantile(los.4e, probs = .50, na.rm=TRUE) %>% print
percentile.90.los.4e <- quantile(los.4e, probs = .90, na.rm=TRUE) %>% print

los.4e.df <- as.data.frame(los.4e)  # easier to work with in ggplot 
str(los.4e.df)



# ******************************
# Analysis for 6E ---------------
# ******************************

# split data by unique encounter: 
split.losdata.6e <- split(losdata.6e, losdata.6e$id)
# str(split.losdata)

# apply los.fn, then combine results into a vector: 
# lapply(split.losdata, los.fn)  %>% unlist # %>% unname %>% str

los.6e <- lapply(split.losdata.6e, los.fn)  %>% unlist %>% unname 
str(los.6e)
summary(los.6e)

# what is the average LOS? -------------
avg.los.6e <- mean(los.4e, na.rm = TRUE) %>% print 
median.los.6e <- quantile(los.4e, probs = .50, na.rm=TRUE) %>% print
percentile.90.los.6e <- quantile(los.4e, probs = .90, na.rm=TRUE) %>% print

los.4e.df <- as.data.frame(los.4e)  # easier to work with in ggplot 
str(los.4e.df)




# ******************************
# Plotting with ggplot: ------------
# ******************************

p1_hist <- 
      ggplot(los.4e.df, 
             aes(x=los.4e)) + 
      geom_histogram(stat="bin", 
                     binwidth = 1, 
                     col="black", 
                     fill="deepskyblue") + 
      
      scale_x_continuous(limits=c(-1,85), 
                         breaks=seq(0,85,5), 
                         expand=c(0,0)) + 
      scale_y_continuous(expand=c(0,0)) + 
      
      labs(x="LOS in days", 
           y="Number of cases", 
           title="Distribution of LOS in LGH 4E", 
           subtitle="From 2014-04-01 onwards \nMedian = 5 days; Mean = 11.1 days; ", 
           caption= "\nData source: DSDW ADTCMart; extraction date: 2017-10-10 ") + 
      
      geom_vline(xintercept = avg.los, 
                 col="red") + 
      
      geom_vline(xintercept = median.los, 
                 col="red", 
                 linetype=2) + 
      
      theme_classic(base_size = 16); p1_hist



# *******************************************
# Save outputs: ---------------

pdf(file="\\\\vch.ca/departments/Projects (Dept VC)/Patient Flow Project/Coastal HSDA/2017 Requests/2017.10.10 LGH redevelopment - patient flow between old and new buildings/results/output from src/los-histogram-2015-2017.pdf", 
      height= 8.5, width = 14) 
p1_hist
dev.off()


