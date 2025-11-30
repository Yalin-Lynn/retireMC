# Simple demonstration of retireMC package
# This script demonstrates how to run a basic retirement simulation

library(retireMC)

# 1. Setup Parameters
cat("Initializing parameters...\n")
initial_wealth <- 1000000
years <- 30
withdraw <- 60000

# 2. Run Simulation
cat("Running Monte Carlo simulation...\n")
res <- run_mc(initial = initial_wealth, n_years = years, withdraw = withdraw)

# 3. Display Results
cat("Simulation complete!\n")
cat(paste("Success Rate:", res$metrics$success_rate * 100, "%\n"))

# 4. Plot Results
# Note: Demos usually pause before plotting, but here we generate it directly if interactive
if (interactive()) {
  plot_percentile_bands(res$wealth)
}