test_that("both launchers pass options without leaking workshop mode", {
  old <- getOption("cataScience.workshop")
  called <- NULL
  testthat::local_mocked_bindings(run_cata = function(...) {
    called <<- list(workshop = getOption("cataScience.workshop"), args = list(...))
  })
  run_catas(port = 1234, launch.browser = FALSE)
  expect_true(called$workshop)
  expect_equal(called$args$port, 1234)
  expect_identical(getOption("cataScience.workshop"), old)
})

test_that("extended UI builds and VIM remains optional", {
  withr::local_options(cataScience.workshop = TRUE)
  local_app_dir()
  env <- new.env(parent = globalenv())
  env$requireNamespace <- function(package, ...) {
    if (package %in% c("VIM", "DSIR")) FALSE else base::requireNamespace(package, ...)
  }
  app <- source("app.R", local = env)$value
  expect_s3_class(app, "shiny.appobj")
  html <- as.character(env$ui)
  expect_match(html, "Why data matters", fixed = TRUE)
  expect_match(html, "5 Communicate", fixed = TRUE)
  expect_false(grepl("optional VIM", html, fixed = TRUE))
})

test_that("review and sample actions keep raw data and support undo", {
  env <- cata_app_env(c("app-function.R", "mod-workflow.R"))
  shiny::testServer(env$workflowServer, args = list(datasets = shiny::reactive(list(ds1 = NULL, ds2 = NULL, merged = NULL))), {
    session$setInputs(example = "art", load = 1)
    expect_equal(nrow(state$data), 604)
    session$setInputs(reference = "facilities", left_key = "facility_id", right_key = "facility_id", relationship = "many-to-one", join = 1)
    expect_equal(nrow(state$data), 604)
    expect_equal(state$join_audit$unmatched_left_rows, 2)
    session$setInputs(course_selection = 1)
    expect_equal(nrow(state$data), 587)
    expect_equal(nrow(state$raw), 604)
    expect_equal(nrow(state$audit), 2)
    session$setInputs(undo = 1)
    expect_equal(nrow(state$data), 604)
    expect_equal(nrow(state$audit), 1)
    session$setInputs(reset = 1)
    expect_equal(state$data, state$raw)
    expect_equal(nrow(state$audit), 0)
  })
})

test_that("classic outlier removal never consumes source shadow columns", {
  env <- cata_app_env(c("app-function.R", "mod-cleaning.R"))
  original <- data.frame(value = c(1:9, 100), shadow_note = rep("original note", 10))
  rv <- shiny::reactiveVal(original)
  shiny::testServer(env$cleaningServer, args = list(data_rv = rv), {
    session$setInputs(outlier_variable = "value", deal_outlier_method = "remove", apply_outlier = 1)
    expect_equal(nrow(rv()), 9)
    expect_identical(names(rv()), names(original))
    expect_true(all(rv()$shadow_note == "original note"))
  })
})

test_that("the cascade lesson uses declared counts and denominators", {
  env <- cata_app_env(c("app-function.R", "mod-lessons.R"))
  shiny::testServer(env$whyServer, {
    session$setInputs(district = "A", year = "2025", reveal = TRUE)
    expect_equal(selected()$t / selected()$a * 100, 85)
    expect_equal(selected()$s / selected()$t * 100, 90)
    expect_match(output$ratios, "85", fixed = TRUE)
    expect_true(nzchar(output$cascade$src))
  })
})
