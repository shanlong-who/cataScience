server <- function(input, output, session) {
  # In the packaged desktop build the launcher sets CATA_DESKTOP=1: closing
  # the browser window then also stops the R process. On a Shiny server this
  # must not happen, so it is opt-in.
  if (Sys.getenv("CATA_DESKTOP") == "1") {
    session$onSessionEnded(function() {
      stopApp()
    })
  }

  # Datasets -----------------------------------------------------------------

  df1 <- reactiveVal()
  df2 <- reactiveVal()

  cleaningServer("ds1", df1, demo_file = "data/cat-dirty-data.xlsx")
  cleaningServer("ds2", df2, demo_file = "data/cat-dirty-data2.xlsx")

  # Merging ------------------------------------------------------------------

  source("R/server-merging.R", local = TRUE)

  observe({
    df <- df1()
    req(df)
    current_selected <- input$key1
    keep_selected <- intersect(current_selected, names(df))
    updateSelectizeInput(session, "key1", choices = names(df), selected = keep_selected)
  })
  observe({
    df <- df2()
    req(df)
    current_selected <- input$key2
    keep_selected <- intersect(current_selected, names(df))
    updateSelectizeInput(session, "key2", choices = names(df), selected = keep_selected)
  })

  df_merged_applied <- reactiveVal(NULL)
  observeEvent(input$apply_merge, {
    df_merged_applied(df_merged())
    updateRadioButtons(session, "vis_dataset", selected = "merged")
  })

  # The working dataset for visualization, chosen in the Visualize sidebar.
  df0 <- reactive({
    req(input$vis_dataset)
    switch(
      input$vis_dataset,
      ds1 = df1(),
      ds2 = df2(),
      merged = df_merged_applied()
    )
  })

  output$df1_pre_merge <- renderDT(
    {
      req(df1())
      catatable(df1())
    },
    server = FALSE
  )
  output$df2_pre_merge <- renderDT(
    {
      req(df2())
      catatable(df2())
    },
    server = FALSE
  )
  output$df_merged <- renderDT(
    {
      req(input$action_merge)
      req(df_merged())
      catatable(df_merged())
    },
    server = FALSE
  )

  # Visualization --------------------------------------------------------------

  # Variable-selector updates live in server-visualization.R (vis_var_specs).
  source("R/server-visualization.R", local = TRUE)

  ## Chart outputs -------------------------------------------------------------

  output$df_vis <- renderDT(
    {
      validate_vis_data()
      catatable(df0())
    },
    server = FALSE
  )

  output$p_bar_col <- renderPlotly({
    validate_vis_data()
    req(input$bar_x)
    cata_plotly(p_bar_col())
  })

  output$p_hist <- renderPlotly({
    validate_vis_data()
    req(input$hist_x)
    cata_plotly(p_hist())
  })

  output$p_den <- renderPlotly({
    validate_vis_data()
    req(input$den_x)
    cata_plotly(p_den())
  })

  output$p_pie <- renderPlotly({
    validate_vis_data()
    req(input$pie_x)
    plotly_tidy_toolbar(p_pie())
  })

  output$p_line <- renderPlotly({
    validate_vis_data()
    req(input$line_x)
    req(input$line_y)
    cata_plotly(p_line())
  })

  output$p_point <- renderPlotly({
    validate_vis_data()
    req(input$point_x)
    req(input$point_y)
    cata_plotly(p_point())
  })

  output$p_box <- renderPlotly({
    validate_vis_data()
    req(input$box_x)
    req(input$box_y)
    cata_plotly(p_box())
  })

  # Statistics pages ------------------------------------------------------------

  source("R/server-stats.R", local = TRUE)

  # Quiz -------------------------------------------------------------------------

  quizServer("quiz", quiz_questions)
}
