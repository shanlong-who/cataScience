test_that("chart geometries build for all supported types", {
  data <- data.frame(label = c("A", "B", "C"), year = 2023:2025,
                     value = c(2, 4, 3), second = c(4, 5, 6), lower = c(1, 2, 2), upper = c(3, 6, 4))
  cases <- list(
    list(type = "bar", x = "label"), list(type = "bar", x = "label", y = "value"),
    list(type = "histogram", x = "value"), list(type = "density", x = "value"),
    list(type = "line", x = "year", y = "value"), list(type = "scatter", x = "value", y = "second"),
    list(type = "box", x = "label", y = "value"), list(type = "dot", x = "label", y = "value", percent = TRUE),
    list(type = "heatmap", x = "label", y = "year", value = "value"),
    list(type = "dumbbell", x = "label", y = "value", yend = "second"),
    list(type = "forest", x = "label", y = "value", lower = "lower", upper = "upper", log_scale = TRUE),
    list(type = "cascade", x = "label", y = "value")
  )
  for (args in cases) {
    plot <- do.call(cata_plot, c(list(data = data), args))
    expect_s3_class(plot, "ggplot")
    expect_s3_class(ggplot2::ggplot_build(plot), "ggplot_built")
  }
})

test_that("plots reject ambiguous aggregates and report omitted measurements", {
  data <- data.frame(label = c("A", "A", "B"), value = c(1, 2, NA))
  expect_error(cata_plot(data, "bar", "label", "value"), "Summarise")
  expect_error(cata_plot(data, "line", "label", "value"), "Summarise")
  plot <- cata_plot(data, "scatter", "value", "value")
  expect_equal(attr(plot, "cata_rows")$omitted, 1)
  expect_error(cata_plot(data.frame(label = "A", value = 101), "dot", "label", "value", percent = TRUE), "between 0 and 100")
  expect_error(cata_plot(data.frame(x = "2025", y = 1), "line", "x", "y"), "ordered")
})

test_that("multiple imputation is reproducible and preserves the caller RNG", {
  set.seed(4)
  before <- .Random.seed
  a <- cata_mice_demo(m = 2, maxit = 2)
  expect_identical(.Random.seed, before)
  b <- cata_mice_demo(m = 2, maxit = 2)
  expect_equal(a$comparison, b$comparison)
  expect_equal(sum(is.na(a$incomplete$weight_kg)), 36)
  expect_length(a$completed, 2)
  expect_equal(nrow(a$pooled), 2)
  expect_true(all(vapply(a$completed, function(x) !anyNA(x), logical(1))))
  expect_equal(a$comparison$records, c(120, 84, 120, 120))
})

test_that("missing comparison categories remain visible without merging labels", {
  data <- data.frame(group = c("Hospital", "(Missing)", NA), percent = c(75, 60, 100))
  plot <- cata_plot(data, "dot", "group", "percent", percent = TRUE, sort = TRUE)
  expect_equal(attr(plot, "cata_rows")$used, 3)
  expect_equal(attr(plot, "cata_rows")$omitted, 0)
  expect_equal(nrow(ggplot2::ggplot_build(plot)$data[[1]]), 3)
  expect_equal(length(levels(plot$data$x)), 3)
  expect_error(cata_plot(data, "dumbbell", "group", "percent", yend = "percent", group = "group"), "facets")
})
