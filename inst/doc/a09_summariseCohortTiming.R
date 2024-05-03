## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>", message = FALSE, warning = FALSE
)

library(CDMConnector)
if (Sys.getenv("EUNOMIA_DATA_FOLDER") == "") Sys.setenv("EUNOMIA_DATA_FOLDER" = tempdir())
if (!dir.exists(Sys.getenv("EUNOMIA_DATA_FOLDER"))) dir.create(Sys.getenv("EUNOMIA_DATA_FOLDER"))
if (!eunomia_is_available()) downloadEunomiaData()

## -----------------------------------------------------------------------------
library(CDMConnector)
library(CodelistGenerator)
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

meds_cs <- getDrugIngredientCodes(
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
  conceptSet = meds_cs,
  end = "event_end_date",
  limit = "all",
  overwrite = TRUE
)

settings(cdm$meds)
cohortCount(cdm$meds)

## -----------------------------------------------------------------------------
meds_timing <- cdm$meds |>
  summariseCohortTiming(restrictToFirstEntry = TRUE)
meds_timing |>
  glimpse()

## -----------------------------------------------------------------------------
tableCohortTiming(meds_timing,
  timeScale = "years",
  .options = list(decimals = c(numeric = 0))
)

## -----------------------------------------------------------------------------
plotCohortTiming(meds_timing,
  plotType = "boxplot",
  timeScale = "years"
)

## -----------------------------------------------------------------------------
meds_timing <- cdm$meds |>
  summariseCohortTiming(
    restrictToFirstEntry = TRUE,
    density = TRUE
  )
plotCohortTiming(meds_timing,
  plotType = "density",
  timeScale = "years"
)

## -----------------------------------------------------------------------------
cdm$meds <- cdm$meds |>
  PatientProfiles::addAge(ageGroup = list(c(0, 49), c(50, 150))) |>
  compute(temporary = FALSE, name = "meds") |>
  newCohortTable()
meds_timing <- cdm$meds |>
  summariseCohortTiming(
    restrictToFirstEntry = TRUE,
    strata = list("age_group"),
    density = TRUE
  )
tableCohortTiming(meds_timing,
  timeScale = "years",
  .options = list(decimals = c(numeric = 0))
)
plotCohortTiming(meds_timing,
  plotType = "boxplot",
  timeScale = "years",
  facet = "strata_level",
  colour = "strata_level",
  colourName = "Age group"
)

