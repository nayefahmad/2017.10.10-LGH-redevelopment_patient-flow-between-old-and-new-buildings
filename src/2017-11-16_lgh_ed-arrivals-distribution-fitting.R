
#*********************************
# DISTRIBUTION FITTING FOR ED VISITS AND ADMITS 
#*********************************

library("lubridate")
library("tidyr")
library("ggplot2")
library("dgof")
library("xlsx")
library("readxl")



# rm(list=ls())

#**********************************
# Example: using ks.test() function to test goodness-of-fit --------- 
#**********************************

CSVDataLoc <- "G:/Projects (Dept VC)/Patient Flow Project/Coastal HSDA/2017 Requests/2017.10.10 LGH redevelopment - patient flow between old and new buildings/src/ED.csv"

# reference distribution: 
#ref.poisson <- rpois(1000, 8)
#ref.poisson <- read.table(file = "clipboard",  sep = "\t", header=TRUE)
ref.poisson <- read.table(file = CSVDataLoc, sep=",", header=TRUE)


str(ref.poisson); summary(ref.poisson)
ggplot(data.frame(pois.rv=ref.poisson), aes(x=pois.rv)) + 
      geom_histogram(binwidth = 1)


ED_Average <- read.csv ("G:/Projects (Dept VC)/Patient Flow Project/Coastal HSDA/2017 Requests/2017.10.10 LGH redevelopment - patient flow between old and new buildings/src/ED_Average.csv", header = FALSE, sep = ",")
#df <- data.frame(pois.mean <-read.table(file = CSVAVg))


pois.mean = rep(0,24)
for (tempCounter in 1:24){ pois.mean[tempCounter] <- ED_Average[tempCounter,1]}
df <- data.frame(pois.mean)

# df with poisson means calculated from data 
#df <- data.frame(pois.mean=c(3.96, 3.27, 2.78, 2.61, 2.36, 2.43, 3.03, 5.26, 7.78, 10.29, 11.03, 11.35, 10.48))


# generate a separate distribution for each row of df: 
pois.distributions <- lapply(df$pois.mean, rpois, n=1000) # %>% str

# plot the distributions:  
#setpar <- par(mfrow=c(length(pois.distributions), 1))
setpar <- par(mfrow=c(4,6))
lapply(pois.distributions, hist)
par(setpar)




# > test goodness-of-fit with reference dist: ---------
# Kolmogorov-Smirnov test: 
# H0: distributions are the same
# reject H0 if p value is small 
dgof::ks.test(pois.distributions[[1]], ecdf(ref.poisson[ , 1]))  # accept H0
dgof::ks.test(pois.distributions[[2]], ecdf(ref.poisson[ , 2]))  # accept H0
dgof::ks.test(pois.distributions[[3]], ecdf(ref.poisson[ , 3]))  # accept H0
dgof::ks.test(pois.distributions[[4]], ecdf(ref.poisson[ , 4]))  # accept H0
dgof::ks.test(pois.distributions[[5]], ecdf(ref.poisson[ , 5]))  # accept H0
dgof::ks.test(pois.distributions[[6]], ecdf(ref.poisson[ , 6]))  # accept H0
dgof::ks.test(pois.distributions[[7]], ecdf(ref.poisson[ , 7]))  # accept H0
dgof::ks.test(pois.distributions[[8]], ecdf(ref.poisson[ , 8]))  # reject H0, p-value=0.04085
dgof::ks.test(pois.distributions[[9]], ecdf(ref.poisson[ , 9]))  # accept H0
dgof::ks.test(pois.distributions[[10]], ecdf(ref.poisson[ , 10]))  # accept H0 
dgof::ks.test(pois.distributions[[11]], ecdf(ref.poisson[ , 11]))  # reject H0, p-value = 0.000313
dgof::ks.test(pois.distributions[[12]], ecdf(ref.poisson[ , 12]))  # accept H0
dgof::ks.test(pois.distributions[[13]], ecdf(ref.poisson[ , 13]))  # accept H0
dgof::ks.test(pois.distributions[[14]], ecdf(ref.poisson[ , 14]))  # accept H0
dgof::ks.test(pois.distributions[[15]], ecdf(ref.poisson[ , 15]))  # accept H0
dgof::ks.test(pois.distributions[[16]], ecdf(ref.poisson[ , 16]))  # accept H0
dgof::ks.test(pois.distributions[[17]], ecdf(ref.poisson[ , 17]))  # accept H0
dgof::ks.test(pois.distributions[[18]], ecdf(ref.poisson[ , 18]))  # accept H0
dgof::ks.test(pois.distributions[[19]], ecdf(ref.poisson[ , 19]))  # accept H0
dgof::ks.test(pois.distributions[[20]], ecdf(ref.poisson[ , 20]))  # accept H0
dgof::ks.test(pois.distributions[[21]], ecdf(ref.poisson[ , 21]))  # accept H0
dgof::ks.test(pois.distributions[[22]], ecdf(ref.poisson[ , 22]))  # accept H0 
dgof::ks.test(pois.distributions[[23]], ecdf(ref.poisson[ , 23]))  # accept H0
dgof::ks.test(pois.distributions[[24]], ecdf(ref.poisson[ , 24]))  # accept H0

# get results of above 3 lines at once: 
#lapply(pois.distributions, ks.test, y=ecdf(ref.poisson))


# > plot final 2 distributions: ----
setpar <- par(mfrow=c(1, 2))
hist(ref.poisson[ , 8])
hist(pois.distributions[[8]])
par(setpar)
