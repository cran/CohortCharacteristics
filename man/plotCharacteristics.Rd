% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plotCharacteristics.R
\name{plotCharacteristics}
\alias{plotCharacteristics}
\title{Create a ggplot from the output of summariseCharacteristics.
`r lifecycle::badge("experimental")`}
\usage{
plotCharacteristics(
  data,
  xAxis = "variable_name",
  yAxis = "estimate_value",
  plotStyle = "barplot",
  facetVarX = NULL,
  facetVarY = NULL,
  colorVars = NULL,
  vertical_x = FALSE
)
}
\arguments{
\item{data}{output of summariseCharacteristics.}

\item{xAxis}{what to plot on x axis, default as variable_name column. Has to be a column in data.}

\item{yAxis}{what to plot on y axis, default as estimate_value column. Has to be a column in data. One of the xAxis or yAxis has to be estimate_value.}

\item{plotStyle}{Now allows boxplot or barplot only.}

\item{facetVarX}{column in data to facet by on horizontal axis}

\item{facetVarY}{column in data to facet by on vertical axis}

\item{colorVars}{column in data to color by.}

\item{vertical_x}{whether to display x axis string vertically.}
}
\value{
A ggplot.
}
\description{
Create a ggplot from the output of summariseCharacteristics.
`r lifecycle::badge("experimental")`
}
\examples{
\donttest{
library(CohortCharacteristics)

cdm <- mockCohortCharacteristics()

results <- summariseCharacteristics(
  cohort = cdm$cohort1,
  ageGroup = list(c(0, 19), c(20, 39), c(40, 59), c(60, 79), c(80, 150)),
  tableIntersect = list(
    tableName = "visit_occurrence", value = "count", window = c(-365, -1)
  ),
  cohortIntersect = list(
    targetCohortTable = "cohort2", value = "flag", window = c(-365, -1)
  )
)

plotCharacteristics(results)

CDMConnector::cdmDisconnect(cdm = cdm)
}
}