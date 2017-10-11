

#******************************************
# Function for basic data wrangling on data output from sql
#******************************************

clean.los <- function(df){
      
      # function takes a df, does some cleaning, outputs a df
      require("dplyr")
      require("tidyr")
      
      mutate(df, 
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
      
}
