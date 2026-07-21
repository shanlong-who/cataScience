test_that("safe_import_data() reads the bundled Excel example data", {
  env <- cata_app_env("app-function.R")

  df <- env$safe_import_data("data/cat-dirty-data.xlsx")
  expect_s3_class(df, "tbl_df")
  expect_gt(nrow(df), 0)
  expect_gt(ncol(df), 0)
})

test_that("safe_import_data() reads the bundled CSV example data", {
  env <- cata_app_env("app-function.R")

  df <- env$safe_import_data("data/test-scatter.csv")
  expect_s3_class(df, "tbl_df")
  expect_gt(nrow(df), 0)
})

test_that("safe_import_data() gives a readable error for a missing file", {
  env <- cata_app_env("app-function.R")

  expect_error(env$safe_import_data(NULL), "valid file")
  expect_error(env$safe_import_data("data/no-such-file.xlsx"), "valid file")
})

test_that("every bundled example dataset still imports", {
  env <- cata_app_env("app-function.R")
  files <- list.files("data", full.names = TRUE)
  expect_gt(length(files), 0)

  for (f in files) {
    df <- env$safe_import_data(f)
    expect_s3_class(df, "tbl_df")
    expect_gt(ncol(df), 0)
  }
})
