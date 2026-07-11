# Print a short missing-data summary.
has_missing <- function(df) {
  if (is.null(df) || !is.data.frame(df)) {
    cat("No dataset is available.")
    return(invisible(NULL))
  }
  if (any_miss(df)) {
    cat(
      "There is still missing data...\n",
      n_miss(df), " values with missing,\n",
      n_var_miss(df), " variables with missing,\n",
      n_case_miss(df), " row incomplete."
    )
  } else {
    cat(capture.output(mice::md.pattern(df, plot = FALSE))[1:6], sep = "\n")
  }
}

# Identify non-outlier values in a numeric vector using the IQR rule.
recognize_outlier <- function(vec, k = 1.5) {
  if (!is.numeric(vec)) {
    return(rep(TRUE, length(vec)))
  }
  if (all(is.na(vec))) {
    return(rep(TRUE, length(vec)))
  }
  q1 <- quantile(vec, .25, na.rm = TRUE)
  q3 <- quantile(vec, .75, na.rm = TRUE)
  iqr <- q3 - q1
  lower <- q1 - k * iqr
  upper <- q3 + k * iqr
  replace_na(between(vec, lower, upper), TRUE)
}

# Winsorize a numeric vector using the IQR rule. NA values are left as NA.
winsorize <- function(vec, k = 1.5) {
  if (!is.numeric(vec)) {
    return(vec)
  }
  if (all(is.na(vec))) {
    return(vec)
  }
  q1 <- quantile(vec, .25, na.rm = TRUE)
  q3 <- quantile(vec, .75, na.rm = TRUE)
  iqr <- q3 - q1
  lower <- q1 - k * iqr
  upper <- q3 + k * iqr
  vec[!is.na(vec) & vec > upper] <- upper
  vec[!is.na(vec) & vec < lower] <- lower
  return(vec)
}

# Return numeric variables with at least one IQR outlier.
recognize_outlier_variable <- function(df, k = 1.5) {
  if (is.null(df) || !is.data.frame(df) || ncol(df) == 0) {
    return(character(0))
  }
  df_num <- df %>%
    select(where(is.numeric))
  if (ncol(df_num) == 0) {
    return(character(0))
  }
  df_num %>%
    mutate(across(everything(), ~ recognize_outlier(.x, k))) %>%
    select(where(~ any(!.x, na.rm = TRUE))) %>%
    names()
}

impute_mean_vars <- function(df, vars) {
  vars <- intersect(vars, names(df))
  if (length(vars) == 0) {
    return(df)
  }
  df %>%
    mutate(across(
      all_of(vars),
      ~ if (is.numeric(.x) && any(!is.na(.x))) {
        replace_na(.x, mean(.x, na.rm = TRUE))
      } else {
        .x
      }
    ))
}

impute_median_vars <- function(df, vars) {
  vars <- intersect(vars, names(df))
  if (length(vars) == 0) {
    return(df)
  }
  df %>%
    mutate(across(
      all_of(vars),
      ~ if (is.numeric(.x) && any(!is.na(.x))) {
        replace_na(.x, median(.x, na.rm = TRUE))
      } else {
        .x
      }
    ))
}

# Test whether a data frame has any IQR outliers.
any_outlier <- function(df, k = 1.5) {
  if (is.null(df) || !is.data.frame(df) || ncol(df) == 0) {
    return(FALSE)
  }
  length(recognize_outlier_variable(df, k)) != 0
}

# Shared datatable settings. Must be rendered with renderDT(server = FALSE):
# with server-side processing the export buttons only receive the visible page,
# not the full dataset.
catatable <- function(df) {
  req(!is.null(df))
  datatable(
    df,
    rownames = FALSE,
    extensions = "Buttons",
    options = list(
      dom = "Bfrtip",
      pageLength = 10,
      scrollX = TRUE,
      buttons = c("copy", "csv", "excel", "print")
    )
  )
}

# Import an uploaded or bundled file, stopping with a readable message when
# the file cannot be used. Callers wrap this in tryCatch + showNotification.
safe_import_data <- function(path) {
  if (is.null(path) || !file.exists(path)) {
    stop("Please upload a valid file.", call. = FALSE)
  }
  df <- rio::import(path)
  if (!is.data.frame(df)) {
    stop("The uploaded file could not be read as a table.", call. = FALSE)
  }
  if (ncol(df) == 0) {
    stop("The uploaded file has no columns.", call. = FALSE)
  }
  as_tibble(df)
}

# Plot theme used in the training app.
theme_cat <- function() {
  theme(
    panel.border = element_rect(color = "grey30"),
    strip.background = element_rect(color = "grey30", fill = "#E6F2F8")
  )
}

# Discrete fill/colour scales matching the app theme (Okabe-Ito, black
# dropped). The palette recycles beyond 8 levels so trainee-uploaded data with
# many categories never crashes a plot.
okabe_ito <- unname(palette.colors(9, palette = "Okabe-Ito"))[-1]

palette_cat <- function() {
  pal <- function(n) rep_len(okabe_ito, n)
  list(
    discrete_scale("fill", palette = pal, na.value = "grey70"),
    discrete_scale("colour", palette = pal, na.value = "grey70")
  )
}

# Trim the plotly toolbar: keep zoom/pan/reset/download, drop the logo and the
# selection tools trainees do not need.
plotly_tidy_toolbar <- function(w) {
  config(
    w,
    displaylogo = FALSE,
    modeBarButtonsToRemove = c(
      "lasso2d", "select2d", "zoomIn2d", "zoomOut2d", "autoScale2d",
      "hoverClosestCartesian", "hoverCompareCartesian", "toggleSpikelines"
    )
  )
}

# ggplotly with the shared toolbar settings.
cata_plotly <- function(p, ...) {
  plotly_tidy_toolbar(ggplotly(p, ...))
}

# Constrain page content on wide screens (see .page-wrap in custom.css).
page_wrap <- function(...) {
  div(class = "page-wrap", ...)
}

# Static image helper: serves files placed under www/picture.
app_img <- function(file, alt = "", class = "img-content", style = NULL) {
  tags$img(src = file.path("picture", file), alt = alt, class = class, style = style)
}

# Markdown include shortcut for content pages.
md_page <- function(file) {
  div(class = "p-2", includeMarkdown(file.path("markdown", file)))
}

# Compact HTML table for small teaching examples (statistics pages).
teach_table <- function(df) {
  tags$table(
    class = "table table-striped table-sm-tight w-auto",
    tags$thead(tags$tr(lapply(names(df), tags$th))),
    tags$tbody(
      lapply(seq_len(nrow(df)), function(i) {
        tags$tr(lapply(df[i, ], function(x) tags$td(format(x))))
      })
    )
  )
}

# Copy-to-clipboard button for a <pre>/<div> element holding text content.
copy_button <- function(target_id, label = "Copy") {
  tags$button(
    class = "btn btn-sm btn-outline-primary mb-2",
    onclick = sprintf(
      "navigator.clipboard.writeText(document.getElementById('%s').innerText).then(() => { this.innerText = 'Copied!'; setTimeout(() => this.innerText = '%s', 1500); });",
      target_id, label
    ),
    label
  )
}
