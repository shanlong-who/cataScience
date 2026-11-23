miUI <- function(id) {
  ns <- NS(id)
  tagList(h2("Missing data: beyond a single replacement"),
    p("Use a controlled synthetic cat example to see why multiple imputation produces several completed datasets. The original missing weights stay visible."),
    layout_columns(col_widths = c(4, 8),
      card(card_header("Teaching simulation"),
        sliderInput(ns("m"), "Completed datasets", min = 2, max = 10, value = 5, step = 1),
        sliderInput(ns("iterations"), "Iterations", min = 2, max = 15, value = 5, step = 1),
        numericInput(ns("seed"), "Random seed", value = 2026, min = 1, max = 100000),
        actionButton(ns("run"), "Run the cat example", class = "btn-primary"),
        p("120 synthetic cats; 36 weights are hidden at random for this demonstration. The model relates weight to length. IDs are not predictors.")),
      card(card_header("Compare the slope estimates"), plotOutput(ns("comparison"), height = "400px"), DTOutput(ns("estimates")))),
    navset_card_tab(
      nav_panel("Completed values", DTOutput(ns("completed"))),
      nav_panel("Chains", plotOutput(ns("trace"), height = "400px")),
      nav_panel("Missingness pattern", plotOutput(ns("pattern"), height = "360px")),
      nav_panel("R code", verbatimTextOutput(ns("code")))
    ),
    p("Fit the same model in each completed dataset, then pool estimates and uncertainty. Do not stack completed datasets and treat them as independent observations."),
    p("This example illustrates a method. Stable chains do not prove a real study's missingness assumptions. Uploaded patient data are not imputed by this lesson."),
    tags$a(href = "https://amices.org/mice/reference/pool.html", target = "_blank", "mice: pooling documentation"))
}

miServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    result <- eventReactive(input$run, {
      withProgress(message = "Imputing the synthetic cats", value = .2, {
        cataScience::cata_mice_demo(m = input$m, maxit = input$iterations, seed = input$seed)
      })
    })
    output$comparison <- renderPlot({
      req(result())
      cataScience::cata_plot(result()$comparison, "forest", "method", "estimate", lower = "lower", upper = "upper",
        reference = 0, ylab = cata_label("Weight difference (kg) per cm of length"), title = cata_label("One model, different missing-data approaches"))
    })
    output$estimates <- renderDT({
      req(result())
      DT::formatRound(catatable(result()$comparison), c("estimate", "lower", "upper"), digits = 3)
    }, server = FALSE)
    output$completed <- renderDT({
      req(result())
      rows <- result()$missing_rows
      data <- data.frame(cat = rows, length_cm = result()$incomplete$length_cm[rows], observed_weight_kg = NA_real_)
      for (i in seq_along(result()$completed)) data[[paste0("imputation_", i)]] <- result()$completed[[i]]$weight_kg[rows]
      catatable(data)
    }, server = FALSE)
    output$trace <- renderPlot({ req(result()); plot(result()$imputation) })
    output$pattern <- renderPlot({ req(result()); mice::md.pattern(result()$incomplete, rotate.names = TRUE) })
    output$code <- renderText({
      paste0("library(cataScience)\nlibrary(mice)\n\ndemo <- cata_mice_demo(m = ", input$m,
        ", maxit = ", input$iterations, ", seed = ", input$seed,
        ")\ndemo$comparison\nplot(demo$imputation)\n# Fit the same model in each completed dataset; pool model estimates.\n")
    })
  })
}
