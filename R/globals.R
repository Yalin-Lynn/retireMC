#' @importFrom stats median quantile rnorm
#' @importFrom utils head tail
#' @importFrom tibble tibble
#' 
utils::globalVariables(c(
  "year", 
  "p05", 
  "p25", 
  "median", 
  "p75", 
  "p95", 
  "wealth", 
  "sim", 
  "return"
))