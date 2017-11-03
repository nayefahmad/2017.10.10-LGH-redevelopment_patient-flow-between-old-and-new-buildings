--Pulls all the transfers from EIP to 4E, 6E, 6W, 7E, including bed request date/time and transfer date/time
IF OBJECT_ID('tempdb.dbo.#temp') IS NOT NULL DROP TABLE #temp
Select a.PatientID, a.ContinuumId, b.continuumID as ContinuumID2, a.FromNursingUnitCode, a.ToNursingUnitCode,  b.StartDate, b.StartTime, 
b.BedRequestDate, b.BedRequestTime, b.DispositionDate, b.DispositionTime, a.TransferDate, a.TransferTime
into #temp
FROM [ADTCMart].[ADTC].[vwTransferFact] a
Left join 
(Select PatientID, ContinuumID, StartDate, StartTime, BedRequestDate, BedRequestTime, DispositionDate, DispositionTime
FROM [EDMart].[dbo].[vwEDVisitIdentifiedRegional]
Where FacilityLongName  = 'Lions Gate Hospital')
b on a.ContinuumId = b.continuumID
Where a.FromFacilityLongName = 'Lions Gate Hospital'
AND a.ToFacilityLongName = 'Lions Gate Hospital'
AND a.FromNursingUnitCode in ('EIP')
AND a.ToNursingUnitCode in ('4E', '6E', '6W', '7E')
AND a.TransferDate between '2017-03-01' and '2017-11-01'
--3119

--Calculated the time difference in minutes from bed request to transfer, assuming that transfer always happen after bed request
Select * , 
Case when TransferTime >= BedRequestTime then (DATEDIFF(Day,BedRequestDate,TransferDate)*24*60) + DATEDIFF(minute,BedRequestTime,TransferTime) 
else ((DATEDIFF(Day,BedRequestDate,TransferDate)-1)*24*60) + DATEDIFF(minute, BedRequestTime, '23:59') + 1 + DATEDIFF(minute, '00:00', TransferTime)
end as BedRequestToTransferMinutes
From #temp
Where ContinuumID2 is not null
--3116

