

#' Unsummarize Data
#' Use this function if you encounter already summarized data and
#'  need to split it into long format. For example, you might have
#'  ASL data that has a row with Sex=M, Length=687, Specimen Count=3
#' This means that there are 3 fish that are males all with the same
#' length of 687. Often though, we will want to run stats on our
#' data which require it to NOT be summarized. This function takes
#' summarized data and adds rows based on the count column
#'
#' @param dataframename Name of dataframe
#' @param duplicatecolname Name of column that contains numeric counts of how many duplicates
#' @param replacenaswithone Using replacenaswithone allows you to
#' decide whether an NA in the count column were really a count of 1.
#'  Carefully use this because most often an NA is a true zero.
#'
#' @return
#' @export
#' @importFrom dplyr select
#' @importFrom tibble deframe
#' @importFrom tidyr replace_na
#' @importFrom magrittr "%>%"
#'
#'
#' @examples
#' duplicaterows(dataframename = newdf, duplicatecolname = "Number_Specimens")
#'
duplicaterows <- function(dataframename,
                          duplicatecolname = "specimen_count",
                          replacenaswithone = FALSE){

  # Make an index of which rows will be repeated, and how many times
  .dupcount <- dataframename %>% dplyr::select(duplicatecolname) %>% tibble::deframe()

  # NAs will normally make this fail. We can replace NAs though
  # This replaces NAs with 1. THIS IS A LARGE ASSUMPTION SO BE CAREFUL
  if(sum(is.na(.dupcount) > 0) && replacenaswithone == TRUE){
    .dupcount <- tidyr::replace_na(.dupcount, 1)
  }

  # Now repeat this for every row to duplicate.
  # A specimen count of 1 will mean the row isn't duplicated; a count of 5, repeats the row 5 times
  dataframename[rep(1:nrow(dataframename), .dupcount), ] %>%
    dplyr::select(-duplicatecolname) # Removes the count row now that it is incorrect!

  # Thanks to: https://stackoverflow.com/questions/29743691/duplicate-rows-in-a-data-frame-in-r
}



