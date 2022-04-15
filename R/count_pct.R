


#' Summarize Proportions of Grouped Variables
#'
#' @param df The dataframe containing a group
#'
#' @return
#' @export
#' @importFrom magrittr "%>%"
#' @importFrom dplyr mutate tally group_by
#'
#' @examples
#' count_pct(iris %>%
#'           group_by(Species))

count_pct <- function(df) {
  # https://stackoverflow.com/questions/24576515/relative-frequencies-proportions-with-dplyr
  return(
    df %>%
      dplyr::tally %>%
      dplyr::mutate(n_pct = 100*n/sum(n))
  )
}
