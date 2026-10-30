# Extra workshop lessons, loaded only by run_catas().
whyUI <- function(id) {
  ns <- NS(id)
  page_wrap(
    div(class = "workshop-hero",
      div(h1("Why data matters"), p(class = "lead", "Ask a question. Examine the evidence. Explain what should happen next."),
          p("Keep your curiosity: the cats are still here. This workshop connects the data workflow to public health decisions.")),
      tags$img(src = "picture/0-maomi.jpg", alt = "The cataScience teacher cat")),
    navset_card_tab(
      nav_panel("Predict, then reveal",
        h3("Which result needs a closer look?"),
        p("Two fictional district-years from Dataset A. Start with the percentage among people with a usable result."),
        tableOutput(ns("cases")),
        checkboxInput(ns("reveal"), "Reveal testing coverage and denominators", FALSE),
        uiOutput(ns("interpretation")),
        p(class = "text-muted", "Synthetic training cases; not Lao PDR estimates. Dataset A is independent of B/C.")),
      nav_panel("John Snow",
        h3("A map supports an investigation"),
        p("During the 1854 London cholera outbreak, John Snow investigated the link between illness and water supply. Mapping deaths helped communicate a pattern, alongside evidence about which water people used."),
        tags$img(src = "snow-cholera-map.jpg", alt = "John Snow map of recorded cholera deaths and water pumps around Broad Street", style = "max-width:100%;height:auto"),
        p("Discuss: what pattern can you see, what other evidence is needed, and what action could the evidence support? The map alone does not establish causation or measure the effect of removing a pump handle."),
        tags$a(href = "https://wellcomecollection.org/works/dx4prdbj", target = "_blank", "Map source: Wellcome Collection, Public Domain Mark")),
      nav_panel("Care cascade",
        h3("Keep the counts and denominators together"),
        layout_columns(col_widths = c(4, 8),
          card(selectInput(ns("district"), "Fictional district", LETTERS[1:5]),
            selectInput(ns("year"), "Year", 2023:2025, selected = 2025),
            p("L: people living with HIV; D: diagnosed; A: on ART; T: with a usable viral-load result; S: suppressed among those with results."),
            p("These synthetic nested counts are an illustration. S/T describes the tested group; it does not estimate suppression among all people on ART.")),
          card(plotOutput(ns("cascade"), height = "400px"))),
        tableOutput(ns("ratios")),
        p(class = "text-muted", "Dataset A: synthetic training counts, independent of the patient records in B/C.")),
      nav_panel("A figure for the decision-maker",
        h3("Make the message easy to find"),
        tags$ol(tags$li("Name the question and audience before choosing a chart."),
          tags$li("Show a clear comparison, with units and the denominator."),
          tags$li("Keep uncertainty and selection limits visible."),
          tags$li("Ask a partner to explain the chart without seeing your code.")),
        p("Use Workflow to compare a bar chart and a sorted dot plot from the same summary. Decide which better answers your question."),
        tags$a(href = "https://clauswilke.com/dataviz/telling-a-story.html#make-a-figure-for-the-generals", target = "_blank", "Claus O. Wilke: Make a figure for the generals")),
      nav_panel("Course route",
        teach_table(data.frame(Session = c("1-4", "5-7", "8-9", "10-12"),
          Activity = c("Question, observation unit, codebook and denominator", "Review, join, summarise and visualise",
                       "Statistical assumptions and careful interpretation", "Reproducible reports, dashboards and peer review"))),
        p("In Workflow, use the original cats first, then the synthetic public health examples. Core activities and downloads work offline."),
        h4("AI chart comparison: a separate classroom exercise"),
        p("Download the same synthetic data for each AI tool. Ask for several chart options. Check the numbers, denominator, labels, scales and message against R output. Record actual AI use and human verification. No AI connection is required inside this app."),
        p("The communication project contains local RStudio, Quarto and Shiny starting points for Sessions 10-12."))
    )
  )
}

whyServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    cascade.data <- cataScience::cata_example("cascade")
    selected <- reactive({
      req(input$district, input$year)
      cascade.data[cascade.data$district == input$district & cascade.data$year == as.numeric(input$year), ]
    })
    output$cascade <- renderPlot({
      data <- selected()
      counts <- data.frame(stage = c("Living with HIV", "Diagnosed", "On ART", "Usable result", "Suppressed"),
        count = as.numeric(unlist(data[1, c("l", "d", "a", "t", "s")], use.names = FALSE)))
      cataScience::cata_plot(counts, "cascade", "stage", "count", xlab = "", ylab = "People",
        title = paste("District", input$district, input$year), caption = "Synthetic training counts")
    })
    output$ratios <- renderTable({
      data <- selected()
      ratios <- cataScience::cata_proportion(
        c(data$d, data$a, data$t, data$s), c(data$l, data$d, data$a, data$t))
      data.frame(Measure = c("Diagnosed (D/L)", "ART among diagnosed (A/D)",
        "Result coverage (T/A)", "Suppression among results (S/T)"),
        Numerator = ratios$numerator, Denominator = ratios$denominator, Percent = ratios$value)
    }, digits = 1, striped = TRUE, bordered = TRUE)
    cases <- cascade.data
    cases <- cases[(cases$district == "A" & cases$year == 2025) | (cases$district == "C" & cases$year == 2024), ]
    output$cases <- renderTable({
      table <- data.frame(Case = paste(cases$district, cases$year),
        `Suppressed among those with results (S/T, %)` = round(100 * cases$s / cases$t, 1), check.names = FALSE)
      if (isTRUE(input$reveal)) {
        table$`Result coverage among ART patients (T/A, %)` <- round(100 * cases$t / cases$a, 1)
        table$`S / T` <- paste(cases$s, "/", cases$t)
        table$`T / A` <- paste(cases$t, "/", cases$a)
      }
      table
    }, striped = TRUE, bordered = TRUE)
    output$interpretation <- renderUI({
      if (!isTRUE(input$reveal)) return(p("Predict: is the higher percentage enough to judge overall performance?"))
      div(class = "alert alert-info", "The two percentages describe different groups. Ask how people were selected for testing and whether those with results represent all ART patients. High coverage alone does not establish representativeness.")
    })
  })
}

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
        reference = 0, ylab = "Weight difference (kg) per cm of length", title = "One model, different missing-data approaches")
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

publicHealthUI <- function(id) {
  ns <- NS(id)
  tagList(h2("Public health: sample, test and interpretation"),
    p("Reproduce the Lao workshop's fixed synthetic B/C example. Reported VL testing is the outcome; it is not viral suppression or verified result availability."),
    actionButton(ns("run"), "Run the worked example", class = "btn-primary"),
    navset_card_tab(
      nav_panel("Sample and denominator", DTOutput(ns("flow")), DTOutput(ns("summary"))),
      nav_panel("Chi-square", p("Sex by known reported testing status, with the default Yates correction for a 2 × 2 table. Inspect expected counts as well as the test."),
        tableOutput(ns("observed")), tableOutput(ns("expected")), verbatimTextOutput(ns("chisq"))),
      nav_panel("Logistic regression", p("The crude and adjusted models use the same complete-predictor sample. Reference groups: Female and Health Center; age per 10 years, ART duration per 12 months."),
        plotOutput(ns("forest"), height = "430px"), DTOutput(ns("or"))),
      nav_panel("Explain the result", p("An odds ratio is not a probability ratio. An interval including 1 does not demonstrate equality. A converged model does not establish valid inference."),
        p("Ordinary Wald intervals and tests ignore correlation within facilities. Facility type as a predictor does not remove this issue. Selection, source flags, functional-form assumptions and unmeasured factors remain."),
        p("These synthetic examples support descriptive and modelling practice, not national, causal or clinical conclusions."),
        pre("library(cataScience)\nlesson <- cata_lao_analysis()\nlesson$flow\nlesson$chi_square\nlesson$odds_ratios"))
    ))
}

publicHealthServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    result <- eventReactive(input$run, cataScience::cata_lao_analysis())
    output$flow <- renderDT({ req(result()); catatable(result()$flow) }, server = FALSE)
    output$summary <- renderDT({
      req(result())
      data <- result()$summary
      data$group[is.na(data$group)] <- "(Missing)"
      DT::formatRound(catatable(data), "percent", digits = 1)
    }, server = FALSE)
    output$observed <- renderTable({ req(result()); as.data.frame.matrix(result()$chi_table) }, rownames = TRUE)
    output$expected <- renderTable({ req(result()); as.data.frame.matrix(result()$chi_square$expected) }, rownames = TRUE)
    output$chisq <- renderPrint({ req(result()); result()$chi_square })
    output$or <- renderDT({
      req(result())
      DT::formatSignif(catatable(result()$odds_ratios), c("estimate", "lower", "upper", "p_value"), digits = 3)
    }, server = FALSE)
    output$forest <- renderPlot({
      req(result())
      d <- result()$odds_ratios
      d <- d[d$model == "Adjusted", ]
      cataScience::cata_plot(d, "forest", "contrast", "estimate", lower = "lower", upper = "upper",
        log_scale = TRUE, reference = 1, title = "Adjusted associations in the synthetic sample",
        ylab = "Odds ratio (ordinary 95% Wald CI)", caption = "Outcome: reported testing Yes vs No. Within-facility correlation is not accounted for.")
    })
  })
}
