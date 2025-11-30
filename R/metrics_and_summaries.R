#' Compute ruin metrics and basic summaries
#'
#' @param wealth matrix (n_years + 1) x n_sims from simulate_wealth
#' @param ruin_threshold numeric threshold considered ruin (default 0)
#' @return a list with elements: ruin_prob_by_year (vector length n_years), success_rate, final_summary (tibble)
#' @examples
#' R <- simulate_returns(30, 200)
#' W <- simulate_wealth(1e6, R, withdraw = 60000)
#' compute_ruin(W)
#' @export
compute_ruin <- function(wealth, ruin_threshold = 0) {
  # wealth rows: 1..(n_years+1). We consider ruin if any year wealth <= threshold
  n_sims <- ncol(wealth)
  ruined <- apply(wealth <= ruin_threshold, 2, any)
  success_rate <- sum(!ruined) / n_sims
  # ruin probability by year: proportion of sims that are <= threshold at that year
  ruin_prob_by_year <- rowMeans(wealth[-1, ] <= ruin_threshold)  # exclude initial
  final_wealth <- wealth[nrow(wealth), ]
  
  return(list(
    success_rate = success_rate,
    ruin_prob_by_year = ruin_prob_by_year,
    final_wealth = final_wealth
  ))
}

#' Summarize multiple simulations as a tibble
#' @param wealth matrix returned by simulate_wealth
#' @importFrom magrittr %>%
#' @export
#' @importFrom stats rnorm quantile median
summarize_simulations <- function(wealth) {
  n_years <- nrow(wealth) - 1
  years <- 0:n_years
  df <- as.data.frame(wealth)
  colnames(df) <- paste0("sim_", seq_len(ncol(df)))
  df$year <- years
  
  # Use dplyr and tidyr to summarize
  tib <- df %>%
    tidyr::pivot_longer(cols = dplyr::starts_with("sim_"), names_to = "sim", values_to = "wealth") %>%
    dplyr::group_by(year) %>%
    dplyr::summarise(p05 = quantile(wealth, 0.05),
                     p25 = quantile(wealth, 0.25),
                     median = quantile(wealth, 0.5),
                     p75 = quantile(wealth, 0.75),
                     p95 = quantile(wealth, 0.95),
                     mean = mean(wealth), .groups = "drop")
  return(tib)
}