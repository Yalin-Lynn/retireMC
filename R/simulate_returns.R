#' Simulate returns (GBM or empirical resampling)
#' @importFrom stats rnorm quantile median
#' @param n_years integer number of years to simulate
#' @param n_sims integer number of Monte Carlo paths
#' @param model character, "gbm" or "empirical"
#' @param mu numeric expected annual return (for gbm)
#' @param sigma numeric annual volatility (for gbm)
#' @param dt numeric time-step in years (default 1)
#' @param empirical_returns numeric vector of returns used when model=="empirical" (e.g., c(0.10, -0.05, ...))
#' @param seed integer seed for reproducibility (optional)
#' @return matrix of gross returns (n_years x n_sims); each entry is (1 + r_t)
#' @examples
#' simulate_returns(30, 1000, model = "gbm", mu = 0.07, sigma = 0.15)
#' @export
simulate_returns <- function(n_years, n_sims, model = "gbm",
                             mu = 0.07, sigma = 0.15, dt = 1,
                             empirical_returns = NULL, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  if (!(model %in% c("gbm", "empirical"))) stop("model must be 'gbm' or 'empirical'")
  if (model == "gbm") {
    Z <- matrix(rnorm(n_years * n_sims), nrow = n_years, ncol = n_sims)
    drift <- (mu - 0.5 * sigma^2) * dt
    vol <- sigma * sqrt(dt)
    gross <- exp(drift + vol * Z)  # multiplicative gross returns
    return(gross)
  } else {
    if (is.null(empirical_returns)) stop("empirical_returns required for model = 'empirical'")
    idx <- matrix(sample(seq_along(empirical_returns), size = n_years * n_sims, replace = TRUE),
                  nrow = n_years, ncol = n_sims)
    gross <- matrix(1 + empirical_returns[idx], nrow = n_years, ncol = n_sims)
    return(gross)
  }
}