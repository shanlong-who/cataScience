#' Launch the "A Journey of Data Science" training app
#'
#' Starts the interactive training app bundled with the package: import,
#' clean, visualize, and understand data, then learn to work with AI
#' assistants safely. The app opens in your default browser.
#'
#' @param ... Passed on to [shiny::runApp()], for example `port` or
#'   `launch.browser`.
#'
#' @return No return value; called for the side effect of launching the app.
#'   The function blocks the R session while the app is running.
#'
#' @examples
#' # The app is bundled with the package and launched from its own directory.
#' app_dir <- system.file("app", package = "cataScience")
#' file.exists(file.path(app_dir, "app.R"))
#'
#' # Starting the app needs an interactive session, since it blocks R until
#' # the browser window is closed.
#' if (interactive()) {
#'   run_cata()
#' }
#'
#' @export
run_cata <- function(...) {
  app_dir <- system.file("app", package = "cataScience")
  if (!nzchar(app_dir)) {
    stop(
      "The bundled app could not be found. Try re-installing 'cataScience'.",
      call. = FALSE
    )
  }
  shiny::runApp(app_dir, ...)
}
