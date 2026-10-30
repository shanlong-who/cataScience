#' A clear theme for training figures
#' @param base_size Base text size in points.
#' @param style Use the built-in theme or the optional DSIR theme.
#' @return A ggplot2 theme.
#' @export
#' @examples
#' theme_cata()
theme_cata <- function(base_size = 13, style = c("cata", "dsi")) {
  style <- match.arg(style)
  if (style == "dsi") {
    if (!requireNamespace("DSIR", quietly = TRUE)) {
      stop("Install the optional DSIR package to use its theme.", call. = FALSE)
    }
    return(DSIR::theme_dsi(base_size = base_size))
  }
  ggplot2::theme_minimal(base_size = base_size) +
    ggplot2::theme(panel.grid.minor = ggplot2::element_blank(),
                   plot.title.position = "plot", plot.caption.position = "plot",
                   plot.title = ggplot2::element_text(face = "bold"),
                   legend.position = "bottom")
}

#' Create a chart with explicit variable names
#'
#' Returns an editable ggplot object. Bar charts count rows when `y` is NULL;
#' supplying `y` uses already summarised values and requires unique chart
#' keys. Lines also require one value per x/group/facet. Charts omit rows
#' missing a required measurement and report that count in the caption.
#' Missing categories in comparison charts are labelled explicitly.
#' @param data A data frame.
#' @param type Chart type: bar, histogram, density, line, scatter, box, dot,
#'   heatmap, dumbbell, forest, or cascade.
#' @param x,y Names of axis variables. `y` is optional only for a count bar,
#'   histogram, or density plot. For a forest plot, x contains term labels.
#' @param group,facet Optional grouping and faceting variable names.
#' @param value Numeric fill variable for a heatmap.
#' @param yend Second numeric value for a dumbbell chart.
#' @param lower,upper Numeric confidence-limit columns for a forest plot.
#' @param title,subtitle,caption Plot text.
#' @param xlab,ylab Optional axis labels, including units where appropriate.
#' @param sort Sort a single-series bar/dot/dumbbell by its value.
#' @param percent Whether values are percentages on a 0 to 100 scale.
#' @param bins Number of histogram bins.
#' @param style Built-in `"cata"` or optional `"dsi"` theme.
#' @param log_scale Use a logarithmic estimate axis for a forest plot.
#' @param reference Reference value for a forest plot (1 for an odds ratio).
#' @return A ggplot object with a `cata_rows` attribute describing input,
#'   plotted, and omitted rows.
#' @importFrom rlang .data
#' @export
#' @examples
#' d <- data.frame(district = c("A", "B"), percent = c(75, 68))
#' cata_plot(d, "dot", "district", "percent", percent = TRUE)
cata_plot <- function(data, type = "bar", x, y = NULL, group = NULL,
                      facet = NULL, value = NULL, yend = NULL, lower = NULL,
                      upper = NULL, title = NULL, subtitle = NULL, caption = NULL,
                      xlab = NULL, ylab = NULL, sort = FALSE, percent = FALSE,
                      bins = 10, style = "cata", log_scale = FALSE, reference = 1) {
  type <- match.arg(type, c("bar", "histogram", "density", "line", "scatter",
                            "box", "dot", "heatmap", "dumbbell", "forest", "cascade"))
  if (!is.null(group) && type %in% c("heatmap", "dumbbell", "cascade")) {
    stop("Use facets to compare groups in a heatmap, dumbbell or cascade chart.", call. = FALSE)
  }
  mappings <- list(x = x, y = y, group = group, facet = facet, value = value,
                   yend = yend, lower = lower, upper = upper)
  present <- mappings[!vapply(mappings, is.null, logical(1))]
  if (any(lengths(present) != 1L)) stop("Choose one column for each mapping.", call. = FALSE)
  cata_assert_columns(data, unique(unlist(present, use.names = FALSE)))
  if (is.null(y) && !type %in% c("bar", "histogram", "density")) {
    stop("This chart needs a y variable.", call. = FALSE)
  }
  if (type == "heatmap" && is.null(value)) stop("Select a numeric heatmap value.", call. = FALSE)
  if (type == "dumbbell" && is.null(yend)) stop("Select both values for a dumbbell.", call. = FALSE)
  if (type == "forest" && (is.null(lower) || is.null(upper))) stop("Select both confidence limits.", call. = FALSE)
  numeric.columns <- unique(c(if (type %in% c("histogram", "density", "scatter")) x,
    if (type != "heatmap") y, value, yend, lower, upper))
  if (length(numeric.columns)) cata_assert_columns(data, numeric.columns, numeric = TRUE)
  plot.data <- as.data.frame(data[unlist(present, use.names = FALSE)], check.names = FALSE)
  names(plot.data) <- names(present)
  if (type %in% c("bar", "box", "dot", "dumbbell", "forest", "cascade") && anyNA(plot.data$x)) {
    labels <- as.character(plot.data$x)
    missing.label <- "(Missing)"
    while (missing.label %in% labels) missing.label <- paste0(missing.label, "*")
    labels[is.na(labels)] <- missing.label
    plot.data$x <- labels
  }
  needed <- setdiff(names(plot.data), c("group", "facet"))
  keep <- stats::complete.cases(plot.data[needed])
  for (column in intersect(names(plot.data), names(present)[vapply(present, function(z) z %in% numeric.columns, logical(1))])) {
    keep <- keep & is.finite(plot.data[[column]])
  }
  plot.data <- plot.data[keep, , drop = FALSE]
  if (!nrow(plot.data)) stop("No usable rows for the selected chart.", call. = FALSE)
  for (column in intersect(c("group", "facet"), names(plot.data))) {
    plot.data[[column]] <- factor(ifelse(is.na(plot.data[[column]]), "(Missing)", as.character(plot.data[[column]])))
  }
  if (!is.null(group) && length(unique(plot.data$group)) > 8) {
    warning("More than eight groups: consider faceting or showing a subset.", call. = FALSE)
  }
  keys <- intersect(c("x", "group", "facet"), names(plot.data))
  if ((type %in% c("line", "dot", "dumbbell", "forest", "cascade") ||
       (type == "bar" && !is.null(y))) && anyDuplicated(plot.data[keys])) {
    stop("Multiple rows share a chart key. Summarise first or choose a grouping variable.", call. = FALSE)
  }
  if (type == "heatmap" && anyDuplicated(plot.data[intersect(c("x", "y", "facet"), names(plot.data))])) {
    stop("A heatmap needs one value per x/y/facet combination.", call. = FALSE)
  }
  if (type == "line" && !(is.numeric(plot.data$x) || inherits(plot.data$x, "Date") ||
                          inherits(plot.data$x, "POSIXt") || is.ordered(plot.data$x))) {
    stop("Use numeric, date, or explicitly ordered x values for a line chart.", call. = FALSE)
  }
  if (type %in% c("histogram", "density") &&
      (length(bins) != 1L || !is.finite(bins) || bins < 1 || bins != as.integer(bins))) {
    stop("'bins' must be a positive integer.", call. = FALSE)
  }
  if (type == "density" && length(unique(plot.data$x)) < 2L) {
    stop("Density estimation needs at least two distinct observations.", call. = FALSE)
  }
  if (percent && type %in% c("histogram", "density", "scatter", "box", "heatmap", "forest")) {
    stop("Percentage scaling is supported for bar, line, dot, dumbbell and cascade charts.", call. = FALSE)
  }
  if (percent && (is.null(y) || any(plot.data$y < 0 | plot.data$y > 100) ||
                 (!is.null(yend) && any(plot.data$yend < 0 | plot.data$yend > 100)))) {
    stop("Percentages must be supplied as values between 0 and 100.", call. = FALSE)
  }
  if (type == "forest") {
    if (any(plot.data$lower > plot.data$y | plot.data$upper < plot.data$y)) {
      stop("Each estimate must lie within its confidence limits.", call. = FALSE)
    }
    if (length(reference) != 1 || !is.finite(reference)) stop("Supply a finite reference value.", call. = FALSE)
    if (log_scale && (any(plot.data$lower <= 0) || reference <= 0)) {
      stop("Logarithmic forest plots require positive estimates, bounds and reference.", call. = FALSE)
    }
  }
  if (sort && is.null(group) && type %in% c("bar", "dot", "dumbbell") && !is.null(y)) {
    ordered <- unique(as.character(plot.data$x[order(plot.data$y)]))
    plot.data$x <- factor(plot.data$x, levels = ordered)
  } else if (type %in% c("box", "dot", "dumbbell", "forest", "cascade")) {
    plot.data$x <- factor(plot.data$x, levels = unique(as.character(plot.data$x)))
  }
  p <- ggplot2::ggplot(plot.data, ggplot2::aes(x = .data$x))
  if (!is.null(y)) p <- p + ggplot2::aes(y = .data$y)
  if (!is.null(group)) p <- p + ggplot2::aes(colour = .data$group, fill = .data$group, group = .data$group)
  blue <- "#0072B2"
  if (type == "bar") {
    p <- if (is.null(y)) p + ggplot2::geom_bar(position = "dodge", colour = NA) else p + ggplot2::geom_col(position = "dodge", colour = NA)
  } else if (type == "histogram") {
    p <- p + ggplot2::geom_histogram(bins = bins, position = "identity", alpha = .65, colour = "white")
  } else if (type == "density") {
    p <- p + ggplot2::geom_density(fill = NA, linewidth = .8)
  } else if (type == "line") {
    if (is.null(group)) p <- p + ggplot2::aes(group = 1)
    p <- p + ggplot2::geom_line(linewidth = .8) + ggplot2::geom_point(size = 2)
  } else if (type == "scatter") {
    p <- p + ggplot2::geom_point(alpha = .75, size = 2.5)
  } else if (type == "box") {
    p <- p + ggplot2::geom_boxplot()
  } else if (type == "dot") {
    p <- p + ggplot2::geom_point(size = 3) + ggplot2::coord_flip()
  } else if (type == "heatmap") {
    p <- p + ggplot2::aes(fill = .data$value) + ggplot2::geom_tile(colour = "white") +
      ggplot2::scale_fill_viridis_c(name = value)
  } else if (type == "dumbbell") {
    p <- p + ggplot2::geom_segment(ggplot2::aes(xend = .data$x, yend = .data$yend), colour = "grey65", linewidth = 1) +
      ggplot2::geom_point(ggplot2::aes(colour = "First"), size = 3) +
      ggplot2::geom_point(ggplot2::aes(y = .data$yend, colour = "Second"), size = 3) +
      ggplot2::scale_colour_manual(values = c(First = "#0072B2", Second = "#D55E00"),
                                   labels = c(First = y, Second = yend), name = NULL) + ggplot2::coord_flip()
  } else if (type == "forest") {
    p <- p + ggplot2::geom_hline(yintercept = reference, linetype = "dashed", colour = "grey60") +
      ggplot2::geom_errorbar(ggplot2::aes(ymin = .data$lower, ymax = .data$upper), width = .18) +
      ggplot2::geom_point(size = 2.8) + ggplot2::coord_flip()
    if (log_scale) p <- p + ggplot2::scale_y_log10()
  } else if (type == "cascade") {
    if (any(plot.data$y < 0)) stop("Cascade counts must be non-negative.", call. = FALSE)
    p <- p + ggplot2::geom_col(fill = blue) + ggplot2::geom_text(ggplot2::aes(label = .data$y), vjust = -.4)
  }
  if (!is.null(group) && !type %in% c("heatmap", "dumbbell")) {
    p <- p + ggplot2::scale_colour_viridis_d(name = group, end = .85) +
      ggplot2::scale_fill_viridis_d(name = group, end = .85)
  }
  if (!is.null(facet)) p <- p + ggplot2::facet_wrap(ggplot2::vars(.data$facet))
  if (percent) p <- p + ggplot2::scale_y_continuous(limits = c(0, 100), labels = scales::label_percent(scale = 1))
  default.y <- if (type == "density") "Density" else if (is.null(y)) "Records" else y
  counts <- list(input = nrow(data), used = nrow(plot.data), omitted = sum(!keep))
  note <- sprintf("Rows used: %s; excluded for missing/non-finite chart values: %s.", counts$used, counts$omitted)
  caption <- paste(c(caption, note), collapse = "\n")
  p <- p + ggplot2::labs(title = title, subtitle = subtitle,
                         x = if (is.null(xlab)) x else xlab,
                         y = if (is.null(ylab)) default.y else ylab, caption = caption) + theme_cata(style = style)
  attr(p, "cata_rows") <- counts
  p
}
