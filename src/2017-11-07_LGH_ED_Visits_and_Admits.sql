--set time range for desired data
Drop Table #DataTimeRange

Select 
	'2014-04-01' StartDate, 
	'2017-11-02' EndDate
into #DataTimeRange

Select * from #DataTimeRange


--identify all ED visits 
drop table #EDVisits

select 
VisitID
, StartDate, StartTime --StartDate + StartTime as StartDateTime
, ArrivalDate, ArrivalTime --ArrivalDate + ArrivalTime as ArrivalDateTime
, BedRequestDate, BedRequestTime --BedRequestDate + BedRequestTime as BedRequestDateTime
, DispositionDate, DispositionTime --DispositionDate + DispositionTime as DispositionDateTime 
, InpatientDate, InpatientTime --InpatientDate + InpatientTime as InpatientDateTime
, AdmittedFlag
, DischargeDispositionCode
, InpatientNursingUnitID
, InpatientNursingUnitName
, TriageAcuityCode
into #EDVisits
from EDMart.[dbo].[vwEDVisitIdentifiedLGH] 
where StartDate between (select StartDate from #DataTimeRange) and (select EndDate from #DataTimeRange)
and FacilityLongName = 'Lions Gate Hospital'
Order by VisitID

Select * from #EDVisits

--adding in interarrival time for ED visits
drop table #EDVisitsWithElapsedMinutes

select 
E.*
, DayofWeek StartDateDayOfWeek
, Interval_1_Hour StartTimeHourInterval
, datediff(minute, lag(StartDate+StartTime) over (order by StartDate+StartTime), StartDate+StartTime) MinuteElapsed
into #EDVisitsWithElapsedMinutes
from #EDVisits E
inner join EDMart.dim.Date D on E.StartDate = D.ShortDate 
inner join EDMart.dim.Time T on E.StartTime = T.Time24Hr

select * from #EDVisitsWithElapsedMinutes

--Average ED visits by day of week and hour of day

select StartTimeHourInterval 
, Monday = sum(case when StartDateDayOfWeek = 'Monday' then 1 else 0 end)*1.0/(select Count(DayOfWeek) from EDMart.Dim.Date where ShortDate between (select StartDate from #DataTimeRange) and (select EndDate from #DataTimeRange) and DayOfWeek = 'Monday')
, Tuesday = sum(case when StartDateDayOfWeek = 'Tuesday' then 1 else 0 end)*1.0/(select Count(DayOfWeek) from EDMart.Dim.Date where ShortDate between (select StartDate from #DataTimeRange) and (select EndDate from #DataTimeRange) and DayOfWeek = 'Tuesday')
, Wednesday = sum(case when StartDateDayOfWeek = 'Wednesday' then 1 else 0 end)*1.0/(select Count(DayOfWeek) from EDMart.Dim.Date where ShortDate between (select StartDate from #DataTimeRange) and (select EndDate from #DataTimeRange) and DayOfWeek = 'Wednesday')
, Thursday= sum(case when StartDateDayOfWeek = 'Thursday' then 1 else 0 end)*1.0/(select Count(DayOfWeek) from EDMart.Dim.Date where ShortDate between (select StartDate from #DataTimeRange) and (select EndDate from #DataTimeRange) and DayOfWeek = 'Thursday')
, Friday = sum(case when StartDateDayOfWeek = 'Friday' then 1 else 0 end)*1.0/(select Count(DayOfWeek) from EDMart.Dim.Date where ShortDate between (select StartDate from #DataTimeRange) and (select EndDate from #DataTimeRange) and DayOfWeek = 'Friday')
, Saturday= sum(case when StartDateDayOfWeek = 'Saturday' then 1 else 0 end)*1.0/(select Count(DayOfWeek) from EDMart.Dim.Date where ShortDate between (select StartDate from #DataTimeRange) and (select EndDate from #DataTimeRange) and DayOfWeek = 'Saturday')
, Sunday = sum(case when StartDateDayOfWeek = 'Sunday' then 1 else 0 end)*1.0/(select Count(DayOfWeek) from EDMart.Dim.Date where ShortDate between (select StartDate from #DataTimeRange) and (select EndDate from #DataTimeRange) and DayOfWeek = 'Sunday')
from #EDVisitsWithElapsedMinutes
group by StartTimeHourInterval
order by StartTimeHourInterval


--Admits from ED into 4E, 6E, 6W, 7E, IPS, 4W
Select E.* 
from #EDVisitsWithElapsedMinutes E
inner join EDMart.dim.Location L on E.InpatientNursingUnitID = L.LocationID
where AdmittedFlag = 1
and LocationCode in ('4E', '6E', '6W', '7E', 'IPS', '4W')
