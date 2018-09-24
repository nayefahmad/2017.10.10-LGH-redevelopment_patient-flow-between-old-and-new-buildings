-- LGH ED start date and times, and bed request date and times
If Object_ID('tempdb.dbo.#EDStartBedRequest') is not null drop table #EDStartBedRequest
  Select PatientID 
  , CAST(CAST(StartDate AS DATE) AS DATETIME) + CAST(CAST(StartTime AS TIME) AS DATETIME) as EDStartDateTime
  , CAST(CAST(BedRequestDate AS DATE) AS DATETIME) + CAST(CAST(BedRequestTime AS TIME) AS DATETIME) as EDBedRequestDateTime
  Into #EDStartBedRequest
  FROM [EDMart].[dbo].[vwEDVisitIdentifiedRegional]
  Where FacilityLongName = 'Lions Gate Hospital'
  AND StartDate between '2017-04-01' and '2017-12-18'
  AND BedRequestDate is not Null
--6386 rows
-- Select * from #EDStartBedRequest


  Select PatientID, EDStartDateTime, EDBedRequestDateTime, DATEDIFF(Minute, EDStartDateTime, EDBedRequestDateTime)*1.0/60 as EDStartToBedRequestTimeHour
  From #EDStartBedRequest
  order by DATEDIFF(Minute, EDStartDateTime, EDBedRequestDateTime)*1.0/60
  --6386 rows