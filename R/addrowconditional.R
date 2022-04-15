

#' Conditionally Add Rows
#' Use this function if you need to add rows to a dataframe based on a certain criteria
#' For example, you might have rockfish data that had species "groups" which might
#' need to be partitioned into extra rows for which add'l catch can be assigned.
#' This function can specify which rows need to be duplicated ("criteria1"),
#' how many times to repeat that row ("repeatcount1"),
#' and then sort ("sort1") to make a more useful view.
#' Additionally, these are extended by secondary criteria ("criteria2"),
#' repeat counts ("repeatcount2"), and sorting ("sort2").
#'
#' @param dataframename The name of the dataframe
#' @param criteriacolumn The name of the column containing the criteria of interest
#' @param repeatcount1 How many times to repeat rows meeting criteria 1. Default = 1.
#' @param repeatcount2 How many times to repeat rows meeting criteria 1. Default = 0.
#' @param criteria1 The conditions that meet criteria1 in the criteriacolumn
#' @param criteria2 The conditions that meet criteria2 in the criteriacolumn
#' @param sort1 Arrange (sort) the columns in the output based first on this value
#' @param sort2 Arrange (sort) the columns in the output based secondly on this value
#'
#' @return
#' @export
#' @importFrom dplyr filter full_join arrange
#' @importFrom magrittr "%>%"
#'
#' @examples
#' addrowconditional(df, criteriacolumn = species,
#'                   repeatcount1 = 5, repeatcount2 = 10,
#'                   criteria1 = 168, criteria2 = 140,
#'                   sort1 = year, sort2 = species)
#' This would create duplicate rows 5 times for species == 168 (red rockfishes),
#'  and 10 duplicate rows for species == 140, then sort by columns year and species
addrowconditional <- function(dataframename, criteriacolumn = columnname,
                              repeatcount1 = 1, repeatcount2 = 0,
                              criteria1 = filter1, criteria2 = NA,
                              sort1 = column1, sort2 = NA){

  .duprows1 <- dataframename %>%
    filter({{criteriacolumn}} == criteria1)   # Note the use of the {{}} here!

  .duprows2 <- dataframename %>%
    filter({{criteriacolumn}} == criteria2)

  .duprows1 <- .duprows1[rep(1:nrow(.duprows1), repeatcount1), ]
  .duprows2 <- .duprows2[rep(1:nrow(.duprows2), repeatcount2), ]

  .gooddata <- dataframename %>%
    filter({{criteriacolumn}} != criteria1 | {{criteriacolumn}} != criteria2)

  .duprows1 %>%
    full_join(.duprows2) %>%
    full_join(.gooddata) %>%
    arrange({{sort1}}, {{sort2}})
}
