------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
--ED visits by hour of day
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------


--set time range for desired data
If object_id('tempdb.dbo.#DataTimeRange') is not null Drop Table #DataTimeRange
Select 
	'2016-01-01' StartDate, 
	'2017-11-02' EndDate
into #DataTimeRange

--Select * from #DataTimeRange

--Build a table with all dates and times
If object_id('tempdb.dbo.#AllDates') is not null Drop Table #AllDates 
Select ShortDate, TempCol=1 
Into #AllDates 
From [ADTCMart].[dim].[Date] 
Where ShortDate between (select StartDate from #DataTimeRange) and (select EndDate from #DataTimeRange)
If object_id('tempdb.dbo.#AllDatesAndTimes') is not null Drop Table #AllDatesAndTimes 
Select a.ShortDate, b.Interval_1_Hour 
Into #AllDatesAndTimes
From #AllDates a
Left join (Select Distinct Interval_1_Hour, TempCol=1 From [ADTCMart].[dim].[Time] Where Interval_1_Hour Is not Null) b 
On a.TempCol=b.TempCol
Order by a.ShortDate, b.Interval_1_Hour
-- Select * From #AllDatesAndTimes


--Identify all ED visits 
If object_id('tempdb.dbo.#EDVisits') is not null Drop Table #EDVisits
select 
a.PatientID, a.StartDate, a.StartTime, b.Interval_1_Hour
into #EDVisits
from EDMart.[dbo].[vwEDVisitIdentifiedRegional] a
left join (Select Time24Hr, Interval_1_Hour From [ADTCMart].[dim].[Time] Where Time24Hr is not null) b on a.StartTime = b.Time24Hr
where a.StartDate between (select StartDate from #DataTimeRange) and (select EndDate from #DataTimeRange)
and a.FacilityLongName = 'Lions Gate Hospital'

--Select * from #EDVisits

--Adding ED visits to the date and time table
If object_id('tempdb.dbo.#EDVisitsByHourOfDay') is not null Drop Table #EDVisitsByHourOfDay
Select a.ShortDate, a.Interval_1_Hour, COUNT(b.PatientID) as NumberOfPatients
Into #EDVisitsByHourOfDay
From #AllDatesAndTimes a
Left join #EDVisits b on (a.ShortDate=b.StartDate and a.Interval_1_Hour=b.Interval_1_Hour)
Group by a.ShortDate, a.Interval_1_Hour
Order by a.ShortDate, a.Interval_1_Hour

Select * from #EDVisitsByHourOfDay

Select Interval_1_Hour, AVG(NumberOfPatients*1.0) as AverageEDVisitByHourOfDay
From #EDVisitsByHourOfDay
Group by Interval_1_Hour
Order by Interval_1_Hour

------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
--Direct inflow by hour of day for 4E, 6E, 6W, 7E, and IPS
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------


--set time range for desired data
If object_id('tempdb.dbo.#DataTimeRange') is not null Drop Table #DataTimeRange
Select 
	'2016-01-01' StartDate, 
	'2017-11-02' EndDate
into #DataTimeRange

--Select * from #DataTimeRange

--Build a table with all dates and times
If object_id('tempdb.dbo.#AllDates') is not null Drop Table #AllDates 
Select ShortDate, TempCol=1 
Into #AllDates 
From [ADTCMart].[dim].[Date] 
Where ShortDate between (select StartDate from #DataTimeRange) and (select EndDate from #DataTimeRange)

If object_id('tempdb.dbo.#AllDatesAndTimes') is not null Drop Table #AllDatesAndTimes 
Select a.ShortDate, b.Interval_1_Hour, a.TempCol 
Into #AllDatesAndTimes
From #AllDates a
Left join (Select Distinct Interval_1_Hour, TempCol=1 From [ADTCMart].[dim].[Time] Where Interval_1_Hour Is not Null) b 
On a.TempCol=b.TempCol

If object_id('tempdb.dbo.#AllDatesAndTimesWithNU') is not null Drop Table #AllDatesAndTimesWithNU
Select a.ShortDate, a.Interval_1_Hour, b.AdmissionNursingUnitCode 
Into #AllDatesAndTimesWithNU
From #AllDatesAndTimes a
Left join (Select Distinct AdmissionNursingUnitCode, TempCol=1 From [ADTCMart].[ADTC].[vwAdmissionDischargeFact] Where AdmissionNursingUnitCode in ('4E', '6E', '6W', '7E', 'IPS')) b 
On a.TempCol=b.TempCol

-- Select * From #AllDatesAndTimesWithNU Order by AdmissionNursingUnitCode, ShortDate, Interval_1_Hour


--Identify all ADTC visits for 4E, 6E, 6W, 7E, and IPS
If object_id('tempdb.dbo.#DirectAdmits') is not null Drop Table #DirectAdmits
select 
a.PatientID, a.AdjustedAdmissionDate, a.AdjustedAdmissionTime, b.Interval_1_Hour, a.AdmissionNursingUnitCode
into #DirectAdmits
from [ADTCMart].[ADTC].[vwAdmissionDischargeFact] a
left join (Select Time24Hr, Interval_1_Hour From [ADTCMart].[dim].[Time] Where Time24Hr is not null) b on a.AdjustedAdmissionTime = b.Time24Hr
where a.AdjustedAdmissionDate between (select StartDate from #DataTimeRange) and (select EndDate from #DataTimeRange)
and a.AdmissionFacilityLongName = 'Lions Gate Hospital'
and AdmissionNursingUnitCode in ('4E', '6E', '6W', '7E', 'IPS')

--Select * from #DirectAdmits


--Adding ADTC visits to the date and time table
If object_id('tempdb.dbo.#ADTCVisitsByHourOfDay') is not null Drop Table #ADTCVisitsByHourOfDay
Select a.ShortDate, a.Interval_1_Hour, COUNT(b.PatientID) as NumberOfPatients, a.AdmissionNursingUnitCode
Into #ADTCVisitsByHourOfDay
From #AllDatesAndTimesWithNU a
Left join #DirectAdmits b on (a.ShortDate=b.AdjustedAdmissionDate and a.Interval_1_Hour=b.Interval_1_Hour and a.AdmissionNursingUnitCode=b.AdmissionNursingUnitCode)
Group by a.ShortDate, a.Interval_1_Hour, a.AdmissionNursingUnitCode


Select * from #ADTCVisitsByHourOfDay Order by AdmissionNursingUnitCode, Interval_1_Hour, ShortDate

Select AdmissionNursingUnitCode, Interval_1_Hour, AVG(NumberOfPatients*1.0) as AverageEDVisitByHourOfDay
From #ADTCVisitsByHourOfDay
Group by AdmissionNursingUnitCode, Interval_1_Hour
Order by AdmissionNursingUnitCode, Interval_1_Hour


