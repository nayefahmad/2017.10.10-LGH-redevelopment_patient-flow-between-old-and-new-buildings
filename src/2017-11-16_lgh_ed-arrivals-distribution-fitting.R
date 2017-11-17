
#*********************************
# DISTRIBUTION FITTING FOR ED VISITS AND ADMITS 
#*********************************

library("lubridate")
library("tidyr")
library("ggplot2")
library("dgof")

# rm(list=ls())

#**********************************
# Example: using ks.test() function to test goodness-of-fit --------- 
#**********************************

# reference distribution: 
ref.poisson <- rpois(1000, 8)
str(ref.poisson); summary(ref.poisson)
ggplot(data.frame(pois.rv=ref.poisson), aes(x=pois.rv)) + 
      geom_histogram(binwidth = 1)



# df with poisson means calculated from data 
df <- data.frame(pois.mean=c(7.5, 8.1, 18.2))

# generate a separate distribution for each row of df: 
pois.distributions <- lapply(df$pois.mean, rpois, n=1000) # %>% str


# plot the distributions:  
setpar <- par(mfrow=c(length(pois.distributions), 1))
lapply(pois.distributions, hist)
par(setpar)



# > test goodness-of-fit with reference dist: ---------
# Kolmogorov-Smirnov test: 
# H0: distributions are the same
# reject H0 if p value is small 
dgof::ks.test(pois.distributions[[1]], ecdf(ref.poisson))  # reject h0
dgof::ks.test(pois.distributions[[2]], ecdf(ref.poisson))  # accept H0
dgof::ks.test(pois.distributions[[3]], ecdf(ref.poisson))  # reject H0

# get results of above 3 lines at once: 
lapply(pois.distributions, ks.test, y=ecdf(ref.poisson))


# > plot final 2 distributions: ----
setpar <- par(mfrow=c(1, 2))
hist(ref.poisson)
hist(pois.distributions[[2]])
par(setpar)
