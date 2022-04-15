


# There are four functions here:
# impute_global() which imputes all NAs in all years iteratively
# impute_cohodefault() which imputes all NAs before year 2000 globally, then imputes annually
# impute_local() which imputes a 10-year rolling imputation (prev & following 5 years)
# impute_local_improved which is similar to impute_local() but accounts for early years better



#' @title Global Impute
#' @description This creates a dataframe that imputes NA values across all available years and rivers.
#' This algorithm interpolates across rows and columns, following Blick.
#' In essence, imputing across rows (years) and columns (streams) allows for an NA in
#' a year/stream to be informed by typical counts and for that year AND stream
#' This function can be easily modified to auto-create a named dataframe
#' Make sure that all NAs are present (a missing row is NOT same as a row with an NA)
#'
#' @param dfname The name of the dataframe
#' @param Year_column The name of the column with the year (i.e., impute criteria 1)
#' @param StreamName_column The name of the column with the stream name (i.e., impute criteria 2)
#' @param outputname Vestigial.
#' @param count_column The name of the column with the counts to impute.
#'
#' @return
#' @export
#'
#' @importFrom dplyr rename select mutate filter
#' @importFrom magrittr "%>%"
#'
#' @examples
#' impute_global(ktn_index, StreamName_column = "River", Year_column = "year")
impute_global <- function(dfname, Year_column="year",
                          StreamName_column="stream_name",
                          outputname = "globalimpute", # Only used if Step 3 turned "on"
                          count_column = "total_count"){

  # Step 1: Set up dataframe to impute
  .test <- dfname %>% rename(year = Year_column,
                             stream_name = StreamName_column,
                             total_count = Count_column)
  .test <- .test %>% dplyr::select(year, stream_name, total_count)
  .test <- .test %>% mutate(imputed = is.na(total_count))

  # Step 2: Use multiplicative imputation as per Blick, in an iterative procedure
  j=1
  repeat{
    for(i in 1:nrow(.test)){
      .temprow = .test[i,]

      if(.temprow$imputed == TRUE){
        .sumyr = sum((.test %>% filter(year == .temprow$year) )$total_count, na.rm = TRUE)
        .sumrvr = sum((.test %>% filter(stream_name == .temprow$stream_name) )$total_count, na.rm = TRUE)
        .sumall = sum(.test$total_count, na.rm = TRUE)
        .test$total_count[i] = .sumyr * .sumrvr / .sumall
        # this interpolates across rows and columns
      }
    }
    j=j+1
    if(j>100){break} # repeat the above 100 times
  }
  print(.test)

  # Optional Step 3: Auto create a dataframe with the correct name
  # #assign(paste0((outputname), "_survey_imputed"), .test, envir = parent.frame() ) # use if you want a dynamic name
  ## imputedsurvey <- .test # use this if you want a static name
}







#' Default Coho (Leon) Imputation.
#' This function imputes missing data (NAs) in a dataframe but does so separately
#' for years 1987-2000 (using a global imputation), then backwards imputes
#' each new year after that. This is to replicate the process used
#' for imputing done by Leon Shaul.
#' For all years pre-2000, impute globally (all values 1987-1999
#' inform imputed NAs). Then for each following year, calculate
#' a new imputation looking backwards only Leon imputed everything
#' once ~2000 then annually would add the new years data with blanks.
#' He ran the imputation on this new row which was informed by previous
#' years' imputations. Once imputed, these values would go in the table
#' and not be updated (i.e., NAs from 2002 would not be updated in
#' subsequent years). Make sure that all NAs are present
#' (a missing row is NOT same as a row with an NA).

#'
#' @param dfname The name of the dataframe
#' @param Year_column The name of the column with the year (i.e., impute criteria 1)
#' @param StreamName_column The name of the column with the stream name (i.e., impute criteria 2)
#' @param outputname Vestigial.
#' @param count_column The name of the column with the counts to impute.
#'
#' @return
#' @export
#'
#' @importFrom dplyr rename select mutate filter
#' @importFrom magrittr "%>%"
#'
#' @examples
#' impute_cohodefault(ktn_index, Year_column="year", outputname = "ktn2020")
impute_cohodefault <- function(dfname,
                               Year_column="year",
                               StreamName_column="stream_name",
                               Count_column = "total_count",
                               outputname = "defaultcohoimputed"){
  # Step 1: Set up dataframe to impute
  .test <- dfname %>% rename(year = Year_column, stream_name = StreamName_column, total_count = Count_column)
  .test <- .test %>% dplyr::select(year, stream_name, total_count)
  .test <- .test %>% mutate(imputed = is.na(total_count))

  # Step 2: Use multiplicative imputation as per Blick, in an iterative procedure
  j=1
  repeat{
    for(i in 1:nrow(.test %>% filter(year < 2000))){
      .temprow = .test[i,]
      if(.temprow$imputed == TRUE){
        .test_early <- .test %>% filter(year < 2000)
        .sumyr = sum((.test_early %>% filter(year == .temprow$year) )$total_count, na.rm = TRUE)
        .sumrvr = sum((.test_early %>% filter(stream_name == .temprow$stream_name) )$total_count, na.rm = TRUE)
        .sumall = sum(.test_early$total_count, na.rm = TRUE)
        .test$total_count[i] = .sumyr * .sumrvr / .sumall
      }
    }
    j=j+1
    if(j>100){break} # repeat the above 100 times. Needs to be iterative (imputing depends on other imputed values)
  }# end early

  j=1
  repeat{
    for(i in (nrow(.test %>% filter(year < 2000))+1):nrow(.test)){
      .temprow = .test[i,]
      if(.temprow$imputed == TRUE){
        .curryr <- .temprow$year
        .yr_range = .test %>% filter(year <= .curryr) #5 yrs before / after
        .sumyr = sum((.yr_range %>% filter(year == .temprow$year) )$total_count, na.rm = TRUE)
        .sumrvr = sum((.yr_range %>% filter(stream_name == .temprow$stream_name) )$total_count, na.rm = TRUE)
        .sumall = sum(.yr_range$total_count, na.rm = TRUE)
        .test$total_count[i] = .sumyr * .sumrvr / .sumall
        # this is multiplicative imputation as per Blick
      }
    }
    j=j+1
    if(j>100){break} # repeat the above 100 times. Needs to be iterative (imputing depends on other imputed values)
  }
  print(.test)
}






#' 10-yr Localized Imputation
#' This takes a dataframe with NA values and imputes missing data.
#' This algorithm uses "local" imputation: only 5 years before and
#' after impute a missing value, i.e., only using the preceding
#' 5 years and following 5 years. Make sure that all NAs are present
#' (a missing row is NOT same as a row with an NA)
#'
#' @param dfname The name of the dataframe
#' @param Year_column The name of the column with the year (i.e., impute criteria 1)
#' @param StreamName_column The name of the column with the stream name (i.e., impute criteria 2)
#' @param count_column The name of the column with the counts to impute.
#'
#'
#' @return
#' @export
#'
#' @importFrom dplyr rename select mutate filter
#' @importFrom magrittr "%>%"
#'
#' @examples
#' impute_local(ktn_index, Year_column="year")
impute_local <- function(dfname,
                         Year_column="year",
                         StreamName_column="stream_name",
                         Count_column = "total_count"){

  # Step 1: Set up dataframe to impute
  .test <- dfname %>% rename(year = Year_column,
                             stream_name = StreamName_column,
                             total_count = Count_column)
  .test <- .test %>% dplyr::select(year, stream_name, total_count)
  .test <- .test %>% mutate(imputed = is.na(total_count))

  # Step 2: Use multiplicative imputation as per Blick, in an iterative procedure
  j=1
  repeat{
    for(i in 1:nrow(.test)){
      .temprow = .test[i,]

      if(.temprow$imputed == TRUE){
        .yr_range = .test %>% filter(between(year, .temprow$year - 5, .temprow$year + 5)) #5 yrs before / after
        .sumyr = sum((.yr_range %>% filter(year == .temprow$year) )$total_count, na.rm = TRUE)
        .sumrvr = sum((.yr_range %>% filter(stream_name == .temprow$stream_name) )$total_count, na.rm = TRUE)
        .sumall = sum(.yr_range$total_count, na.rm = TRUE)
        .test$total_count[i] = .sumyr * .sumrvr / .sumall
        # this is multiplicative imputation as per Blick
      }
    }
    j=j+1
    if(j>100){break} # repeat the above 100 times
  }
  print(.test)

}





#' 10-yr Localized Imputation, improved
#' This takes a dataframe with NA values and imputes missing data.
#' This algorithm uses "local" imputation: only 5 years before and
#' after impute a missing value, i.e., only using the preceding
#' 5 years and following 5 years (similar to impute_local()).
#' However this version adds a rule for early years (1987-1996)
#' to use 10 next years (10-year minimum). Make sure that all
#' NAs are present (a missing row is NOT same as a row with an NA)
#'
#' @param dfname The name of the dataframe
#' @param Year_column The name of the column with the year (i.e., impute criteria 1)
#' @param StreamName_column The name of the column with the stream name (i.e., impute criteria 2)
#' @param count_column The name of the column with the counts to impute.
#'
#'
#' @return
#' @export
#'
#' @importFrom dplyr rename select mutate filter
#' @importFrom magrittr "%>%"
#'
#' @examples
#' impute_local_improved(ktn_index, Year_column="year")
impute_local_improved <- function(dfname,
                                  Year_column="year",
                                  StreamName_column="stream_name",
                                  Count_column = "total_count"){

  # Step 1: Set up dataframe to impute
  .test <- dfname %>% rename(year = Year_column, stream_name = StreamName_column, total_count = Count_column)
  .test <- .test %>% dplyr::select(year, stream_name, total_count)
  .test <- .test %>% mutate(imputed = is.na(total_count))

  # Step 2: Use multiplicative imputation as per Blick, in an iterative procedure
  j=1
  repeat{
    for(i in 1:nrow(.test)){
      .temprow = .test[i,]

      if(.test$year < 1997){
        if(.temprow$imputed == TRUE){
          .test_early <- .test %>% filter(year < 1997)
          .sumyr = sum((.test_early %>% filter(year == .temprow$year) )$total_count, na.rm = TRUE)
          .sumrvr = sum((.test_early %>% filter(stream_name == .temprow$stream_name) )$total_count, na.rm = TRUE)
          .sumall = sum(.test_early$total_count, na.rm = TRUE)
          .test$total_count[i] = .sumyr * .sumrvr / .sumall
        } # end early
      }}
    j=j+1
    if(j>50){break} # repeat the above 50 times. Needs to be iterative (imputing depends on other imputed values)
  }# end early

  j=1
  repeat{
    for(i in (nrow(.test %>% filter(year < 1997))+1):nrow(.test)){
      .temprow = .test[i,]
      if(.temprow$imputed == TRUE){
        .yr_range = .test %>% filter(between(year, .temprow$year - 5, .temprow$year + 5)) #5 yrs before / after
        .sumyr = sum((.yr_range %>% filter(year == .temprow$year) )$total_count, na.rm = TRUE)
        .sumrvr = sum((.yr_range %>% filter(stream_name == .temprow$stream_name) )$total_count, na.rm = TRUE)
        .sumall = sum(.yr_range$total_count, na.rm = TRUE)
        .test$total_count[i] = .sumyr * .sumrvr / .sumall
        # this is multiplicative imputation as per Blick
      }
    }
    j=j+1
    if(j>50){break} # repeat the above 50 times. Needs to be iterative (imputing depends on other imputed values)
  } # end late
  print(.test)
}
