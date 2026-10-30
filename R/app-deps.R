# The training app under inst/app attaches or calls these packages at
# runtime (see inst/app/R/app-load.R), so R CMD check cannot see them being
# used from package code. Referencing one export from each keeps the declared
# Imports honest and silences the "unused imports" check note.
app_dependencies <- function() {
  list(
    base64enc::dataURI,
    broom::tidy,
    bslib::bs_theme,
    cowplot::theme_minimal_grid,
    dplyr::mutate,
    DT::datatable,
    forcats::fct,
    ggplot2::ggplot,
    htmltools::htmlEscape,
    markdown::mark,
    mice::md.pattern,
    naniar::any_miss,
    plotly::ggplotly,
    purrr::walk,
    readr::read_csv,
    readxl::read_excel,
    rlang::sym,
    scales::percent_format,
    skimr::skim,
    stringr::str_detect,
    tibble::tibble,
    tidyr::replace_na,
    zip::zipr
  )
}
