-- Number of discharges versus transfer outs for 4E, 6E, 6W, and 7E 
-- Transfers between E, 6E/W, and 7E are not counted
IF OBJECT_ID('tempdb.dbo.#tempOutflow') IS NOT NULL drop table #tempOutflow	
SELECT PatientID, ContinuumID, DischargeNursingUnitCode, AdjustedDischargeDate, TransferToUnit = 'Discharge', DataType = 'Discharge'
INTO #tempOutflow	
FROM [ADTCMart].[ADTC].[vwAdmissionDischargeFact]
WHERE DischargeFacilityLongName = 'Lions Gate Hospital' 
AND DischargeNursingUnitCode in ('4E', '6E', '6w', '7E')
AND AdjustedDischargeDate between '2017-03-01' and '2017-10-31'
--4195 rows
Union ALL
SELECT PatientID, ContinuumID, FromNursingUnitCode, TransferDate, ToNursingUnitCode, Datatype = 'TransferOut'
FROM [ADTCMart].[ADTC].[vwTransferFact] 
WHERE FromFacilityLongName = 'Lions Gate Hospital'
AND FromNursingUnitCode in ('4E', '6E', '6w', '7E')
AND TransferDate between '2017-03-01' and '2017-10-31'
AND ToNursingUnitCode NOT IN ('4E', '6E', '6w', '7E')
--874 rows
--5069 rows for both discharges and transfers out

SELECT DischargeNursingUnitCode, DataType, Count(PatientID) as NumberOfCases
FROM #tempOutflow
GROUP BY DischargeNursingUnitCode, DataType
ORDER BY DischargeNursingUnitCode, DataType