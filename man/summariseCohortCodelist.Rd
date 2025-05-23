% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summariseCohortCodelist.R
\name{summariseCohortCodelist}
\alias{summariseCohortCodelist}
\title{Summarise the cohort codelist attribute}
\usage{
summariseCohortCodelist(cohort, cohortId = NULL)
}
\arguments{
\item{cohort}{A cohort_table object.}

\item{cohortId}{A cohort definition id to restrict by. If NULL, all cohorts
will be included.}
}
\value{
A summarised_result object with the exported cohort codelist
information.
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}}
}
\examples{
\donttest{
library(CohortCharacteristics)
library(CDMConnector)
library(duckdb)
library(dplyr, warn.conflicts = FALSE)

dbName <- "GiBleed"
requireEunomia(datasetName = dbName)
con <- dbConnect(drv = duckdb(dbdir = eunomiaDir(datasetName = dbName)))
cdm <- cdmFromCon(con = con, cdmSchema = "main", writeSchema = "main")

cdm <- generateConceptCohortSet(cdm = cdm,
                                conceptSet = list(pharyngitis = 4112343L),
                                name = "my_cohort")

result <- summariseCohortCodelist(cdm$my_cohort)

glimpse(result)

tidy(result)
}

}
