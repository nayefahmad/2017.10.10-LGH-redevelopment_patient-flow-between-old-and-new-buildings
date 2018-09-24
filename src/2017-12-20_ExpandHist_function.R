

#**************************
# FN TO EXPAND HISTOGRAM TO FULL DATA     
#**************************

# Expands a frequency table into a raw data format table
# For readibility, user-defined varaibles, parameters, functions, ... start with a x
xExpandHist <- function(xHistCSV,xResultCSV){
      # dataframe: xData
      # data.col: col number to expand; cannot be 1 
      # output: vector with expanded data 
      
      xData <- read.csv(paste0("G:/Projects (Dept VC)/Patient Flow Project/Coastal HSDA/2017 Requests/2017.10.10 LGH redevelopment - patient flow between old and new buildings/results/output from src/",xHistCSV))
      xResult <- mapply(rep, xData[,1], xData[,2]) %>% unlist
      write.csv(xResult, file = paste0("G:/Projects (Dept VC)/Patient Flow Project/Coastal HSDA/2017 Requests/2017.10.10 LGH redevelopment - patient flow between old and new buildings/results/output from src/",xResultCSV),row.names = FALSE)
}


xExpandHist("2017-10-11_LGH_histogram-table_4E.csv","2017-12-20_LGH_LOS_4E.csv")
xExpandHist("2017-10-11_LGH_histogram-table_6E.csv","2017-12-20_LGH_LOS_6E.csv")
xExpandHist("2017-10-11_LGH_histogram-table_6W.csv","2017-12-20_LGH_LOS_6W.csv")
xExpandHist("2017-11-17_LGH_histogram-table_7E.csv","2017-12-20_LGH_LOS_7E.csv")

