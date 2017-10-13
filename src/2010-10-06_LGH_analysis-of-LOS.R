

#****************************************
# Analysis of LOS data for 4E, 6E, 6W
#****************************************

library("ggplot2")
library("dplyr")

# rm(list=ls())


# Todo: -------------------
# > why 58 NAs for 4E data? 
# > use aggregate/summarize to get mean, median, 90th percentile 
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
los.4e <- 
      lapply(split.losdata.4e, los.fn, 
                 nursingunit = "4E")  %>%  # nursingunit is passed to los.fn
      unlist %>% unname 
str(los.4e)
summary(los.4e)


los.4e.df <- as.data.frame(los.4e)  # easier to work with in ggplot 
str(los.4e.df)

# tables of results: 
summary.4e <- 
      summarise(los.4e.df,
          unit="4E", 
          mean=mean(los.4e, na.rm=TRUE), 
          median=quantile(los.4e, probs = .50, na.rm=TRUE), 
          x90th.perc=quantile(los.4e, probs = .90, na.rm=TRUE))

table.4e <- table(los.4e) %>% as.data.frame


# ******************************
# Analysis for 6E ---------------
# ******************************

# split data by unique encounter: 
split.losdata.6e <- split(losdata.6e, losdata.6e$id)
# str(split.losdata)

# apply los.fn, then combine results into a vector: 
los.6e <- 
      lapply(split.losdata.6e, los.fn, 
             nursingunit = "6E")  %>% 
      unlist %>% unname 
str(los.6e)
summary(los.6e)


los.6e.df <- as.data.frame(los.6e)  # easier to work with in ggplot 
str(los.6e.df)

# tables of results: 
summary.6e <- 
      summarise(los.6e.df,
                unit="6E", 
                mean=mean(los.6e, na.rm=TRUE), 
                median=quantile(los.6e, probs = .50, na.rm=TRUE), 
                x90th.perc=quantile(los.6e, probs = .90, na.rm=TRUE))

table.6e <- table(los.6e) %>% as.data.frame
# note: id=6660898079-17064865 has LOS = -1 because discharge date = 2017-05-29
#     and transfer date = 2017-05-30. Not sure why that would happen. 



# ******************************
# Analysis for 6W ---------------
# ******************************

# split data by unique encounter: 
split.losdata.6w <- split(losdata.6w, losdata.6w$id)
# str(split.losdata.6w)

# apply los.fn, then combine results into a vector: 
los.6w <- 
      lapply(split.losdata.6w, los.fn, 
             nursingunit = "6W")  %>% 
      unlist %>% unname 
str(los.6w)
summary(los.6w)


los.6w.df <- as.data.frame(los.6w)  # easier to work with in ggplot 
str(los.6w.df)

# tables of results: 
summary.6w <- 
      summarise(los.6w.df,
                unit="6W", 
                mean=mean(los.6w, na.rm=TRUE), 
                median=quantile(los.6w, probs = .50, na.rm=TRUE), 
                x90th.perc=quantile(los.6w, probs = .90, na.rm=TRUE))

table.6w <- table(los.6w) %>% as.data.frame



# ******************************
# Plotting with ggplot: ------------
# ******************************

# > Graph for 4E --------
p1_hist.4e <- 
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
      
      geom_vline(xintercept = avg.los.4e, 
                 col="red") + 
      
      geom_vline(xintercept = median.los.4e, 
                 col="red", 
                 linetype=2) + 
      
      theme_classic(base_size = 16); p1_hist.4e


# > Graph for 6E --------
p2_hist.6e <- 
      ggplot(los.6e.df, 
             aes(x=los.6e)) + 
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
           title="Distribution of LOS in LGH 6E", 
           subtitle="From 2014-04-01 onwards \nMedian = 3 days; Mean = 6.7 days; ", 
           caption= "\nData source: DSDW ADTCMart; extraction date: 2017-10-10 ") + 
      
      geom_vline(xintercept = avg.los.6e, 
                 col="red") + 
      
      geom_vline(xintercept = median.los.6e, 
                 col="red", 
                 linetype=2) + 
      
      theme_classic(base_size = 16); p2_hist.6e


# > Plotting 6W: --------------
p3_hist.6w <- 
      ggplot(los.6w.df, 
             aes(x=los.6w)) + 
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
           title="Distribution of LOS in LGH 6W", 
           subtitle="From 2014-04-01 onwards \nMedian = 3 days; Mean = 8.6 days; ", 
           caption= "\nData source: DSDW ADTCMart; extraction date: 2017-10-11 ") + 
      
      geom_vline(xintercept = avg.los.6w, 
                 col="red") + 
      
      geom_vline(xintercept = median.los.6w, 
                 col="red", 
                 linetype=2) + 
      
      theme_classic(base_size = 16); p3_hist.6w



# *******************************************


# Save outputs: ---------------

pdf(file="\\\\vch.ca/departments/Projects (Dept VC)/Patient Flow Project/Coastal HSDA/2017 Requests/2017.10.10 LGH redevelopment - patient flow between old and new buildings/results/output from src/los-histogram-2015-2017_2.pdf", 
      height= 8.5, width = 14) 
p1_hist.4e
p2_hist.6e
p3_hist.6w
dev.off()

# single summary table: 
write.csv(rbind(summary.4e, 
                summary.6e, 
                summary.6w),
          file="\\\\vch.ca/departments/Projects (Dept VC)/Patient Flow Project/Coastal HSDA/2017 Requests/2017.10.10 LGH redevelopment - patient flow between old and new buildings/results/output from src/2017-10-11_LGH_summary-of-LOS.csv", 
          row.names = FALSE)


# histogram data, 4E: 
write.csv(table.4e, file="\\\\vch.ca/departments/Projects (Dept VC)/Patient Flow Project/Coastal HSDA/2017 Requests/2017.10.10 LGH redevelopment - patient flow between old and new buildings/results/output from src/2017-10-11_LGH_histogram-table_4E.csv", 
          row.names = FALSE)

# histogram data, 6E: 
write.csv(table.6e, file="\\\\vch.ca/departments/Projects (Dept VC)/Patient Flow Project/Coastal HSDA/2017 Requests/2017.10.10 LGH redevelopment - patient flow between old and new buildings/results/output from src/2017-10-11_LGH_histogram-table_6E.csv", 
          row.names = FALSE)

# histogram data, 6W: 
write.csv(table.6w, file="\\\\vch.ca/departments/Projects (Dept VC)/Patient Flow Project/Coastal HSDA/2017 Requests/2017.10.10 LGH redevelopment - patient flow between old and new buildings/results/output from src/2017-10-11_LGH_histogram-table_6W.csv", 
          row.names = FALSE)
