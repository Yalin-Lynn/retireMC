#' Run a full Monte Carlo experiment
#' @param initial numeric initial wealth
#' @param n_years integer
#' @param n_sims integer
#' @param withdraw numeric annual withdrawal (first-year amount)
#' @param infl_rate numeric annual inflation for withdrawal
#' @param returns_args list additional args forwarded to simulate_returns (e.g., mu, sigma, model)
#' @param seed integer seed for reproducibility (optional)
#' @return list with wealth matrix and metrics
#' @export
run_mc <- function(initial = 1e6, n_years = 30, n_sims = 5000, withdraw = 60000,
                   infl_rate = 0.02, returns_args = list(), seed = NULL) {
  if (!is.null(seed)) returns_args$seed <- seed
  
  # 1. Simulate Returns
  returns <- do.call(simulate_returns, c(list(n_years = n_years, n_sims = n_sims), returns_args))
  
  # 2. Build Inflation-Adjusted Withdrawal Vector
  withdraw_vec <- withdraw * (1 + infl_rate)^(0:(n_years-1))
  
  # 3. Simulate Wealth Paths
  wealth <- simulate_wealth(initial = initial, returns = returns, contrib = 0,
                            withdraw = withdraw_vec, withdraw_timing = "start", floor_zero = TRUE)
  
  # 4. Compute Metrics
  metrics <- compute_ruin(wealth)
  
  return(list(wealth = wealth, metrics = metrics))
}