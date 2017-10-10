
----------------------------------------
-- 2017-10-04_LGH_LGH-redevelopment-LOS-data
----------------------------------------

----------------------------------------
--TODO: 
----------------------------------------

----------------------------------------


-- Pull all admits to specified Nursing Unit: ----------------------------------------
-- Set desired Nursing Unit: 
Declare @nursingunit as varchar(3) = '4E'; 


Select a.ContinuumID as [a.ContinuumID]
	, tr.ContinuumID as [tr.ContinuumID]
	, a.AccountNumber
	, tr.AccountNum
	, AdmissionNursingUnitCode
	, AdmissionFiscalYear
	, [AdjustedAdmissionDate]
	, [AdjustedAdmissionTime]
	, AdjustedDischargeDate
	, AdjustedDischargeTime
	, [TransferDate]
	, TransferTime
	, FromNursingUnitCode 
	, FromBed
	, [ToNursingUnitCode] 
	, ToBed
	, case when ToBed = FromBed then '1' 
		else 0 
		end as CheckTransferCols 
From [ADTCMart].[ADTC].[vwAdmissionDischargeFact] a 
	full outer join [ADTCMart].[ADTC].[vwTransferFact] tr
		on a.ContinuumId = tr.ContinuumId
			and a.AccountNumber = tr.AccountNum
Where (AdmissionFacilityLongName = 'Lions Gate Hospital' ) 
	and (AdmissionFiscalYear >= '2015' ) 
	--and AdjustedAdmissionDate > '2017-01-01'		-- just for testing 
	and (AdmissionNursingUnitCode in (@nursingunit)
		or tr.ToNursingUnitCode = @nursingunit)
	and tr.TransferDate >= '2014-04-01'  --(FY 14/15) 
order by AdmissionNursingUnitCode
	, [AdjustedAdmissionDate]
	, [AdjustedAdmissionTime]
	, tr.TransferDate
	, tr.TransferTime; 





