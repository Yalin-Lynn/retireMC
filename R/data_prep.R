#' Get S&P 500 Annual Data
#'
#' Returns the full historical S&P 500 annual returns data frame.
#'
#' @return A data frame with columns 'Year' and 'Return'.
#' @export
sp500_annual_data <- function() {
  data_file <- system.file("extdata/sp500_data.csv", package = "retireMC")
  
  if (!file.exists(data_file)) {
    stop("S&P 500 data file not found. Expected at: ", data_file)
  }
  
  read.csv(data_file)
}

#' Get S&P 500 Annual Returns Sample Vector
#'
#' Returns a numeric vector of historical S&P 500 annual returns.
#'
#' @return A numeric vector of historical returns.
#' @export
sp500_annual_sample <- function() {
  df <- sp500_annual_data()
  return(df$Return)
}