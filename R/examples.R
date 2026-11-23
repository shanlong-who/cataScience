#' Load a documented example
#' @param name Example name. NULL returns the catalogue.
#' @return A tibble with a `cata_source` attribute, or the catalogue.
#' @export
#' @examples
#' cata_example()
#' cats <- cata_example("cats")
cata_example <- function(name = NULL) {
  catalogue <- tibble::tribble(
    ~name, ~file, ~unit, ~description,
    "cats", "app/data/cat-dirty-data.xlsx", "Cat record", "Original teaching cats; sampling and measurement protocol unavailable",
    "cats2", "app/data/cat-dirty-data2.xlsx", "Cat record", "Second original cat table for joining exercises"
  )
  if (is.null(name)) return(catalogue)
  if (length(name) != 1L || is.na(name) || !name %in% catalogue$name) {
    stop("Unknown example. Use cata_example() to list the available names.", call. = FALSE)
  }
  item <- catalogue[catalogue$name == name, ]
  path <- system.file(item$file, package = "cataScience")
  data <- cata_read(path)
  attr(data, "cata_source") <- as.list(item[c("name", "unit", "description")])
  data
}
