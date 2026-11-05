# Check translated signatures and every local link in both generated languages.
library(fs)
library(xml2)
source("pkgdown/translate-interface.R")

args <- commandArgs(trailingOnly = TRUE)
site.dir <- path_abs(if (length(args)) args[1] else "docs")
source.files <- dir_ls("man", glob = "*.Rd")
translated.files <- dir_ls("pkgdown/zh/man", glob = "*.Rd")
stopifnot(setequal(path_file(source.files), path_file(translated.files)))
get_usage <- function(file) {
  rd <- tools::parse_Rd(file, encoding = "UTF-8")
  tags <- vapply(rd, function(node) attr(node, "Rd_tag"), character(1))
  text <- paste(unlist(rd[[which(tags == "\\usage")]]), collapse = "")
  parse(text = text, keep.source = FALSE)
}
for (file in source.files) {
  stopifnot(identical(get_usage(file), get_usage(file.path("pkgdown/zh/man", path_file(file)))))
}

failures <- character()
id.cache <- new.env(parent = emptyenv())
get_ids <- function(file) {
  key <- as.character(file)
  if (!exists(key, id.cache, inherits = FALSE)) {
    doc <- read_html(file, encoding = "UTF-8")
    assign(key, c(xml_attr(xml_find_all(doc, "//*[@id]"), "id"),
      xml_attr(xml_find_all(doc, "//a[@name]"), "name")), id.cache)
  }
  get(key, id.cache, inherits = FALSE)
}
pages <- dir_ls(site.dir, recurse = TRUE, glob = "*.html")
switches <- 0L
for (file in pages) {
  document <- read_html(file, encoding = "UTF-8")
  stopifnot(!any(grepl("^[0-9-]", xml_attr(xml_find_all(document, "//*[@id]"), "id"))))
  language.link <- xml_find_all(document, "//nav//a[@hreflang]")
  if (length(language.link)) {
    switches <- switches + 1L
    stopifnot(length(language.link) == 1L)
  }
  links <- unique(xml_attr(xml_find_all(document, "//a[@href] | //img[@src] | //script[@src] | //link[@href]"), "href"))
  links <- unique(c(links, xml_attr(xml_find_all(document, "//img[@src] | //script[@src]"), "src")))
  links <- links[!is.na(links) & nzchar(links) & !grepl("^([a-z]+:|//)", links)]
  for (link in links) {
    relative <- URLdecode(sub("[?#].*$", "", link))
    target <- if (nzchar(relative)) path_norm(file.path(path_dir(file), relative)) else file
    if (dir_exists(target)) target <- file.path(target, "index.html")
    if (!file_exists(target)) failures <- c(failures, paste(path_rel(file, site.dir), "->", link))
    if (file_exists(target) && path_ext(target) == "html" && grepl("#", link, fixed = TRUE)) {
      fragment <- URLdecode(sub("^[^#]*#", "", link))
      if (nzchar(fragment) && !fragment %in% get_ids(target)) {
        failures <- c(failures, paste(path_rel(file, site.dir), "-> missing anchor", link))
      }
    }
  }
}
base.url <- "https://shanlong-who.github.io/cataScience/"
for (search.file in c(file.path(site.dir, "search.json"), file.path(site.dir, "zh/search.json"))) {
  entries <- jsonlite::fromJSON(search.file, simplifyVector = FALSE)
  for (entry in entries) {
    # A missing fragment must remain JSON null, never an object or an array.
    stopifnot(is.null(entry$id) || (is.character(entry$id) && length(entry$id) == 1L))
    if (length(entry$path) != 1L || !startsWith(entry$path, base.url)) next
    target <- file.path(site.dir, sub(base.url, "", entry$path, fixed = TRUE))
    if (dir_exists(target)) target <- file.path(target, "index.html")
    if (!file_exists(target)) failures <- c(failures, paste("Missing search page:", entry$path))
    if (file_exists(target) && length(entry$id) == 1L && nzchar(entry$id) && !entry$id %in% get_ids(target)) {
      failures <- c(failures, paste("Missing search anchor:", entry$path, entry$id))
    }
  }
}
reference.zh <- read_html(file.path(site.dir, "zh/reference/cata_mice_demo.html"), encoding = "UTF-8")
stopifnot(trimws(xml_text(xml_find_first(reference.zh, "//*[@id='ref-usage']"))) == "用法")
stopifnot(xml_attr(xml_find_first(reference.zh, "//*[@id='search-input']"), "aria-label") == "搜索网站")
# Simulate a build without Chinese message catalogs and preserve every code block.
reference.en <- read_html(file.path(site.dir, "reference/cata_mice_demo.html"), encoding = "UTF-8")
code.before <- xml_text(xml_find_all(reference.en, "//pre"))
fallback.zh <- translate_interface(reference.en)
stopifnot(trimws(xml_text(xml_find_first(fallback.zh, "//*[@id='ref-usage']"))) == "用法")
stopifnot(xml_attr(xml_find_first(fallback.zh, "//*[@id='search-input']"), "aria-label") == "搜索网站")
stopifnot(identical(code.before, xml_text(xml_find_all(fallback.zh, "//pre"))))
if (length(failures)) stop(paste(failures, collapse = "\n"))
stopifnot(switches >= 44L)
cat("PASS translated signatures:", length(source.files), "\n")
cat("PASS local links and assets:", length(pages), "pages\n")
cat("PASS language switches:", switches, "pages\n")
