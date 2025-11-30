#' Simulate wealth trajectories given returns, contributions and withdrawals
#'
#' @param initial numeric initial wealth (W0)
#' @param returns matrix of gross returns (n_years x n_sims), as returned by simulate_returns
#' @param contrib numeric scalar or vector length n_years (positive = deposit)
#' @param withdraw numeric scalar or vector length n_years (positive = cash out)
#' @param withdraw_timing character "start" or "end" indicating when withdrawal occurs within year (default "start")
#' @param floor_zero logical; if TRUE, wealth floors at 0 (no negative balances)
#' @return matrix of wealth values (n_years + 1 rows x n_sims columns). Row 1 is initial wealth.
#' @examples
#' R <- simulate_returns(30, 100, seed = 1)
#' simulate_wealth(1e6, R, contrib = 0, withdraw = 60000)
#' @export
simulate_wealth <- function(initial, returns, contrib = 0, withdraw = 0,
                            withdraw_timing = c("start", "end"), floor_zero = TRUE) {
  withdraw_timing <- match.arg(withdraw_timing)
  n_years <- nrow(returns)
  n_sims <- ncol(returns)
  W <- matrix(NA_real_, nrow = n_years + 1, ncol = n_sims)
  W[1, ] <- initial
  contrib_vec <- if (length(contrib) == 1) rep(contrib, n_years) else contrib
  withdraw_vec <- if (length(withdraw) == 1) rep(withdraw, n_years) else withdraw
  if (length(contrib_vec) != n_years) stop("contrib must be length 1 or n_years")
  if (length(withdraw_vec) != n_years) stop("withdraw must be length 1 or n_years")
  
  for (t in seq_len(n_years)) {
    if (withdraw_timing == "start") {
      # withdrawal/contribution at start of year
      W[t, ] <- W[t, ] - withdraw_vec[t]
      W[t, ] <- W[t, ] + contrib_vec[t]
      # apply returns
      W[t + 1, ] <- W[t, ] * returns[t, ]
    } else {
      # withdrawal/contribution at end of year: growth first
      W[t, ] <- W[t, ] + contrib_vec[t]
      W[t + 1, ] <- W[t, ] * returns[t, ]
      W[t + 1, ] <- W[t + 1, ] - withdraw_vec[t]
    }
    if (floor_zero) {
      W[t + 1, ][W[t + 1, ] < 0] <- 0
    }
  }
  return(W)
}