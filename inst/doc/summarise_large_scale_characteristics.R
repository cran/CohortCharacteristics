## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  message = FALSE,
  warning = FALSE
)

CDMConnector::requireEunomia()

## -----------------------------------------------------------------------------
library(duckdb)
library(CDMConnector)
library(dplyr, warn.conflicts = FALSE)
library(PatientProfiles)
library(CohortCharacteristics)

con <- dbConnect(duckdb(), dbdir = eunomiaDir())
cdm <- cdmFromCon(
  con = con, cdmSchem = "main", writeSchema = "main", cdmName = "Eunomia"
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
tableTopLargeScaleCharacteristics(lsc,
                                  topConcepts = 5)

## -----------------------------------------------------------------------------
lsc <- cdm$ankle_sprain |>
  addSex() |>
  summariseLargeScaleCharacteristics(
    window = list(c(-Inf, -1), c(0, 0)),
    strata = list("sex"),
    eventInWindow = "drug_exposure",
    minimumFrequency = 0.1
  )

tableTopLargeScaleCharacteristics(lsc)

## -----------------------------------------------------------------------------
plotLargeScaleCharacteristics(lsc)

## -----------------------------------------------------------------------------
plotComparedLargeScaleCharacteristics(
  result = lsc,
  colour = "sex",
  reference = 'overall',
  facet = cohort_name ~ variable_level
)

