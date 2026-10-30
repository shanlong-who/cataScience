#' Explore multiple imputation using synthetic cats
#'
#' A fixed teaching simulation with missing weights. Fits the same linear
#' model to each completed dataset and pools model estimates, not datasets.
#' It does not impute uploaded records. Diagnostic plots do not establish
#' that the missingness assumptions hold in a real study.
#' @param m Number of imputations, from 2 to 20.
#' @param maxit Number of iterations, from 2 to 20.
#' @param seed Integer seed for reproducibility. The caller's random-number
#'   state is restored on exit.
#' @return A list with complete and incomplete synthetic data, the `mids`
#'   object, completed datasets, pooled model estimates and a comparison of
#'   the complete-data, complete-case, mean-imputed and pooled slopes.
#' @export
#' @examples
#' \donttest{
#' demo <- cata_mice_demo(m = 3, maxit = 3)
#' demo$comparison
#' }
cata_mice_demo <- function(m = 5, maxit = 5, seed = 2026) {
  for (value in list(m, maxit)) {
    if (length(value) != 1L || !is.finite(value) || value < 2 || value > 20 || value != as.integer(value)) {
      stop("'m' and 'maxit' must be integers between 2 and 20.", call. = FALSE)
    }
  }
  if (length(seed) != 1L || !is.finite(seed) || seed != as.integer(seed)) stop("Use a finite integer seed.", call. = FALSE)
  had.seed <- exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE)
  if (had.seed) old.seed <- get(".Random.seed", envir = .GlobalEnv)
  on.exit({
    if (had.seed) assign(".Random.seed", old.seed, envir = .GlobalEnv)
    else if (exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE)) rm(".Random.seed", envir = .GlobalEnv)
  }, add = TRUE)
  set.seed(seed)
  complete <- data.frame(length_cm = round(stats::runif(120, 30, 55), 1))
  complete$weight_kg <- round(.12 * complete$length_cm - 1 + stats::rnorm(120, 0, .45), 2)
  incomplete <- complete
  missing.rows <- sample.int(nrow(incomplete), 36)
  incomplete$weight_kg[missing.rows] <- NA_real_
  predictor <- matrix(c(0, 1, 0, 0), 2, 2, dimnames = list(names(incomplete), names(incomplete)))
  imputation <- mice::mice(incomplete, m = m, maxit = maxit,
                           method = c("", "pmm"), predictorMatrix = predictor,
                           seed = seed, printFlag = FALSE)
  completed <- mice::complete(imputation, action = "all")
  fits <- lapply(completed, function(d) stats::lm(weight_kg ~ length_cm, data = d))
  pooled <- summary(mice::pool(fits), conf.int = TRUE)
  single <- incomplete
  single$weight_kg[is.na(single$weight_kg)] <- mean(single$weight_kg, na.rm = TRUE)
  methods <- list("Complete synthetic data" = complete, "Complete cases" = incomplete,
                  "Single mean imputation" = single)
  comparison <- dplyr::bind_rows(lapply(names(methods), function(method) {
    fit <- stats::lm(weight_kg ~ length_cm, data = methods[[method]])
    coef <- broom::tidy(fit, conf.int = TRUE)
    row <- coef[coef$term == "length_cm", ]
    tibble::tibble(method = method, estimate = row$estimate, lower = row$conf.low,
                   upper = row$conf.high, records = stats::nobs(fit))
  }))
  pooled.slope <- pooled[pooled$term == "length_cm", ]
  comparison <- dplyr::bind_rows(comparison, tibble::tibble(method = "Multiple imputation (pooled)",
    estimate = pooled.slope$estimate, lower = pooled.slope$conf.low, upper = pooled.slope$conf.high,
    records = nrow(incomplete)))
  list(complete = complete, incomplete = incomplete, missing_rows = missing.rows,
       imputation = imputation, completed = completed, pooled = pooled,
       comparison = comparison)
}
