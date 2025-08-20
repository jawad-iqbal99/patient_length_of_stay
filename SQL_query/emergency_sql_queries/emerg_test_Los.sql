SELECT DISTINCT TOP 500
    
-- Weekend Flag
CASE 
    WHEN DATEPART(WEEKDAY, CAST(SpellStartDate AS DATETIME)) IN (1, 7) THEN 1
    ELSE 0
END AS weekend,

-- Time of day
CASE 
    WHEN DATEPART(HOUR, CAST(SpellStartTime AS DATETIME)) BETWEEN 6 AND 11 THEN '1'
    WHEN DATEPART(HOUR, CAST(SpellStartTime AS DATETIME)) BETWEEN 12 AND 17 THEN '2'
    WHEN DATEPART(HOUR, CAST(SpellStartTime AS DATETIME)) BETWEEN 18 AND 23 THEN '3'
    ELSE '4'

END AS time_of_day,
MONTH(apc_tbl.SpellStartDate) AS month,

apc_tbl.Los,

WardAdmission,

CASE WHEN cds_ecds.AcuitySnomedCode = '1064891000000107' then 1 
	when AcuitySnomedCode= '1064911000000105' THEN 2
	when AcuitySnomedCode = '1064901000000108' THEN 3
	WHEN AcuitySnomedCode = '1077241000000103' THEN 4
	WHEN AcuitySnomedCode = '1077251000000100' THEN 5 END as acuity,

apc_tbl.AdmissionMethod, 
SourceOfAdmission, 
apc_tbl.AgeOnAdmission,  
apc_tbl.StartSexofPatientsCode,

apc_tbl.PrimaryDiagnosisICD, 
ICD_code.Chapter_Number,

IMD.IMD_Decile


FROM cds_apc.dbo.tblAPCCurrent AS apc_tbl
INNER JOIN Demographics.dbo.tblDemographicsCurrent AS demo_tbl ON apc_tbl.localPatientid = demo_tbl.LocalPtId
INNER JOIN ImprovementTeam.dbo.lsoa_21_postcode_lookup AS postcode_tbl ON demo_tbl.Postcode IN (postcode_tbl.pcd7, postcode_tbl.pcd8, postcode_tbl.pcd8)
INNER JOIN ImprovementTeam.dbo.Indices_of_Multiple_Deprivation_2019 AS IMD ON postcode_tbl.lsoa21cd = IMD.lsoa11cd
INNER JOIN Reference_UKHD.ICD10.Codes_And_Titles_And_MetaData AS ICD_code ON apc_tbl.PrimaryDiagnosisICD COLLATE DATABASE_DEFAULT = ICD_code.Alt_Code COLLATE DATABASE_DEFAULT
--INNER JOIN Reference_UKHD.OPCS4.Codes_And_Titles AS OPCS_Code ON apc_tbl.PrimaryProcedureOPCS COLLATE DATABASE_DEFAULT = OPCS_Code.Code_Without_Decimal COLLATE DATABASE_DEFAULT
--LEFT JOIN CDS_EAL.dbo.tblEALCensusCurrent as cds_evl ON apc_tbl.localPatientid = cds_evl.LocalPtId
INNER JOIN CDS_ECDS.dbo.tblECDSCurrent AS cds_ecds ON demo_tbl.NHSNumber = cds_ecds.NHSNumber


 
Where SourceSys = 'TauntonandSomerset'
and (SpellStartDate >='2025-01-01' AND SpellDischargeDate <= '2025-07-31')
and trim(WardAdmission) <> 'Test Ward'
and em_el_dc in ('EMERG')
and apc_tbl.ActivityTreatmentfunctioncode = 320 -- 	Cardiology 
and AgeOnAdmission >= 18 -- excluding under 18 patient as they are treated by paediatrics
and ICD_code.Effective_To IS NULL
and LastEpisodeInSpellIndicator = 1 
--and OPCS_Code.Effective_To IS NULL