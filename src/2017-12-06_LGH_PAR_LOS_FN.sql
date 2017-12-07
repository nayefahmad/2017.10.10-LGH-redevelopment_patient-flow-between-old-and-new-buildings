--All patients transferred to PAR excluding PAR tp PAR transfers
If Object_ID('tempdb.dbo.#PARInflow') is not null drop table #PARInflow
SELECT PatientID, AccountNum, FromNursingUnitCode, ToNursingUnitCode, TransferDate, TransferTime
  INTO #PARInflow
  FROM [ADTCMart].[ADTC].[vwTransferFact]
  Where FromFacilityLongName = 'Lions Gate Hospital'
  AND ToNursingUnitCode = 'PAR'
  AND FromNursingUnitCode <> 'PAR'
  AND TransferDate between '2017-04-01' and '2017-12-04'
  -- 754 rows
--Direct admits to PAR are excluded
  --Union all
  --Select PatientID, AccountNumber, TransferFrom = 'Direct', AdmissionNursingUnitCode, AdjustedAdmissionDate, AdjustedAdmissionTime
  --FROM [ADTCMart].[ADTC].[vwAdmissionDischargeFact]
  --Where AdmissionFacilityLongName = 'Lions Gate Hospital'
  --AND AdmissionNursingUnitCode = 'PAR'
  --AND AdjustedAdmissionDate between '2017-04-01' and '2017-12-04'
  --133 rows
 --887 rows
 -- Select * from #PARInflow order by PatientID, AccountNum, TransferDate, TransferTime

--All patients discharged from PAR or transferred from PAR excluding PAR to PAR transfers
If Object_ID('tempdb.dbo.#PAROutflow') is not null drop table #PAROutflow
SELECT PatientID, AccountNum, FromNursingUnitCode, ToNursingUnitCode, TransferDate, TransferTime
  INTO #PAROutflow
  FROM [ADTCMart].[ADTC].[vwTransferFact]
  Where FromFacilityLongName = 'Lions Gate Hospital'
  AND FromNursingUnitCode = 'PAR'
  AND ToNursingUnitCode <> 'PAR'
  AND TransferDate between '2017-04-01' and '2017-12-04'
  -- 639 rows
  Union all
  Select PatientID, AccountNumber, DischargeNursingUnitCode, TransferTo = 'Discharge', AdjustedDischargeDate, AdjustedDischargeTime
  FROM [ADTCMart].[ADTC].[vwAdmissionDischargeFact]
  Where DischargeFacilityLongName = 'Lions Gate Hospital'
  AND DischargeNursingUnitCode = 'PAR'
  AND AdjustedDischargeDate between '2017-04-01' and '2017-12-04'
  --202 rows
 --841 rows
  -- Select * from #PAROutflow

  -- Inflow and outflow, may contain some duplicates
If Object_ID('tempdb.dbo.#PARInflowOutflow') is not null drop table #PARInflowOutflow
  Select distinct a.PatientID, a.AccountNum, a.FromNursingUnitCode as InflowFrom, a.ToNursingUnitCode as InflowTo, a.TransferDate as InflowDate, a.TransferTime as InflowTime, 
  CAST(CAST(a.TransferDate AS DATE) AS DATETIME) + CAST(CAST(a.TransferTime AS TIME) AS DATETIME) as InflowDateTime,
  b.FromNursingUnitCode as OutflowFrom, b.ToNursingUnitCode as OutflowTo, b.TransferDate as OutflowDate, b.TransferTime as OutflowTime, 
  CAST(CAST(b.TransferDate AS DATE) AS DATETIME) + CAST(CAST(b.TransferTime AS TIME) AS DATETIME) as OutflowDateTime
  Into #PARInflowOutflow
  From #PARInflow a
  Left join #PAROutflow b on (a.PatientID = b.PatientID and a.AccountNum = b.AccountNum)
  Where ((a.TransferDate = b.TransferDate AND a.TransferTime <= b.TransferTime) OR a.TransferDate < b.TransferDate)
  order by a.PatientID, a.AccountNum
--753 rows
-- Select * from #PARInflowOutflow


  Select distinct PatientID, AccountNum, InflowFrom, InflowTo, InflowDateTime, min(OutflowDateTime) as OutflowDateTime, DATEDIFF(minute, InflowDateTime,min(OutflowDateTime))*1.0/60 as PARLOSHour
  From #PARInflowOutflow
  Group by PatientID, AccountNum, InflowFrom, InflowTo, InflowDateTime
  Order by PatientID, AccountNum, InflowDateTime
  --744 rows