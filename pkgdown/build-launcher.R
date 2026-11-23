# Add a visible startup screen and a bounded parallel download queue.
library(jsonlite)

write_cata_launcher <- function(site.dir) {
  template <- readLines("pkgdown/shinylive-launcher/index.html", encoding = "UTF-8")
  template <- gsub("{{loader_version}}", unname(tools::md5sum("pkgdown/shinylive-launcher/launch.js")), template, fixed = TRUE)
  writeLines(template, file.path(site.dir, "index.html"), useBytes = TRUE)
  legacy.dir <- file.path(site.dir, "classic")
  dir.create(legacy.dir, recursive = TRUE, showWarnings = FALSE)
  redirect <- c('<!doctype html><meta charset="utf-8"><title>cataScience</title>',
    '<script>location.replace("../" + location.search + location.hash);</script>',
    '<a href="../">Open cataScience</a>')
  writeLines(redirect, file.path(legacy.dir, "index.html"), useBytes = TRUE)
  old.bundle <- file.path(legacy.dir, "app.json")
  if (file.exists(old.bundle) && !file.remove(old.bundle)) stop("Could not retire ", old.bundle)
  file.copy("pkgdown/shinylive-launcher/launch.js", site.dir, overwrite = TRUE)
  runtime.files <- c(
    "shinylive/shinylive.js", "shinylive/shinylive.css", "shinylive/style-resets.css",
    list.files(file.path(site.dir, "shinylive"), pattern = "^chunk-.*[.]js$", full.names = FALSE),
    list.files(file.path(site.dir, "shinylive/webr"), pattern = "[.](js|mjs|wasm|gz|metadata|so)$", full.names = FALSE)
  )
  runtime.files[grepl("^chunk-", runtime.files)] <- paste0("shinylive/", runtime.files[grepl("^chunk-", runtime.files)])
  root.files <- !grepl("/", runtime.files, fixed = TRUE)
  runtime.files[root.files] <- paste0("shinylive/webr/", runtime.files[root.files])
  package.files <- list.files(file.path(site.dir, "shinylive/webr/packages"), recursive = TRUE)
  paths <- unique(c(runtime.files, paste0("shinylive/webr/packages/", package.files)))
  describe_file <- function(path) list(path = path, bytes = unname(file.info(file.path(site.dir, path))$size))
  manifest <- list(files = lapply(c(paths, "app.json"), describe_file))
  stopifnot(all(vapply(manifest$files, function(file) is.finite(file$bytes), logical(1))))
  writeBin(charToRaw(paste0(toJSON(manifest, auto_unbox = TRUE, pretty = TRUE), "\n")),
    file.path(site.dir, "launch-manifest.json"))
  cat("Added startup screen for", length(paths), "shared files.\n")
  invisible(site.dir)
}

if (sys.nframe() == 0L) {
  args <- commandArgs(trailingOnly = TRUE)
  if (length(args) != 1L) stop("Supply the exported site directory.")
  write_cata_launcher(args[1])
}
