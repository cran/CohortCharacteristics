## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>", message = FALSE, warning = FALSE,
  fig.width = 7
)

## -----------------------------------------------------------------------------
library(omock)
library(CDMConnector)
library(dplyr, warn.conflicts = FALSE)
library(ggplot2)
library(CodelistGenerator)
library(PatientProfiles)
library(CohortCharacteristics)

cdm <- mockCdmFromDataset(datasetName = "GiBleed", source = "duckdb")

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
settings(cdm$injuries)
cohortCount(cdm$injuries)

## -----------------------------------------------------------------------------
chars <- cdm$injuries |>
  summariseCharacteristics(ageGroup = list(c(0, 49), c(50, Inf)))
chars |>
  glimpse()

## -----------------------------------------------------------------------------
tableCharacteristics(chars)

## -----------------------------------------------------------------------------
chars |>
  filter(variable_name == "Age") |>
  plotCharacteristics(
    plotType = "boxplot",
    colour = "cohort_name",
    facet = c("cdm_name")
  )

## -----------------------------------------------------------------------------
chars <- cdm$injuries |>
  addAge(ageGroup = list(
    c(0, 49),
    c(50, Inf)
  )) |>
  summariseCharacteristics(strata = list("age_group"))

## -----------------------------------------------------------------------------
tableCharacteristics(chars,
  groupColumn = "age_group"
)

## -----------------------------------------------------------------------------
chars |>
  filter(variable_name == "Prior observation") |>
  plotCharacteristics(
    plotType = "boxplot",
    colour = "cohort_name",
    facet = c("age_group")
  ) +
  coord_flip()

## -----------------------------------------------------------------------------
medsCs <- getDrugIngredientCodes(
  cdm = cdm,
  name = c("acetaminophen", "morphine", "warfarin")
)
cdm <- generateConceptCohortSet(
  cdm = cdm,
  name = "meds",
  conceptSet = medsCs,
  end = "event_end_date",
  limit = "all",
  overwrite = TRUE
)

## -----------------------------------------------------------------------------
chars <- cdm$injuries |>
  summariseCharacteristics(cohortIntersectFlag = list(
    "Medications prior to index date" = list(
      targetCohortTable = "meds",
      window = c(-Inf, -1)
    ),
    "Medications on index date" = list(
      targetCohortTable = "meds",
      window = c(0, 0)
    )
  ))

## -----------------------------------------------------------------------------
tableCharacteristics(chars)

## -----------------------------------------------------------------------------
plot_data <- chars |>
  filter(
    variable_name == "Medications prior to index date",
    estimate_name == "percentage"
  )

plot_data |>
  plotCharacteristics(
    plotType = "barplot",
    colour = "variable_level",
    facet = c("cdm_name", "cohort_name")
  ) +
  scale_x_discrete(limits = rev(sort(unique(plot_data$variable_level)))) +
  coord_flip() +
  ggtitle("Medication use prior to index date")

## -----------------------------------------------------------------------------
chars <- cdm$injuries |>
  summariseCharacteristics(conceptIntersectFlag = list(
    "Medications prior to index date" = list(
      conceptSet = medsCs,
      window = c(-Inf, -1)
    ),
    "Medications on index date" = list(
      conceptSet = medsCs,
      window = c(0, 0)
    )
  ))

## -----------------------------------------------------------------------------
tableCharacteristics(chars)

## -----------------------------------------------------------------------------
chars <- cdm$injuries |>
  summariseCharacteristics(
    tableIntersectCount = list(
      "Visits in the year prior" = list(
        tableName = "visit_occurrence",
        window = c(-365, -1)
      )
    ),
    tableIntersectFlag = list(
      "Any drug exposure in the year prior" = list(
        tableName = "drug_exposure",
        window = c(-365, -1)
      ),
      "Any procedure in the year prior" = list(
        tableName = "procedure_occurrence",
        window = c(-365, -1)
      )
    )
  )

## -----------------------------------------------------------------------------
tableCharacteristics(chars)

