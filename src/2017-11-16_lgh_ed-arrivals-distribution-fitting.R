
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
#ref.poisson <- rpois(1000, 8)
ref.poisson <- (0.078599222, 0.151750973, 0.212451362, 0.20077821, 0.158754864, 0.102723735, 0.052918288, 0.026459144, 0.010116732, 0.00155642, 0.003891051)

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
