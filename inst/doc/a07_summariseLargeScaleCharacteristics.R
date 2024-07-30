## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  message = FALSE,
  warning = FALSE
)

library(CDMConnector)
if (Sys.getenv("EUNOMIA_DATA_FOLDER") == "") Sys.setenv("EUNOMIA_DATA_FOLDER" = tempdir())
if (!dir.exists(Sys.getenv("EUNOMIA_DATA_FOLDER"))) dir.create(Sys.getenv("EUNOMIA_DATA_FOLDER"))
if (!eunomia_is_available()) downloadEunomiaData()

## -----------------------------------------------------------------------------
library(CDMConnector)
library(dplyr)
library(ggplot2)
library(CohortCharacteristics)

con <- DBI::dbConnect(duckdb::duckdb(),
  dbdir = CDMConnector::eunomia_dir()
)
cdm <- CDMConnector::cdm_from_con(con,
  cdm_schem = "main",
  write_schema = "main"
)

cdm <- generateConceptCohortSet(
  cdm = cdm,
  name = "ankle_sprain",
  conceptSet = list("ankle_sprain" = 81151),
  end = "event_end_date",
  limit = "first",
  overwrite = TRUE
)

## -----------------------------------------------------------------------------
lsc <- cdm$ankle_sprain |>
  summariseLargeScaleCharacteristics(
    window = list(c(-Inf, -1), c(0, 0)),
    eventInWindow = c(
      "condition_occurrence",
      "procedure_occurrence"
    ),
    episodeInWindow = "drug_exposure",
    minimumFrequency = 0.1
  )

tableLargeScaleCharacteristics(lsc)

## -----------------------------------------------------------------------------
tableLargeScaleCharacteristics(lsc,
  topConcepts = 5
)

## -----------------------------------------------------------------------------
lsc <- cdm$ankle_sprain |>
  PatientProfiles::addSex() |>
  summariseLargeScaleCharacteristics(
    window = list(c(-Inf, -1), c(0, 0)),
    strata = list("sex"),
    eventInWindow = "drug_exposure",
    minimumFrequency = 0.1
  )

tableLargeScaleCharacteristics(lsc)

