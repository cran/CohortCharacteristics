# Copyright 2024 DARWIN EU (C)
#
# This file is part of CohortCharacteristics
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#' create a ggplot from the output of summariseLargeScaleCharacteristics.
#'
#' `r lifecycle::badge("experimental")`
#'
#' @param result A summarised_result object. Output of
#' summariseLargeScaleCharacteristics().
#' @param facet Columns to facet by. See options with `tidyColumns(result)`.
#' Formula is also allowed to specify rows and columns.
#' @param colour Columns to color by. See options with `tidyColumns(result)`.
#'
#' @return A ggplot2 object.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library(CohortCharacteristics)
#' library(duckdb)
#' library(CDMConnector)
#' library(DrugUtilisation)
#'
#' con <- dbConnect(duckdb(), eunomiaDir())
#' cdm <- cdmFromCon(con, cdmSchem = "main", writeSchema = "main")
#'
#' cdm <- generateIngredientCohortSet(
#'   cdm = cdm, name = "my_cohort", ingredient = "acetaminophen"
#' )
#'
#' resultsLsc <- cdm$my_cohort |>
#'   summariseLargeScaleCharacteristics(
#'     window = list(c(-365, -1), c(1, 365)),
#'     eventInWindow = "condition_occurrence"
#'   )
#'
#' resultsLsc |>
#'   plotLargeScaleCharacteristics(
#'     facet = c("cdm_name", "cohort_name"),
#'     colour = "variable_level"
#'   )
#'
#' cdmDisconnect(cdm)
#' }
#'
plotLargeScaleCharacteristics <- function(result,
                                          facet = c("cdm_name", "cohort_name"),
                                          colour = "variable_level") {
  # validate result
  result <- omopgenerics::validateResultArgument(result)

  # check settings
  result <- result |>
    visOmopResults::filterSettings(
      .data$result_type == "summarise_large_scale_characteristics"
    )

  if (nrow(result) == 0) {
    cli::cli_warn("`result` object does not contain any `result_type == 'summarise_large_scale_characteristics'` information.")
    return(emptyPlot())
  }

  labs <- unique(result$variable_level)

  result |>
    dplyr::mutate(variable_level = factor(.data$variable_level, labs)) |>
    visOmopResults::scatterPlot(
      x = "variable_name",
      y = "percentage",
      line = FALSE,
      ribbon = FALSE,
      point = TRUE,
      facet = facet,
      colour = colour
    )
}
