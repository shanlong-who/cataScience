var_all <- reactive({
  req(df0())
  names(df0())
})

var_cat <- reactive({
  req(df0())
  df0() %>%
    select(-where(is.numeric)) %>%
    names()
})

var_num <- reactive({
  req(df0())
  df0() %>%
    select(where(is.numeric)) %>%
    names()
})

# Friendly empty state shown in place of every chart until data are available.
validate_vis_data <- function() {
  validate(need(
    df0(),
    paste(
      "No data for this selection yet.",
      "Import data on the Import page;",
      "for the merged dataset, click 'Apply merging' on the Merge page."
    )
  ))
}

# Variable-selector updates, one observer per selector. Each spec: the input
# id, which variable set fills the choices (all/num/cat), and whether the list
# starts with a "(none)" option. The "(none)" value must be a non-empty
# sentinel: selectize turns a value of "" into a placeholder that cannot be
# re-selected once the user picks a real variable.
vis_var_specs <- tribble(
  ~id,           ~vars, ~none,
  "bar_x",       "all", FALSE,
  "bar_y",       "num", FALSE,
  "bar_group",   "cat", TRUE,
  "bar_facet",   "cat", TRUE,
  "hist_x",      "num", FALSE,
  "hist_group",  "cat", TRUE,
  "hist_facet",  "cat", TRUE,
  "den_x",       "num", FALSE,
  "den_group",   "cat", TRUE,
  "den_facet",   "cat", TRUE,
  "pie_x",       "cat", FALSE,
  "line_x",      "all", FALSE,
  "line_y",      "num", FALSE,
  "line_group",  "cat", TRUE,
  "line_facet",  "cat", TRUE,
  "point_x",     "num", FALSE,
  "point_y",     "num", FALSE,
  "point_group", "cat", TRUE,
  "point_facet", "cat", TRUE,
  "box_x",       "all", FALSE,
  "box_y",       "num", FALSE,
  "box_group",   "cat", TRUE,
  "box_facet",   "cat", TRUE
)

pwalk(vis_var_specs, function(id, vars, none) {
  observe({
    req(df0())
    # The bar y-axis is only meaningful for pre-counted data.
    if (id == "bar_y") req(input$pre_count)
    choices <- switch(vars, all = var_all(), num = var_num(), cat = var_cat())
    current_val <- input[[id]]
    if (none) {
      choices <- c("(none)" = "__none__", choices)
      selected_val <- if (!is.null(current_val) && current_val %in% choices) current_val else "__none__"
      updateSelectInput(session, id, choices = choices, selected = selected_val)
    } else {
      selected_val <- if (!is.null(current_val) && current_val %in% choices) current_val else ""
      updateSelectInput(session, id, choices = choices, selected = selected_val)
    }
  })
})

# Typing in the title/subtitle boxes should not redraw the plot on every
# keystroke: wait until the user pauses.
title_lab <- debounce(reactive(input$title), 400)
subtitle_lab <- debounce(reactive(input$subtitle), 400)

# bar ---------------------------------------------------------------------

p_bar <- reactive({
  req(!input$pre_count)
  req(!is.null(input$bar_x))
  .x <- input$bar_x
  .group <- input$bar_group
  .facet <- input$bar_facet

  if (!is.null(.group) && .group != "__none__") {
    p <- ggplot(df0(), aes(.data[[.x]], fill = .data[[.group]])) +
      geom_bar(color = "black", position = input$bar_position)
  } else {
    p <- ggplot(df0(), aes(.data[[.x]])) +
      geom_bar(color = "black")
  }

  if (!is.null(.facet) && .facet != "__none__") {
    p <- p + facet_wrap(vars(.data[[.facet]]))
  }
  p
})

p_col <- reactive({
  req(input$pre_count)
  req(!is.null(input$bar_x))
  req(!is.null(input$bar_y))
  .x <- input$bar_x
  .y <- input$bar_y
  .group <- input$bar_group
  .facet <- input$bar_facet

  if (!is.null(.group) && .group != "__none__") {
    p <- ggplot(df0(), aes(.data[[.x]], .data[[.y]], fill = .data[[.group]])) +
      geom_col(color = "black", position = input$bar_position)
  } else {
    p <- ggplot(df0(), aes(.data[[.x]], .data[[.y]])) +
      geom_col(color = "black")
  }


  if (!is.null(.facet) && .facet != "__none__") {
    p <- p + facet_wrap(vars(.data[[.facet]]))
  }
  p
})

p_bar_col <- reactive({
  p <- if (input$pre_count) p_col() else p_bar()
  p <- p + theme_cat() + palette_cat()
  if (input$flip) p <- p + coord_flip()
  p + labs(title = title_lab(), subtitle = subtitle_lab())
})

# histogram --------------------------------------------------------------------

p_hist <- reactive({
  req(input$hist_bins > 0)
  req(df0())
  req(!is.null(input$hist_x))

  .x <- input$hist_x
  .group <- input$hist_group
  .facet <- input$hist_facet
  .bins <- input$hist_bins

  if (!is.null(.group) && .group != "__none__") {
    p <- ggplot(df0(), aes(.data[[.x]], fill = .data[[.group]])) +
      geom_histogram(color = "black", bins = .bins)
  } else {
    p <- ggplot(df0(), aes(.data[[.x]])) +
      geom_histogram(color = "black", bins = .bins)
  }

  if (!is.null(.facet) && .facet != "__none__") {
    p <- p + facet_wrap(vars(.data[[.facet]]))
  }
  p <- p + theme_cat() + palette_cat()
  if (input$flip) p <- p + coord_flip()
  p + labs(title = title_lab(), subtitle = subtitle_lab())
})

# density --------------------------------------------------------------------

p_den <- reactive({
  req(df0())
  req(!is.null(input$den_x))

  .x <- input$den_x
  .group <- input$den_group
  .facet <- input$den_facet

  if (!is.null(.group) && .group != "__none__") {
    p <- ggplot(df0(), aes(.data[[.x]], color = .data[[.group]])) +
      geom_density()
  } else {
    p <- ggplot(df0(), aes(.data[[.x]])) +
      geom_density()
  }

  if (!is.null(.facet) && .facet != "__none__") {
    p <- p + facet_wrap(vars(.data[[.facet]]))
  }
  p <- p + theme_cat() + palette_cat()
  if (input$flip) p <- p + coord_flip()
  p + labs(title = title_lab(), subtitle = subtitle_lab())
})

# pie --------------------------------------------------------------------------

df0_count <- reactive({
  req(df0())
  if (is.null(input$pie_x) || input$pie_x == "") {
    return(NULL)
  }
  count(df0(), .data[[input$pie_x]]) %>%
    set_names("label", "count")
})

pie_title <- reactive(paste0(title_lab(), "\n", subtitle_lab()))

p_pie <- reactive({
  req(df0_count())
  if (is.null(df0_count())) {
    return(NULL)
  }
  plot_ly(
    df0_count(),
    labels = ~label,
    values = ~count,
    type = "pie"
  ) %>%
    layout(title = list(text = pie_title()))
})

# point ------------------------------------------------------------------------

p_point <- reactive({
  req(df0())
  req(!is.null(input$point_x))
  req(!is.null(input$point_y))

  .x <- input$point_x
  .y <- input$point_y
  .group <- input$point_group
  .facet <- input$point_facet

  if (!is.null(.group) && .group != "__none__") {
    p <- ggplot(df0(), aes(.data[[.x]], .data[[.y]], color = .data[[.group]])) +
      geom_point()
  } else {
    p <- ggplot(df0(), aes(.data[[.x]], .data[[.y]])) +
      geom_point()
  }

  if (!is.null(.facet) && .facet != "__none__") {
    p <- p + facet_wrap(vars(.data[[.facet]]))
  }

  if (input$point_smooth) {
    p <- p + geom_smooth(method = "lm", se = FALSE)
  }
  p <- p + theme_cat() + palette_cat()
  if (input$flip) p <- p + coord_flip()
  p + labs(title = title_lab(), subtitle = subtitle_lab())
})

# box ------------------------------------------------------------------------

p_box <- reactive({
  req(df0())
  req(!is.null(input$box_x))
  req(!is.null(input$box_y))

  .x <- input$box_x
  .y <- input$box_y
  .group <- input$box_group
  .facet <- input$box_facet

  if (!is.null(.group) && .group != "__none__") {
    p <- ggplot(df0(), aes(.data[[.x]], .data[[.y]], fill = .data[[.group]])) +
      geom_boxplot()
  } else {
    p <- ggplot(df0(), aes(.data[[.x]], .data[[.y]])) +
      geom_boxplot()
  }

  if (!is.null(.facet) && .facet != "__none__") {
    p <- p + facet_wrap(vars(.data[[.facet]]))
  }

  p <- p + theme_cat() + palette_cat()
  if (input$flip) p <- p + coord_flip()
  p + labs(title = title_lab(), subtitle = subtitle_lab())
})

# line ------------------------------------------------------------------------

p_line <- reactive({
  req(df0())
  req(!is.null(input$line_x))
  req(!is.null(input$line_y))

  .x <- input$line_x
  .y <- input$line_y
  .group <- input$line_group
  .facet <- input$line_facet

  if (!is.null(.group) && .group != "__none__") {
    p <- ggplot(df0(), aes(.data[[.x]], .data[[.y]],
      color = .data[[.group]], group = .data[[.group]]
    )) +
      geom_line()
  } else {
    p <- ggplot(df0(), aes(.data[[.x]], .data[[.y]], group = 1)) +
      geom_line()
  }

  if (!is.null(.facet) && .facet != "__none__") {
    p <- p + facet_wrap(vars(.data[[.facet]]))
  }

  p <- p + theme_cat() + palette_cat()
  if (input$flip) p <- p + coord_flip()
  p + labs(title = title_lab(), subtitle = subtitle_lab())
})
