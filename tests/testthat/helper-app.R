# The training app lives under inst/app and is loaded by shiny at launch, so
# its functions are not part of the package namespace. These helpers load the
# shipped app files into a private environment, the same way app.R does, so
# the app logic can be tested without starting a server.

app_dir <- function() {
  system.file("app", package = "cataScience")
}

# The app reads data/ and markdown/ with relative paths, so its own directory
# must be the working directory both while sourcing and while the module
# servers run. The directory is restored when the calling test finishes.
local_app_dir <- function(envir = parent.frame()) {
  dir <- app_dir()
  testthat::skip_if(!nzchar(dir), "the bundled app is not installed")
  old <- setwd(dir)
  withr::defer(setwd(old), envir = envir)
  dir
}

# Source app files into a fresh environment. app-load.R comes first: it
# attaches the packages the app code calls unqualified.
cata_app_env <- function(files, envir = parent.frame()) {
  local_app_dir(envir)
  env <- new.env(parent = globalenv())
  for (f in c("app-load.R", files)) {
    sys.source(file.path("R", f), envir = env)
  }
  env
}

# A small frame with one obvious high outlier in `value`, no outlier in
# `plain`, plus a character column that outlier code must leave alone.
outlier_demo_data <- function() {
  data.frame(
    value = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 100),
    plain = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10),
    label = letters[1:10],
    stringsAsFactors = FALSE
  )
}
