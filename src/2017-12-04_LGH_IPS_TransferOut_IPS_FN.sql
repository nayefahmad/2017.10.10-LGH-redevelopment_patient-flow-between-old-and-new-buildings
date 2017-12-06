--Counts transfers from IPS to other units and discharges from IPS
If Object_ID('tempdb.dbo.#IPSOutflow') is not null drop table #IPSOutflow
SELECT PatientID, FromNursingUnitCode, ToNursingUnitCode
  INTO #IPSOutflow
  FROM [ADTCMart].[ADTC].[vwTransferFact]
  Where FromFacilityLongName = 'Lions Gate Hospital'
  AND FromNursingUnitCode = 'IPS'
  AND TransferDate between '2017-04-01' and '2017-12-04'
  -- 1300 rows
  Union all
  Select PatientID, DischargeNursingUnitCode, ToNursingUnit = 'Discharge'
  FROM [ADTCMart].[ADTC].[vwAdmissionDischargeFact]
  Where DischargeFacilityLongName = 'Lions Gate Hospital'
  AND DischargeNursingUnitCode = 'IPS'
  AND AdjustedDischargeDate between '2017-04-01' and '2017-12-04'
  --56 rows
 --1356 rows

 Select FromNursingUnitCode, ToNursingUnitCode, Count(PatientID) as CountOfOutflow
 From #IPSOutflow
 Group by FromNursingUnitCode, ToNursingUnitCode
 Order by Count(PatientID) Desc


