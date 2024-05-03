## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>", message = FALSE, warning = FALSE,
  fig.width = 7
)

library(CDMConnector)
if (Sys.getenv("EUNOMIA_DATA_FOLDER") == "") Sys.setenv("EUNOMIA_DATA_FOLDER" = tempdir())
if (!dir.exists(Sys.getenv("EUNOMIA_DATA_FOLDER"))) dir.create(Sys.getenv("EUNOMIA_DATA_FOLDER"))
if (!eunomia_is_available()) downloadEunomiaData()

## -----------------------------------------------------------------------------
library(CDMConnector)
library(CohortCharacteristics)
library(dplyr)
library(ggplot2)

con <- DBI::dbConnect(duckdb::duckdb(),
  dbdir = CDMConnector::eunomia_dir()
)
cdm <- CDMConnector::cdm_from_con(con,
  cdm_schem = "main",
  write_schema = "main",
  cdm_name = "Eunomia"
)

cdm <- generateConceptCohortSet(
  cdm = cdm,
  name = "injuries",
  conceptSet = list(
    "ankle_sprain" = 81151,
    "ankle_fracture" = 4059173,
    "forearm_fracture" = 4278672,
    "hip_fracture" = 4230399
  ),
  end = "event_end_date",
  limit = "all"
)

## -----------------------------------------------------------------------------
cohort_counts <- summariseCohortCount(cdm[["injuries"]])
tableCohortCount(cohort_counts)

## -----------------------------------------------------------------------------
cdm[["injuries"]] <- cdm[["injuries"]] |>
  PatientProfiles::addAge(ageGroup = list(
    c(0, 3),
    c(4, 17),
    c(18, Inf)
  )) |>
  compute(temporary = FALSE, name = "injuries")

cohort_counts <- summariseCohortCount(cdm[["injuries"]], strata = "age_group")
tableCohortCount(cohort_counts)

## -----------------------------------------------------------------------------
cohort_counts <- suppress(cohort_counts, minCellCount = 10)
tableCohortCount(cohort_counts)

## -----------------------------------------------------------------------------
cdm <- generateConceptCohortSet(
  cdm = cdm,
  name = "ankle_sprain",
  conceptSet = list("ankle_sprain" = 81151),
  end = "event_end_date",
  limit = "all"
)

cdm[["ankle_sprain"]] <- cdm[["ankle_sprain"]] |>
  filter(year(cohort_start_date) >= 2000) |>
  recordCohortAttrition("Restrict to cohort_start_date >= 2000") |>
  compute(temporary = FALSE, name = "ankle_sprain")

attrition_summary <- summariseCohortAttrition(cdm[["ankle_sprain"]])

plotCohortAttrition(attrition_summary)

## -----------------------------------------------------------------------------
cdm[["ankle_sprain"]] <- cdm[["ankle_sprain"]] |>
  PatientProfiles::addAge() |>
  filter(age >= 18) |>
  compute(temporary = FALSE, name = "ankle_sprain") |>
  recordCohortAttrition("Restrict to age >= 18")

attrition_summary <- summariseCohortAttrition(cdm[["ankle_sprain"]])

plotCohortAttrition(attrition_summary, cohortId = 1)

## -----------------------------------------------------------------------------
cdm <- generateConceptCohortSet(
  cdm = cdm,
  name = "ankle_sprain",
  conceptSet = list("ankle_sprain" = 81151),
  end = "event_end_date",
  limit = "all"
)

cdm[["ankle_sprain"]] <- cdm[["ankle_sprain"]] |>
  PatientProfiles::addAge() |>
  filter(age >= 18) |>
  compute(temporary = FALSE, name = "ankle_sprain") |>
  recordCohortAttrition("Restrict to age >= 18")

cdm[["ankle_sprain"]] <- cdm[["ankle_sprain"]] |>
  filter(year(cohort_start_date) >= 2000) |>
  recordCohortAttrition("Restrict to cohort_start_date >= 2000") |>
  compute(temporary = FALSE, name = "ankle_sprain")


attrition_summary <- summariseCohortAttrition(cdm[["ankle_sprain"]])

plotCohortAttrition(attrition_summary, cohortId = 1)

## -----------------------------------------------------------------------------
tableCohortAttrition(attrition_summary)

