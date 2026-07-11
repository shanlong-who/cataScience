# "AI-assisted analysis" page, rebuilt from
# slides/slides-2026-ai-data-training.qmd (July 2026 GHLC / SIAP trainings).

ui_ai_training <- div(
  card(
    card_header("Why this page exists"),
    markdown(paste(
      "AI can write R code quickly. But a useful health analysis still needs",
      "**human judgement**:",
      "",
      "- Is the data fit for the question?",
      "- Is the indicator appropriate?",
      "- Are missingness, outliers, and denominators handled well?",
      "- Does the interpretation go beyond the evidence?",
      "- Can the message support a policy decision?",
      sep = "\n"
    )),
    h6("Course map"),
    div(
      class = "flow-map",
      span(class = "flow-step", "Question"),
      span(class = "flow-arrow", "→"),
      span(class = "flow-step", "Indicator"),
      span(class = "flow-arrow", "→"),
      span(class = "flow-step", "Data quality"),
      span(class = "flow-arrow", "→"),
      span(class = "flow-step", "Descriptive analysis"),
      span(class = "flow-arrow", "→"),
      span(class = "flow-step", "Interpretation"),
      span(class = "flow-arrow", "→"),
      span(class = "flow-step", "Policy message")
    ),
    markdown(paste(
      "Before asking AI to write code, define: the public health **question**,",
      "the **indicator** that answers it, the **population, place, and year**,",
      "the **comparison** that is meaningful, and the **decision** the analysis",
      "could inform. The AI prompt is never the first analytical step — the",
      "question is.",
      sep = "\n"
    ))
  ),
  layout_columns(
    col_widths = c(6, 6),
    card(
      card_header("Data types matter"),
      teach_table(tribble(
        ~`Data type`, ~Examples, ~`Common summaries`, ~`Common plots`,
        "Categorical", "sex, country, facility type", "count, proportion", "bar chart",
        "Numeric", "rate, index, age, income", "mean, median, range, SD", "histogram, boxplot",
        "Date or time", "year, month, reporting week", "trend, change", "line chart",
        "Text", "names, free-text notes", "cleaned categories, keywords", "table, bar chart"
      ))
    ),
    card(
      card_header("Data quality is analytical, not just technical"),
      teach_table(tribble(
        ~Issue, ~`Technical risk`, ~`Interpretation risk`,
        "Missing values", "functions fail or rows drop", "biased indicator",
        "Outliers", "mean and model distorted", "rare but important group hidden",
        "Text inconsistency", "false categories", "wrong subgroup message",
        "Bad merge key", "duplicated or lost rows", "wrong denominator"
      ))
    )
  ),
  layout_columns(
    col_widths = c(6, 6),
    card(
      card_header("Missing data: ask why"),
      markdown(paste(
        "MCAR, MAR, and MNAR are not only statistical labels — they are",
        "questions about the **data-generating process**.",
        "",
        "- **MCAR** — missing by random chance → safe to drop; small bias risk.",
        "- **MAR** — related to other observed variables → impute with caution.",
        "- **MNAR** — related to the missing value itself → high bias risk;",
        "  investigate before analyzing.",
        sep = "\n"
      ))
    ),
    card(
      card_header("Outliers: error, rare, or important?"),
      markdown(paste(
        "An outlier can be:",
        "",
        "- a data entry **error**;",
        "- a valid **extreme case**;",
        "- a meaningful **signal** of inequity or system failure.",
        "",
        "Do **not** delete an outlier only because it makes the chart",
        "inconvenient.",
        sep = "\n"
      ))
    )
  ),
  card(
    card_header("AI-assisted R coding"),
    markdown(paste(
      "Use AI to draft code, but keep the analytical decisions visible.",
      "A good prompt provides: **context and dataset** → **indicator",
      "definition** → **required checks** → **required outputs** →",
      "**interpretation guardrails**.",
      sep = "\n"
    )),
    copy_button("ai_prompt_template"),
    div(
      id = "ai_prompt_template", class = "prompt-block",
      paste(
        "I am working in R. Please help me use the DSIR package to fetch or prepare",
        "WHO/SDG indicator data for SDG 3.8.1 in WPRO. First inspect the data",
        "structure, missing values, and variable types. Then produce descriptive",
        "statistics and one clear chart. Do not make causal claims. Explain any data",
        "quality limitations in simple English.",
        sep = " "
      )
    ),
    accordion(
      open = FALSE,
      accordion_panel(
        "Example R workflow the AI should produce",
        tags$pre(
          class = "prompt-block",
          paste(
            'library(tidyverse)',
            'library(DSIR)',
            '',
            '# 1. Fetch SDG 3.8.1 data for WPRO countries',
            'df <- sdg_data("3.8.1", area = wpro_cty, year_from = 2015)',
            '',
            '# 2. Inspect structure and missing values',
            'glimpse(df)',
            'df |> summarise(across(c(value, timePeriodStart, geoAreaName), ~sum(is.na(.))))',
            '',
            '# 3. Clean and summarise',
            'df_clean <- df |>',
            '  select(country = geoAreaName, year = timePeriodStart, uhc = value) |>',
            '  mutate(uhc = as.numeric(uhc)) |>',
            '  filter(!is.na(uhc))',
            '',
            'df_clean |>',
            '  group_by(year) |>',
            '  summarise(n = n(), median_uhc = median(uhc), iqr = IQR(uhc))',
            '',
            '# 4. Visualise',
            'ggplot(df_clean, aes(x = year, y = uhc, group = country)) +',
            '  geom_line(alpha = 0.5) +',
            '  labs(',
            '    title = "UHC Service Coverage Index, WPRO, 2015-2023",',
            '    x = "Year", y = "UHC index (SDG 3.8.1)",',
            '    caption = "Source: UN SDG API."',
            '  ) +',
            '  theme_dsi()',
            sep = "\n"
          )
        )
      )
    )
  ),
  card(
    card_header("Dashboard lab: practice inside this app"),
    markdown(paste(
      "1. Go to **Import** and load the example data (or upload",
      "   `cat-dirty-data.xlsx`).",
      "2. Inspect data types and missing values.",
      "3. Compare missing-data handling choices under **Cleaning → Missing",
      "   data**.",
      "4. Compare outlier handling choices under **Cleaning → Outliers**.",
      "5. Create one chart in **Visualize** before and after cleaning.",
      "",
      "**Debrief questions**: What did AI need to know before writing useful",
      "code? Which data quality issue changed the result? Which cleaning",
      "decision should be documented? What would you ask AI to revise?",
      sep = "\n"
    ))
  ),
  layout_columns(
    col_widths = c(6, 6),
    card(
      card_header("Interpretation is not automatic"),
      markdown(paste(
        "A chart or model can be technically correct but still misleading.",
        "Always check:",
        "",
        "- **Uncertainty** — sampling variation, small numbers, missing or",
        "  mismeasured data, changing definitions. Do not hide uncertainty",
        "  just because a policy message needs to be short.",
        "- **Confounding** — a third factor (e.g. GDP) affecting both the",
        "  exposure and the outcome.",
        "- **Bias** — who is missing or under-reported? Are groups measured",
        "  the same way? Do averages hide within-country inequity?",
        "- Whether the **language implies causation** the design cannot support.",
        sep = "\n"
      ))
    ),
    card(
      card_header("Safer wording"),
      markdown(paste(
        "Instead of:",
        "",
        "> Higher GDP **causes** better UHC.",
        "",
        "Use:",
        "",
        "> In this dataset, countries with higher GDP per capita **tend to",
        "> have** higher UHC service coverage index values. This relationship",
        "> should not be interpreted as causal without considering",
        "> health-system capacity, demographics, reporting quality, and other",
        "> confounders.",
        sep = "\n"
      ))
    )
  ),
  card(
    card_header("Group activity: critique an AI-generated analysis"),
    markdown(paste(
      "Label each part of the AI output:",
      "",
      "- **Keep** — correct and useful.",
      "- **Revise** — useful but needs clearer evidence, wording, or chart choice.",
      "- **Remove** — unsupported, misleading, or irrelevant.",
      "",
      "Check five areas: **data and indicator fit**, **descriptive claims**,",
      "**causal language**, **bias and context**, **communication and policy",
      "use**. The full checklist is in *Training → Training guide*.",
      "",
      "Finish with a two-sentence policy message: what does the evidence",
      "suggest, and what should decision-makers do next — with what",
      "uncertainty in mind?",
      sep = "\n"
    ))
  )
)
