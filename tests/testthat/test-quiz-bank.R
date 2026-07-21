test_that("the quiz bank has the structure the quiz module expects", {
  env <- cata_app_env(c("app-function.R", "data-quiz.R"))
  questions <- env$quiz_questions

  expect_type(questions, "list")
  expect_gt(length(questions), 0)

  for (q in questions) {
    expect_type(q$topic, "character")
    expect_true(nzchar(q$topic))
    expect_type(q$question, "character")
    expect_true(nzchar(q$question))
    expect_gt(length(q$choices), 1)
    expect_length(q$answer, 1)
    # A question whose answer is not on the list can never be scored right.
    expect_true(q$answer %in% q$choices)
    expect_type(q$explanation, "character")
  }
})

test_that("quiz images and answer plots resolve", {
  env <- cata_app_env(c("app-function.R", "data-quiz.R"))

  for (q in env$quiz_questions) {
    if (!is.null(q$image)) {
      expect_true(file.exists(file.path("www", "picture", q$image)))
    }
    if (!is.null(q$plot)) {
      expect_type(q$plot, "closure")
      # Same path the module takes: build the widget, then trim its toolbar.
      expect_s3_class(env$plotly_tidy_toolbar(q$plot()), "plotly")
    }
  }
})
