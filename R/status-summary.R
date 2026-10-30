#' Summarise a reported binary status with unknowns kept visible
#' @param data A data frame.
#' @param status Status column name.
#' @param yes,no Distinct character labels for success and failure.
#' @param by Optional grouping column name.
#' @return A tibble with records, yes, no, unknown, blank, known denominator
#'   and percent. Unknown/blank statuses are excluded from the denominator
#'   and reported separately. The measure is reported status, not verified
#'   service/result availability.
#' @export
#' @examples
#' cata_count_status(data.frame(test = c("Yes", "No", "Unknown", NA)), "test")
cata_count_status <- function(data, status, yes = "Yes", no = "No", by = NULL) {
  cata_assert_columns(data, c(status, by))
  if (length(status) != 1L || (!is.null(by) && length(by) != 1L) ||
      length(yes) != 1L || length(no) != 1L || anyNA(c(yes, no)) ||
      !nzchar(yes) || !nzchar(no) || identical(yes, no)) stop("Select distinct, non-empty Yes and No labels.", call. = FALSE)
  groups <- if (is.null(by)) rep("All records", nrow(data)) else as.character(data[[by]])
  values <- as.character(data[[status]])
  levels <- unique(groups)
  empty <- tibble::tibble(group = character(), records = integer(), yes = integer(),
                          no = integer(), unknown = integer(), blank = integer(), known = integer(), percent = numeric())
  if (!length(levels)) return(empty)
  result <- dplyr::bind_rows(lapply(levels, function(group) {
    rows <- if (is.na(group)) is.na(groups) else !is.na(groups) & groups == group
    x <- values[rows]
    blank <- is.na(x) | trimws(x) == ""
    yes.n <- sum(x %in% yes)
    no.n <- sum(x %in% no)
    unknown.n <- sum(!blank & !x %in% c(yes, no))
    tibble::tibble(group = group, records = length(x), yes = yes.n, no = no.n,
      unknown = unknown.n, blank = sum(blank), known = yes.n + no.n,
      percent = cata_proportion(yes.n, yes.n + no.n)$value)
  }))
  result
}
