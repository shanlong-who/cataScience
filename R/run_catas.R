#' Launch the extended cataScience workshop
#'
#' Adds a guided workflow, public health examples, audited data preparation,
#' additional charts, multiple-imputation teaching, and report/dashboard
#' export to the original training app. Core activities work offline.
#' @param ... Arguments passed to [shiny::runApp()].
#' @inheritParams run_cata
#' @return Called for its side effect; blocks while the app is running.
#' @seealso [run_cata()]
#' @export
#' @examples
#' if (interactive()) run_catas()
run_catas <- function(..., language = c("auto", "en", "zh")) {
  old <- options(cataScience.workshop = TRUE)
  on.exit(options(old), add = TRUE)
  run_cata(..., language = match.arg(language))
}
