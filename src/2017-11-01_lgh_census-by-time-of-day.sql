use ADTCMart 
set nocount on  --Stops the message that shows the count of the number of rows affected by a Transact-SQL statement

-------------------------------------
-- USER INPUTS: 
declare @site varchar(50)
set @site='lions gate hospital'

declare @startdate date,@enddate date
set @startdate='10/31/2017'
set @enddate='10/31/2017'

------------------------------------
-- drop tables: 
IF OBJECT_ID('tempdb..#HospitalistList') IS NOT NULL DROP TABLE #HospitalistList
IF OBJECT_ID('tempdb.dbo.#time') IS NOT NULL DROP TABLE #time; 
IF OBJECT_ID('tempdb.dbo.#date') IS NOT NULL DROP TABLE #date; 
IF OBJECT_ID('tempdb.dbo.#census') IS NOT NULL DROP TABLE #census; 
------------------------------------


/***** create table of hospitalists *****/
create table #HospitalistList (Hospitalist varchar(75))

if @site='lions gate hospital'
begin
insert into #HospitalistList (Hospitalist) values
	('BRACHE, MORGAN L.')
	,('BYMAN, ANDREA')
	,('CHAN, PHILIP')
	,('CHORNY, IRINA')
	,('EARLY, ANITA M.')
	,('Evans, David Joseph')
	,('KAZEMI, ALI-REZA')
	,('KROLL, EDWARD S.')
	,('LEA, JOHN')
	,('LONG, BRUCE FREDERICK')
	,('MCFEE, INGRID')
	,('MORGENSTERN, KATHERINE')
	,('O''NEIL, MICHAEL BRENDAN')
	,('PURVIS, ALISON')
	,('SAUNIER, JEREMY GABRIEL')
	,('STOKES, ERIKA')
	,('ZIBIN, KERRY')
end


/***** create time table *****/
SELECT distinct ROW_NUMBER() OVER(ORDER BY [Time24Hr]) AS Row
	,cast([Time24Hr] as time) as [Time24Hr]
into #time
FROM [ADTCMart].[dim].[Time]
where right([Time24Hr],2)='01'
 --select * from #time

/***** create date table *****/
SELECT distinct ROW_NUMBER() OVER(ORDER BY shortdate) AS Row
	,cast(shortdate as date) as shortdate
  into #date
FROM [ADTCMart].[dim].[Date]
where cast(shortdate as date) between @startdate and @enddate
order by shortdate
-- select * from #date

/***** create census table *****/
create table #census (censusdate date
	,censustime time
	,nursingunitcode varchar(25)
	,accountnum varchar(20)
	,[AttendDoctorService] varchar(75)
	,ALCFlag varchar(10)
	,[PatientServiceDescription] varchar(75)
	,[AdmitToCensusDays] int); 

/***** establish baseline census data *****/
declare @censusdate date
	,@censusdatecounter int
	,@censusdatecountermax int
set @censusdatecounter =1
set @censusdatecountermax = (select max(row) from #date)


-- start outer loop: loop through dates:  
while @censusdatecounter <=@censusdatecountermax 
BEGIN
set @censusdate =(select shortdate from #date where row=@censusdatecounter)

insert into #census			-- add midnight census data for day1 in period
select cast(@censusdate as date) as censusdate
	,cast(dateadd(mi,1,cast(@censusdate as datetime)) as time) as censustime
	,nursingunitcode
	,accountnum
	,case when [AttendDoctorName] in (select hospitalist from #hospitalistlist) then 'Hospitalist' 
		else [AttendDoctorService] 
		end as [AttendDoctorService]
	,case when Patientservicecode like 'AL[0-9]' or Patientservicecode like 'A[0-9]%' or Patientservicecode = 'ALC' then 'ALC' else 'Not ALC' end as ALCFlag
	,[PatientServiceDescription]
	,[AdmitToCensusDays]
from [ADTC].[CensusView]
where facilitylongname=@site
--and [AttendDoctorName] in (select hospitalist from #hospitalistlist)
	and	accounttype in ('i','inpatient')
	and AccountSubType  in ('Acute','Geriatric','*IP Hospice','*IP Medical','*IP Obstetrics','*IP Pediatrics','*IP Psychiatric','*IP Surgical')
	and [NursingUnitCode] not like 'M[0-9]%'
	and Patientservicecode <>'nb'
	and censusdate=dateadd(dd,-1,@censusdate)
--select * from #census order by censusdate,censustime

--/***** loop through the times *****/
declare @timecounter int,@timecountermax int
set @timecounter=2		-- hour 2 is 0100, 1hour after baseline of midnight 
set @timecountermax=24

-- inner loop: 
		while @timecounter <= @timecountermax 
		BEGIN

		--/***** add baseline census each hour ****/
		insert into #census
		select censusdate
			,(select [Time24Hr] from #time where row=@timecounter) as censustime  --"Row" is a field we created in #time and #date tables
			,nursingunitcode
			,accountnum
			,[AttendDoctorService] 
			,ALCFlag
			,[PatientServiceDescription]
			,[AdmitToCensusDays]
		from #census 
		where censusdate=@censusdate 
			and censustime=(select [Time24Hr] from #time where row=@timecounter-1)

		--/***** add admissions each hour *****/
		insert into #census
		select cast(adjustedadmissiondate as date) as censusdate
			,(select [Time24Hr] from #time where row=@timecounter) as censustime
			,admissionnursingunitcode as nursingunitcode,AccountNumber as accountnum
			,case when [AdmissionAttendingDoctorName] in (select hospitalist from #hospitalistlist) 
				then 'Hospitalist' 
				else [admissionAttendingDoctorService] end as [AttendDoctorService]
			,'Not ALC' as ALCFlag
			,[AdmissionPatientServiceDescription] as [PatientServiceDescription]
			,0 as [AdmitToCensusDays]
		from [ADTC].[AdmissionDischargeView]
		where admissionfacilitylongname=@site
			--and [AttendDoctorName] in (select hospitalist from #hospitalistlist)
			and cast(adjustedadmissiondate as date)=@censusdate 
			and accounttype in ('i','inpatient')
			and admissionAccountSubType  in ('Acute','Geriatric','*IP Hospice','*IP Medical','*IP Obstetrics','*IP Pediatrics','*IP Psychiatric','*IP Surgical')
			and [AdmissionNursingUnitCode] not like 'M[0-9]%'
			and admissionPatientservicecode<>'nb'
			and cast(adjustedadmissiontime as time) between 
				(select [Time24Hr] from #time where row=@timecounter-1) 
				and (select [Time24Hr] from #time where row=@timecounter)

		--/***** remove discharges each hour *****/
		delete #census
		where accountnum in (
			
			select AccountNumber
				--cast(adjusteddischargedate as date) as censusdate,(select [Time24Hr] from #time where row=@timecounter) as censustime
				--,dischargenursingunitcode as nursingunitcode,AccountNumber as accountnum
				--,case when [dischargeAttendingDrName] in (select hospitalist from #hospitalistlist) then 'Hospitalist' else [dischargeAttendingDrService] end as [AttendDoctorService]
				--,case when DischargePatientServiceCode like 'AL[0-9]' or DischargePatientServiceCode like 'A[0-9]%' then 'ALC' else 'Not ALC' end as ALCFlag
				--,[dischargePatientServiceDescription] as [PatientServiceDescription]
				--,0 as [AdmitToCensusDays]
			from [ADTC].[AdmissionDischargeView]
			where dischargefacilitylongname=@site
				--and [AttendDoctorName] in (select hospitalist from #hospitalistlist)
				and cast(adjusteddischargedate as date)=@censusdate 
				and accounttype in ('i','inpatient')
				and dischargeAccountSubType  in ('Acute','Geriatric','*IP Hospice','*IP Medical','*IP Obstetrics','*IP Pediatrics','*IP Psychiatric','*IP Surgical')
				and [dischargeNursingUnitCode] not like 'M[0-9]%'
				and dischargePatientservicecode<>'nb'
				and cast(adjusteddischargetime as time) between (select [Time24Hr] from #time where row=@timecounter-1) 
					and (select [Time24Hr] from #time where row=@timecounter)
				) 

		and censusdate=@censusdate and censustime = (select [Time24Hr] from #time where row=@timecounter)


		set @timecounter =@timecounter +1
		END  -- end inner loop

set @censusdatecounter= @censusdatecounter+1
END  -- end outer loop 


/*
if @site='lions gate hospital'
begin
select * into dssi.dbo.LGHCensusByTOD_FY2016
from #census
end

if @site='vancouver general hospital'
begin
select * into dssi.dbo.VGHCensusByTOD_FY2016
from #census
end
*/


/********  Ends here *******/

select censusdate
	,censustime
	,nursingunitcode
	,count(*) as census
from #census
--where [AttendDoctorService]='hospitalist'
group by censusdate
	,nursingunitcode
	,censustime
order by censusdate
	,nursingunitcode
	, censustime


drop table #hospitalistlist 
--drop table #time
--drop table #date
--drop table #census


/***** Return data *******/
select fiscalperiodlong,censustime,[AttendDoctorService],count(*)*1.0/daysinfiscalperiod as avgcensus
from #census
left outer join dim.[date] on cast(shortdate as date)=censusdate
--where [AttendDoctorService]='hospitalist'
group by fiscalperiodlong,censustime,[AttendDoctorService],daysinfiscalperiod
order by fiscalperiodlong,censustime


/*
select censusdate,censustime,[AttendDoctorService],count(*)*1.0 as census
,sum(case when alcflag<>'alc' then 1 else 0 end)*1.0 as acutecensus
,sum(case when alcflag='alc' then 1 else 0 end)*1.0 as alccensus
from #census
left outer join dim.[date] on cast(shortdate as date)=censusdate
--where [AttendDoctorService]='hospitalist'
--and censustime ='00:01:00.0000000'
group by censusdate,censustime,[AttendDoctorService],daysinfiscalperiod
order by censusdate,censustime
*/