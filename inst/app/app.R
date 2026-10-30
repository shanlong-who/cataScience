source("R/app-load.R", local = TRUE, encoding = "UTF-8")
source("R/app-function.R", local = TRUE, encoding = "UTF-8")
source("R/app-theme.R", local = TRUE, encoding = "UTF-8")
source("R/mod-cleaning.R", local = TRUE, encoding = "UTF-8")
source("R/data-quiz.R", local = TRUE, encoding = "UTF-8")
source("R/mod-quiz.R", local = TRUE, encoding = "UTF-8")
source("R/data-stats.R", local = TRUE, encoding = "UTF-8")
source("R/ui-stats.R", local = TRUE, encoding = "UTF-8")
source("R/ui-ai-training.R", local = TRUE, encoding = "UTF-8")
source("R/ui-ai-pages.R", local = TRUE, encoding = "UTF-8")
if (cata_workshop) {
  source("R/mod-lessons.R", local = TRUE, encoding = "UTF-8")
  source("R/mod-workflow.R", local = TRUE, encoding = "UTF-8")
}
source("R/app-ui.R", local = TRUE, encoding = "UTF-8")
source("R/app-server.R", local = TRUE, encoding = "UTF-8")

shinyApp(ui, server)
