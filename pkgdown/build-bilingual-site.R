# Build English documentation and a Chinese overlay with matching page links.
library(pkgdown)
library(fs)
library(xml2)
library(withr)
library(jsonlite)
source("pkgdown/translate-interface.R")
source("pkgdown/patch-search.R")

args <- commandArgs(trailingOnly = TRUE)
destination <- path_abs(if (length(args)) args[1] else "docs")
dir_create(destination)
build_site_github_pages(dest_dir = destination, clean = FALSE,
  new_process = FALSE, install = FALSE)

# The overlay changes website text only. Package help and CRAN sources stay English.
stage.dir <- path_abs(file.path("outputs", "website-source-zh"))
dir_create(stage.dir)
for (directory in c("R", "man", "inst", "vignettes", "pkgdown")) {
  dir_copy(directory, file.path(stage.dir, directory), overwrite = TRUE)
}
for (file in c("DESCRIPTION", "NAMESPACE", "LICENSE", "LICENSE.md")) {
  if (file.exists(file)) file_copy(file, file.path(stage.dir, file), overwrite = TRUE)
}
for (file in c("README.md", "NEWS.md", "_pkgdown.yml")) {
  file_copy(file.path("pkgdown", "zh", file), file.path(stage.dir, file), overwrite = TRUE)
}
for (directory in c("man", "vignettes")) {
  dir_copy(file.path("pkgdown", "zh", directory), file.path(stage.dir, directory), overwrite = TRUE)
}
with_language("zh_CN", {
  build_site_github_pages(pkg = stage.dir, dest_dir = file.path(destination, "zh"),
    clean = FALSE, new_process = FALSE, install = FALSE)
})
for (directory in c(destination, file.path(destination, "zh"))) patch_search(directory)

# Resolve the language switch at build time: no translation service or JS is needed.
base.url <- "https://shanlong-who.github.io/cataScience/"
html.files <- dir_ls(destination, recurse = TRUE, glob = "*.html")
anchor.changes <- list()
for (file in html.files) {
  relative <- as.character(path_rel(file, destination))
  chinese <- startsWith(relative, "zh/")
  page <- sub("^zh/", "", relative)
  counterpart <- file.path(destination, if (chinese) page else file.path("zh", page))
  if (!file.exists(counterpart)) next
  document <- read_html(file, encoding = "UTF-8")
  if (chinese) document <- translate_interface(document)
  script <- xml_find_first(document, "//script[@src='pkgdown.js' or @src='../pkgdown.js']")
  if (!inherits(script, "xml_missing")) {
    asset <- file.path(destination, if (chinese) "zh" else "", "pkgdown.js")
    xml_set_attr(script, "src", paste0(xml_attr(script, "src"), "?v=", unname(tools::md5sum(asset))))
  }
  # Some translated reference headings become '-' or begin with a number.
  # Bootstrap uses CSS selectors, so these IDs need a valid leading letter.
  nodes <- xml_find_all(document, "//*[@id]")
  ids <- xml_attr(nodes, "id")
  unsafe <- grepl("^[0-9-]", ids)
  replacements <- stats::setNames(paste0("section-", ids[unsafe]), ids[unsafe])
  if (length(replacements)) {
    stopifnot(!any(unname(replacements) %in% ids))
    xml_set_attr(nodes[unsafe], "id", unname(replacements))
    links <- xml_find_all(document, "//a[starts-with(@href, '#')]")
    fragments <- substring(xml_attr(links, "href"), 2L)
    changed <- fragments %in% names(replacements)
    xml_set_attr(links[changed], "href", paste0("#", replacements[fragments[changed]]))
    anchor.changes[[relative]] <- replacements
  }
  switch <- xml_find_first(document, if (chinese)
    "//nav//a[normalize-space(.)='English']" else "//nav//a[normalize-space(.)='中文']")
  if (inherits(switch, "xml_missing")) stop("Missing language switch: ", relative)
  xml_set_attr(switch, "href", as.character(path_rel(counterpart, path_dir(file))))
  xml_set_attr(switch, "hreflang", if (chinese) "en" else "zh-CN")
  xml_set_attr(switch, "lang", if (chinese) "en" else "zh-CN")
  xml_set_attr(switch, "aria-label", if (chinese) "Read this page in English" else "阅读本页中文版")
  xml_set_attr(xml_find_first(document, "//html"), "lang", if (chinese) "zh-CN" else "en")
  head <- xml_find_first(document, "//head")
  xml_add_child(head, "link", rel = "alternate", hreflang = "en", href = paste0(base.url, page))
  xml_add_child(head, "link", rel = "alternate", hreflang = "zh-CN", href = paste0(base.url, "zh/", page))
  write_html(document, file, options = "format")
}
for (directory in c(destination, file.path(destination, "zh"))) {
  search.file <- file.path(directory, "search.json")
  search <- fromJSON(search.file, simplifyVector = FALSE)
  for (i in seq_along(search)) {
    page <- sub(base.url, "", search[[i]]$path, fixed = TRUE)
    # Search records without a page or fragment do not need an anchor rewrite.
    replacements <- if (length(page) == 1L && page %in% names(anchor.changes)) anchor.changes[[page]] else NULL
    if (length(search[[i]]$id) == 1L && search[[i]]$id %in% names(replacements)) {
      search[[i]]$id <- unname(replacements[search[[i]]$id])
    }
    if (identical(directory, file.path(destination, "zh"))) {
      for (field in intersect(c("dir", "what", "previous_headings", "title"), names(search[[i]]))) {
        search[[i]][[field]] <- translate_label(search[[i]][[field]])
      }
    }
  }
  write_json(search, search.file, auto_unbox = TRUE, null = "null")
}
cat("Bilingual website:", destination, "\n")
