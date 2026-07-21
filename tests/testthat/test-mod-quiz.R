# The quiz module is the only part of the app that keeps a score, so its
# reactive logic is tested end to end with shiny::testServer().

quiz_fixture <- function() {
  list(
    list(
      topic = "Alpha",
      question = "1 + 1?",
      choices = c("1", "2"),
      answer = "2",
      explanation = "Two."
    ),
    list(
      topic = "Beta",
      question = "2 + 2?",
      choices = c("3", "4"),
      answer = "4",
      explanation = "Four."
    )
  )
}

test_that("a correct answer scores and a wrong one does not", {
  env <- cata_app_env(c("app-function.R", "mod-quiz.R"))

  shiny::testServer(env$quizServer, args = list(questions = quiz_fixture()), {
    expect_equal(idx(), 1)
    expect_equal(score(), 0)

    session$setInputs(answer = "2", submit = 1)
    expect_true(answered())
    expect_equal(score(), 1)

    session$setInputs(next_q = 1)
    expect_equal(idx(), 2)
    expect_false(answered())

    session$setInputs(answer = "3", submit = 2)
    expect_equal(score(), 1)
  })
})

test_that("the quiz finishes after the last question and can restart", {
  env <- cata_app_env(c("app-function.R", "mod-quiz.R"))

  shiny::testServer(env$quizServer, args = list(questions = quiz_fixture()), {
    session$setInputs(answer = "2", submit = 1)
    session$setInputs(next_q = 1)
    session$setInputs(answer = "4", submit = 2)
    session$setInputs(next_q = 2)

    expect_true(finished())
    expect_equal(score(), 2)

    session$setInputs(restart = 1)
    expect_false(finished())
    expect_equal(idx(), 1)
    expect_equal(score(), 0)
  })
})

test_that("submitting twice cannot double-count the same question", {
  env <- cata_app_env(c("app-function.R", "mod-quiz.R"))

  shiny::testServer(env$quizServer, args = list(questions = quiz_fixture()), {
    session$setInputs(answer = "2", submit = 1)
    session$setInputs(submit = 2)
    expect_equal(score(), 1)
  })
})

test_that("the topic filter keeps only the selected topics and restarts", {
  env <- cata_app_env(c("app-function.R", "mod-quiz.R"))

  shiny::testServer(env$quizServer, args = list(questions = quiz_fixture()), {
    expect_equal(n_q(), 2)

    session$setInputs(answer = "2", submit = 1)
    session$setInputs(topics = "Beta", apply_topics = 1)

    expect_equal(n_q(), 1)
    expect_equal(active()[[1]]$topic, "Beta")
    expect_equal(score(), 0)
    expect_equal(idx(), 1)

    # An empty selection is refused instead of leaving an empty quiz.
    session$setInputs(topics = character(0), apply_topics = 2)
    expect_equal(n_q(), 1)
  })
})

test_that("the shipped question bank runs through the module", {
  env <- cata_app_env(c("app-function.R", "data-quiz.R", "mod-quiz.R"))

  shiny::testServer(env$quizServer, args = list(questions = env$quiz_questions), {
    expect_equal(n_q(), length(env$quiz_questions))

    # Answer every question correctly; a scoring or navigation regression
    # anywhere in the bank shows up as a wrong final score.
    for (i in seq_len(n_q())) {
      session$setInputs(answer = active()[[i]]$answer, submit = i)
      session$setInputs(next_q = i)
    }

    expect_true(finished())
    expect_equal(score(), length(env$quiz_questions))
  })
})
