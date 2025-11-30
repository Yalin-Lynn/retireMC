#' Load S&P 500 annual returns sample data
#'
#' @return A numeric vector of annual returns
#' @export
#'
sp500_annual_sample <- function() {
  # 获取数据文件路径
  data_path <- system.file("extdata", "sp500_annual_sample.csv", 
                           package = "retireMC")
  
  # 检查文件是否存在
  if (!file.exists(data_path)) {
    stop("S&P 500 data file not found. Expected at: ", data_path)
  }
  
  # 读取数据
  sp500_data <- read.csv(data_path)
  
  # 返回收益向量
  return(sp500_data$return)
}

#' Get full S&P 500 data with years
#'
#' @return A data frame with year and return columns
#' @export
#'
sp500_annual_data <- function() {
  data_path <- system.file("extdata", "sp500_annual_sample.csv", 
                           package = "retireMC")
  
  if (!file.exists(data_path)) {
    stop("S&P 500 data file not found.")
  }
  
  return(read.csv(data_path))
}