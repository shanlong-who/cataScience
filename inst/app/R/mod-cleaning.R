# Per-dataset module: import, missing data, outliers, and text cleaning.
# One cleaningServer() instance per dataset replaces the duplicated df1/df2
# reactive pairs of the old server-missing.R / server-outlier.R / server-text.R.

# ---- UI fragments -----------------------------------------------------------

source("R/source-correction.R", local = TRUE, encoding = "UTF-8")

cleaningImportUI <- function(id, label) {
  ns <- NS(id)
  card(
    card_header(label),
    fileInput(
      ns("file"),
      "Upload a .csv / .xlsx / .xls file (one sheet):",
      multiple = FALSE,
      accept = c(".csv", ".xlsx", ".xls")
    ),
    actionButton(
      ns("demo"),
      "Or use the example data",
      icon = icon("cat"),
      class = "btn-outline-primary"
    ),
    cleaningResetButton(ns("reset_import"))
  )
}

# "Undo everything": restore the dataset as it was imported. Offered on the
# import card and next to every "Apply cleaning" button.
cleaningResetButton <- function(id) {
  actionButton(
    id,
    "Reset to original data",
    icon = icon("rotate-left"),
    class = "btn-outline-secondary"
  )
}

cleaningPreviewUI <- function(id) {
  ns <- NS(id)
  tagList(
    div(DTOutput(ns("datatable")), style = "clear: both; margin-bottom: 15px;"),
    accordion(open = FALSE,
      accordion_panel("Original import", DTOutput(ns("original_table")))),
    div(
      style = "overflow-x: auto; white-space: pre; clear: both; margin-top: 15px;",
      verbatimTextOutput(ns("glimpse"))
    )
  )
}

cleaningMissingUI <- function(id) {
  ns <- NS(id)
  navset_underline(
    nav_panel(
      "Recognize",
      div(class = "my-2", verbatimTextOutput(ns("has_missing"))),
      layout_columns(
        col_widths = c(6, 6, 6, 6),
        card(
          card_header("Where are the missing values?"),
          plotlyOutput(ns("p_vis_miss"))
        ),
        card(
          card_header("Missing values per variable"),
          plotlyOutput(ns("p_gg_miss_var"))
        ),
        card(
          card_header("Missing-data patterns"),
          plotOutput(ns("p_aggr"))
        ),
        card(
          card_header("Missing values per case"),
          plotlyOutput(ns("p_gg_miss_case"))
        )
      )
    ),
    nav_panel("Verify a source record", sourceCorrectionUI(ns("missing_edit"))),
    nav_panel(
      "Deal",
      layout_sidebar(
        sidebar = sidebar(
          width = 320,
          radioButtons(
            ns("deal_missing_method"),
            "Please select a method:",
            choices = c(
              "Drop rows with missing values" = "drop_na",
              "Fill missing values down or up" = "fill",
              "Replace missing with mean" = "mean",
              "Replace missing with median" = "median",
              if (requireNamespace("VIM", quietly = TRUE)) {
                c("K-Nearest Neighbors imputation (optional VIM)" = "knn")
              }
            ),
            selected = "drop_na"
          ),
          checkboxGroupInput(
            ns("missing_variable"),
            "Please select variables to deal with:",
            choices = "All",
            selected = NULL
          ),
          conditionalPanel(
            condition = "input.deal_missing_method == 'fill'",
            ns = ns,
            selectInput(
              ns("missing_params"),
              "Fill direction:",
              choices = c("down", "up"),
              selected = "down"
            )
          ),
          actionButton(
            ns("apply_missing"),
            "Apply cleaning to dataset",
            class = "btn-primary"
          ),
          cleaningResetButton(ns("reset_missing"))
        ),
        card(
          card_header("Preview of the cleaned dataset"),
          DTOutput(ns("df_no_missing"))
        )
      )
    )
  )
}

cleaningOutlierUI <- function(id) {
  ns <- NS(id)
  navset_underline(
    nav_panel(
      "Recognize",
      card(
        card_header("Boxplots of all numeric variables"),
        plotlyOutput(ns("p_outlier"), height = "480px")
      )
    ),
    nav_panel("Verify a source record", sourceCorrectionUI(ns("outlier_edit"))),
    nav_panel(
      "Deal",
      layout_sidebar(
        sidebar = sidebar(
          width = 320,
          radioButtons(
            ns("deal_outlier_method"),
            "Please select a method:",
            choices = c(
              "Remove extreme values" = "remove",
              "Winsorize extreme values" = "winsorize"
            ),
            selected = "remove"
          ),
          checkboxGroupInput(
            ns("outlier_variable"),
            "Select variables to treat:",
            choices = "All",
            selected = NULL
          ),
          actionButton(
            ns("apply_outlier"),
            "Apply cleaning to dataset",
            class = "btn-primary"
          ),
          cleaningResetButton(ns("reset_outlier"))
        ),
        card(
          card_header("Preview of the cleaned dataset"),
          DTOutput(ns("df_no_outlier"))
        )
      )
    )
  )
}

cleaningTextUI <- function(id) {
  ns <- NS(id)
  tagList(
    layout_columns(
      col_widths = c(5, 5, 2),
      card(
        selectizeInput(
          ns("text_variable"),
          "Please select the variables you want to edit:",
          choices = NULL,
          selected = NULL,
          multiple = TRUE
        ),
        selectInput(
          ns("text_uppercase"),
          "Please select a method for upper case:",
          choices = c("ALL UPPER", "all lower", "Like Title", "Like sentence"),
          selected = "Like Title"
        )
      ),
      card(
        textInput(
          ns("text_replace_from"),
          "Please input the text you want to replace from:"
        ),
        textInput(
          ns("text_replace_to"),
          "Please input the text you want to replace to:"
        )
      ),
      card(
        actionButton(ns("show_text"), "Show results", class = "btn-outline-primary mb-2"),
        actionButton(ns("apply_text"), "Apply cleaning to dataset", class = "btn-primary mb-2"),
        cleaningResetButton(ns("reset_text"))
      )
    ),
    card(DTOutput(ns("df_clean_text")))
  )
}

# ---- Server -----------------------------------------------------------------

# data_rv: a reactiveVal holding the dataset; the module reads it and writes
# cleaned versions back, so merging/visualization at the top level see updates.
cleaningServer <- function(id, data_rv, demo_file = NULL) {
  moduleServer(id, function(input, output, session) {
    # Untouched copy of the last import, for the reset buttons.
    initial <- isolate(data_rv())
    raw_rv <- reactiveVal(initial)
    rows <- reactiveVal(seq_len(NROW(initial)))
    history <- reactiveVal(tibble())
    generation <- reactiveVal(0L)
    import.version <- reactiveVal(0L)
    example <- reactiveVal(FALSE)
    restore <- function(df) {
      generation(generation() + 1L)
      rows(seq_len(nrow(df)))
      history(tibble())
      data_rv(df)
    }
    load_data <- function(df, case.one = FALSE) {
      raw_rv(df)
      example(case.one)
      import.version(import.version() + 1L)
      restore(df)
    }
    sourceCorrectionServer("missing_edit", TRUE, data_rv, raw_rv, rows, history, generation, example)
    sourceCorrectionServer("outlier_edit", FALSE, data_rv, raw_rv, rows, history, generation, example)

    # Friendly empty state shown in place of tables and plots before import.
    need_data <- function() {
      validate(need(
        data_rv(),
        cata_label("No data yet — upload a file or load the example data on the Import page.")
      ))
    }

    # Import -------------------------------------------------------------
    observeEvent(input$file, {
      tryCatch(
        {
          df <- safe_import_data(input$file$datapath, input$file$name)
          load_data(df)
        },
        error = function(e) {
          showNotification(conditionMessage(e), type = "error")
        }
      )
    })

    observeEvent(input$demo, {
      req(demo_file)
      tryCatch(
        {
          df <- safe_import_data(demo_file)
          load_data(df, basename(demo_file) == "cat-dirty-data.xlsx")
          showNotification(
            paste("Example data loaded:", basename(demo_file)),
            type = "message"
          )
        },
        error = function(e) {
          showNotification(conditionMessage(e), type = "error")
        }
      )
    })

    # One reset button per cleaning page, all with the same behaviour.
    walk(
      c("reset_import", "reset_missing", "reset_outlier", "reset_text"),
      function(.id) {
        observeEvent(input[[.id]], {
          req(raw_rv())
          restore(raw_rv())
          showNotification(
            "Dataset restored to the original import.",
            type = "message"
          )
        })
      }
    )

    output$datatable <- renderDT(
      {
        need_data()
        catatable(data_rv())
      },
      server = FALSE
    )
    output$original_table <- renderDT({
      need_data()
      catatable(raw_rv())
    }, server = FALSE)
    output$glimpse <- renderPrint({
      req(data_rv())
      old_width <- getOption("width")
      old_twidth <- getOption("tibble.width")
      options(width = 150, tibble.width = Inf)
      on.exit({
        options(width = old_width)
        options(tibble.width = old_twidth)
      })
      print(skim(data_rv()))
    })

    # Missing data ---------------------------------------------------------
    observe({
      df <- data_rv()
      req(df, any_miss(df))
      updateCheckboxGroupInput(
        session,
        "missing_variable",
        choices = c("All", miss_var_which(df)),
        selected = NULL
      )
    })

    missing_variable <- reactive({
      req(data_rv())
      if (is.null(input$missing_variable)) {
        character(0)
      } else if (any(input$missing_variable == "All")) {
        miss_var_which(data_rv())
      } else {
        intersect(input$missing_variable, names(data_rv()))
      }
    })

    complete_rows <- reactive({
      vars <- missing_variable()
      if (length(vars)) stats::complete.cases(data_rv()[vars]) else rep(TRUE, nrow(data_rv()))
    })

    df_fill <- reactive({
      req(input$deal_missing_method == "fill")
      req(input$missing_params)
      if (length(missing_variable()) == 0) {
        data_rv()
      } else {
        fill(data_rv(), missing_variable(), .direction = input$missing_params)
      }
    })

    df_mean <- reactive({
      req(input$deal_missing_method == "mean")
      impute_mean_vars(data_rv(), missing_variable())
    })

    df_median <- reactive({
      req(input$deal_missing_method == "median")
      impute_median_vars(data_rv(), missing_variable())
    })

    df_knn <- reactive({
      req(input$deal_missing_method == "knn")
      if (length(missing_variable()) == 0 || all_complete(data_rv())) {
        data_rv()
      } else {
        validate(need(requireNamespace("VIM", quietly = TRUE),
                      "The optional VIM package is needed for kNN imputation."))
        VIM::kNN(data_rv(), missing_variable(), imp_var = FALSE)
      }
    })

    df_no_missing <- reactive({
      req(data_rv())
      req(input$deal_missing_method)
      switch(
        input$deal_missing_method,
        "drop_na" = data_rv()[complete_rows(), , drop = FALSE],
        "fill" = df_fill(),
        "mean" = df_mean(),
        "median" = df_median(),
        "knn" = df_knn()
      )
    })

    observeEvent(input$apply_missing, {
      if (!is.null(input$deal_missing_method)) {
        cleaned <- df_no_missing()
        if (input$deal_missing_method == "drop_na") rows(rows()[complete_rows()])
        data_rv(cleaned)
      }
    })

    # has_missing() prints its own "No dataset is available." message, so no
    # req() here.
    output$has_missing <- renderPrint({
      has_missing(data_rv())
    })

    need_missing <- function() {
      need_data()
      validate(need(
        any_miss(data_rv()),
        cata_label("No missing values in this dataset. 🎉")
      ))
    }

    output$p_vis_miss <- renderPlotly({
      need_missing()
      cata_plotly(vis_miss(data_rv()))
    })
    output$p_aggr <- renderPlot({
      need_missing()
      mice::md.pattern(as.data.frame(data_rv()), rotate.names = TRUE)
    })
    output$p_gg_miss_var <- renderPlotly({
      need_missing()
      cata_plotly(gg_miss_var(data_rv()))
    })
    output$p_gg_miss_case <- renderPlotly({
      need_missing()
      cata_plotly(gg_miss_case(data_rv()))
    })
    output$df_no_missing <- renderDT(
      {
        need_data()
        catatable(df_no_missing())
      },
      server = FALSE
    )

    # Outliers -------------------------------------------------------------
    observe({
      df <- data_rv()
      req(df)
      req(any_outlier(df))
      updateCheckboxGroupInput(
        session,
        "outlier_variable",
        choices = c("All", recognize_outlier_variable(df)),
        selected = NULL
      )
    })

    outlier_variable <- reactive({
      req(data_rv())
      if (is.null(input$outlier_variable)) {
        character(0)
      } else if (any(input$outlier_variable == "All")) {
        recognize_outlier_variable(data_rv())
      } else {
        intersect(input$outlier_variable, recognize_outlier_variable(data_rv()))
      }
    })

    non_extreme_rows <- reactive({
      vars <- outlier_variable()
      if (length(vars)) Reduce(`&`, lapply(data_rv()[vars], recognize_outlier)) else rep(TRUE, nrow(data_rv()))
    })

    df_winsorize <- reactive({
      if (length(outlier_variable()) == 0) {
        data_rv()
      } else {
        data_rv() %>%
          mutate(across(outlier_variable(), winsorize))
      }
    })

    df_no_outlier <- reactive({
      req(data_rv())
      req(input$deal_outlier_method)
      switch(
        input$deal_outlier_method,
        "remove" = data_rv()[non_extreme_rows(), , drop = FALSE],
        "winsorize" = df_winsorize()
      )
    })

    observeEvent(input$apply_outlier, {
      if (!is.null(input$deal_outlier_method)) {
        cleaned <- df_no_outlier()
        if (input$deal_outlier_method == "remove") rows(rows()[non_extreme_rows()])
        data_rv(cleaned)
      }
    })

    df_long <- reactive({
      df_num <- data_rv() %>%
        select(where(is.numeric))
      validate(need(ncol(df_num) > 0, cata_label("No numeric variables are available.")))
      df_num %>%
        mutate(.id = seq_len(nrow(.))) %>%
        pivot_longer(-.id, names_to = "name", values_to = "value", names_transform = fct) %>%
        # Boxplots ignore missing values anyway; dropping them here keeps the
        # console free of "removed n rows" warnings while data is being cleaned.
        filter(!is.na(value))
    })

    output$p_outlier <- renderPlotly({
      need_data()
      p <- ggplot(df_long(), aes(name, value)) +
        geom_boxplot() +
        labs(x = "", y = "")
      cata_plotly(p)
    })
    output$df_no_outlier <- renderDT(
      {
        need_data()
        catatable(df_no_outlier())
      },
      server = FALSE
    )

    # Text cleaning ----------------------------------------------------------
    # Only character columns are offered: applying str_to_upper() etc. to a
    # numeric column would silently convert it to text.
    observe({
      df <- data_rv()
      req(df)
      updateSelectizeInput(
        session,
        "text_variable",
        choices = names(select(df, where(is.character))),
        selected = NULL
      )
    })

    text.settings <- eventReactive(input$show_text, {
      list(vars = input$text_variable, case = input$text_uppercase,
           from = input$text_replace_from, to = input$text_replace_to, generation = generation())
    })
    df_cleaned_text <- reactive({
      settings <- text.settings()
      req(identical(settings$generation, generation()))
      req(data_rv())
      df_tmp <- data_rv()
      vars <- intersect(
        settings$vars,
        names(select(df_tmp, where(is.character)))
      )
      if (length(vars) > 0) {
        fn <- switch(
          settings$case,
          "ALL UPPER" = str_to_upper,
          "all lower" = str_to_lower,
          "Like Title" = str_to_title,
          "Like sentence" = str_to_sentence
        )
        df_tmp <- df_tmp %>%
          mutate(across(all_of(vars), fn))
        # Whole-cell replacement by exact match, not regex: trainee input like
        # "N/A (unknown)" must never be interpreted as a pattern.
        if (settings$from != "") {
          df_tmp <- df_tmp %>%
            mutate(
              across(
                all_of(vars),
                ~ if_else(
                  .x == settings$from,
                  settings$to,
                  .x,
                  missing = .x
                )
              )
            )
        }
      }
      df_tmp
    })

    observeEvent(input$apply_text, {
      data_rv(df_cleaned_text())
    })

    output$df_clean_text <- renderDT(
      {
        need_data()
        catatable(df_cleaned_text())
      },
      server = FALSE
    )
    import.version
  })
}
