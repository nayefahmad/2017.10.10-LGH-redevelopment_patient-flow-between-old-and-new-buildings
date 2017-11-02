Select PatientID, ContinuumID, FromNursingUnitCode, ToNursingUnitCode, TransferDate, TransferTime
FROM [ADTCMart].[ADTC].[vwTransferFact]
Where FromFacilityLongName = 'Lions Gate Hospital'
AND ToFacilityLongName = 'Lions Gate Hospital'
AND FromNursingUnitCode in ('EIP')
AND ToNursingUnitCode in ('4E', '6E', '6W', '7E')
AND TransferDate between '2017-03-01' and '2017-11-01'
--3119