## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>", message = FALSE, warning = FALSE
)

library(CDMConnector)
if (Sys.getenv("EUNOMIA_DATA_FOLDER") == "") Sys.setenv("EUNOMIA_DATA_FOLDER" = tempdir())
if (!dir.exists(Sys.getenv("EUNOMIA_DATA_FOLDER"))) dir.create(Sys.getenv("EUNOMIA_DATA_FOLDER"))
if (!eunomia_is_available()) downloadEunomiaData()

## ----message=FALSE, warning = FALSE-------------------------------------------
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
meds_overlap <- cdm$meds |>
  summariseCohortOverlap()
meds_overlap |>
  glimpse()

## -----------------------------------------------------------------------------
tableCohortOverlap(meds_overlap)

## -----------------------------------------------------------------------------
plotCohortOverlap(meds_overlap)

## -----------------------------------------------------------------------------
cdm$meds <- cdm$meds |>
  PatientProfiles::addAge(ageGroup = list(c(0, 49), c(50, 150))) |>
  compute(temporary = FALSE, name = "meds") |>
  newCohortTable()
meds_overlap <- cdm$meds |>
  summariseCohortOverlap(strata = list("age_group"))

## -----------------------------------------------------------------------------
tableCohortOverlap(meds_overlap)

## -----------------------------------------------------------------------------
plotCohortOverlap(meds_overlap,
  facet = "strata_level"
)

