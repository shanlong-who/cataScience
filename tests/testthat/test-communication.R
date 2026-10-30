test_that("HTML exports escape author text and include an offline chart", {
  path <- tempfile(fileext = ".html")
  data <- data.frame(group = c("A", "B"), value = c(2, 3))
  plot <- cata_plot(data, "dot", "group", "value")
  cata_report(data, path, title = "<script>bad()</script>", finding = "A & B", plot = plot, format = "dashboard")
  html <- paste(readLines(path, warn = FALSE), collapse = "\n")
  expect_match(html, "&lt;script&gt;", fixed = TRUE)
  expect_false(grepl("<script>bad()", html, fixed = TRUE))
  expect_match(html, "data:image/png;base64,", fixed = TRUE)
  expect_match(html, "table-search", fixed = TRUE)
  expect_error(cata_report(data, path), "already exists")
})

test_that("an exported project replays preparation and recreates its results", {
  input <- data.frame(id = c("001", "002", "003"), status = c("Yes", "No", "Unknown"), keep = c(TRUE, TRUE, FALSE))
  selected <- input[input$keep, , drop = FALSE]
  directory <- tempfile("project with spaces ")
  cata_export(selected, directory, input = input,
    steps = "analysis.data <- analysis.data[analysis.data$keep, , drop = FALSE]",
    summary_spec = list(status = "status"), chart_data = "summary",
    plot_args = list(type = "dot", x = "group", y = "percent", percent = TRUE),
    title = "Synthetic test", denominator = "Known Yes/No statuses")
  expect_true(all(file.exists(file.path(directory, c("input.rds", "data.csv", "report.html", "dashboard.html", "analysis.R", "report.qmd", "dashboard.qmd", "app.R")))))
  withr::local_dir(directory)
  env <- new.env(parent = globalenv())
  source("analysis.R", local = env)
  expect_equal(env$analysis.data, selected)
  expect_identical(env$analysis.data$id, c("001", "002"))
  expect_equal(env$tables[[1]]$percent, 50)
  expect_error(cata_export(selected, directory), "protected")
})
