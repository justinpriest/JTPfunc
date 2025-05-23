% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/impute_functions.R
\name{impute_global}
\alias{impute_global}
\title{Global Impute}
\usage{
impute_global(
  dfname,
  Year_column = "year",
  StreamName_column = "stream_name",
  outputname = "globalimpute",
  count_column = "total_count"
)
}
\arguments{
\item{dfname}{The name of the dataframe}

\item{Year_column}{The name of the column with the year (i.e., impute criteria 1)}

\item{StreamName_column}{The name of the column with the stream name (i.e., impute criteria 2)}

\item{outputname}{Vestigial.}

\item{count_column}{The name of the column with the counts to impute.}
}
\value{

}
\description{
This creates a dataframe that imputes NA values across all available years and rivers.
This algorithm interpolates across rows and columns, following Blick.
In essence, imputing across rows (years) and columns (streams) allows for an NA in
a year/stream to be informed by typical counts and for that year AND stream
This function can be easily modified to auto-create a named dataframe
Make sure that all NAs are present (a missing row is NOT same as a row with an NA)
}
\examples{
impute_global(ktn_index, StreamName_column = "River", Year_column = "year")
}
