test_that("recognize_outlier() flags IQR outliers and keeps everything else", {
  env <- cata_app_env("app-function.R")
  vec <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 100)

  keep <- env$recognize_outlier(vec)
  expect_type(keep, "logical")
  expect_length(keep, length(vec))
  expect_false(keep[10])
  expect_true(all(keep[1:9]))

  # A wide enough fence keeps every value.
  expect_true(all(env$recognize_outlier(vec, k = 25)))
})

test_that("recognize_outlier() treats NA and non-numeric input as 'keep'", {
  env <- cata_app_env("app-function.R")

  expect_true(all(env$recognize_outlier(c(letters[1:3]))))
  expect_true(all(env$recognize_outlier(c(NA_real_, NA_real_))))
  expect_true(env$recognize_outlier(c(1, 2, 3, NA, 5))[4])
})

test_that("winsorize() caps values at the IQR fences", {
  env <- cata_app_env("app-function.R")
  vec <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 100)

  out <- env$winsorize(vec)
  expect_length(out, length(vec))
  expect_lt(out[10], 100)
  expect_equal(out[1:9], vec[1:9])
  expect_true(all(env$recognize_outlier(out)))
})

test_that("winsorize() leaves NA and non-numeric input untouched", {
  env <- cata_app_env("app-function.R")

  expect_identical(env$winsorize(letters[1:3]), letters[1:3])
  expect_identical(env$winsorize(c(NA_real_, NA_real_)), c(NA_real_, NA_real_))
  expect_true(is.na(env$winsorize(c(1, 2, 3, NA, 100))[4]))
})

test_that("recognize_outlier_variable() returns only numeric columns with outliers", {
  env <- cata_app_env("app-function.R")

  expect_identical(env$recognize_outlier_variable(outlier_demo_data()), "value")
  expect_identical(
    env$recognize_outlier_variable(data.frame(label = letters[1:5])),
    character(0)
  )
  expect_identical(env$recognize_outlier_variable(NULL), character(0))
  expect_identical(env$recognize_outlier_variable(data.frame()), character(0))
})

test_that("any_outlier() answers the yes/no question the app asks", {
  env <- cata_app_env("app-function.R")

  expect_true(env$any_outlier(outlier_demo_data()))
  expect_false(env$any_outlier(data.frame(plain = 1:10)))
  expect_false(env$any_outlier(NULL))
  expect_false(env$any_outlier(data.frame()))
})
