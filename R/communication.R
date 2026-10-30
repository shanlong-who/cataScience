cata_html_table <- function(data, max_rows = 200L) {
  if (!is.data.frame(data)) stop("Report tables must be data frames.", call. = FALSE)
  shown <- utils::head(data, max_rows)
  format_cell <- function(x) {
    if (!length(x) || is.na(x)) return("Not available")
    if (is.numeric(x)) return(format(signif(x, 5), trim = TRUE, scientific = FALSE))
    as.character(x)
  }
  htmltools::tagList(
    htmltools::tags$div(class = "table-wrap", htmltools::tags$table(
      htmltools::tags$thead(htmltools::tags$tr(lapply(names(data), htmltools::tags$th))),
      htmltools::tags$tbody(lapply(seq_len(nrow(shown)), function(i) {
        htmltools::tags$tr(lapply(shown[i, , drop = FALSE], function(x) htmltools::tags$td(format_cell(x))))
      }))
    )),
    if (nrow(data) > max_rows) htmltools::tags$p(sprintf("Showing %s of %s rows. Use the source project to inspect all records.", max_rows, nrow(data)))
  )
}

#' Write a self-contained report or dashboard
#'
#' Creates a local HTML file with no online resources. Text is escaped;
#' narrative findings and limitations come from the author. The dashboard
#' includes local table search. For editable and reproducible source files,
#' use [cata_export()].
#' @param data Data frame describing the selected analysis records.
#' @param file Output HTML path. Existing files are protected by default.
#' @param title,question,methods,finding,limitations,source,unit,denominator
#'   Author-supplied report text. Missing text is displayed as "Not provided".
#' @param plot Optional ggplot figure.
#' @param tables Named list of data frames to include before the data profile.
#' @param audit Optional data frame of preparation/selection steps.
#' @param format Report or dashboard layout.
#' @param width,height Figure dimensions in inches.
#' @param overwrite Explicitly allow replacing an existing output file.
#' @return The output path, invisibly.
#' @export
#' @examples
#' f <- tempfile(fileext = ".html")
#' cata_report(data.frame(value = 1:3), f, title = "Teaching example")
cata_report <- function(data, file, title = "Data analysis report", question = "",
                        methods = "", finding = "", limitations = "", source = "",
                        unit = "", denominator = "", plot = NULL, tables = list(),
                        audit = NULL, format = c("report", "dashboard"),
                        width = 8, height = 5, overwrite = FALSE) {
  cata_assert_data(data)
  format <- match.arg(format)
  if (length(file) != 1L || is.na(file) || !nzchar(file) || dir.exists(file)) stop("Supply an HTML output file path.", call. = FALSE)
  if (file.exists(file) && !isTRUE(overwrite)) stop("Output already exists; choose a new file or set overwrite = TRUE.", call. = FALSE)
  if (!dir.exists(dirname(file))) stop("The output directory does not exist.", call. = FALSE)
  text <- list(title, question, methods, finding, limitations, source, unit, denominator)
  if (any(vapply(text, function(x) !is.character(x) || length(x) != 1L || is.na(x), logical(1)))) {
    stop("Report text fields must be single, non-missing strings.", call. = FALSE)
  }
  if (!is.list(tables) || (length(tables) && (is.null(names(tables)) || any(!nzchar(names(tables)))))) {
    stop("Use a named list for report tables.", call. = FALSE)
  }
  paragraph <- function(x) htmltools::tags$p(if (nzchar(x)) x else "Not provided", class = "narrative")
  figure <- NULL
  if (!is.null(plot)) {
    if (!inherits(plot, "ggplot")) stop("'plot' must be a ggplot object.", call. = FALSE)
    if (any(!is.finite(c(width, height))) || length(width) != 1 || length(height) != 1 || width <= 0 || height <= 0) {
      stop("Use positive finite figure dimensions.", call. = FALSE)
    }
    png <- tempfile(fileext = ".png")
    on.exit(unlink(png), add = TRUE)
    ggplot2::ggsave(png, plot = plot, width = width, height = height, dpi = 144, bg = "white")
    figure <- htmltools::tags$figure(htmltools::tags$img(src = base64enc::dataURI(file = png, mime = "image/png"),
      alt = if (nzchar(finding)) finding else "Analysis chart; see the accompanying tables and methods."))
  }
  section <- function(title, ...) htmltools::tags$section(htmltools::tags$h2(title), ...)
  summary <- cata_profile(data)
  css <- "body{font-family:system-ui,'Segoe UI',sans-serif;color:#23313b;background:#f5f7f9;margin:0;line-height:1.55}main{max-width:1120px;margin:auto;padding:32px}header{border-bottom:4px solid #0072B2;margin-bottom:28px}h1{font-size:2rem;line-height:1.2}h2{font-size:1.2rem;color:#00547f;margin-top:0}section{background:white;padding:22px;margin:0 0 20px;border-radius:8px;break-inside:avoid}.narrative{white-space:pre-wrap}.metrics{display:flex;gap:32px;flex-wrap:wrap;margin:24px 0}.metrics strong{font-size:1.8rem;display:block}.table-wrap{overflow:auto}table{width:100%;border-collapse:collapse;font-size:.9rem}th,td{text-align:left;padding:8px 10px;border-bottom:1px solid #dfe5e8}th{background:#edf3f7}img{max-width:100%;height:auto}.dashboard .results{display:grid;grid-template-columns:1fr 1fr;gap:20px}.dashboard .results section{min-width:0}input{padding:10px;width:min(90%,460px);font:inherit;margin-bottom:20px}footer{font-size:.85rem;color:#52616b}@media(max-width:800px){main{padding:16px}.dashboard .results{display:block}}@media print{body{background:white}main{max-width:none;padding:0}input{display:none}section{border-radius:0;padding:12px 0}.dashboard .results{display:block}th{-webkit-print-color-adjust:exact}}"
  result.sections <- htmltools::tagList(
    if (!is.null(figure)) section("Figure", figure),
    lapply(names(tables), function(name) section(name, cata_html_table(tables[[name]]))),
    if (!is.null(audit)) section("Preparation and sample record", cata_html_table(audit)),
    section("Data profile", cata_html_table(summary))
  )
  page <- htmltools::tags$html(lang = "en",
    htmltools::tags$head(htmltools::tags$meta(charset = "utf-8"),
      htmltools::tags$meta(name = "viewport", content = "width=device-width, initial-scale=1"),
      htmltools::tags$title(title), htmltools::tags$style(htmltools::HTML(css))),
    htmltools::tags$body(class = format, htmltools::tags$main(
      htmltools::tags$header(htmltools::tags$p("cataScience \u00b7 Communication"), htmltools::tags$h1(title)),
      htmltools::tags$div(class = "metrics",
        htmltools::tags$div(htmltools::tags$strong(nrow(data)), "Selected records"),
        htmltools::tags$div(htmltools::tags$strong(ncol(data)), "Variables"),
        htmltools::tags$div(htmltools::tags$strong(sum(is.na(data))), "Missing cells")),
      section("Question and main finding", paragraph(question), paragraph(finding)),
      section("Data and methods", htmltools::tags$h3("Source"), paragraph(source),
        htmltools::tags$h3("Observation unit"), paragraph(unit),
        htmltools::tags$h3("Analysis and selection"), paragraph(methods),
        htmltools::tags$h3("Denominator"), paragraph(denominator)),
      if (format == "dashboard") htmltools::tags$input(id = "table-search", type = "search",
        placeholder = "Search table rows", `aria-label` = "Search table rows"),
      htmltools::tags$div(class = "results", result.sections),
      section("Interpretation and limitations", paragraph(limitations)),
      htmltools::tags$footer(paste("Generated with cataScience", utils::packageVersion("cataScience"),
        "\u00b7 HTML works offline. Author-supplied narrative requires review."))
    ), if (format == "dashboard") htmltools::tags$script(htmltools::HTML(
      "document.getElementById('table-search').addEventListener('input',function(){const q=this.value.toLowerCase();document.querySelectorAll('tbody tr').forEach(function(row){row.hidden=!row.textContent.toLowerCase().includes(q);});});"
    ))))
  writeLines(c("<!doctype html>", as.character(page)), file, useBytes = TRUE)
  invisible(normalizePath(file, winslash = "/", mustWork = TRUE))
}

cata_literal <- function(x) paste(utils::capture.output(dput(x)), collapse = "\n")

#' Export a reproducible communication project
#'
#' Writes a new directory containing input and selected-data snapshots, an
#' R script, report and dashboard HTML, Quarto sources, and a local Shiny
#' dashboard. The R script reconstructs selected data using the supplied
#' preparation steps, then recomputes summaries and the chart. It uses an
#' input RDS snapshot to preserve identifiers, factors, dates and column types.
#' @param data Selected analysis data.
#' @param directory A new output directory; existing directories are protected.
#' @param input Original input snapshot, before the listed preparation steps.
#' @param steps Character vector of R preparation statements, each operating
#'   on `analysis.data`. These are written to the exported script, not executed
#'   by this function. Only export statements you have reviewed.
#' @param join_data Optional reference-table snapshot used by preparation steps.
#' @param plot_args Named arguments for [cata_plot()], excluding data.
#' @param summary_spec Optional arguments for [cata_count_status()], excluding
#'   data. The status summary is recomputed when the project is run.
#' @param chart_data Use selected records or the status summary for the chart.
#' @param audit Optional preparation log.
#' @param width,height Figure dimensions in inches, retained in the project.
#' @param title,question,methods,finding,limitations,source,unit,denominator
#'   Author-supplied report text.
#' @return The new directory, invisibly. Source files are generated even when
#'   Quarto is not installed. HTML exports need neither Quarto nor a server.
#' @export
#' @examples
#' \donttest{
#' out <- tempfile("cata-project-")
#' cata_export(data.frame(value = 1:5), out, title = "Example report")
#' }
cata_export <- function(data, directory, input = data, steps = character(),
                        join_data = NULL, plot_args = NULL, summary_spec = NULL,
                        chart_data = c("records", "summary"), audit = NULL,
                        title = "Data analysis report", question = "", methods = "",
                        finding = "", limitations = "", source = "", unit = "",
                        denominator = "", width = 8, height = 5) {
  cata_assert_data(data)
  cata_assert_data(input)
  chart_data <- match.arg(chart_data)
  if (length(directory) != 1L || is.na(directory) || !nzchar(directory) || file.exists(directory)) {
    stop("Choose a new output directory; existing paths are protected.", call. = FALSE)
  }
  if (!is.character(steps) || anyNA(steps)) stop("'steps' must contain reviewed R statements.", call. = FALSE)
  if (!length(steps) && !identical(data, input)) stop("Supply preparation steps when input differs from selected data.", call. = FALSE)
  if (chart_data == "summary" && is.null(summary_spec)) stop("A summary chart needs summary_spec.", call. = FALSE)
  if (length(width) != 1L || length(height) != 1L || any(!is.finite(c(width, height))) || width <= 0 || height <= 0) {
    stop("Use positive finite figure dimensions.", call. = FALSE)
  }
  if (!dir.create(directory, recursive = TRUE)) stop("Could not create the output directory.", call. = FALSE)
  settings <- list(plot_args = plot_args, summary_spec = summary_spec, chart_data = chart_data,
    report = list(title = title, question = question, methods = methods, finding = finding,
      limitations = limitations, source = source, unit = unit, denominator = denominator,
      width = width, height = height))
  saveRDS(input, file.path(directory, "input.rds"))
  saveRDS(data, file.path(directory, "data.rds"))
  saveRDS(settings, file.path(directory, "settings.rds"))
  saveRDS(audit, file.path(directory, "audit.rds"))
  if (!is.null(join_data)) saveRDS(join_data, file.path(directory, "join-data.rds"))
  readr::write_csv(data, file.path(directory, "data.csv"), na = "")
  tables <- if (is.null(summary_spec)) list() else list("Status summary" = do.call(cata_count_status, c(list(data = data), summary_spec)))
  plot.data <- if (chart_data == "summary") tables[[1]] else data
  plot <- if (is.null(plot_args)) NULL else do.call(cata_plot, c(list(data = plot.data), plot_args))
  for (format in c("report", "dashboard")) {
    do.call(cata_report, c(list(data = data, file = file.path(directory, paste0(format, ".html")),
      plot = plot, tables = tables, audit = audit, format = format), settings$report))
  }
  code <- c(
    "# Run from this project directory in RStudio. No network is required.",
    "library(cataScience)", "library(readr)", "",
    "settings <- readRDS('settings.rds')", "analysis.data <- readRDS('input.rds')", steps, "",
    "saveRDS(analysis.data, 'data.rds')", "write_csv(analysis.data, 'data.csv', na = '')",
    "tables <- if (is.null(settings$summary_spec)) list() else list(",
    "  'Status summary' = do.call(cata_count_status, c(list(data = analysis.data), settings$summary_spec)))",
    "plot.data <- if (settings$chart_data == 'summary') tables[[1]] else analysis.data",
    "figure <- if (is.null(settings$plot_args)) NULL else do.call(cata_plot, c(list(data = plot.data), settings$plot_args))",
    "audit <- readRDS('audit.rds')",
    "for (format in c('report', 'dashboard')) {",
    "  do.call(cata_report, c(list(data = analysis.data, file = paste0(format, '.html'),",
    "    plot = figure, tables = tables, audit = audit, format = format, overwrite = TRUE), settings$report))",
    "}", "writeLines(utils::capture.output(utils::sessionInfo()), 'session-info.txt')"
  )
  writeLines(code, file.path(directory, "analysis.R"))
  writeLines(c("Version: 1.0", "RestoreWorkspace: No", "SaveWorkspace: No", "AlwaysSaveHistory: No"), file.path(directory, "cata-project.Rproj"))
  for (format in c("report", "dashboard")) {
    qmd <- c("---", paste0("title: ", encodeString(title, quote = "\"")), "format:", "  html:", "    embed-resources: true", "execute:", "  echo: false", "  warning: false", "---", "",
      "```{r}", "#| include: false", "library(cataScience)", "library(knitr)", "source('analysis.R', local = TRUE)", "```", "",
      "# Question and finding", "", "```{r}", "#| results: asis", "cat(htmltools::htmlEscape(settings$report$question))", "cat('\n\n')", "cat(htmltools::htmlEscape(settings$report$finding))", "```", "",
      "# Data and methods", "", "```{r}", "knitr::kable(data.frame(Item = c('Source', 'Unit', 'Methods', 'Denominator'),",
      "  Description = unlist(settings$report[c('source', 'unit', 'methods', 'denominator')])))", "```", "",
      "# Figure and tables", "", "```{r}", paste0("#| fig-width: ", width), paste0("#| fig-height: ", height), "if (!is.null(figure)) print(figure)", "```", "",
      "```{r}", "#| results: asis", "for (name in names(tables)) {", "  cat(paste0('<h3>', htmltools::htmlEscape(name), '</h3>'))",
      "  print(knitr::kable(tables[[name]], format = 'html', escape = TRUE))", "}",
      "knitr::kable(cata_profile(analysis.data), format = 'html', escape = TRUE)", "```", "",
      "# Interpretation and limitations", "", "```{r}", "#| results: asis", "cat(htmltools::htmlEscape(settings$report$limitations))", "```")
    if (format == "dashboard") qmd <- sub("^  html:$", "  dashboard:", qmd)
    writeLines(qmd, file.path(directory, paste0(format, ".qmd")))
  }
  shiny <- c("library(shiny)", "library(cataScience)", "library(DT)", "source('analysis.R', local = TRUE)",
    "ui <- fluidPage(titlePanel(settings$report$title), p(settings$report$question),",
    "  p(settings$report$finding), p(paste('Unit:', settings$report$unit)),",
    "  p(paste('Denominator:', settings$report$denominator)),",
    "  plotOutput('figure', height = '480px'), DTOutput('summary'),",
    "  h3('Limitations'), p(settings$report$limitations))",
    "server <- function(input, output, session) {",
    "  output$figure <- renderPlot({ if (!is.null(figure)) figure })",
    "  output$summary <- renderDT({ if (length(tables)) tables[[1]] else cata_profile(analysis.data) })",
    "}", "shinyApp(ui, server)")
  writeLines(shiny, file.path(directory, "app.R"))
  writeLines(c("cataScience communication project", "",
    "Open report.html or dashboard.html directly for offline viewing.",
    "To reproduce: open cata-project.Rproj in RStudio, then source('analysis.R').",
    "The script replays reviewed preparation steps from input.rds, and recreates summaries, charts and HTML.",
    "input.rds is the original snapshot; data.rds/data.csv are selected analysis records.",
    "audit.rds is the recorded preparation log; it is not an independent validation of the analysis.",
    "settings.rds contains chart mappings and author-written text. Review narrative after changing data.",
    "Optional: quarto render report.qmd or quarto render dashboard.qmd (Quarto 1.4+ for dashboards).",
    "Optional: shiny::runApp('.') starts the interactive local dashboard; stop it with Esc in RStudio.",
    "Required R packages: cataScience, readr; shiny and DT for app.R; knitr and htmltools for Quarto.",
    "No API keys or online data services are used. The project includes the selected dataset."), file.path(directory, "README.txt"))
  writeLines(utils::capture.output(utils::sessionInfo()), file.path(directory, "session-info.txt"))
  invisible(normalizePath(directory, winslash = "/", mustWork = TRUE))
}
