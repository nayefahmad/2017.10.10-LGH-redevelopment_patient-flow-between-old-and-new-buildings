--drop temp tables: 
if object_id('tempdb.dbo.#DataTimeRange') is not null Drop Table #DataTimeRange; 
if object_id('tempdb.dbo.#EDVisits') is not null Drop Table #EDVisits; 
if object_id('tempdb.dbo.#EDVisitsByHourOfDay') is not null Drop Table #EDVisitsByHourOfDay; 

--set time range for desired data
Select 
	'2016-01-01' StartDate, 
	'2017-11-02' EndDate
into #DataTimeRange

--Select * from #DataTimeRange

--identify all ED visits 
select 
PatientID
, StartDate, StartTime --StartDate + StartTime as StartDateTime
into #EDVisits
from EDMart.[dbo].[vwEDVisitIdentifiedRegional] 
where StartDate between (select StartDate from #DataTimeRange) and (select EndDate from #DataTimeRange)
and FacilityLongName = 'Lions Gate Hospital'
Order by StartDate, StartTime

--Select * from #EDVisits

--adding in interarrival time for ED visits
select 
E.*, D.DayofWeek As StartDateDayOfWeek, T.Interval_1_Hour As StartTimeHourInterval, D.ShortDate
into #EDVisitsByHourOfDay
from #EDVisits E
right join ADTCMart.dim.Date D on E.StartDate = D.ShortDate 
right join ADTCMart.dim.Time T on E.StartTime = T.Time24Hr

--select * from #EDVisitsByHourOfDay

Select StartDate, StartTimeHourInterval,  count(PatientID) as NumberOfPatients
From #EDVisitsByHourOfDay
Group by StartDate, StartTimeHourInterval 
Order by StartDate, StartTimeHourInterval 

---------------------------------------------------------------------
--drop temp tables: 
 



--set time range for desired data
If object_id('tempdb.dbo.#DataTimeRange') is not null Drop Table #DataTimeRange
Select 
	'2014-04-01' StartDate, 
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

--Select * from #EDVisitsByHourOfDay
