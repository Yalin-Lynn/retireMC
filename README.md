# retireMC: Monte Carlo Retirement Planning in R
## 🆕 Latest Updates

**2025-12-06**  
- Updated S&P 500 dataset to the latest version  
- Updated vignette with new examples and improved usage guide
  
An R package for stochastic retirement planning using Monte Carlo simulation. Quantifies sequence-of-returns risk and provides probabilistic retirement outcomes.

## Installation

You can install the development version from GitHub:

```r
# Install devtools if not already installed
if (!require("devtools")) {
  install.packages("devtools")
}

# Install retireMC from GitHub
devtools::install_github("yalin-lynn/retireMC")
```
### Dependencies

This package requires the following R packages:

ggplot2 (for plotting)

dplyr (for data manipulation)

tidyr (for data reshaping)

tibble (for data frames)

magrittr (for pipe operator)

These will be installed automatically when you install retireMC.

### Features

Dual Return Models: Geometric Brownian Motion and empirical resampling

Flexible Withdrawal Strategies: Constant, inflation-adjusted withdrawals

Comprehensive Risk Metrics: Success rates, ruin probabilities, wealth distributions

Professional Visualization: Percentile bands and trajectory plots

Historical Data: Built-in S&P 500 data (1928-2023) for empirical analysis

### Quick Start

```{r}
library(retireMC)

# Basic Monte Carlo simulation
results <- run_mc(
  initial = 1000000,    # $1,000,000 initial portfolio
  n_years = 30,         # 30-year retirement horizon
  n_sims = 5000,        # 5,000 simulations
  withdraw = 60000,     # $60,000 annual withdrawal
  infl_rate = 0.02,     # 2% inflation adjustment
  returns_args = list(
    model = "gbm",      # Use GBM model
    mu = 0.07,          # 7% expected return
    sigma = 0.15        # 15% volatility
  )
)

# View results
cat("Success rate:", round(results$metrics$success_rate * 100, 1), "%\n")

# Create visualization
plot_percentile_bands(results$wealth)
```

### Using Historical Data

```{r}
# Use updated S&P 500 historical returns(1928-2023)
sp500_returns <- sp500_annual_sample()

results_historical <- run_mc(
  initial = 1000000,
  n_years = 30,
  n_sims = 5000,
  withdraw = 60000,
  infl_rate = 0.02,
  returns_args = list(
    model = "empirical",
    empirical_returns = sp500_returns
  )
)

cat("Historical data success rate:", 
    round(results_historical$metrics$success_rate * 100, 1), "%\n")
```

### Core Functions

simulate_returns()

Generate stochastic market returns using GBM or empirical resampling.

```{r}
returns <- simulate_returns(
  n_years = 30,
  n_sims = 1000,
  model = "gbm",        # or "empirical"
  mu = 0.07,
  sigma = 0.15
)
```

simulate_wealth()

Project wealth trajectories given returns and withdrawal strategy.

```{r}
wealth <- simulate_wealth(
  initial = 1000000,
  returns = returns,
  withdraw = 60000,
  withdraw_timing = "start"  # or "end"
)
```

compute_ruin()

Calculate retirement success metrics and ruin probabilities.

```{r}
metrics <- compute_ruin(wealth)
success_rate <- metrics$success_rate
ruin_by_year <- metrics$ruin_prob_by_year
```

plot_percentile_bands()

Visualize Monte Carlo simulation results.

```{r}
plot_percentile_bands(wealth)
```

run_mc()

Complete workflow function for retirement analysis.

```{r}
results <- run_mc(initial = 1000000, n_years = 30, withdraw = 60000)
```

Data Functions

```{r}
# Get S&P 500 returns vector for simulations
returns_vector <- sp500_annual_sample()

# Get full dataset with years
full_data <- sp500_annual_data()
print(full_data)
```

### Data

The package includes annual S&P 500 returns from 1928-2023:

| Year | Return |
|------|--------|
| 1928 | 0.3788 |
| 1929 | -0.1190 |
| 1930 | -0.2848 |
| 1931 | -0.4706 |
| 1932 | -0.1477 |
| 1933 | 0.4407 |
| 1934 | -0.0471 |
| 1935 | 0.4136 |
| 1936 | 0.2792 |
| 1937 | -0.3859 |
| 1938 | 0.2454 |
| 1939 | -0.0517 |
| 1940 | -0.1508 |
...
| 2023 | 0.1153 |


### Examples

### Sensitivity Analysis

```{r}
# Test different withdrawal rates
withdrawal_rates <- c(40000, 50000, 60000)

for (rate in withdrawal_rates) {
  results <- run_mc(
    initial = 1000000,
    n_years = 30,
    n_sims = 1000,
    withdraw = rate,
    returns_args = list(model = "gbm", mu = 0.07, sigma = 0.15)
  )
  cat("$", rate, " withdrawal: ", 
      round(results$metrics$success_rate * 100, 1), "% success rate\n", sep = "")
}
```
### Compare Models
```{r}
# Compare GBM vs historical models
gbm_results <- run_mc(initial = 1000000, n_years = 30, n_sims = 1000,
                     returns_args = list(model = "gbm", mu = 0.07, sigma = 0.15))

historical_results <- run_mc(initial = 1000000, n_years = 30, n_sims = 1000,
                           returns_args = list(model = "empirical",
                                             empirical_returns = sp500_annual_sample()))

cat("GBM success rate:", round(gbm_results$metrics$success_rate * 100, 1), "%\n")
cat("Historical success rate:", round(historical_results$metrics$success_rate * 100, 1), "%\n")
```

### Wealth Distribution Analysis
```{r}
# Analyze final wealth distribution
results <- run_mc(initial = 1000000, n_years = 30, n_sims = 5000, withdraw = 60000)
final_wealth <- results$wealth[31, ]

cat("Final Wealth Distribution:\n")
cat("5th percentile: $", round(quantile(final_wealth, 0.05), 0), "\n")
cat("Median: $", round(median(final_wealth), 0), "\n")
cat("95th percentile: $", round(quantile(final_wealth, 0.95), 0), "\n")
```
### Methodology

### Geometric Brownian Motion

Returns are simulated using:

$$R_t = e^{\left(\mu - \frac{\sigma^2}{2}\right) + \sigma Z_t}
$$
 ∼N(0,1).

### Empirical Resampling

Historical returns are sampled with replacement to preserve actual market patterns including volatility clustering and tail events.

### Package Structure
```
retireMC/
├── R/
│   ├── simulate_returns.R
│   ├── simulate_wealth.R
│   ├── sp500_data.R
│   ├── metrics_and_summaries.R
│   ├── plotting.R
│   ├── utils.R
│   └── globals.R
│   └──sp500_annual_sample.R
│   └──data_prep.R
├── inst/extdata/
│   └── sp500_data.csv
├── man/
│   └── (documentation files)
├── tests/
│   └── testthat.R
└── vignettes/
    └── introduction.Rmd
```
