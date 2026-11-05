# Keep pkgdown's search UI, while waiting for the index and omitting empty fragments.
patch_search <- function(directory) {
  file <- file.path(directory, "pkgdown.js")
  script <- paste(readLines(file, warn = FALSE), collapse = "\n")
  start <- "    // Initialise search index on focus\n"
  end <- "    // Use algolia autocomplete\n"
  start.position <- regexpr(start, script, fixed = TRUE)[1]
  end.position <- regexpr(end, script, fixed = TRUE)[1]
  stopifnot(start.position > 0L, end.position > start.position)
  replacement <- paste(readLines("pkgdown/search-init.js", warn = FALSE), collapse = "\n")
  script <- paste0(substr(script, 1L, start.position - 1L), replacement, "\n\n",
    substring(script, end.position))
  stopifnot(grepl("await fuse;", script, fixed = TRUE))
  script <- sub("await fuse;", "await loadSearchIndex();", script, fixed = TRUE)
  old.link <- 'window.location.href = s.path + "?q=" + q + "#" + s.id;'
  new.link <- paste0('if (s.path) window.location.href = s.path + "?q=" + encodeURIComponent(q || "")',
    ' + (typeof s.id === "string" && s.id ? "#" + encodeURIComponent(s.id) : "");')
  stopifnot(grepl(old.link, script, fixed = TRUE))
  script <- sub(old.link, new.link, script, fixed = TRUE)
  writeBin(charToRaw(enc2utf8(paste0(script, "\n"))), file)
}
