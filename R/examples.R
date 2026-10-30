#' Load a documented example
#' @param name Example name. NULL returns the catalogue.
#' @return A tibble with a `cata_source` attribute, or the catalogue. Teaching
#'   datasets A, B and C are synthetic. A is independent of B/C and must not
#'   be linked to individual ART records.
#' @export
#' @examples
#' cata_example()
#' cats <- cata_example("cats")
cata_example <- function(name = NULL) {
  catalogue <- tibble::tribble(
    ~name, ~file, ~unit, ~description,
    "cats", "app/data/cat-dirty-data.xlsx", "Cat record", "Original teaching cats; sampling and measurement protocol unavailable",
    "cats2", "app/data/cat-dirty-data2.xlsx", "Cat record", "Second original cat table for joining exercises",
    "cascade", "training-data/Dataset_A_Student.xlsx", "District-year", "Dataset A: fictional HIV cascade; independent of B/C",
    "art_raw", "training-data/dataset_b_raw.csv", "Intended annual ART record", "Dataset B: 604 synthetic records, including unresolved repeated IDs",
    "art", "training-data/dataset_b_clean_reference.csv", "Intended annual ART record", "Dataset B reference: all raw rows retained with review flags",
    "facilities", "training-data/dataset_c.csv", "Facility", "Dataset C: ten fictional facilities; joins to B by facility_id",
    "source_review", "training-data/dataset_b_source_review.csv", "Repeated-ID group", "Synthetic evidence for reviewing repeated Dataset B IDs"
  )
  if (is.null(name)) return(catalogue)
  if (length(name) != 1L || is.na(name) || !name %in% catalogue$name) {
    stop("Unknown example. Use cata_example() to list the available names.", call. = FALSE)
  }
  item <- catalogue[catalogue$name == name, ]
  path <- system.file(item$file, package = "cataScience")
  data <- if (name == "cascade") cata_read(path, sheet = "Data", range = "A1:G16") else cata_read(path)
  attr(data, "cata_source") <- as.list(item[c("name", "unit", "description")])
  data
}
