## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>", message = FALSE, warning = FALSE
)

library(CDMConnector)
requireEunomia()

## -----------------------------------------------------------------------------
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
medsTiming <- cdm$meds |>
  summariseCohortTiming(restrictToFirstEntry = TRUE)
medsTiming |>
  glimpse()

## -----------------------------------------------------------------------------
tableCohortTiming(medsTiming, timeScale = "years", uniqueCombinations = FALSE)

## -----------------------------------------------------------------------------
plotCohortTiming(
  medsTiming,
  plotType = "boxplot",
  timeScale = "years",
  uniqueCombinations = FALSE
)

## -----------------------------------------------------------------------------
plotCohortTiming(
  medsTiming,
  plotType = "densityplot",
  timeScale = "years",
  uniqueCombinations = FALSE
)

## -----------------------------------------------------------------------------
cdm$meds <- cdm$meds |>
  addAge(ageGroup = list(c(0, 49), c(50, 150))) |>
  compute(temporary = FALSE, name = "meds") |>
  newCohortTable()
medsTiming <- cdm$meds |>
  summariseCohortTiming(
    restrictToFirstEntry = TRUE,
    strata = list("age_group"),
    density = TRUE
  )
tableCohortTiming(medsTiming, timeScale = "years")
plotCohortTiming(medsTiming,
  plotType = "boxplot",
  timeScale = "years",
  facet = "age_group",
  colour = "age_group",
  uniqueCombinations = TRUE
)

