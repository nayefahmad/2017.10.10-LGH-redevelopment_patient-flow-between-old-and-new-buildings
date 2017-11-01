

----------------------------------
-- avg starttodisposition for admitted pts at LGH 
----------------------------------

declare @start date
	, @end date; 

set @start='2017-03-01' 
set @end='2017-10-31' 


-- find all pts who were admitted in 10 hours: 
SELECT	FacilityShortName,
		StartDateFiscalYear,
		StartDateFiscalPeriodLong,
		Startdate,
		CASE WHEN a.FacilityShortName in ('UBCH', 'VGH') THEN 'VGH/UBC'
			 WHEN a.FacilityShortName in ('RHS') THEN 'RHS'
			 WHEN a.FacilityShortName in ('SPH','MSJ') THEN 'PHC'
			 WHEN a.FacilityShortName in ('LGH') THEN 'LGH'
			 ELSE 'other'
		END as [Site],
		count(*) as ED_IPAdmitsWithinTarget
FROM    EDMART.[dbo].[vwEDVisitRegional] a
		LEFT OUTER JOIN EDMart.dbo.vwDTUDischargedHome DTU 
			on a.ETLAuditID = DTU.ED_ETLAuditID
WHERE	FacilityShortName = 'LGH'
		AND StartDate >= @start
		and StartDate <= @end

		AND a.AdmittedFlag='True'
		AND a.AccountTypeDescription = 'Inpatient'
		And [StarttoDispositionExclCDUtoBedRequest] <=600
GROUP BY FacilityShortName
		,StartDateFiscalYear
		, StartDateFiscalPeriodLong
		,StartDate
ORDER BY StartDateFiscalYear
		,StartDateFiscalPeriodLong
		,startdate; 