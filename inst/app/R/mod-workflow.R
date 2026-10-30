# One session-local workflow connects data preparation, figures and exports.
workflowUI <- function(id) {
  ns <- NS(id)
  optional <- function(id, label) selectInput(ns(id), label, choices = c("(none)" = "__none__"))
  tagList(
    h2("Your data workflow"),
    p("Keep the input, record each decision, then communicate a result that another person can reproduce."),
    layout_columns(col_widths = c(4, 4, 4),
      card(card_header("Teaching data"),
        selectInput(ns("example"), "Example", choices = c("Original cats" = "cats", "Second cat table" = "cats2",
          "A: fictional district-year cascade" = "cascade", "B: raw ART records" = "art_raw",
          "B: reference with review flags" = "art", "C: fictional facilities" = "facilities")),
        actionButton(ns("load"), "Load example", class = "btn-primary")),
      card(card_header("Your data"),
        fileInput(ns("file"), "Upload CSV or Excel", accept = c(".csv", ".xls", ".xlsx")),
        selectInput(ns("existing"), "Or use an app dataset", c("Dataset 1" = "ds1", "Dataset 2" = "ds2", "Applied merge" = "merged")),
        actionButton(ns("use_existing"), "Use this dataset")),
      card(card_header("Current selection"), textOutput(ns("dimensions")),
        actionButton(ns("undo"), "Undo last step", class = "btn-outline-secondary"),
        actionButton(ns("reset"), "Reset to input", class = "btn-outline-secondary"),
        p(class = "small text-muted", "The workflow keeps its own input snapshot. Changes on other app pages are imported only when you click Use this dataset."))),
    navset_card_tab(id = ns("stage"),
      nav_panel("1 Understand", value = "understand",
        layout_columns(col_widths = c(6, 6),
          textInput(ns("source"), "Source and scope", "Original cataScience cat teaching example; not a representative sample"),
          textInput(ns("unit"), "What does one row represent?", "Cat record; confirm measurement and sampling details")),
        DTOutput(ns("data")),
        accordion(open = FALSE,
          accordion_panel("Variable profile", DTOutput(ns("profile"))),
          accordion_panel("Codebook and provenance", uiOutput(ns("codebook"))))),
      nav_panel("2 Review quality", value = "quality",
        layout_columns(col_widths = c(6, 6),
          card(card_header("Record keys"), selectizeInput(ns("key"), "Proposed key", choices = NULL, multiple = TRUE),
            DTOutput(ns("key_summary")), DTOutput(ns("key_rows"))),
          card(card_header("Missing values"), plotOutput(ns("missing"), height = "280px"),
            verbatimTextOutput(ns("missing_message")),
            p("A blank is not zero. A missing result can be expected when no test was reported. Consult the codebook."))),
        layout_columns(col_widths = c(6, 6),
          card(card_header("Add an outlier/review flag"),
            selectInput(ns("flag_var"), "Numeric field", choices = NULL),
            radioButtons(ns("flag_method"), "Screening rule", c("IQR screen" = "iqr", "Documented limits" = "limits"), inline = TRUE),
            conditionalPanel("input.flag_method == 'iqr'", ns = ns, numericInput(ns("k"), "IQR multiplier", 1.5, min = 0)),
            conditionalPanel("input.flag_method == 'limits'", ns = ns,
              numericInput(ns("lower"), "Lowest allowed value", 18), numericInput(ns("upper"), "Highest allowed value", 110)),
            textInput(ns("flag_name"), "New flag column", "value_review"),
            checkboxInput(ns("flag_missing"), "Also flag missing values for review", TRUE),
            actionButton(ns("flag"), "Add review flag"),
            p("A flag requests review. It does not delete or cap a value.")),
          card(card_header("Standardise documented labels"),
            selectInput(ns("category_var"), "Original field", choices = NULL),
            selectizeInput(ns("category_from"), "Source labels", choices = NULL, multiple = TRUE),
            textInput(ns("category_to"), "Documented replacement", "Female"),
            textInput(ns("category_name"), "New standardised column", "category_standard"),
            actionButton(ns("recode"), "Add or update standardised column"),
            p("Unselected labels remain unchanged. The original column is retained; unknown categories are not guessed.")))),
      nav_panel("3 Join and summarise", value = "summarise",
        layout_columns(col_widths = c(6, 6),
          card(card_header("Check and join a reference table"),
            selectInput(ns("reference"), "Reference", c("C: fictional facilities" = "facilities", "App Dataset 2" = "ds2")),
            selectizeInput(ns("left_key"), "Key in current records", choices = NULL, multiple = TRUE),
            selectizeInput(ns("right_key"), "Key in reference", choices = NULL, multiple = TRUE),
            selectInput(ns("relationship"), "Expected relationship", c("many-to-one", "one-to-one", "one-to-many", "many-to-many")),
            actionButton(ns("join"), "Check keys and join"),
            p("Missing keys do not match. Overlapping non-key names receive .record and .reference suffixes. Facility location does not replace patient residence."),
            DTOutput(ns("join_audit"))),
          card(card_header("Declare the analysis sample"),
            selectizeInput(ns("exclude_flags"), "Exclude rows with these review flags (TRUE or unknown)", choices = NULL, multiple = TRUE),
            actionButton(ns("exclude"), "Apply flag-based selection"),
            optional("filter_var", "Optional category filter"),
            selectizeInput(ns("filter_values"), "Keep these values", choices = NULL, multiple = TRUE),
            checkboxInput(ns("keep_missing"), "Keep missing values in this filter", TRUE),
            actionButton(ns("filter"), "Apply category selection"),
            tags$hr(), actionButton(ns("course_selection"), "Apply the S7 B-reference sample rule"),
            p("S7: retain records with record_action = retain and no age or ART review flag. The full input stays available."))),
        card(card_header("A percentage with a named denominator"),
          layout_columns(col_widths = c(3, 3, 3, 3),
            optional("status", "Reported status field"), textInput(ns("yes"), "Success label", "Yes"),
            textInput(ns("no"), "Failure label", "No"), optional("summary_group", "Group")),
          p("Percentage = success / (success + failure) × 100. Other and blank statuses stay visible outside this denominator."),
          DTOutput(ns("status_summary")))),
      nav_panel("4 Visualise", value = "visualise",
        layout_sidebar(sidebar = sidebar(width = 330,
          selectInput(ns("plot_data"), "Data to plot", c("Selected records" = "records", "Status summary" = "summary")),
          selectInput(ns("plot_type"), "Chart", c("Bar" = "bar", "Sorted dot" = "dot", "Histogram" = "histogram",
            "Density" = "density", "Line" = "line", "Scatter" = "scatter", "Box" = "box", "Heatmap" = "heatmap",
            "Dumbbell" = "dumbbell", "Forest" = "forest", "Cascade counts" = "cascade")),
          selectInput(ns("plot_x"), "X / category / term", choices = NULL),
          optional("plot_y", "Y / estimate (none = count records for bars)"),
          optional("plot_group", "Group"), optional("plot_facet", "Facet"),
          conditionalPanel("input.plot_type == 'heatmap'", ns = ns, selectInput(ns("plot_value"), "Heatmap value", choices = NULL)),
          conditionalPanel("input.plot_type == 'dumbbell'", ns = ns, selectInput(ns("plot_yend"), "Second value", choices = NULL)),
          conditionalPanel("input.plot_type == 'forest'", ns = ns,
            selectInput(ns("plot_lower"), "Lower confidence limit", choices = NULL),
            selectInput(ns("plot_upper"), "Upper confidence limit", choices = NULL),
            numericInput(ns("plot_reference"), "Reference value", 1), checkboxInput(ns("plot_log"), "Log estimate axis", TRUE)),
          conditionalPanel("input.plot_type == 'histogram'", ns = ns, sliderInput(ns("bins"), "Bins", 1, 50, 10, step = 1)),
          checkboxInput(ns("sort"), "Sort a single-series comparison", TRUE),
          checkboxInput(ns("percent"), "Values are percentages (0-100)", FALSE),
          selectInput(ns("style"), "Theme", choices = c("cataScience" = "cata", if (requireNamespace("DSIR", quietly = TRUE)) c("DSIR" = "dsi")))),
        card(plotOutput(ns("plot"), height = "480px"),
          layout_columns(col_widths = c(6, 6), textInput(ns("plot_title"), "Chart title", ""), textInput(ns("plot_subtitle"), "Subtitle", ""),
            textInput(ns("xlab"), "X label and unit", ""), textInput(ns("ylab"), "Y label and unit", "")),
          textAreaInput(ns("caption"), "Source, denominator and limitations", value = "", width = "100%"),
          layout_columns(col_widths = c(3, 3, 3, 3), numericInput(ns("width"), "Width (in)", 8, min = 3, max = 20),
            numericInput(ns("height"), "Height (in)", 5, min = 3, max = 20), downloadButton(ns("png"), "PNG"), downloadButton(ns("pdf"), "PDF")),
          accordion(open = FALSE, accordion_panel("R code", verbatimTextOutput(ns("plot_code"))))))),
      nav_panel("5 Communicate", value = "communicate",
        p("Build a report from the current selected records and figure. Write the interpretation yourself and check it against the table."),
        textInput(ns("report_title"), "Report title", "My data analysis"),
        textAreaInput(ns("question"), "Research question", width = "100%"),
        textAreaInput(ns("methods"), "Analysis population, selection and method", width = "100%"),
        textInput(ns("denominator"), "Denominator: percentage of whom?", ""),
        textAreaInput(ns("finding"), "Main finding, supported by the output", width = "100%"),
        textAreaInput(ns("limitations"), "Interpretation and limitations", width = "100%"),
        checkboxInput(ns("include_plot"), "Include the current figure", TRUE),
        radioButtons(ns("report_format"), "HTML layout", c("Report" = "report", "Dashboard" = "dashboard"), inline = TRUE),
        downloadButton(ns("html"), "Download HTML", class = "btn-primary"),
        downloadButton(ns("project"), "Download reproducible project"),
        p("HTML opens offline. The project includes the input and selected data, preparation code, RStudio project, Quarto sources and a local Shiny dashboard. Review the text again if you change the data."),
        h4("Preparation and selection record"), DTOutput(ns("audit")),
        accordion(open = FALSE, accordion_panel("Preparation R code", verbatimTextOutput(ns("recipe")))))
    )
  )
}

workflowServer <- function(id, datasets) {
  moduleServer(id, function(input, output, session) {
    initial <- cataScience::cata_example("cats")
    empty.audit <- data.frame(step = integer(), action = character(), before = integer(), after = integer(), note = character())
    state <- reactiveValues(raw = initial, data = initial, steps = character(), audit = empty.audit,
      joins = list(), join_audit = NULL, history = list(), example = "cats")
    literal <- function(x) paste(capture.output(dput(x)), collapse = "\n")
    column <- function(x) paste0("analysis.data[[", literal(x), "]]")
    optional <- function(x) if (is.null(x) || !nzchar(x) || identical(x, "__none__")) NULL else x
    guard <- function(expr) tryCatch(force(expr), error = function(e) showNotification(conditionMessage(e), type = "error", duration = 8))
    load_data <- function(data, example = NULL) {
      state$raw <- data; state$data <- data; state$steps <- character(); state$audit <- empty.audit
      state$joins <- list(); state$join_audit <- NULL; state$history <- list(); state$example <- example
      info <- attr(data, "cata_source")
      updateTextInput(session, "source", value = if (is.null(info)) "Uploaded or selected input snapshot; describe its provenance" else info$description)
      updateTextInput(session, "unit", value = if (is.null(info)) "" else info$unit)
    }
    apply_change <- function(data, action, code, note = "", joins = state$joins, join_audit = state$join_audit) {
      state$history <- c(state$history, list(list(data = state$data, steps = state$steps,
        audit = state$audit, joins = state$joins, join_audit = state$join_audit)))
      state$audit <- rbind(state$audit, data.frame(step = nrow(state$audit) + 1L, action = action,
        before = nrow(state$data), after = nrow(data), note = note))
      state$data <- data; state$steps <- c(state$steps, code); state$joins <- joins; state$join_audit <- join_audit
    }
    observeEvent(input$load, guard(load_data(cataScience::cata_example(input$example), input$example)))
    observeEvent(input$file, guard(load_data(cataScience::cata_read(input$file$datapath, format = tools::file_ext(input$file$name)))))
    observeEvent(input$use_existing, guard({
      data <- datasets()[[input$existing]]
      if (is.null(data)) stop("Load or apply that dataset on the app's Import/Merge pages first.")
      load_data(data)
    }))
    observeEvent(input$reset, load_data(state$raw, state$example))
    observeEvent(input$undo, {
      if (!length(state$history)) return(showNotification("There is no step to undo."))
      last <- state$history[[length(state$history)]]
      for (name in names(last)) state[[name]] <- last[[name]]
      state$history <- utils::head(state$history, -1L)
    })
    update_selector <- function(id, choices, default = NULL, none = FALSE, multiple = FALSE) {
      current <- isolate(input[[id]])
      if (none) choices <- c("(none)" = "__none__", choices)
      valid <- intersect(current, unname(choices))
      if (identical(valid, "__none__") && !is.null(default) && !identical(default, "__none__")) valid <- character()
      selected <- if (length(valid)) valid else if (!is.null(default) && all(default %in% choices)) default else if (none) "__none__" else utils::head(unname(choices), 1)
      if (multiple) updateSelectizeInput(session, id, choices = choices, selected = selected)
      else updateSelectInput(session, id, choices = choices, selected = selected)
    }
    observe({
      data <- state$data
      vars <- names(data); nums <- names(data)[vapply(data, is.numeric, logical(1))]
      cats <- names(data)[vapply(data, function(x) is.character(x) || is.factor(x), logical(1))]
      key <- if ("patient_id" %in% vars) "patient_id" else if ("id" %in% vars) "id" else vars[1]
      update_selector("key", vars, default = key, multiple = TRUE)
      update_selector("left_key", vars, default = if ("facility_id" %in% vars) "facility_id" else key, multiple = TRUE)
      update_selector("flag_var", nums, default = if ("age" %in% nums) "age" else utils::head(nums, 1))
      update_selector("category_var", cats)
      update_selector("status", vars, default = if ("vl_tested" %in% vars) "vl_tested" else "__none__", none = TRUE)
      update_selector("summary_group", vars, default = if ("facility_type" %in% vars) "facility_type" else "__none__", none = TRUE)
      update_selector("filter_var", vars, none = TRUE)
      flags <- vars[vapply(data, is.logical, logical(1))]
      updateSelectizeInput(session, "exclude_flags", choices = flags, selected = intersect(isolate(input$exclude_flags), flags))
    })
    observeEvent(input$flag_var, updateTextInput(session, "flag_name", value = paste0(input$flag_var, "_review")))
    observe({
      req(input$category_var, input$category_var %in% names(state$data))
      choices <- sort(unique(as.character(state$data[[input$category_var]])))
      choices <- choices[!is.na(choices)]
      updateSelectizeInput(session, "category_from", choices = choices, selected = intersect(isolate(input$category_from), choices))
    })
    observeEvent(input$category_var, updateTextInput(session, "category_name", value = paste0(input$category_var, "_standard")))
    observe({
      variable <- optional(input$filter_var)
      if (is.null(variable) || !variable %in% names(state$data)) return()
      choices <- unique(as.character(state$data[[variable]])); choices <- choices[!is.na(choices)]
      updateSelectizeInput(session, "filter_values", choices = choices, selected = choices)
    })
    observeEvent(input$flag, guard({
      req(input$flag_var)
      name <- trimws(input$flag_name)
      if (!nzchar(name) || name %in% names(state$data)) stop("Choose a new, unused flag column name.")
      limits <- if (input$flag_method == "limits") c(input$lower, input$upper) else NULL
      flags <- cataScience::cata_flag_outliers(state$data[[input$flag_var]], k = input$k, limits = limits)$flag
      if (isTRUE(input$flag_missing)) flags[is.na(flags)] <- TRUE
      data <- state$data; data[[name]] <- flags
      code <- paste0(column(name), " <- cata_flag_outliers(", column(input$flag_var), ", k = ", literal(input$k), ", limits = ", literal(limits), ")$flag")
      if (isTRUE(input$flag_missing)) code <- c(code, paste0(column(name), "[is.na(", column(name), ")] <- TRUE"))
      apply_change(data, "Add review flag", code, paste(sum(flags %in% TRUE), "flagged; original values retained"))
    }))
    observeEvent(input$recode, guard({
      req(input$category_var)
      name <- trimws(input$category_name)
      if (!nzchar(name) || name %in% names(state$raw) || identical(name, input$category_var)) stop("Use a new output column; original fields are protected.")
      if (!length(input$category_from) || !nzchar(input$category_to)) stop("Choose source labels and a documented replacement.")
      data <- state$data; code <- character()
      if (!name %in% names(data)) {
        data[[name]] <- as.character(data[[input$category_var]])
        code <- paste0(column(name), " <- as.character(", column(input$category_var), ")")
      }
      matched <- data[[name]] %in% input$category_from
      data[[name]][matched] <- input$category_to
      code <- c(code, paste0(column(name), "[", column(name), " %in% ", literal(input$category_from), "] <- ", literal(input$category_to)))
      apply_change(data, "Standardise labels", code, paste(sum(matched), "values mapped; raw column retained"))
    }))
    observeEvent(input$exclude, guard({
      variables <- input$exclude_flags
      if (!length(variables)) stop("Select at least one review flag.")
      if (!all(variables %in% names(state$data)) || !all(vapply(state$data[variables], is.logical, logical(1)))) stop("Choose logical review flags.")
      keep <- Reduce(`&`, lapply(state$data[variables], function(x) !is.na(x) & !x))
      conditions <- vapply(variables, function(x) paste0("(!is.na(", column(x), ") & !", column(x), ")"), character(1))
      code <- paste0("analysis.data <- analysis.data[", paste(conditions, collapse = " & "), ", , drop = FALSE]")
      apply_change(state$data[keep, , drop = FALSE], "Select records by review flags", code, paste(variables, collapse = ", "))
    }))
    observeEvent(input$filter, guard({
      variable <- optional(input$filter_var)
      if (is.null(variable)) stop("Choose a field for the category selection.")
      keep <- state$data[[variable]] %in% input$filter_values
      if (isTRUE(input$keep_missing)) keep <- keep | is.na(state$data[[variable]])
      condition <- paste0(column(variable), " %in% ", literal(input$filter_values))
      if (isTRUE(input$keep_missing)) condition <- paste0("(", condition, " | is.na(", column(variable), "))")
      apply_change(state$data[keep, , drop = FALSE], "Select category values",
        paste0("analysis.data <- analysis.data[", condition, ", , drop = FALSE]"), paste("Filter:", variable))
    }))
    observeEvent(input$course_selection, guard({
      fields <- c("record_action", "age_review", "art_review")
      if (!all(fields %in% names(state$data))) stop("Load the Dataset B reference file with review flags first.")
      keep <- state$data$record_action %in% "retain" & state$data$age_review %in% FALSE & state$data$art_review %in% FALSE
      apply_change(state$data[keep, , drop = FALSE], "Apply S7 analysis sample",
        "analysis.data <- analysis.data[analysis.data$record_action %in% 'retain' & analysis.data$age_review %in% FALSE & analysis.data$art_review %in% FALSE, , drop = FALSE]",
        "Retain; no age or ART review. Raw rows remain in the input.")
    }))
    reference_data <- reactive({
      if (identical(input$reference, "ds2")) datasets()$ds2 else cataScience::cata_example("facilities")
    })
    observe({
      ref <- reference_data()
      if (!is.null(ref)) update_selector("right_key", names(ref), default = if ("facility_id" %in% names(ref)) "facility_id" else names(ref)[1], multiple = TRUE)
    })
    observeEvent(input$join, guard({
      ref <- reference_data()
      if (is.null(ref)) stop("Load the reference table first.")
      if (!length(input$left_key) || length(input$left_key) != length(input$right_key)) stop("Select matching key columns.")
      by <- stats::setNames(input$right_key, input$left_key)
      result <- cataScience::cata_join(state$data, ref, by = by, relationship = input$relationship,
        suffix = c(".record", ".reference"))
      joins <- c(state$joins, list(ref))
      code <- paste0("analysis.data <- cata_join(analysis.data, readRDS('join-data.rds')[[", length(joins),
        "]], by = ", literal(by), ", relationship = ", literal(input$relationship), ", suffix = c('.record', '.reference'))$data")
      apply_change(result$data, "Audited left join", code,
        paste(result$audit$unmatched_left_rows, "unmatched left records; NA keys do not match"), joins, result$audit)
    }))
    summary_spec <- reactive({
      status <- optional(input$status)
      if (is.null(status) || !status %in% names(state$data)) return(NULL)
      list(status = status, yes = input$yes, no = input$no, by = optional(input$summary_group))
    })
    status_summary <- reactive({
      spec <- summary_spec()
      if (is.null(spec)) return(NULL)
      tryCatch(do.call(cataScience::cata_count_status, c(list(data = state$data), spec)),
        error = function(e) validate(need(FALSE, conditionMessage(e))))
    })
    chart_data <- reactive({
      if (identical(input$plot_data, "summary")) {
        result <- status_summary()
        validate(need(!is.null(result), "Choose a reported status field in Join and summarise."))
        result
      } else state$data
    })
    observe({
      data <- chart_data(); req(data)
      vars <- names(data); nums <- vars[vapply(data, is.numeric, logical(1))]
      cats <- vars[!vapply(data, is.numeric, logical(1))]
      update_selector("plot_x", vars, default = if (length(cats)) cats[1] else vars[1])
      update_selector("plot_y", vars, default = if (identical(input$plot_data, "summary")) "percent" else "__none__", none = TRUE)
      for (id in c("plot_group", "plot_facet")) update_selector(id, vars, none = TRUE)
      for (id in c("plot_value", "plot_yend", "plot_lower", "plot_upper")) update_selector(id, nums)
    })
    plot_args <- reactive({
      req(input$plot_type, input$plot_x)
      type <- input$plot_type
      args <- list(type = type, x = input$plot_x, y = if (type %in% c("histogram", "density")) NULL else optional(input$plot_y),
        group = if (type %in% c("heatmap", "dumbbell")) NULL else optional(input$plot_group), facet = optional(input$plot_facet),
        title = input$plot_title, subtitle = input$plot_subtitle, caption = input$caption,
        xlab = if (nzchar(input$xlab)) input$xlab else NULL, ylab = if (nzchar(input$ylab)) input$ylab else NULL,
        sort = isTRUE(input$sort), percent = isTRUE(input$percent), bins = input$bins, style = input$style)
      if (type == "heatmap") args$value <- input$plot_value
      if (type == "dumbbell") args$yend <- input$plot_yend
      if (type == "forest") {
        args$lower <- input$plot_lower; args$upper <- input$plot_upper
        args$log_scale <- isTRUE(input$plot_log); args$reference <- input$plot_reference
      }
      args
    })
    figure <- reactive({
      tryCatch(do.call(cataScience::cata_plot, c(list(data = chart_data()), plot_args())),
        error = function(e) validate(need(FALSE, conditionMessage(e))))
    })
    report_args <- reactive(list(title = input$report_title, question = input$question,
      methods = input$methods, finding = input$finding, limitations = input$limitations,
      source = input$source, unit = input$unit, denominator = input$denominator))
    export_project <- function(directory) {
      do.call(cataScience::cata_export, c(list(data = state$data, directory = directory, input = state$raw,
        steps = state$steps, join_data = state$joins,
        plot_args = if (isTRUE(input$include_plot)) plot_args() else NULL,
        summary_spec = summary_spec(), chart_data = if (isTRUE(input$include_plot)) input$plot_data else "records",
        audit = state$audit, width = input$width, height = input$height), report_args()))
    }
    output$dimensions <- renderText(paste(nrow(state$data), "selected records ·", ncol(state$data), "variables ·", nrow(state$audit), "recorded steps"))
    output$data <- renderDT(catatable(state$data), server = FALSE)
    output$profile <- renderDT(catatable(cataScience::cata_profile(state$data)), server = FALSE)
    output$key_summary <- renderDT({ req(input$key); catatable(cataScience::cata_check_keys(state$data, input$key)$summary) }, server = FALSE)
    output$key_rows <- renderDT({ req(input$key); catatable(cataScience::cata_check_keys(state$data, input$key)$review_rows) }, server = FALSE)
    output$join_audit <- renderDT({
      req(state$join_audit)
      catatable(data.frame(Check = gsub("_", " ", names(state$join_audit)),
        Count = unlist(state$join_audit, use.names = FALSE)))
    }, server = FALSE)
    output$status_summary <- renderDT({
      req(status_summary())
      data <- status_summary()
      data$group[is.na(data$group)] <- "(Missing)"
      DT::formatRound(catatable(data), "percent", digits = 1)
    }, server = FALSE)
    output$audit <- renderDT(catatable(state$audit), server = FALSE)
    output$missing <- renderPlot({
      data <- cataScience::cata_missing(state$data)
      cataScience::cata_plot(data, "dot", "variable", "missing", sort = TRUE, xlab = "Variable", ylab = "Missing values")
    })
    output$missing_message <- renderPrint({
      if (!nrow(state$data)) cat("The selected dataset has no rows. Review the sample filters.") else has_missing(state$data)
    })
    output$codebook <- renderUI({
      example <- state$example
      file <- if (!is.null(example) && example %in% c("art", "art_raw")) "dataset_b_codebook.md" else if (identical(example, "facilities")) "dataset_c_codebook.md" else NULL
      if (!is.null(file)) {
        text <- readLines(system.file("training-data", file, package = "cataScience"), encoding = "UTF-8", warn = FALSE)
        return(HTML(markdown::mark(text = text, output = NULL)))
      }
      if (identical(example, "cascade")) return(p("Dataset A: each row is one fictional district-year. L = estimated people living with HIV; D = diagnosed; A = on ART; T = with a usable VL result; S = suppressed among T. See the bundled workbook's Codebook and Scenarios sheets. A is independent of B/C."))
      p("Record the observation unit, sampling, measurement definitions, missing-value codes and provenance. The original cat example has no full collection protocol; do not infer representativeness.")
    })
    output$plot <- renderPlot(figure())
    output$plot_code <- renderText({
      args <- plot_args(); text <- vapply(names(args), function(name) paste0("  ", name, " = ", literal(args[[name]])), character(1))
      paste0("library(cataScience)\n\n# chart.data is the selected records or the explicit status summary.\nfigure <- cata_plot(\n  data = chart.data,\n", paste(text, collapse = ",\n"), "\n)\nfigure")
    })
    output$recipe <- renderText(paste(c("library(cataScience)", "analysis.data <- readRDS('input.rds')", state$steps), collapse = "\n"))
    output$png <- downloadHandler("cata-chart.png", function(file) ggplot2::ggsave(file, plot = figure(), device = "png", width = input$width, height = input$height, dpi = 300, bg = "white"))
    output$pdf <- downloadHandler("cata-chart.pdf", function(file) ggplot2::ggsave(file, plot = figure(), device = "pdf", width = input$width, height = input$height))
    output$html <- downloadHandler(function() paste0("cata-", input$report_format, ".html"), function(file) {
      tables <- if (is.null(summary_spec())) list() else list("Status summary" = status_summary())
      do.call(cataScience::cata_report, c(list(data = state$data, file = file,
        plot = if (isTRUE(input$include_plot)) figure() else NULL, tables = tables, audit = state$audit,
        format = input$report_format, width = input$width, height = input$height, overwrite = TRUE), report_args()))
    })
    output$project <- downloadHandler("cata-project.zip", function(file) {
      parent <- tempfile("cata-export-"); dir.create(parent)
      on.exit(unlink(parent, recursive = TRUE), add = TRUE)
      directory <- file.path(parent, "cata-project")
      export_project(directory)
      zip::zipr(file, files = "cata-project", root = parent)
    })
    list(data = reactive(state$data), raw = reactive(state$raw), audit = reactive(state$audit),
      steps = reactive(state$steps), summary = status_summary, figure = figure, export = export_project)
  })
}
