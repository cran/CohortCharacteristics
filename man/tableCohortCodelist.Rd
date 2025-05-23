% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summariseCohortCodelist.R
\name{tableCohortCodelist}
\alias{tableCohortCodelist}
\title{Create a visual table from \verb{<summarised_result>} object from
\code{summariseCohortCodelist()}}
\usage{
tableCohortCodelist(result, type = "reactable")
}
\arguments{
\item{result}{A summarised_result object.}

\item{type}{Type of table. Supported types: "gt", "flextable", "tibble",
"datatable", "reactable".}
}
\value{
A visual table with the results.
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

tableCohortCodelist(result)
}

}
