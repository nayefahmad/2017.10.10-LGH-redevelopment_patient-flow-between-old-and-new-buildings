-- LGH ED admit rate
If Object_ID('tempdb.dbo.#EDVisits') is not null drop table #EDVisits
  Select a.StartDate, b.DayOfWeek, a.PatientID, Cast(a.AdmittedFlag AS int) as AdmittedPatient
  Into #EDVisits
  FROM [EDMart].[dbo].[vwEDVisitIdentifiedRegional] a
  left join [ADTCMart].[dim].[Date] b on a.StartDate = b.ShortDate
  Where a.FacilityLongName = 'Lions Gate Hospital'
  AND a.StartDate between '2017-04-01' and '2017-12-19'
--46083 rows
-- Select * from #EDVisits


Select StartDate, DayOfWeek, Count(PatientID) as NumEDVisits, Sum(AdmittedPatient) as NumEDAdmits, Sum(AdmittedPatient)*1.0/Count(PatientID) as AdmitRatio
From #EDVisits
Group By StartDate, DayOfWeek
Order By StartDate, DayOfWeek
-- 263 rows