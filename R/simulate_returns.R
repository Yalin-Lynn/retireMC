#' Simulate returns (GBM or empirical resampling)
#' @importFrom stats rnorm
#' @param n_years integer number of years to simulate
#' @param n_sims integer number of Monte Carlo paths
#' @param model character, "gbm" or "empirical"
#' @param mu numeric expected annual return (for gbm)
#' @param sigma numeric annual volatility (for gbm)
#' @param dt numeric time-step in years (default 1)
#' @param empirical_returns numeric vector of returns used when model=="empirical" 
#' @param seed integer seed for reproducibility (optional)
#' @return matrix of gross returns (n_years x n_sims); each entry is (1 + r_t)
#' @export
simulate_returns <- function(n_years, n_sims, model = "gbm",
                             mu = 0.07, sigma = 0.15, dt = 1,
                             empirical_returns = NULL, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  if (!(model %in% c("gbm", "empirical"))) stop("model must be 'gbm' or 'empirical'")
  
  if (model == "gbm") {
    # Geometric Brownian Motion (GBM)
    # R_t = exp((mu - 0.5 * sigma^2) * dt + sigma * sqrt(dt) * Z_t)
    Z <- matrix(rnorm(n_years * n_sims), nrow = n_years, ncol = n_sims)
    drift <- (mu - 0.5 * sigma^2) * dt
    vol <- sigma * sqrt(dt)
    gross <- exp(drift + vol * Z)
    return(gross)
  } else {
    # Empirical Resampling (Bootstrapping)
    
    # 1. Determine the source of historical returns
    if (is.null(empirical_returns)) {
      # This block assumes the function sp500_annual_sample() exists
      # and correctly returns a numeric vector of returns.
      if (!exists("sp500_annual_sample", mode = "function", inherits = TRUE)) {
        stop("Internal historical data function 'sp500_annual_sample' is unavailable. 
             Ensure the package is correctly installed or provide 'empirical_returns'.")
      }
      # *** KEY FIX: Call the function to get the data vector ***
      returns_source <- sp500_annual_sample()
      
      # NOTE: For proper package use, you might need to use :: if not imported:
      # returns_source <- retireMC::sp500_annual_sample()
    } else {
      returns_source <- empirical_returns
    }
    
    # 2. Ensure returns_source is a valid vector
    # We use as.numeric() to safely convert potential tibbles/data.frame columns
    returns_source <- as.numeric(returns_source)
    if (!is.vector(returns_source) || length(returns_source) == 0 || any(!is.finite(returns_source))) {
      stop("Historical returns data is invalid, empty, or contains non-finite values.")
    }
    
    # Convert returns (r) to gross returns (1 + r) for resampling
    gross_returns_source <- 1 + returns_source
    
    # 3. Perform empirical resampling (bootstrapping)
    # Select indices for n_years * n_sims samples with replacement
    idx <- matrix(sample(seq_along(gross_returns_source), 
                         size = n_years * n_sims, 
                         replace = TRUE),
                  nrow = n_years, 
                  ncol = n_sims)
    
    # Map indices back to gross returns to form the simulation matrix
    gross <- matrix(gross_returns_source[idx], nrow = n_years, ncol = n_sims)
    return(gross)
  }
}