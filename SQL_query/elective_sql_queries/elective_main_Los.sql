SELECT DISTINCT
    -- Combine date and time into full admission timestamp
    CAST(SpellStartDate AS DATETIME) + CAST(SpellStartTime AS DATETIME) AS admission_datetime,

    -- Weekend flag (Sunday = 1, Saturday = 7)
    CASE 
        WHEN DATEPART(WEEKDAY, CAST(SpellStartDate AS DATETIME)) IN (1, 7) THEN 1
        ELSE 0
    END AS weekend,

    -- Categorise time of admission
    CASE 
        WHEN DATEPART(HOUR, CAST(SpellStartTime AS DATETIME)) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, CAST(SpellStartTime AS DATETIME)) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN DATEPART(HOUR, CAST(SpellStartTime AS DATETIME)) BETWEEN 18 AND 23 THEN 'Evening'
        ELSE 'Midnight'
    END AS time_of_day,

    -- Admission and discharge details
    apc_tbl.DischargeDestination,
    apc_tbl.WardAdmission,
    apc_tbl.Los,

    -- EAL census data (elective-specific)
    eal_cds.PriorityType,
    eal_cds.IntendedManagement,

    -- Admission method and source
    apc_tbl.AdmissionMethod,
    SourceOfAdmission,
    apc_tbl.em_el_dc,

    -- Demographics
    demo_tbl.EthnicCategory,
    apc_tbl.AgeOnAdmission,
    apc_tbl.StartSexofPatientsCode,

    -- Diagnosis and ICD metadata
    apc_tbl.PrimaryDiagnosisICD,
    ICD_code.[Description],
    ICD_code.Chapter_Number,
    ICD_code.Chapter_Description,

    -- IMD decile for deprivation analysis
    IMD.IMD_Decile

FROM cds_apc.dbo.tblAPCCurrent AS apc_tbl

-- Join with patient demographics
INNER JOIN Demographics.dbo.tblDemographicsCurrent AS demo_tbl 
    ON apc_tbl.localPatientid = demo_tbl.LocalPtId

-- Link postcode to LSOA
INNER JOIN ImprovementTeam.dbo.lsoa_21_postcode_lookup AS postcode_tbl 
    ON demo_tbl.Postcode IN (postcode_tbl.pcd7, postcode_tbl.pcd8)

-- Link LSOA to IMD decile
INNER JOIN ImprovementTeam.dbo.Indices_of_Multiple_Deprivation_2019 AS IMD 
    ON postcode_tbl.lsoa21cd = IMD.lsoa11cd

-- Join ICD code metadata
INNER JOIN Reference_UKHD.ICD10.Codes_And_Titles_And_MetaData AS ICD_code 
    ON apc_tbl.PrimaryDiagnosisICD COLLATE DATABASE_DEFAULT = ICD_code.Alt_Code COLLATE DATABASE_DEFAULT

-- Join elective census data
INNER JOIN CDS_EAL.dbo.tblEALCensusCurrent AS eal_cds 
    ON apc_tbl.localPatientid = eal_cds.LocalPtId

-- Filters to clean and focus the dataset
WHERE SourceSys = 'TauntonandSomerset'
    AND SpellStartDate >= '2018-01-01'
    AND SpellDischargeDate <= '2024-01-31'
    AND (WellBabyFlagDerivied = '0' OR WellBabyFlagDerivied IS NULL) -- exclude well babies
    AND (AdministrativeCatagory <> '02' OR AdministrativeCatagory IS NULL) -- exclude private patients
    AND TRIM(WardAdmission) <> 'Test Ward' -- remove test data
    AND em_el_dc = 'ELECT' -- keep only elective admissions
    AND apc_tbl.ActivityTreatmentfunctioncode = 320 -- cardiology only
    AND AgeOnAdmission >= 18 -- exclude paediatrics 
    AND ICD_code.Effective_To IS NULL -- only current ICD codes
    AND LastEpisodeInSpellIndicator = 1 -- keep only last episode in spell
