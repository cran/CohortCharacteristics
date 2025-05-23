% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plotComparedLargeScaleCharacteristics.R
\name{plotComparedLargeScaleCharacteristics}
\alias{plotComparedLargeScaleCharacteristics}
\title{create a ggplot from the output of summariseLargeScaleCharacteristics.}
\usage{
plotComparedLargeScaleCharacteristics(
  result,
  colour,
  reference = NULL,
  facet = NULL,
  missings = 0
)
}
\arguments{
\item{result}{A summarised_result object.}

\item{colour}{Columns to color by. See options with
\code{availablePlotColumns(result)}.}

\item{reference}{A named character to set up the reference. It must be one of
the levels of reference.}

\item{facet}{Columns to facet by. See options with
\code{availablePlotColumns(result)}. Formula is also allowed to specify rows and
columns.}

\item{missings}{Value to replace the missing value with. If NULL missing
values will be eliminated.}
}
\value{
A ggplot.
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
library(plotly, warn.conflicts = FALSE)

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
  plotComparedLargeScaleCharacteristics(
    colour = "variable_level",
    reference = "-365 to -1",
    missings = NULL
  ) |>
  ggplotly()

cdmDisconnect(cdm)
}

}
