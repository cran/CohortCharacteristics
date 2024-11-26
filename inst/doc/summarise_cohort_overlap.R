## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>", message = FALSE, warning = FALSE
)

library(CDMConnector)
requireEunomia()

## ----message=FALSE, warning = FALSE-------------------------------------------
library(duckdb)
library(CDMConnector)
library(dplyr, warn.conflicts = FALSE)
library(CodelistGenerator)
library(PatientProfiles)
library(CohortCharacteristics)

con <- dbConnect(duckdb(), dbdir = eunomiaDir())
cdm <- cdmFromCon(
  con = con, cdmSchem = "main", writeSchema = "main", cdmName = "Eunomia"
)

medsCs <- getDrugIngredientCodes(
  cdm = cdm,
  name = c(
    "acetaminophen",
    "morphine",
    "warfarin"
  )
)

cdm <- generateConceptCohortSet(
  cdm = cdm,
  name = "meds",
  conceptSet = medsCs,
  end = "event_end_date",
  limit = "all",
  overwrite = TRUE
)

settings(cdm$meds)
cohortCount(cdm$meds)

## -----------------------------------------------------------------------------
medsOverlap <- cdm$meds |>
  summariseCohortOverlap()
medsOverlap |>
  glimpse()

## -----------------------------------------------------------------------------
tableCohortOverlap(medsOverlap, uniqueCombinations = FALSE)

## -----------------------------------------------------------------------------
plotCohortOverlap(medsOverlap, uniqueCombinations = FALSE)

## -----------------------------------------------------------------------------
cdm$meds <- cdm$meds |>
  addAge(ageGroup = list(c(0, 49), c(50, 150))) |>
  compute(temporary = FALSE, name = "meds") |>
  newCohortTable()
medsOverlap <- cdm$meds |>
  summariseCohortOverlap(strata = list("age_group"))

## -----------------------------------------------------------------------------
tableCohortOverlap(medsOverlap, uniqueCombinations = FALSE)

## -----------------------------------------------------------------------------
plotCohortOverlap(
  medsOverlap,
  y = c("cohort_name_reference", "cohort_name_comparator"),
  facet = c("age_group"),
  uniqueCombinations = TRUE
)

