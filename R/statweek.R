
#' @title Stat Week Calculation
#' @description Calculate the Statistical Week based on a date object
#'
#' @param x The date column of interest to convert
#'
#' @keywords stat week
#' @return
#' @export
#'
#' @examples
#' dataframe %>% mutate(week = statweek(datecolumn))
#' statweek(as.Date("2021-07-01")
statweek <- function(x) {
  as.numeric(format(as.Date(x), "%U")) - as.numeric(format(as.Date(cut(x, "year")), "%U")) + 1
  # Function modified from:
  # https://stackoverflow.com/questions/17286983/calculate-statistical-week-starting-1st-january-as-used-in-fisheries-data
}

