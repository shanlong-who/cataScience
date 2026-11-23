# Run from the package root: Rscript pkgdown/build-shinylive.R [output-directory]
# The CRAN package stays unchanged. Only generated browser copies are adapted.
library(shinylive)
library(fs)
library(jsonlite)

args <- commandArgs(trailingOnly = TRUE)
version <- read.dcf("DESCRIPTION")[1, "Version"]
assets.version <- Sys.getenv("CATASCIENCE_SHINYLIVE_ASSETS", "0.10.16")
output.dir <- if (length(args)) args[1] else file.path("outputs", paste0("shinylive-", version))
stage.dir <- file.path(output.dir, "source")
site.dir <- file.path(output.dir, "site")
dir_create(stage.dir)
dir_create(site.dir)
options(timeout = max(600, getOption("timeout")))
shinylive::assets_ensure(assets.version)

# A locally installed GitHub development copy has no matching Wasm release.
# Use a CRAN copy in an isolated build library; leave the user's library alone.
build.library <- file.path(output.dir, "build-library")
dir_create(build.library)
.libPaths(c(normalizePath(build.library), .libPaths()))
if (requireNamespace("DSIR", quietly = TRUE) &&
    identical(utils::packageDescription("DSIR")$RemoteType, "github")) {
  install.packages("DSIR", lib = build.library, repos = "https://cloud.r-project.org",
    dependencies = FALSE)
}

replace_required <- function(text, before, after) {
  if (!grepl(before, text, fixed = TRUE)) stop("Expected source text was not found: ", before)
  gsub(before, after, text, fixed = TRUE)
}

helpers <- setdiff(dir_ls("R", glob = "*.R"),
  file.path("R", c("app-deps.R", "run_cata.R")))

app.dir <- tempfile("classroom-", tmpdir = stage.dir)
dir_create(app.dir)
dir_copy("inst/app", app.dir, overwrite = TRUE)
dir_create(file.path(app.dir, "R", "package"))

# Source the exact release helpers instead of waiting for a CRAN Wasm binary.
# Keep exported project scripts using library(cataScience) for local R users.
for (file in helpers) {
  text <- paste(readLines(file, encoding = "UTF-8", warn = FALSE), collapse = "\n")
  if (basename(file) == "examples.R") {
    text <- replace_required(text, 'system.file(item$file, package = "cataScience")',
      'sub("^app/", "", item$file)')
  }
  if (basename(file) == "communication.R") {
    text <- replace_required(text, 'utils::packageVersion("cataScience")',
      encodeString(version, quote = '"'))
  }
  writeLines(text, file.path(app.dir, "R", "package", basename(file)), useBytes = TRUE)
}

for (file in dir_ls(file.path(app.dir, "R"), glob = "*.R")) {
  text <- paste(readLines(file, encoding = "UTF-8", warn = FALSE), collapse = "\n")
  text <- gsub("cataScience::", "", text, fixed = TRUE)
  if (basename(file) == "app-function.R") {
    text <- replace_required(text,
      'requireNamespace("cataScience", quietly = TRUE) &&\n      "cata_read" %in% getNamespaceExports("cataScience")',
      'exists("cata_read", mode = "function")')
  }
  if (basename(file) == "mod-cleaning.R") {
    # VIM imports xgboost, whose shared-memory Wasm binary cannot load in
    # this runtime. A failed load also corrupts subsequent DLL loading.
    text <- replace_required(text, 'requireNamespace("VIM", quietly = TRUE)', 'FALSE')
    text <- replace_required(text, 'VIM::kNN(data_rv(), missing_variable(), imp_var = FALSE)',
      'stop("kNN imputation is available in the R app.")')
    text <- replace_required(text, 'The optional VIM package is needed for kNN imputation.',
      'kNN imputation is available in the R app.')
    text <- replace_required(text, '          checkboxGroupInput(\n            ns("missing_variable"),',
      paste('          helpText("kNN imputation is available in the R app."),',
        '          checkboxGroupInput(\n            ns("missing_variable"),', sep = "\n"))
  }
  writeLines(text, file, useBytes = TRUE)
}

bootstrap <- c(
  'for (file in list.files("R/package", pattern = "[.]R$", full.names = TRUE)) {',
  '  source(file, local = TRUE, encoding = "UTF-8")',
  '}'
)
app <- readLines("inst/app/app.R", encoding = "UTF-8")
extra <- c(
  'ui <- htmltools::tagAppendChild(ui, shiny::tags$footer(class = "browser-edition",',
  sprintf('  shiny::tags$small("cataScience %s | ", shiny::tags$span("Runs in your browser"), " | "),', version),
  '  shiny::tags$a("User guide", id = "cata-browser-guide", href = "https://shanlong-who.github.io/cataScience/",',
  '    `data-en-href` = "https://shanlong-who.github.io/cataScience/",',
  '    `data-zh-href` = "https://shanlong-who.github.io/cataScience/zh/", target = "_blank")))'
)
app <- append(app, extra, after = length(app) - 1L)
writeLines(c(bootstrap, app), file.path(app.dir, "app.R"), useBytes = TRUE)
cat("\nPrepared classroom from cataScience", version, "\n")

shinylive::export(app.dir, site.dir,
  subdir = "",
  assets_version = assets.version,
  wasm_packages = TRUE, quiet = FALSE,
  template_params = list(
    title = "cataScience",
    include_in_head = '<link rel="icon" type="image/png" href="https://shanlong-who.github.io/cata/favicon-96x96.png">'
  ))

file_copy("pkgdown/favicon/favicon-96x96.png", file.path(site.dir, "favicon-96x96.png"), overwrite = TRUE)
file_copy("pkgdown/favicon/favicon.ico", file.path(site.dir, "favicon.ico"), overwrite = TRUE)
file_create(file.path(site.dir, ".nojekyll"))
source("pkgdown/build-launcher.R", local = TRUE)
write_cata_launcher(site.dir)
write_json(list(package = "cataScience", version = version,
  source_commit = system2("git", c("rev-parse", "HEAD"), stdout = TRUE),
  shinylive = as.character(packageVersion("shinylive")),
  assets = assets.version,
  app = "./", legacy_redirect = "classic/"),
  file.path(site.dir, "build-info.json"), auto_unbox = TRUE, pretty = TRUE)
cat("\nBrowser site:", normalizePath(site.dir, winslash = "/"), "\n")
