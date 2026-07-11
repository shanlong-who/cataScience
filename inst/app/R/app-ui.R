# Main UI: bslib page_navbar. Content-heavy pages live in their own files
# (ui-stats.R, ui-ai-training.R, ui-ai-pages.R); the quiz and per-dataset
# cleaning UIs come from mod-quiz.R and mod-cleaning.R.

# ---- Home ---------------------------------------------------------------------

ui_home <- page_wrap(
  layout_columns(
    col_widths = c(8, 4),
    card(
      class = "hero-card",
      card_body(
        h1("A Journey of Data Science"),
        p(
          class = "lead",
          "A hands-on training companion for people who are new to data:",
          " import → clean → visualize → understand — with AI as your",
          " assistant, and you as the judge."
        ),
        markdown(paste(
          "An image is data, because it is made up of raster pixels.",
          "Sound is data, because it is defined by frequency, volume, and timbre.",
          "In fact, **everything is data**.",
          "",
          "Data analysis is the process of discovering patterns from data to",
          "serve our work and our lives. We don't have to obsess over tools —",
          "R, Stata, SAS, Python, or Excel — because:",
          "",
          "**It doesn't matter if a cat is black or white, as long as it",
          "catches the mouse. 🐭**",
          sep = "\n"
        )),
        div(
          class = "d-flex gap-2 mt-3 flex-wrap",
          tags$a(
            icon("download"), "Download datasets",
            href = "datasets.zip",
            download = NA,
            class = "btn btn-light"
          ),
          tags$a(
            icon("envelope"), "Contact Shanlong",
            href = "mailto:dings@who.int",
            class = "btn btn-outline-light"
          )
        )
      )
    ),
    card(
      app_img("0-maomi.jpg", alt = "The teacher cat"),
      card_footer("Your instructor is ready. 🐱")
    )
  ),
  card(
    card_header("The data science workflow"),
    app_img("2-workflow.png", alt = "Import, tidy, transform, visualize, model, communicate"),
    card_footer(
      "We follow this loop throughout the training: the pages in the navbar",
      " mirror each step, the AI pages teach you to work with an assistant,",
      " and the Quiz checks what you remember."
    )
  ),
  layout_columns(
    col_widths = c(4, 4, 4),
    value_box(
      title = "Import",
      value = "2 files",
      showcase = icon("file-import"),
      theme = "primary",
      p("Upload your own Excel/CSV files or load the example data.")
    ),
    value_box(
      title = "Clean",
      value = "4 skills",
      showcase = icon("broom"),
      theme = "success",
      p("Missing data, outliers, text, and merging.")
    ),
    value_box(
      title = "Visualize",
      value = "7 charts",
      showcase = icon("chart-column"),
      theme = "warning",
      p("Bar, histogram, density, line, pie, scatter, and box.")
    ),
    value_box(
      title = "Statistics",
      value = "4 topics",
      showcase = icon("chart-line"),
      theme = "info",
      p("Describing data, the normal distribution, t-tests, and regression.")
    ),
    value_box(
      title = "AI skills",
      value = "5 pages",
      showcase = icon("robot"),
      theme = "danger",
      p("Prompting levels, a prompt gallery, safety rules, and a cautionary tale.")
    ),
    value_box(
      title = "Quiz",
      value = paste(length(quiz_questions), "questions"),
      showcase = icon("graduation-cap"),
      theme = "secondary",
      p("Pick the topics for your session and test yourself.")
    )
  )
)

# ---- Import ------------------------------------------------------------------

ui_import <- navset_card_tab(
  nav_panel(
    "Practise",
    card(
      card_header("📂 Upload your data files"),
      markdown(paste(
        "- 📝 Please upload one or two Excel/CSV files.",
        "- 📄 Each file should contain only one sheet.",
        "- 🤝 If you don't need to merge data, uploading one file is enough.",
        "- 🐱 No file at hand? Use the **example data** buttons.",
        sep = "\n"
      ))
    ),
    layout_columns(
      col_widths = c(6, 6),
      cleaningImportUI("ds1", "Dataset 1"),
      cleaningImportUI("ds2", "Dataset 2")
    ),
    navset_card_tab(
      nav_panel("Dataset 1", cleaningPreviewUI("ds1")),
      nav_panel("Dataset 2", cleaningPreviewUI("ds2"))
    )
  ),
  nav_panel("Background", md_page("background-import.md")),
  nav_panel("Issues", md_page("background-import-issues.md"))
)

# ---- Cleaning pages -----------------------------------------------------------

ui_missing <- navset_card_tab(
  nav_panel("Dataset 1", cleaningMissingUI("ds1")),
  nav_panel("Dataset 2", cleaningMissingUI("ds2")),
  nav_panel("Background", md_page("background-missing.md")),
  nav_panel("Type", md_page("background-missing-type.md")),
  nav_panel("Methodology", md_page("background-missing-methodology.md"))
)

ui_outliers <- navset_card_tab(
  nav_panel("Dataset 1", cleaningOutlierUI("ds1")),
  nav_panel("Dataset 2", cleaningOutlierUI("ds2")),
  nav_panel("Background", md_page("background-outlier.md")),
  nav_panel("Detect", md_page("background-outlier-detect.md")),
  nav_panel("Handle", md_page("background-outlier-handle.md"))
)

ui_text <- navset_card_tab(
  nav_panel("Dataset 1", cleaningTextUI("ds1")),
  nav_panel("Dataset 2", cleaningTextUI("ds2")),
  nav_panel("Background", md_page("background-text.md"))
)

ui_merge <- navset_card_tab(
  nav_panel(
    "Practise",
    accordion(
      open = FALSE,
      accordion_panel("Preview: dataset 1", DTOutput("df1_pre_merge")),
      accordion_panel("Preview: dataset 2", DTOutput("df2_pre_merge"))
    ),
    card(
      layout_columns(
        col_widths = c(3, 3, 3, 3),
        selectizeInput(
          "key1",
          "Please select the keys in order for dataset 1:",
          choices = NULL,
          selected = NULL,
          multiple = TRUE
        ),
        selectizeInput(
          "key2",
          "Please select the keys in order for dataset 2:",
          choices = NULL,
          selected = NULL,
          multiple = TRUE
        ),
        selectInput(
          "join",
          "Please select a join method:",
          choices = paste0(c("left", "right", "inner", "full"), "_join"),
          selected = "left_join"
        ),
        div(
          actionButton("action_merge", "Merge!", class = "btn-primary mb-2 d-block"),
          actionButton("apply_merge", "Apply merging to dataset", class = "d-block")
        )
      )
    ),
    card(
      card_header("Merged result"),
      DTOutput("df_merged")
    )
  ),
  nav_panel("Background", md_page("background-merging.md")),
  nav_panel("Methodology", md_page("background-merging-methodology.md"))
)

# ---- Visualization -------------------------------------------------------------

vis_select <- function(id, label) {
  selectInput(id, label, choices = NULL, selected = NULL)
}

ui_visualize <- layout_sidebar(
  sidebar = sidebar(
    width = 300,
    title = "Global options",
    radioButtons(
      "vis_dataset",
      "Dataset to visualize:",
      choices = c("Dataset 1" = "ds1", "Dataset 2" = "ds2", "Merged" = "merged"),
      selected = "ds1"
    ),
    p(class = "text-muted small", "Please clean your data before visualization. :-)"),
    checkboxInput("flip", "Do you want to flip the graph?", value = FALSE),
    textInput("title", "Please set a graph title:"),
    textInput("subtitle", "Please set a graph subtitle:")
  ),
  accordion(
    open = FALSE,
    accordion_panel("Current dataset used for visualization", DTOutput("df_vis"))
  ),
  navset_card_pill(
    nav_panel(
      "Background",
      navset_underline(
        nav_panel("History", md_page("background-vis.md")),
        nav_panel("Type", md_page("background-vis-type.md")),
        nav_panel("Principles", md_page("background-vis-principles.md"))
      )
    ),
    nav_panel(
      "Bar chart",
      accordion(
        open = FALSE,
        accordion_panel("Principles of bar charts", md_page("principle-bar.md"))
      ),
      layout_columns(
        col_widths = c(4, 4, 4),
        div(
          vis_select("bar_x", "Please select x-axis:"),
          conditionalPanel(
            condition = "input.pre_count",
            vis_select("bar_y", "Please select y-axis:")
          )
        ),
        div(
          vis_select("bar_group", "Please select grouped variable:"),
          vis_select("bar_facet", "Please select faceted variable:")
        ),
        div(
          checkboxInput("pre_count", "Use pre-counted data?", value = FALSE),
          selectInput(
            "bar_position",
            "Position of different groups:",
            choices = c("stack", "fill", "dodge"),
            selected = "stack"
          )
        )
      ),
      plotlyOutput("p_bar_col", height = "460px")
    ),
    nav_panel(
      "Histogram",
      layout_columns(
        col_widths = c(4, 4, 4),
        div(
          vis_select("hist_x", "Please select x-axis:"),
          sliderInput(
            "hist_bins",
            "Number of bins:",
            min = 1, max = 50, value = 10, step = 1
          )
        ),
        vis_select("hist_group", "Please select grouped variable:"),
        vis_select("hist_facet", "Please select faceted variable:")
      ),
      plotlyOutput("p_hist", height = "460px")
    ),
    nav_panel(
      "Density plot",
      layout_columns(
        col_widths = c(4, 4, 4),
        vis_select("den_x", "Please select x-axis:"),
        vis_select("den_group", "Please select grouped variable:"),
        vis_select("den_facet", "Please select faceted variable:")
      ),
      plotlyOutput("p_den", height = "460px")
    ),
    nav_panel(
      "Line chart",
      layout_columns(
        col_widths = c(4, 4, 4),
        div(
          vis_select("line_x", "Please select x-axis:"),
          vis_select("line_y", "Please select y-axis:")
        ),
        vis_select("line_group", "Please select grouped variable:"),
        vis_select("line_facet", "Please select faceted variable:")
      ),
      plotlyOutput("p_line", height = "460px")
    ),
    nav_panel(
      "Pie chart",
      layout_columns(
        col_widths = c(4),
        vis_select("pie_x", "Please select variable:")
      ),
      plotlyOutput("p_pie", height = "460px")
    ),
    nav_panel(
      "Scatterplot",
      layout_columns(
        col_widths = c(4, 4, 4),
        div(
          vis_select("point_x", "Please select the x-axis:"),
          vis_select("point_y", "Please select the y-axis:")
        ),
        div(
          vis_select("point_group", "Please select the grouped variable:"),
          vis_select("point_facet", "Please select the faceted variable:")
        ),
        checkboxInput("point_smooth", "Do you want a regression line?", value = FALSE)
      ),
      plotlyOutput("p_point", height = "460px")
    ),
    nav_panel(
      "Box plot",
      layout_columns(
        col_widths = c(4, 4, 4),
        div(
          vis_select("box_x", "Please select x-axis:"),
          vis_select("box_y", "Please select y-axis:")
        ),
        vis_select("box_group", "Please select the grouped variable:"),
        vis_select("box_facet", "Please select the faceted variable:")
      ),
      plotlyOutput("p_box", height = "460px")
    )
  )
)

# ---- Training guide -------------------------------------------------------------

ui_training_guide <- div(
  accordion(
    open = "Training playbook: build a session from this app",
    accordion_panel(
      "Training playbook: build a session from this app",
      md_page("training-playbook.md")
    ),
    accordion_panel(
      "Data-quality lab script (20-30 minutes)",
      md_page("lab-script-data-quality.md")
    ),
    accordion_panel(
      "AI-generated analysis critique checklist",
      md_page("ai-analysis-critique-checklist.md")
    ),
    accordion_panel(
      "Dataset recommendation",
      md_page("training-dataset-recommendation.md")
    )
  )
)

# ---- Assemble -------------------------------------------------------------------

ui <- page_navbar(
  title = tags$span(
    tags$img(src = "1-logo.jpg", class = "navbar-logo", alt = ""),
    "A Journey of Data Science"
  ),
  window_title = "A Journey of Data Science",
  theme = app_theme,
  fillable = FALSE,
  header = tagList(
    useBusyIndicators(),
    tags$head(
      tags$link(rel = "icon", type = "image/jpeg", href = "1-logo.jpg"),
      # The ?v= query busts browser caches when the stylesheet changes;
      # bump it together with meaningful CSS edits.
      tags$link(rel = "stylesheet", href = "custom.css?v=2.1.1")
    )
  ),
  nav_panel("Home", ui_home, icon = icon("house")),
  nav_panel("Import", page_wrap(ui_import), icon = icon("file-import")),
  nav_menu(
    "Cleaning",
    icon = icon("broom"),
    nav_panel("Missing data", page_wrap(ui_missing), icon = icon("circle-question")),
    nav_panel("Outliers", page_wrap(ui_outliers), icon = icon("bullseye")),
    nav_panel("Text", page_wrap(ui_text), icon = icon("eraser")),
    nav_panel("Merge", page_wrap(ui_merge), icon = icon("object-group"))
  ),
  nav_panel("Visualize", page_wrap(ui_visualize), icon = icon("chart-column")),
  nav_menu(
    "Statistics",
    icon = icon("chart-line"),
    nav_panel("Describing data", page_wrap(ui_stats_describe)),
    nav_panel("Normal distribution", page_wrap(ui_stats_normal)),
    nav_panel("t-test", page_wrap(ui_stats_ttest)),
    nav_panel("Regression", page_wrap(ui_stats_regression))
  ),
  nav_menu(
    "AI",
    icon = icon("robot"),
    nav_panel("Prompting levels", page_wrap(ui_ai_prompting), icon = icon("layer-group")),
    nav_panel("Prompt gallery", page_wrap(ui_ai_gallery), icon = icon("images")),
    nav_panel("AI-assisted analysis", page_wrap(ui_ai_training), icon = icon("magnifying-glass-chart")),
    nav_panel("When AI gets it wrong", page_wrap(ui_ai_case), icon = icon("triangle-exclamation")),
    nav_panel("AI safety", page_wrap(md_page("ai-safety.md")), icon = icon("shield-halved"))
  ),
  nav_panel("Quiz", quizUI("quiz"), icon = icon("clipboard-check")),
  nav_menu(
    "Training",
    icon = icon("graduation-cap"),
    nav_panel("Training guide", page_wrap(ui_training_guide)),
    nav_panel("Credits", page_wrap(md_page("image-credits.md")))
  ),
  nav_spacer(),
  nav_item(
    tags$a(
      icon("envelope"),
      "dings@who.int",
      href = "mailto:dings@who.int",
      class = "nav-link"
    )
  )
)
