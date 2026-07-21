# The cleaning module carries the data-preparation logic of the app: import,
# missing values, outliers and text cleaning. Each step is driven through
# shiny::testServer() with the example dataset shipped in inst/app/data.

cleaning_args <- function(rv) {
  list(
    data_rv = rv,
    demo_file = "data/cat-dirty-data.xlsx"
  )
}

test_that("the example dataset loads through the import button", {
  env <- cata_app_env(c("app-function.R", "mod-cleaning.R"))
  rv <- shiny::reactiveVal()

  shiny::testServer(env$cleaningServer, args = cleaning_args(rv), {
    session$setInputs(demo = 1)
    df <- rv()
    expect_s3_class(df, "tbl_df")
    expect_equal(nrow(df), 31)
    expect_true("weight_kg" %in% names(df))
    expect_true(anyNA(df$weight_kg))
  })
})

test_that("dropping rows with missing values removes them from the dataset", {
  env <- cata_app_env(c("app-function.R", "mod-cleaning.R"))
  rv <- shiny::reactiveVal()

  shiny::testServer(env$cleaningServer, args = cleaning_args(rv), {
    session$setInputs(demo = 1)
    n_before <- nrow(rv())

    session$setInputs(
      missing_variable = "All",
      deal_missing_method = "drop_na",
      apply_missing = 1
    )

    expect_false(anyNA(rv()))
    expect_lt(nrow(rv()), n_before)
  })
})

test_that("mean and median imputation keep every row", {
  env <- cata_app_env(c("app-function.R", "mod-cleaning.R"))

  for (method in c("mean", "median")) {
    rv <- shiny::reactiveVal()
    shiny::testServer(env$cleaningServer, args = cleaning_args(rv), {
      session$setInputs(demo = 1)
      n_before <- nrow(rv())

      session$setInputs(
        missing_variable = "weight_kg",
        deal_missing_method = method,
        apply_missing = 1
      )

      expect_equal(nrow(rv()), n_before)
      expect_false(anyNA(rv()$weight_kg))
    })
  }
})

test_that("winsorizing removes the outliers the app reports", {
  env <- cata_app_env(c("app-function.R", "mod-cleaning.R"))
  rv <- shiny::reactiveVal()

  shiny::testServer(env$cleaningServer, args = cleaning_args(rv), {
    session$setInputs(demo = 1)
    session$setInputs(
      missing_variable = "All",
      deal_missing_method = "drop_na",
      apply_missing = 1
    )
    expect_true(env$any_outlier(rv()))
    n_before <- nrow(rv())
    max_before <- max(rv()$weight_kg)

    session$setInputs(
      outlier_variable = "All",
      deal_outlier_method = "winsorize",
      apply_outlier = 1
    )

    expect_equal(nrow(rv()), n_before)
    expect_lt(max(rv()$weight_kg), max_before)
    expect_false(env$any_outlier(rv()))
  })
})

test_that("removing outliers drops rows but keeps the columns", {
  env <- cata_app_env(c("app-function.R", "mod-cleaning.R"))
  rv <- shiny::reactiveVal()

  shiny::testServer(env$cleaningServer, args = cleaning_args(rv), {
    session$setInputs(demo = 1)
    session$setInputs(
      missing_variable = "All",
      deal_missing_method = "drop_na",
      apply_missing = 1
    )
    n_before <- nrow(rv())
    vars_before <- names(rv())

    session$setInputs(
      outlier_variable = "All",
      deal_outlier_method = "remove",
      apply_outlier = 1
    )

    expect_lt(nrow(rv()), n_before)
    # The temporary shadow_* helper columns must not survive.
    expect_identical(names(rv()), vars_before)
  })
})

test_that("text cleaning recodes a whole cell without touching other columns", {
  env <- cata_app_env(c("app-function.R", "mod-cleaning.R"))
  rv <- shiny::reactiveVal()

  shiny::testServer(env$cleaningServer, args = cleaning_args(rv), {
    session$setInputs(demo = 1)
    weight_before <- rv()$weight_kg

    session$setInputs(
      text_variable = "gender",
      text_uppercase = "Like Title",
      text_replace_from = "F",
      text_replace_to = "Female",
      show_text = 1
    )
    session$setInputs(apply_text = 1)

    expect_false("F" %in% rv()$gender)
    expect_true("Female" %in% rv()$gender)
    expect_identical(rv()$weight_kg, weight_before)
  })
})

test_that("the reset buttons restore the imported dataset", {
  env <- cata_app_env(c("app-function.R", "mod-cleaning.R"))
  rv <- shiny::reactiveVal()

  shiny::testServer(env$cleaningServer, args = cleaning_args(rv), {
    session$setInputs(demo = 1)
    df_raw <- rv()

    session$setInputs(
      missing_variable = "All",
      deal_missing_method = "drop_na",
      apply_missing = 1
    )
    expect_lt(nrow(rv()), nrow(df_raw))

    session$setInputs(reset_missing = 1)
    expect_identical(rv(), df_raw)
  })
})
