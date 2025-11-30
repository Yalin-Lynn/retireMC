test_that('Basic GBM Logic', {
  # If volatility is 0 and return is 0, wealth should flatline (minus withdrawal)
  ret <- simulate_returns(5, 10, model='gbm', mu=0, sigma=0)
  expect_true(all(abs(ret - 1) < 1e-10))
})

test_that("wealth grows with positive returns and zero withdraw", {
  R <- matrix(1.05, nrow = 3, ncol = 5) # constant +5% gross each year
  W <- simulate_wealth(100, R, contrib = 0, withdraw = 0, withdraw_timing = "end")
  # final wealth should be 100 * 1.05^3
  expect_equal(as.numeric(W[nrow(W), 1]), 100 * 1.05^3)
})

test_that('Bankruptcy Check', {
  # Force bankruptcy
  W <- simulate_wealth(100, matrix(0.5, 5, 5), withdraw = 500)
  # Should be 0 at the end, not negative
  expect_true(all(W[nrow(W),] == 0))
})