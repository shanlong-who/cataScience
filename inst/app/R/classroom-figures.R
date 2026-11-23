# Two views of the same records, with labels derived from the selected data.
classroom_comparison <- function(df, lesson) {
  group <- "personality"
  field <- if (lesson == "shares") "neutered" else "weight_kg"
  validate(need(all(c(group, field) %in% names(df)),
    cata_label("Select the merged cat tables to compare personality groups.")))
  df <- df[!is.na(df[[group]]) & !is.na(df[[field]]), , drop = FALSE]
  validate(need(nrow(df) > 0, cata_label("No complete records for these fields.")))
  group.n <- table(as.character(df[[group]]))
  axis.labels <- setNames(paste0(names(group.n), " (n=", as.integer(group.n), ")"), names(group.n))
  group.axis <- scale_y_discrete(labels = axis.labels)
  if (lesson == "shares") {
    df$status <- as.character(df$neutered)
    df$status[df$status == "TRUE"] <- cata_label("Yes")
    df$status[df$status == "FALSE"] <- cata_label("No")
    bars <- ggplot(df, aes(y = personality, fill = status)) +
      group.axis + palette_cat() + labs(y = NULL, fill = cata_label("Neutered"))
    counts <- bars + geom_bar() + labs(x = cata_label("Number of cats"))
    shares <- bars + geom_bar(position = "fill") +
      scale_x_continuous(labels = scales::label_percent()) + labs(x = cata_label("Within-group percentage"))
    return(cowplot::plot_grid(counts, shares, nrow = 1))
  }
  validate(need(is.numeric(df$weight_kg), cata_label("Weight must be numeric.")))
  df <- df[is.finite(df$weight_kg), , drop = FALSE]
  validate(need(nrow(df) > 0, cata_label("No complete records for these fields.")))
  means <- summarise(df, average = mean(weight_kg), .by = personality)
  limits <- range(c(0, df$weight_kg))
  weights <- ggplot(df, aes(y = personality, x = weight_kg)) + group.axis +
    scale_x_continuous(limits = limits) + labs(y = NULL, x = cata_label("Weight (kg)"))
  averages <- weights + geom_col(data = means, aes(x = average), fill = "#0072B2") +
    labs(title = cata_label("Mean weight"))
  observations <- weights + geom_point(position = position_jitter(width = 0, height = 0.13, seed = 1),
    color = "#0072B2", alpha = 0.75) +
    geom_point(data = means, aes(x = average), shape = 18, size = 3.5, color = "#D55E00") +
    labs(title = cata_label("Every cat and the mean"))
  cowplot::plot_grid(averages, observations, nrow = 1)
}

classroom_bar_data <- function(df, x, y, order) {
  if (is.numeric(df[[x]]) || inherits(df[[x]], c("Date", "POSIXt"))) return(df)
  label <- as.character(df[[x]])
  if (!isTRUE(order %in% c("descending", "ascending"))) {
    if (!is.factor(df[[x]])) df[[x]] <- factor(label, levels = unique(label[!is.na(label)]))
    return(df)
  }
  weights <- if (is.null(y)) rep(1, nrow(df)) else df[[y]]
  totals <- tapply(weights, label, sum, na.rm = TRUE)
  df[[x]] <- factor(label, levels = names(sort(totals, decreasing = order == "descending")))
  df
}

write_classroom_report <- function(file, chart, finding, limitation, dataset, language) {
  png <- tempfile(fileext = ".png")
  on.exit(unlink(png), add = TRUE)
  ggplot2::ggsave(png, chart, width = 10, height = 5.6, dpi = 140, bg = "white")
  label <- function(x) cata_label(x, language)
  title <- label("My data science report")
  doc <- tags$html(lang = language,
    tags$head(tags$meta(charset = "UTF-8"), tags$title(title),
      tags$meta(name = "viewport", content = "width=device-width, initial-scale=1"),
      tags$style("body{max-width:56rem;margin:auto;padding:2rem;font:1rem/1.5 system-ui,sans-serif;color:#193448}img{max-width:100%;height:auto}p{white-space:pre-wrap}h2{font-size:1.15rem}@media print{body{padding:0}img{max-height:45vh;object-fit:contain}}")),
    tags$body(tags$main(tags$h1(title), tags$p(label("Analysis dataset"), " · ", label(dataset)),
      tags$img(src = base64enc::dataURI(file = png, mime = "image/png"), alt = label("Selected chart")),
      tags$h2(label("One finding")), tags$p(finding),
      tags$h2(label("One limitation")), tags$p(limitation))))
  writeLines(enc2utf8(c("<!doctype html>", as.character(doc))), file, useBytes = TRUE)
}
