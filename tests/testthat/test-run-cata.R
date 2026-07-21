test_that("run_cata() passes extra arguments on to shiny::runApp()", {
  expect_true(is.function(run_cata))
  expect_named(formals(run_cata), "...")
})

test_that("the app directory shipped with the package is complete", {
  dir <- app_dir()
  skip_if(!nzchar(dir), "the bundled app is not installed")

  expect_true(file.exists(file.path(dir, "app.R")))
  expect_true(dir.exists(file.path(dir, "R")))
  expect_true(dir.exists(file.path(dir, "data")))
  expect_true(dir.exists(file.path(dir, "markdown")))
  expect_true(file.exists(file.path(dir, "www", "custom.css")))

  # Every file app.R sources must be there.
  sourced <- readLines(file.path(dir, "app.R"), warn = FALSE)
  sourced <- regmatches(sourced, regexpr('"R/[^"]+\\.R"', sourced))
  sourced <- gsub('"', "", sourced)
  expect_gt(length(sourced), 0)
  for (f in sourced) {
    expect_true(file.exists(file.path(dir, f)), info = f)
  }
})

test_that("app_dependencies() covers every declared import", {
  deps <- cataScience:::app_dependencies()
  expect_type(deps, "list")
  expect_true(all(vapply(deps, is.function, logical(1))))

  imports <- read.dcf(
    file.path(find.package("cataScience"), "DESCRIPTION"),
    fields = "Imports"
  )[1, 1]
  imports <- trimws(gsub("\\(.*?\\)", "", strsplit(imports, ",")[[1]]))
  imports <- imports[nzchar(imports)]

  # One reference per declared import, except shiny, which run_cata() calls
  # directly. An import added to DESCRIPTION but wired up nowhere fails here.
  expect_length(deps, length(setdiff(imports, "shiny")))
})
