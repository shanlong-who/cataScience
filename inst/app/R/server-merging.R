
allowed_join_fns <- list(
  left_join = dplyr::left_join,
  right_join = dplyr::right_join,
  inner_join = dplyr::inner_join,
  full_join = dplyr::full_join
)

by_vec <- reactive({
  req(df1(), df2())
  req(input$key1, input$key2)
  validate(
    need(length(input$key1) == length(input$key2), "Please select matching join keys."),
    need(all(input$key1 %in% names(df1())), "Dataset 1 join keys are not valid."),
    need(all(input$key2 %in% names(df2())), "Dataset 2 join keys are not valid.")
  )
  setNames(input$key2, input$key1)
})

df_merged <- eventReactive(input$action_merge, {
  req(input$join)
  validate(need(input$join %in% names(allowed_join_fns), "Please select a valid join method."))
  fn <- allowed_join_fns[[input$join]]
  tryCatch(
    {
      do.call(fn, list(df1(), df2(), by = by_vec()))
    },
    error = function(e) {
      validate(need(FALSE, paste("Error during join:", conditionMessage(e))))
    }
  )
})
