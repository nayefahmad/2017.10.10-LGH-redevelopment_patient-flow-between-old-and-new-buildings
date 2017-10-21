
#******************************************
# function to find arrival time of single patient
#******************************************

# TODO: -----------
# > delete redundant if else 
#*******************


# function definition: ----------------

arrival.fn <- function(df, nursingunit){
      # inputs:
            # dataframe with all rows of single patient-account combo 
            # nursingunitcode as character string 
      # output: arrival timestamp for the specified unit  
      
      require("dplyr")
      require("tidyr")
      require("lubridate")
      
      
      df <- arrange(df,
                    ad.date, t.date)
      # print(df)
      # df$ad.unitcode
      if (df$ad.unitcode[1] == nursingunit && is.na(df$t.date[1] == TRUE)) {
            # patient type: ad and dis from specified unit, no transfers 
            # print("branch1")
            return(df$ad.date)
            
      } else if (df$ad.unitcode[1] == nursingunit && df$to.unit != nursingunit){
            # patient type: admit to specified unit, transferred out of specified unit, 
            # no internal transfers in specified unit 
            # print("branch2")
            return(df$ad.date[1])  
            
      } else if (df$ad.unitcode[1] == nursingunit && df$to.unit == nursingunit){
            # patient type: admit to specified unit, internal transfer in specified unit
            index <- df$to.unit != nursingunit  
            # ^ logical vec to find first transfer out of 4E 
            # print("branch3")
            # print(c("index=", index))
            
            # check whether transfer or discharge is the endpoint of LOS: 
            if (any(index)==TRUE){
                  i <- match(TRUE, index)  # rownum of transfer out of nursingunit
                  return(df$ad.date[1])
            } else {
                  return(df$ad.date[1])
            }
            
      } else if (df$ad.unitcode[1] != nursingunit && df$to.unit == nursingunit) {
            # patient type: admit to other, transferred to specified unit 
            index <- df$to.unit != nursingunit  
            # print("branch4") 
            # print(c("index=", index))
            
            # check whether transfer or discharge is the endpoint of LOS: 
            # note that t.date[1] is the start point, not ad.date[1]
            if (any(index)==TRUE){
                  i <- match(TRUE, index)  # rownum of transfer out of nursingunit 
                  return(df$t.date[1])
            } else {
                  return(df$t.date[1])
            }
            
            
      } else {
            # patient type: other 
            # print("branch5")
            return(NA)
      }
}
