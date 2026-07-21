# Whole-app smoke test. Sourcing app.R runs the same code shiny runs at
# launch: it attaches the packages, reads the bundled datasets, builds every
# UI page from bslib/DT/plotly components and renders the markdown lessons.
# If a dependency changes in a way that breaks the app, this test fails.

test_that("app.R builds a shiny app object", {
  local_app_dir()
  env <- new.env(parent = globalenv())

  app <- source("app.R", local = env)$value

  expect_s3_class(app, "shiny.appobj")
  expect_type(env$server, "closure")
  expect_named(formals(env$server), c("input", "output", "session"))
})

test_that("the whole UI renders to HTML", {
  local_app_dir()
  env <- new.env(parent = globalenv())
  source("app.R", local = env)

  html <- as.character(env$ui)

  expect_type(html, "character")
  expect_gt(nchar(paste(html, collapse = "")), 10000)
  expect_true(any(grepl("A Journey of Data Science", html, fixed = TRUE)))
})

test_that("the statistics pages build their data and models", {
  env <- cata_app_env(c("app-function.R", "data-stats.R"))

  expect_s3_class(env$stats_df_uhc_pop, "tbl_df")
  expect_s3_class(env$stats_df_two_methods, "tbl_df")
  expect_s3_class(env$stats_df_uhc_gdp, "tbl_df")
  expect_equal(nrow(env$stats_var_table), length(env$stats_cat_weights))
})

test_that("every image used by a markdown lesson exists", {
  local_app_dir()
  md_files <- list.files("markdown", pattern = "\\.md$", full.names = TRUE)
  expect_gt(length(md_files), 0)

  for (f in md_files) {
    lines <- readLines(f, warn = FALSE)
    refs <- regmatches(lines, gregexpr("\\(images/[^)]+\\)", lines))
    refs <- unique(unlist(refs))
    for (ref in refs) {
      path <- file.path("markdown", gsub("^\\(|\\)$", "", ref))
      expect_true(file.exists(path), info = paste(basename(f), "->", ref))
    }
  }
})
