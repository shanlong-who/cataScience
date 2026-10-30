#' Read a training dataset
#'
#' Read a CSV or Excel table without modifying the source file. Specify column
#' types when identifiers contain leading zeroes. Excel notes and footers can
#' be excluded with `range`.
#' @param path Path to an existing file.
#' @param format File extension (`csv`, `xls`, or `xlsx`). Useful for uploaded
#'   temporary files whose names do not contain the original extension.
#' @param sheet Excel sheet name or number.
#' @param range Optional Excel cell range.
#' @param col_types Column specification passed to the selected reader.
#' @param na Character values to interpret as missing.
#' @return A tibble. CSV parsing problems remain available through
#'   [readr::problems()].
#' @export
#' @examples
#' cats <- cata_example("cats")
#' cata_profile(cats)
cata_read <- function(path, format = tools::file_ext(path), sheet = 1,
                      range = NULL, col_types = NULL, na = c("", "NA")) {
  if (length(path) != 1L || is.na(path) || !file.exists(path) || dir.exists(path)) {
    stop("Please upload a valid file.", call. = FALSE)
  }
  format <- tolower(format)
  if (length(format) != 1L || !format %in% c("csv", "xls", "xlsx")) {
    stop("Choose a CSV, XLS, or XLSX file; supply 'format' for a temporary upload.", call. = FALSE)
  }
  data <- if (format == "csv") {
    readr::read_csv(path, col_types = col_types, na = na,
                    show_col_types = FALSE, progress = FALSE, name_repair = "check_unique")
  } else {
    reader <- if (format == "xls") readxl::read_xls else readxl::read_xlsx
    reader(path, sheet = sheet, range = range, col_types = col_types,
           na = na, .name_repair = "check_unique")
  }
  cata_assert_data(data)
  tibble::as_tibble(data)
}

cata_assert_data <- function(data) {
  if (!is.data.frame(data) || ncol(data) == 0L) {
    stop("Supply a data frame with at least one column.", call. = FALSE)
  }
  if (anyNA(names(data)) || any(!nzchar(names(data))) || anyDuplicated(names(data))) {
    stop("Column names must be non-missing, non-empty, and unique.", call. = FALSE)
  }
  invisible(data)
}

cata_assert_columns <- function(data, columns, numeric = FALSE) {
  cata_assert_data(data)
  if (!is.character(columns) || !length(columns) || anyNA(columns) ||
      anyDuplicated(columns) || !all(columns %in% names(data))) {
    stop("Select existing, distinct column names.", call. = FALSE)
  }
  if (numeric && !all(vapply(data[columns], is.numeric, logical(1)))) {
    stop("Selected measurement columns must be numeric.", call. = FALSE)
  }
  invisible(columns)
}

#' Summarise the structure and quality of a table
#' @param data A data frame.
#' @return One row per variable, with storage type, record count, observed
#'   unique values, missingness, and numeric summaries. No values are changed.
#' @export
#' @examples
#' cata_profile(data.frame(id = c("001", "002"), value = c(3, NA)))
cata_profile <- function(data) {
  cata_assert_data(data)
  rows <- lapply(names(data), function(variable) {
    x <- data[[variable]]
    finite <- if (is.numeric(x)) x[is.finite(x)] else numeric()
    tibble::tibble(
      variable = variable, type = paste(class(x), collapse = "/"),
      records = length(x), observed = sum(!is.na(x)), missing = sum(is.na(x)),
      missing_pct = if (length(x)) 100 * mean(is.na(x)) else NA_real_,
      distinct = length(unique(x[!is.na(x)])),
      nonfinite = if (is.numeric(x)) sum(!is.finite(x) & !is.na(x)) else 0L,
      minimum = if (length(finite)) min(finite) else NA_real_,
      median = if (length(finite)) stats::median(finite) else NA_real_,
      maximum = if (length(finite)) max(finite) else NA_real_
    )
  })
  dplyr::bind_rows(rows)
}

#' Count missing values and patterns
#' @param data A data frame.
#' @param by Summary level: variables, records, or missingness patterns.
#' @return A tibble. Patterns use `1` for missing and `0` for observed, in
#'   input column order; the `variables` attribute records that order.
#' @export
#' @examples
#' cata_missing(data.frame(a = c(1, NA), b = c(NA, NA)))
cata_missing <- function(data, by = c("variable", "record", "pattern")) {
  cata_assert_data(data)
  by <- match.arg(by)
  missing.matrix <- is.na(data)
  if (by == "variable") {
    return(tibble::tibble(variable = names(data), missing = unname(colSums(missing.matrix)),
                         observed = unname(nrow(data) - colSums(missing.matrix)),
                         missing_pct = if (nrow(data)) unname(100 * colMeans(missing.matrix)) else NA_real_))
  }
  if (by == "record") {
    return(tibble::tibble(row = seq_len(nrow(data)), missing = rowSums(missing.matrix),
                         observed = ncol(data) - rowSums(missing.matrix)))
  }
  patterns <- if (nrow(data)) apply(missing.matrix, 1, function(x) paste(as.integer(x), collapse = "")) else character()
  counts <- sort(table(patterns), decreasing = TRUE)
  result <- tibble::tibble(pattern = names(counts), records = as.integer(counts),
                           percent = if (nrow(data)) 100 * as.numeric(counts) / nrow(data) else numeric())
  attr(result, "variables") <- names(data)
  result
}

#' Flag values for review without changing them
#'
#' An IQR flag is a screening result, not evidence of an erroneous value.
#' Use explicit `limits` only when a documented rule supports them.
#' @param x A numeric vector.
#' @param k Non-negative multiplier for the IQR rule.
#' @param limits Optional numeric lower and upper limits (inclusive).
#' @return A tibble retaining every row and value, with bounds, a review flag,
#'   and a reason. Missing values receive an unknown outlier flag.
#' @export
#' @examples
#' cata_flag_outliers(c(1:9, 100, NA))
cata_flag_outliers <- function(x, k = 1.5, limits = NULL) {
  if (!is.numeric(x)) stop("'x' must be numeric.", call. = FALSE)
  if (length(k) != 1L || !is.finite(k) || k < 0) stop("'k' must be non-negative and finite.", call. = FALSE)
  observed <- x[is.finite(x)]
  if (!is.null(limits)) {
    if (!is.numeric(limits) || length(limits) != 2L || anyNA(limits) || limits[1] > limits[2]) {
      stop("'limits' must contain ordered lower and upper bounds.", call. = FALSE)
    }
    bounds <- limits
  } else if (length(observed)) {
    quartiles <- stats::quantile(observed, c(.25, .75), names = FALSE)
    bounds <- quartiles + c(-1, 1) * k * diff(quartiles)
  } else {
    bounds <- c(NA_real_, NA_real_)
  }
  flagged <- !is.finite(x) | x < bounds[1] | x > bounds[2]
  flagged[is.na(x)] <- NA
  reason <- ifelse(is.na(x), "Missing", ifelse(!is.finite(x), "Non-finite",
                   ifelse(flagged, if (is.null(limits)) "Outside IQR bounds" else "Outside stated limits", "Within bounds")))
  tibble::tibble(row = seq_along(x), value = x, lower = rep(bounds[1], length(x)),
                upper = rep(bounds[2], length(x)), flag = flagged, reason = reason)
}

#' Check a proposed record key
#' @param data A data frame.
#' @param key Character vector of key column names.
#' @return A list with a one-row `summary`, per-row `flags`, and all
#'   `review_rows`. Every member of a repeated-key or identical-row group is
#'   flagged. Repeated IDs are not automatically deleted.
#' @export
#' @examples
#' cata_check_keys(data.frame(id = c("A", "A", NA), value = 1:3), "id")
cata_check_keys <- function(data, key) {
  cata_assert_columns(data, key)
  keys <- data[key]
  missing <- Reduce(`|`, lapply(keys, function(x) is.na(x) | (is.character(x) & trimws(x) == "")))
  repeated <- duplicated(keys) | duplicated(keys, fromLast = TRUE)
  repeated[missing] <- FALSE
  exact <- duplicated(data) | duplicated(data, fromLast = TRUE)
  flags <- tibble::tibble(row = seq_len(nrow(data)), missing_key = missing,
                         repeated_key = repeated, identical_row = exact)
  list(summary = tibble::tibble(records = nrow(data),
        distinct_complete_keys = nrow(unique(keys[!missing, , drop = FALSE])),
        missing_key_rows = sum(missing), repeated_key_rows = sum(repeated),
        identical_row_members = sum(exact), key_is_unique = !any(missing | repeated)),
       flags = flags, review_rows = data[missing | repeated | exact, , drop = FALSE])
}

#' Join tables and return an audit
#' @param x,y Data frames.
#' @param by Character join keys, optionally named to match different names.
#' @param type Join type.
#' @param relationship Expected key relationship; checked by dplyr.
#' @param na_matches Whether missing keys can match. Defaults to `"never"`.
#' @param suffix Suffixes for overlapping non-key columns.
#' @return A list containing `data`, `audit`, both key checks, and unmatched
#'   input rows. Input tables are unchanged.
#' @export
#' @examples
#' cata_join(data.frame(id = c(1, 2, NA)), data.frame(id = 1:2, label = c("A", "B")), by = "id")
cata_join <- function(x, y, by, type = c("left", "inner", "full", "right"),
                      relationship = "many-to-one", na_matches = "never",
                      suffix = c(".x", ".y")) {
  type <- match.arg(type)
  if (!is.character(by) || !length(by) || anyNA(by)) stop("Supply explicit character join keys.", call. = FALSE)
  y.keys <- unname(by)
  x.keys <- names(by)
  if (is.null(x.keys)) x.keys <- y.keys else x.keys[!nzchar(x.keys)] <- y.keys[!nzchar(x.keys)]
  cata_assert_columns(x, x.keys)
  cata_assert_columns(y, y.keys)
  na_matches <- match.arg(na_matches, c("never", "na"))
  relationship <- match.arg(relationship, c("one-to-one", "one-to-many", "many-to-one", "many-to-many"))
  by <- stats::setNames(y.keys, x.keys)
  fn <- switch(type, left = dplyr::left_join, inner = dplyr::inner_join,
               full = dplyr::full_join, right = dplyr::right_join)
  joined <- fn(x, y, by = by, relationship = relationship, na_matches = na_matches, suffix = suffix)
  unmatched.x <- dplyr::anti_join(x, y, by = by, na_matches = na_matches)
  unmatched.y <- dplyr::anti_join(y, x, by = stats::setNames(x.keys, y.keys), na_matches = na_matches)
  list(data = joined, audit = tibble::tibble(left_rows = nrow(x), right_rows = nrow(y),
       result_rows = nrow(joined), matched_left_rows = nrow(x) - nrow(unmatched.x),
       unmatched_left_rows = nrow(unmatched.x), unmatched_right_rows = nrow(unmatched.y),
       row_change = nrow(joined) - nrow(x)),
       left_keys = cata_check_keys(x, x.keys), right_keys = cata_check_keys(y, y.keys),
       unmatched_left = unmatched.x, unmatched_right = unmatched.y)
}

#' Calculate proportions with explicit denominators
#' @param numerator,denominator Numeric counts of equal length, or one scalar.
#' @param scale Multiplier, usually 100 for percentages.
#' @return A tibble with the input counts, `value`, and `status`. Invalid
#'   counts and zero denominators produce NA, with the reason retained.
#' @export
#' @examples
#' cata_proportion(c(200, 233, 0), c(265, 315, 0))
cata_proportion <- function(numerator, denominator, scale = 100) {
  if (!is.numeric(numerator) || !is.numeric(denominator) ||
      length(scale) != 1L || !is.finite(scale) || scale <= 0) {
    stop("Supply numeric counts and a positive finite scale.", call. = FALSE)
  }
  n <- max(length(numerator), length(denominator))
  if (!length(numerator) || !length(denominator)) {
    if (length(numerator) != length(denominator)) stop("Count lengths must match or be scalar.", call. = FALSE)
  } else if (!all(c(length(numerator), length(denominator)) %in% c(1L, n))) {
    stop("Count lengths must match or be scalar.", call. = FALSE)
  }
  numerator <- rep_len(numerator, n)
  denominator <- rep_len(denominator, n)
  status <- rep("OK", n)
  status[!is.finite(numerator) | !is.finite(denominator)] <- "Missing or non-finite count"
  status[which(numerator < 0 | denominator < 0)] <- "Negative count"
  status[which(numerator > denominator & denominator >= 0)] <- "Numerator exceeds denominator"
  status[which(denominator == 0)] <- "Zero denominator"
  value <- rep(NA_real_, n)
  valid <- status == "OK"
  value[valid] <- scale * numerator[valid] / denominator[valid]
  tibble::tibble(numerator = numerator, denominator = denominator, value = value, status = status)
}
