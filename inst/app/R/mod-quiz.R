# Interactive quiz module. Questions come from R/data-quiz.R.

quizUI <- function(id) {
  ns <- NS(id)
  div(
    class = "mx-auto",
    style = "max-width: 960px;",
    card(
      card_header("Choose your topics 🎯"),
      markdown(paste(
        "Every training uses a different mix of modules. Tick the topics",
        "covered in your session and restart the quiz — by default all",
        "topics are included.",
        sep = "\n"
      )),
      uiOutput(ns("topic_ui"))
    ),
    card(
      card_header(
        div(
          class = "d-flex justify-content-between align-items-center",
          span("Test yourself"),
          span(class = "text-muted small", textOutput(ns("score_text"), inline = TRUE))
        )
      ),
      uiOutput(ns("progress_ui")),
      uiOutput(ns("question_ui")),
      uiOutput(ns("feedback_ui")),
      uiOutput(ns("buttons_ui"))
    ),
    card(
      card_header("Final exercise: put it all together"),
      markdown(paste(
        "Use the **SDG 3.8.1** indicator data (download from the Home page) and,",
        "with the help of this dashboard or AI-assisted R coding:",
        "",
        "1. **Descriptive analysis** — summarize the distribution of SDG 3.8.1",
        "   values across WPRO countries; identify the minimum, maximum, mean,",
        "   and median.",
        "2. **Visualize 2021** — create a plot showing the indicator values for",
        "   all WPRO countries in the year 2021.",
        "3. **Trends over time** — group the data by year, calculate the annual",
        "   mean for WPRO countries, and create a time series plot.",
        sep = "\n"
      ))
    )
  )
}

quizServer <- function(id, questions) {
  moduleServer(id, function(input, output, session) {
    all_topics <- unique(vapply(questions, function(q) q$topic, character(1)))

    # Questions in play for this session, filtered by the topic selection.
    active <- reactiveVal(questions)
    n_q <- reactive(length(active()))

    idx <- reactiveVal(1)
    score <- reactiveVal(0)
    answered <- reactiveVal(FALSE)
    submitted_answer <- reactiveVal(NULL)
    finished <- reactiveVal(FALSE)

    current <- reactive(active()[[idx()]])

    reset_quiz <- function() {
      idx(1)
      score(0)
      answered(FALSE)
      submitted_answer(NULL)
      finished(FALSE)
    }

    output$topic_ui <- renderUI({
      ns <- session$ns
      div(
        checkboxGroupInput(
          ns("topics"),
          label = NULL,
          choices = all_topics,
          selected = all_topics,
          inline = TRUE
        ),
        actionButton(
          ns("apply_topics"),
          "Apply topics and restart",
          class = "btn-sm btn-outline-primary"
        )
      )
    })

    observeEvent(input$apply_topics, {
      sel <- input$topics
      if (length(sel) == 0) {
        showNotification("Please keep at least one topic.", type = "warning")
        return()
      }
      active(Filter(function(q) q$topic %in% sel, questions))
      reset_quiz()
      showNotification(
        sprintf("Quiz restarted with %d questions.", n_q()),
        type = "message"
      )
    })

    output$score_text <- renderText({
      sprintf("Score: %d / %d", score(), n_q())
    })

    output$progress_ui <- renderUI({
      done <- idx() - 1 + as.numeric(answered() || finished())
      if (finished()) done <- n_q()
      pct <- round(100 * done / n_q())
      div(
        div(class = "quiz-progress", div(style = paste0("width:", pct, "%;"))),
        div(
          class = "text-muted small mb-2",
          if (finished()) {
            "Quiz completed"
          } else {
            sprintf("Question %d of %d", idx(), n_q())
          }
        )
      )
    })

    output$question_ui <- renderUI({
      ns <- session$ns
      if (finished()) {
        pct <- round(100 * score() / n_q())
        remark <- case_when(
          pct >= 90 ~ "Purr-fect! You are ready to clean data like a pro. 🐱",
          pct >= 70 ~ "Great job — just a few whiskers away from perfect. 🐾",
          pct >= 50 ~ "Good start. Review the Cleaning, Visualize, and AI pages and try again.",
          .default = "Keep practising — the Background tabs on each page will help."
        )
        return(div(
          class = "text-center py-4",
          h3(sprintf("You scored %d out of %d (%d%%)", score(), n_q(), pct)),
          p(class = "lead", remark)
        ))
      }
      q <- current()
      tagList(
        span(class = "badge bg-info quiz-topic-badge", q$topic),
        div(class = "mt-2 mb-2", markdown(q$question)),
        if (!is.null(q$image)) {
          tags$img(src = file.path("picture", q$image), class = "quiz-image")
        },
        div(
          class = if (answered()) "quiz-disabled-options" else NULL,
          radioButtons(
            ns("answer"),
            label = NULL,
            choices = q$choices,
            selected = if (answered()) submitted_answer() else character(0),
            width = "100%"
          )
        )
      )
    })

    output$feedback_ui <- renderUI({
      ns <- session$ns
      req(answered(), !finished())
      q <- current()
      correct <- identical(submitted_answer(), q$answer)
      div(
        div(
          class = if (correct) "alert alert-success" else "alert alert-danger",
          icon(if (correct) "circle-check" else "circle-xmark"),
          strong(if (correct) " Correct!" else paste0(" Not quite. The answer is: ", q$answer))
        ),
        card(
          card_header("Why?"),
          markdown(q$explanation),
          if (!is.null(q$plot)) plotlyOutput(ns("answer_plot"))
        )
      )
    })

    output$answer_plot <- renderPlotly({
      req(answered())
      q <- current()
      req(!is.null(q$plot))
      plotly_tidy_toolbar(q$plot())
    })

    output$buttons_ui <- renderUI({
      ns <- session$ns
      if (finished()) {
        return(div(
          class = "d-flex gap-2 mt-2",
          actionButton(ns("restart"), "Try again", class = "btn-primary")
        ))
      }
      div(
        class = "d-flex gap-2 mt-2",
        if (!answered()) {
          actionButton(ns("submit"), "Submit answer", class = "btn-primary")
        } else {
          actionButton(
            ns("next_q"),
            if (idx() < n_q()) "Next question" else "See my result",
            class = "btn-primary"
          )
        },
        actionButton(ns("restart"), "Restart", class = "btn-outline-secondary")
      )
    })

    observeEvent(input$submit, {
      # Guard against double-clicks: the second click arrives before the
      # re-rendered buttons remove "Submit answer" and would double-count.
      if (answered()) {
        return()
      }
      if (is.null(input$answer)) {
        showNotification("Please choose an answer first.", type = "warning")
        return()
      }
      submitted_answer(input$answer)
      answered(TRUE)
      if (identical(input$answer, current()$answer)) {
        score(score() + 1)
      }
    })

    observeEvent(input$next_q, {
      # Same double-click guard: only advance from an answered question.
      if (!answered() || finished()) {
        return()
      }
      if (idx() < n_q()) {
        idx(idx() + 1)
        answered(FALSE)
        submitted_answer(NULL)
      } else {
        finished(TRUE)
      }
    })

    observeEvent(input$restart, {
      reset_quiz()
    })
  })
}
