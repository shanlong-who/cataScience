# Each editor uses the same imported rows and analysis table as its sibling.
sourceCorrectionUI <- function(id) {
  ns <- NS(id)
  tagList(
    p("Check a register or measurement sheet before changing a value. If you cannot verify it, leave it as recorded."),
    layout_columns(col_widths = c(5, 7),
      selectInput(ns("field"), "Field to check", choices = NULL),
      selectInput(ns("record"), "Record to check", choices = NULL)),
    uiOutput(ns("comparison")),
    actionButton(ns("edit"), "Enter a verified value", class = "btn-primary"),
    tags$hr(), h5("Source correction history"), uiOutput(ns("history"))
  )
}

source_value_text <- function(x) {
  if (is.na(x)) "NA" else as.character(x)
}

source_value_parse <- function(text, column) {
  text <- trimws(text)
  if (!nzchar(text)) stop(cata_label("Enter the value from the source record."))
  bad <- function() stop(cata_label("Enter a valid value of the same type as the field."))
  if (inherits(column, "POSIXt")) {
    tz <- attr(column, "tzone")[1]
    if (is.null(tz) || is.na(tz)) tz <- "UTC"
    value <- as.POSIXct(strptime(text, "%Y-%m-%d %H:%M:%S", tz = tz))
    if (is.na(value) || format(value, "%Y-%m-%d %H:%M:%S", tz = tz) != text) bad()
  } else if (inherits(column, "Date")) {
    value <- as.Date(text, format = "%Y-%m-%d")
    if (is.na(value) || format(value, "%Y-%m-%d") != text) bad()
  } else if (is.logical(column)) {
    value <- as.logical(toupper(text))
    if (is.na(value)) bad()
  } else if (is.numeric(column)) {
    value <- suppressWarnings(as.numeric(text))
    if (!is.finite(value)) bad()
    if (is.integer(column) && value == trunc(value) && abs(value) <= .Machine$integer.max)
      value <- as.integer(value)
  } else {
    value <- text
  }
  value
}

sourceCorrectionServer <- function(id, missing.only, data_rv, raw_rv, rows, history, generation, example) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    pending <- reactiveVal(NULL)
    fields <- reactive({
      df <- req(data_rv())
      valid <- if (missing.only) vapply(df, anyNA, logical(1)) else vapply(df, is.numeric, logical(1))
      names(df)[valid]
    })
    observe({
      choices <- fields()
      selected <- intersect(isolate(input$field), choices)
      updateSelectInput(session, "field", choices = choices,
        selected = if (length(selected)) selected else head(choices, 1))
    })
    records <- reactive({
      df <- req(data_rv())
      req(input$field %in% fields())
      current <- if (missing.only) which(is.na(df[[input$field]])) else seq_len(nrow(df))
      imported <- rows()[current]
      labels <- paste("#", imported, sep = "")
      for (field in intersect(c("id", "name"), names(raw_rv())))
        labels <- paste(labels, raw_rv()[[field]][imported], sep = " · ")
      stats::setNames(paste(generation(), imported, sep = "/"), labels)
    })
    observe({
      choices <- if (isTRUE(input$field %in% fields())) records() else character()
      selected <- intersect(isolate(input$record), choices)
      updateSelectInput(session, "record", choices = choices,
        selected = if (length(selected)) selected else head(choices, 1))
    })
    cell <- reactive({
      choices <- records()
      req(input$record %in% choices)
      original.row <- as.integer(sub(".*/", "", input$record))
      index <- match(original.row, rows())
      list(row = original.row, field = input$field, generation = generation(),
        record = names(choices)[match(input$record, choices)],
        original = raw_rv()[[input$field]][original.row], current = data_rv()[[input$field]][index])
    })
    comparison <- function(target) {
      tags$p(tags$strong(cata_label("Imported value")), " ", tags$code(source_value_text(target$original)),
        " · ", tags$strong(cata_label("Analysis value")), " ", tags$code(source_value_text(target$current)))
    }
    output$comparison <- renderUI({
      validate(need(data_rv(), cata_label("Load a dataset on the Import page.")))
      validate(need(length(fields()), cata_label(if (missing.only) "No missing cells to verify." else "No numeric variables are available.")))
      tagList(comparison(cell()),
        if (isTRUE(example()) && !missing.only) tags$details(
          tags$summary("Check the original records for Case 1"),
          p("The café records give Trevor (a30) a length of 50 cm and Stanley (a08) a weight of 5.6 kg. Compare these with Case 1 before choosing a cleaning method.")))
    })
    observeEvent(input$edit, {
      target <- cell()
      pending(target)
      showModal(modalDialog(title = cata_label("Enter a verified value"),
        p(target$record, " · ", tags$code(target$field)), comparison(target),
        textInput(ns("value"), cata_label("Verified value"), value = ""),
        textInput(ns("source"), cata_label("Source checked"), value = ""),
        footer = tagList(modalButton(cata_label("Cancel")),
          tags$button(type = "button", class = "btn btn-primary",
            `data-submit` = ns("save"), `data-value` = ns("value"), `data-source` = ns("source"),
            onclick = paste(
              "const read = id => document.getElementById(id).value;",
              "Shiny.setInputValue(this.dataset.submit,",
              "{value: read(this.dataset.value), source: read(this.dataset.source)}, {priority: 'event'});"),
            cata_label("Save correction")))))
    })
    observeEvent(input$save, {
      target <- req(pending())
      index <- match(target$row, rows())
      df <- data_rv()
      if (!identical(target$generation, generation()) || is.na(index) ||
          !identical(df[[target$field]][index], target$current)) {
        showNotification(cata_label("This record changed. Select the cell again."), type = "error")
        pending(NULL)
        removeModal()
        return()
      }
      tryCatch({
        source <- trimws(input$save$source)
        if (!isTruthy(source)) stop(cata_label("Identify the source you checked."))
        value <- source_value_parse(input$save$value, df[[target$field]])
        if (is.factor(df[[target$field]]))
          levels(df[[target$field]]) <- union(levels(df[[target$field]]), value)
        df[[target$field]][index] <- value
        if (isTRUE(target$current == value)) stop(cata_label("The analysis value already matches."))
        entry <- tibble(Record = target$record, Field = target$field,
          `Imported value` = source_value_text(target$original),
          `Previous value` = source_value_text(target$current),
          `Verified value` = source_value_text(value), `Source checked` = source)
        data_rv(df)
        history(bind_rows(history(), entry))
        pending(NULL)
        removeModal()
        showNotification(cata_label("Correction saved to the analysis data."), type = "message")
      }, error = function(e) showNotification(conditionMessage(e), type = "error"))
    })
    output$history <- renderUI({
      log <- history()
      if (!nrow(log)) return(p(cata_label("No source corrections recorded.")))
      names(log) <- cata_label(names(log))
      div(class = "table-responsive", tags$table(class = "table table-sm",
        tags$thead(tags$tr(lapply(names(log), tags$th))),
        tags$tbody(lapply(seq_len(nrow(log)), function(i) tags$tr(lapply(log[i, ], tags$td))))))
    })
  })
}
