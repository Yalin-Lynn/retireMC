#' Plot percentile bands for wealth trajectories
#' @param wealth matrix from simulate_wealth
#' @return ggplot object
#' @export
plot_percentile_bands <- function(wealth) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("ggplot2 package is required for plotting")
  }
  
  tib <- summarize_simulations(wealth)
  
  p <- ggplot2::ggplot(tib, ggplot2::aes(x = year)) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = p05, ymax = p95), 
                         alpha = 0.2, fill = 'blue') +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = p25, ymax = p75), 
                         alpha = 0.3, fill = 'blue') +
    ggplot2::geom_line(ggplot2::aes(y = median), size = 1, color = 'red') +
    ggplot2::theme_minimal() +
    ggplot2::labs(title = 'Monte Carlo Wealth Simulation', 
                  subtitle = 'Red line = Median; Bands = 5th-95th Percentiles',
                  y = 'Wealth ($)', x = 'Year')
  
  print(p)
  return(invisible(p))
}