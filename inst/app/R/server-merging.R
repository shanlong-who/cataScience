
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

join.preview <- eventReactive(input$action_merge, {
  req(input$join)
  validate(need(input$join %in% names(allowed_join_fns), "Please select a valid join method."))
  list(method = input$join, keys = by_vec(), imports = c(import1(), import2()))
})

# Freeze the chosen keys and method, while following edits to either table.
joined_data <- function(spec) {
  validate(need(identical(spec$imports, c(import1(), import2())),
    cata_label("A table was reloaded. Preview and apply the join again.")))
  fn <- allowed_join_fns[[spec$method]]
  tryCatch(
    {
      do.call(fn, list(df1(), df2(), by = spec$keys))
    },
    error = function(e) {
      validate(need(FALSE, paste("Error during join:", conditionMessage(e))))
    }
  )
}
df_merged <- reactive(joined_data(join.preview()))

# The example works independently of the uploaded tables.
output$example_join_result <- renderUI({
  req(input$example_join %in% names(allowed_join_fns))
  join <- allowed_join_fns[[input$example_join]]
  teach_table(join(join.names, join.weights, by = "ID"))
})
