missing_demo_data <- function() {
  data.frame(
    num = c(1, 2, 3, NA, 100),
    chr = c("a", NA, "c", "d", "e"),
    stringsAsFactors = FALSE
  )
}

test_that("impute_mean_vars() fills numeric NAs with the column mean", {
  env <- cata_app_env("app-function.R")
  df <- missing_demo_data()

  out <- env$impute_mean_vars(df, "num")
  expect_false(anyNA(out$num))
  expect_equal(out$num[4], mean(df$num, na.rm = TRUE))
  # Other columns are untouched.
  expect_identical(out$chr, df$chr)
})

test_that("impute_median_vars() fills numeric NAs with the column median", {
  env <- cata_app_env("app-function.R")
  df <- missing_demo_data()

  out <- env$impute_median_vars(df, "num")
  expect_false(anyNA(out$num))
  expect_equal(out$num[4], median(df$num, na.rm = TRUE))
})

test_that("imputation ignores character columns and unknown variable names", {
  env <- cata_app_env("app-function.R")
  df <- missing_demo_data()

  expect_identical(env$impute_mean_vars(df, "chr")$chr, df$chr)
  expect_identical(env$impute_mean_vars(df, character(0)), df)
  expect_identical(env$impute_mean_vars(df, "not_a_column"), df)
  expect_identical(env$impute_median_vars(df, "not_a_column"), df)
})

test_that("imputation keeps all-NA numeric columns as NA", {
  env <- cata_app_env("app-function.R")
  df <- data.frame(num = c(NA_real_, NA_real_))

  expect_true(all(is.na(env$impute_mean_vars(df, "num")$num)))
  expect_true(all(is.na(env$impute_median_vars(df, "num")$num)))
})
