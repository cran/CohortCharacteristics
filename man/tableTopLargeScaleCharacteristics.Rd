% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tableLargeScaleCharacteristics.R
\name{tableTopLargeScaleCharacteristics}
\alias{tableTopLargeScaleCharacteristics}
\title{Visualise the top concepts per each cdm name, cohort, statification and
window.}
\usage{
tableTopLargeScaleCharacteristics(result, topConcepts = 10, type = "gt")
}
\arguments{
\item{result}{A summarised_result object.}

\item{topConcepts}{Number of concepts to restrict the table.}

\item{type}{Type of table, it can be any of the supported
\code{visOmopResults::tableType()} formats.}
}
\value{
A formated table.
}
\description{
Visualise the top concepts per each cdm name, cohort, statification and
window.
}
\examples{
\dontrun{
library(CohortCharacteristics)
library(duckdb)
library(CDMConnector)
library(dplyr, warn.conflicts = FALSE)

con <- dbConnect(duckdb(), eunomiaDir())
cdm <- cdmFromCon(con = con, cdmSchema = "main", writeSchema = "main")
cdm <- generateConceptCohortSet(
  cdm = cdm,
  conceptSet = list(viral_pharyngitis = 4112343),
  name = "my_cohort"
)

result <- summariseLargeScaleCharacteristics(
  cohort = cdm$my_cohort,
  window = list(c(-Inf, -1), c(0, 0), c(1, Inf)),
  episodeInWindow = "drug_exposure"
)

tableTopLargeScaleCharacteristics(result)

cdmDisconnect(cdm)
}

}
