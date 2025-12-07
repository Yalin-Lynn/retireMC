#' Get S&P 500 Annual Returns Sample Vector
#'
#' Returns a numeric vector of historical S&P 500 annual returns.
#'
#' @return A numeric vector of historical returns.
#' @export
#' @importFrom utils read.csv
sp500_annual_sample <- function() {
  
  data_file <- system.file("extdata/sp500_data.csv", package = "retireMC")
  
  if (!file.exists(data_file)) {
    stop("S&P 500 data file not found.")
  }
  
  df <- read.csv(data_file, header = TRUE)
  
  if ("Return" %in% colnames(df)) {
    returns <- df$Return
  } else if (ncol(df) == 2) {
    
    returns <- df[, 2]
  } else {
    
    returns <- df[, 1]
  }
  
 
  returns <- as.numeric(returns)
  returns <- returns[!is.na(returns)]
  
  
  if (length(returns) == 0) {
    stop("No valid return data found.")
  }
  
  return(returns)
}