# The training app under inst/app attaches or calls these packages at
# runtime (see inst/app/R/app-load.R), so R CMD check cannot see them being
# used from package code. Referencing one export from each keeps the declared
# Imports honest and silences the "unused imports" check note.
app_dependencies <- function() {
  list(
    broom::tidy,
    bslib::bs_theme,
    cowplot::theme_minimal_grid,
    DT::datatable,
    markdown::mark,
    mice::md.pattern,
    naniar::any_miss,
    plotly::ggplotly,
    readxl::read_excel,
    rio::import,
    scales::percent_format,
    skimr::skim,
    tidyverse::tidyverse_logo,
    VIM::kNN
  )
}
