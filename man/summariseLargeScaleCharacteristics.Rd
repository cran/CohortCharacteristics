% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summariseLargeScaleCharacteristics.R
\name{summariseLargeScaleCharacteristics}
\alias{summariseLargeScaleCharacteristics}
\title{This function is used to summarise the large scale characteristics of a
cohort table}
\usage{
summariseLargeScaleCharacteristics(
  cohort,
  strata = list(),
  window = list(c(-Inf, -366), c(-365, -31), c(-30, -1), c(0, 0), c(1, 30), c(31, 365),
    c(366, Inf)),
  eventInWindow = NULL,
  episodeInWindow = NULL,
  indexDate = "cohort_start_date",
  censorDate = NULL,
  includeSource = FALSE,
  minimumFrequency = 0.005,
  excludedCodes = c(0)
)
}
\arguments{
\item{cohort}{The cohort to characterise.}

\item{strata}{Stratification list.}

\item{window}{Temporal windows that we want to characterize.}

\item{eventInWindow}{Tables to characterise the events in the window. eventInWindow must be provided if episodeInWindow is not specified.}

\item{episodeInWindow}{Tables to characterise the episodes in the window. episodeInWindow must be provided if eventInWindow is not specified.}

\item{indexDate}{Variable in x that contains the date to compute the
intersection.}

\item{censorDate}{whether to censor overlap events at a specific date
or a column date of x}

\item{includeSource}{Whether to include source concepts.}

\item{minimumFrequency}{Minimum frequency covariates to report.}

\item{excludedCodes}{Codes excluded.}
}
\value{
The output of this function is a `ResultSummary` containing the
relevant information.
}
\description{
This function is used to summarise the large scale characteristics of a
cohort table
}
\examples{
\donttest{
library(CohortCharacteristics)
cdm <- CohortCharacteristics::mockCohortCharacteristics()

concept <- dplyr::tibble(
  concept_id = c(1125315, 1503328, 1516978, 317009, 378253, 4266367),
  domain_id = NA_character_,
  vocabulary_id = NA_character_,
  concept_class_id = NA_character_,
  concept_code = NA_character_,
  valid_start_date = as.Date("1900-01-01"),
  valid_end_date = as.Date("2099-01-01")
) |>
  dplyr::mutate(concept_name = paste0("concept: ", .data$concept_id))
cdm <- CDMConnector::insertTable(cdm, "concept", concept)
results <- cdm$cohort2 |>
  summariseLargeScaleCharacteristics(
    episodeInWindow = c("condition_occurrence"),
    minimumFrequency = 0
  )
mockDisconnect(cdm = cdm)
}
}
