% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plotLargeScaleCharacteristics.R
\name{plotLargeScaleCharacteristics}
\alias{plotLargeScaleCharacteristics}
\title{create a ggplot from the output of summariseLargeScaleCharacteristics.}
\usage{
plotLargeScaleCharacteristics(
  result,
  facet = c("cdm_name", "cohort_name"),
  colour = "variable_level"
)
}
\arguments{
\item{result}{A summarised_result object.}

\item{facet}{Columns to facet by. See options with
\code{availablePlotColumns(result)}. Formula is also allowed to specify rows and
columns.}

\item{colour}{Columns to color by. See options with
\code{availablePlotColumns(result)}.}
}
\value{
A ggplot2 object.
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}}
}
\examples{
\dontrun{
library(CohortCharacteristics)
library(duckdb)
library(CDMConnector)
library(DrugUtilisation)

con <- dbConnect(duckdb(), eunomiaDir())
cdm <- cdmFromCon(con, cdmSchem = "main", writeSchema = "main")

cdm <- generateIngredientCohortSet(
  cdm = cdm, name = "my_cohort", ingredient = "acetaminophen"
)

resultsLsc <- cdm$my_cohort |>
  summariseLargeScaleCharacteristics(
    window = list(c(-365, -1), c(1, 365)),
    eventInWindow = "condition_occurrence"
  )

resultsLsc |>
  plotLargeScaleCharacteristics(
    facet = c("cdm_name", "cohort_name"),
    colour = "variable_level"
  )

cdmDisconnect(cdm)
}

}
