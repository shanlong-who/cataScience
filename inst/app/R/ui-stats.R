# Statistics learning pages, rebuilt from slides/slides-cats-teach-stats.Rmd.
# Four pages: Describing data, Normal distribution, t-test, Regression.

# ---- Page 1: Describing data -------------------------------------------------

ui_stats_describe <- div(
  layout_columns(
    col_widths = c(4, 4, 4),
    card(
      card_header("Mode — the most frequent value"),
      app_img("11-mode.jpg", alt = "Mode illustrated with cats"),
      markdown(paste(
        "- **Mode** = the value that appears **most often**.",
        "- Works well for **categorical** or **skewed** data.",
        "- Not affected by outliers.",
        "- In health data: most common symptom, most common risk behavior.",
        sep = "\n"
      )),
      card_footer(
        "Example: for 2, 2, 3, 4, 4, 4, 5, 5 the mode is 4 (appears 3 times)."
      )
    ),
    card(
      card_header("Median — the middle value"),
      app_img("12-median.jpg", alt = "Median illustrated with cats lined up by size"),
      markdown(paste(
        "- **Median** = the middle value when data are sorted.",
        "- Even number of values → average of the two middle ones.",
        "- Not pulled by outliers: for 2, 4, 4, 5, 6, 8, 11, **100** the median",
        "  is still 5.5.",
        "- Common in health reports: median survival time, median hospital",
        "  cost, median household income.",
        sep = "\n"
      ))
    ),
    card(
      card_header("Mean — not only one thing"),
      app_img("10-average.jpg", alt = "Average illustrated with cats"),
      markdown(paste(
        "- **Arithmetic** mean: everyday average — life expectancy.",
        "- **Geometric** mean: long-term growth, ratios (RR, OR).",
        "- **Weighted** mean: fair representation of a population.",
        "",
        "Choosing the right mean is critical for correct analysis.",
        sep = "\n"
      ))
    )
  ),
  card(
    card_header("Try it: a very big cat joins the office 🐱"),
    layout_sidebar(
      sidebar = sidebar(
        width = 320,
        markdown(paste(
          "Nine office cats weigh between 4.2 and 4.9 kg.",
          "Use the slider to let one **new cat** walk in and watch what",
          "happens to the **mean** and the **median**.",
          sep = "\n"
        )),
        sliderInput(
          "st_newcomer",
          "Weight of the new cat (kg):",
          min = 4.5, max = 30, value = 4.5, step = 0.5
        ),
        uiOutput("st_mean_median_text")
      ),
      plotlyOutput("st_p_mean_median", height = "360px")
    ),
    card_footer(
      "The mean chases the big cat; the median barely moves. This is why we",
      " report the median for skewed data such as costs or length of stay."
    )
  ),
  layout_columns(
    col_widths = c(6, 6),
    card(
      card_header("Three kinds of mean"),
      accordion(
        open = FALSE,
        accordion_panel(
          "Arithmetic mean",
          markdown(paste(
            "Sum of all values divided by the number of values.",
            "",
            "Example: cat weights 4.2, 4.4, 4.5, 4.9 →",
            "(4.2 + 4.4 + 4.5 + 4.9) / 4 = **4.5**",
            "",
            "- Pros: intuitive, widely used.",
            "- Cons: sensitive to outliers.",
            "- Common in: income, life expectancy, GDP per capita.",
            sep = "\n"
          )),
          span(class = "stat-formula", "mean = Σ xᵢ / n")
        ),
        accordion_panel(
          "Geometric mean",
          markdown(paste(
            "Multiply all values and take the n-th root.",
            "",
            "Example: growth rates 1.10, 1.20, 1.30 → arithmetic mean ≈ 1.20,",
            "geometric mean ≈ **1.19** (more accurate, because growth compounds).",
            "",
            "- Pros: right for ratios, percentages, growth rates.",
            "- Cons: cannot handle zeros or negative values.",
            "- Common in: economic growth, relative risk (RR), odds ratio (OR).",
            sep = "\n"
          )),
          span(class = "stat-formula", "GM = (∏ xᵢ)^(1/n)")
        ),
        accordion_panel(
          "Weighted mean",
          markdown(paste(
            "Values are averaged with weights, so bigger groups count more.",
            "",
            "**Story**: three mother cats, one question — what is the overall",
            "vaccination coverage across all kittens?",
            sep = "\n"
          )),
          teach_table(stats_weight_table),
          markdown(paste(
            "- Simple average of 50, 60, 90 → 66.7% (ignores litter size).",
            "- Weighted: (2 + 3 + 9) / (4 + 5 + 10) = 14 / 19 = **73.7%**.",
            "",
            "This is exactly how population-weighted coverage indicators work.",
            sep = "\n"
          )),
          span(class = "stat-formula", "mean_w = Σ wᵢ xᵢ / Σ wᵢ")
        )
      )
    ),
    card(
      card_header("Practice: five countries, three means"),
      teach_table(stats_uhc5),
      p("Calculate the arithmetic, geometric, and weighted mean of the UHC index."),
      actionButton("st_show_means", "Show the answer", class = "btn-outline-primary"),
      uiOutput("st_means_answer")
    )
  ),
  layout_columns(
    col_widths = c(6, 6),
    card(
      card_header("Variance and standard deviation"),
      layout_columns(
        col_widths = c(5, 7),
        div(
          app_img("14-variance.png", alt = "Low versus high variance targets"),
          markdown(paste(
            "- **Low variance**: results are consistent, close together.",
            "- **High variance**: results are scattered.",
            "- Variance measures spread, **not** the shape of the distribution.",
            "",
            "Steps: mean → deviation → squared deviation → mean of squares.",
            "Standard deviation = √variance (same unit as the data).",
            sep = "\n"
          ))
        ),
        div(
          teach_table(stats_var_table),
          teach_table(stats_var_summary)
        )
      )
    ),
    card(
      card_header("Skewness — which side is the tail on?"),
      plotOutput("st_p_skew", height = "260px"),
      markdown(paste(
        "- **Right-skewed**: long tail to the right → **mean > median**.",
        "  Examples: costs, length of stay, income, viral load.",
        "- **Left-skewed**: long tail to the left → **mean < median**.",
        "  Examples: ceiling effects (test scores near 100).",
        "",
        "**What to do in practice**",
        "",
        "- For skewed data, report **median (IQR)** rather than mean (SD).",
        "- Always **show a plot** (histogram or boxplot).",
        "- If strictly positive and strongly right-skewed, consider a **log",
        "  scale** or the geometric mean.",
        "- Don't over-interpret mean differences when distributions are skewed.",
        sep = "\n"
      ))
    )
  ),
  card(
    card_header("Practice with AI: descriptive statistics on real data"),
    p(
      "Download the SDG 3.8.1 dataset from the Home page, upload it to an AI",
      " assistant, and use this prompt:"
    ),
    copy_button("st_prompt_desc"),
    div(
      id = "st_prompt_desc", class = "prompt-block",
      paste(
        "Hello, I am uploading a file that contains the 2021 UHC Service Coverage",
        "Index results for WHO Western Pacific Region Member States.",
        "",
        "The file has three columns:",
        "- id = country/area code",
        "- sdg381 = UHC Service Coverage Index value",
        "- population = population size",
        "",
        "Each row corresponds to one Member State.",
        "",
        "Please help me perform descriptive statistics and visualization, including:",
        "- Arithmetic mean of sdg381",
        "- Geometric mean of sdg381",
        "- Population-weighted mean of sdg381 (using population as weight)",
        "- Variance of sdg381",
        "- Skewness (and indicate whether left-skewed or right-skewed)",
        "- A density plot of sdg381 to observe distribution shape",
        "- Any other useful descriptive statistics or plots you find relevant",
        sep = "\n"
      )
    )
  )
)

# ---- Page 2: Normal distribution ---------------------------------------------

ui_stats_normal <- div(
  layout_columns(
    col_widths = c(6, 6),
    card(
      card_header("Our real life follows a bell curve"),
      markdown(paste(
        "- Most cats weigh around **4–5 kg**; few are very small, few are very big.",
        "- The same holds for human height, weight, blood pressure, exam scores…",
        "- The **normal distribution** is symmetric and bell-shaped: most values",
        "  near the mean, fewer at the extremes.",
        "",
        "**Why it matters**: most statistical tests (t-test, confidence",
        "intervals, regression) assume the data — or at least the averages —",
        "are roughly normal. Understanding the bell curve is the foundation",
        "of inference.",
        sep = "\n"
      ))
    ),
    card(
      card_header("The 68–95–99.7 rule"),
      radioButtons(
        "st_sd_k",
        "Highlight values within … of the mean:",
        choices = c("1 SD" = 1, "2 SD" = 2, "3 SD" = 3),
        selected = 1,
        inline = TRUE
      ),
      plotOutput("st_p_rule", height = "280px"),
      uiOutput("st_rule_text")
    )
  ),
  layout_columns(
    col_widths = c(6, 6),
    card(
      card_header("Real data: SDG 3.8.1 (UHC index), 2021, 28 WPR Member States"),
      plotOutput("st_p_uhc_density", height = "340px"),
      card_footer(
        "Not a typical normal distribution — real indicator data are often",
        " skewed. Mean and median tell you different stories here."
      )
    ),
    card(
      card_header("Central Limit Theorem: try it yourself"),
      markdown(paste(
        "Even when the population is **not** normal (like the UHC values on",
        "the left), the distribution of the **sample mean** becomes",
        "approximately normal as the sample size grows.",
        sep = "\n"
      )),
      sliderInput(
        "st_clt_n",
        "Sample size per draw:",
        min = 2, max = 100, value = 5, step = 1
      ),
      plotOutput("st_p_clt", height = "260px"),
      card_footer(
        "2,000 repeated samples (with replacement) from the 28 UHC values;",
        " each dot in the histogram is one sample mean."
      )
    )
  )
)

# ---- Page 3: t-test ------------------------------------------------------------

ui_stats_ttest <- div(
  card(
    card_header("Question: do cats purr more when petted? 🐾"),
    layout_columns(
      col_widths = c(3, 3, 6),
      card(
        app_img("20-oreo.jpg", alt = "A petted cat"),
        card_footer("Group A: petted")
      ),
      card(
        app_img("21-not-petted.jpg", alt = "A cat that is not petted"),
        card_footer("Group B: not petted")
      ),
      markdown(paste(
        "We measured daily purring minutes in two groups of cats.",
        "The petted group purrs more **on average** — but averages alone are",
        "not enough:",
        "",
        "- Every sample is noisy; two random groups never have identical means.",
        "- The question is whether the observed difference is **larger than",
        "  what chance alone would produce**.",
        "- The **t-test** compares the difference between means against the",
        "  variation within groups.",
        sep = "\n"
      ))
    )
  ),
  card(
    card_header("Try it: simulate the experiment"),
    layout_sidebar(
      sidebar = sidebar(
        width = 320,
        sliderInput(
          "st_t_n",
          "Cats per group:",
          min = 3, max = 100, value = 20, step = 1
        ),
        sliderInput(
          "st_t_diff",
          "True difference in purring minutes:",
          min = 0, max = 10, value = 4, step = 0.5
        ),
        uiOutput("st_t_text")
      ),
      layout_columns(
        col_widths = c(7, 5),
        plotlyOutput("st_p_ttest", height = "360px"),
        div(
          h6("t-test result"),
          uiOutput("st_t_table")
        )
      )
    ),
    card_footer(
      "Small samples + small differences → large p-values: the data cannot",
      " distinguish the difference from chance. More cats or bigger",
      " differences → smaller p-values."
    )
  ),
  layout_columns(
    col_widths = c(6, 6),
    card(
      card_header("The p-value"),
      markdown(paste(
        "- The p-value is the probability of seeing a difference **at least as",
        "  large as observed** if there were truly no difference.",
        "- Small p-value (commonly < 0.05) → the observed difference is",
        "  unlikely to be chance alone.",
        "- It is **not** the probability that the hypothesis is true, and",
        "  “not significant” does **not** mean “no effect”.",
        sep = "\n"
      ))
    ),
    card(
      card_header("The confidence interval"),
      markdown(paste(
        "- A 95% confidence interval gives a **range of plausible values** for",
        "  the true difference.",
        "- If the interval excludes 0, the difference is statistically",
        "  significant at the 5% level.",
        "- Wide intervals mean **uncertainty** — usually small samples or",
        "  noisy data.",
        sep = "\n"
      ))
    )
  ),
  card(
    card_header("WHO example: SDG 3.8.1 — old vs new estimation method"),
    layout_columns(
      col_widths = c(6, 6),
      plotlyOutput("st_p_methods", height = "340px"),
      div(
        markdown(paste(
          "The same 28 Member States have UHC index values estimated by an",
          "**old** and a **new** method. Because both values belong to the",
          "same country, we use a **paired** t-test on the within-country",
          "differences.",
          sep = "\n"
        )),
        h6("Paired t-test result"),
        uiOutput("st_methods_table"),
        uiOutput("st_methods_text")
      )
    )
  )
)

# ---- Page 4: Regression ---------------------------------------------------------

ui_stats_regression <- div(
  card(
    card_header("Example: longer cats, heavier cats? 🐱"),
    layout_columns(
      col_widths = c(7, 5),
      plotlyOutput("st_p_cat_reg", height = "340px"),
      markdown(paste(
        "Linear regression draws the **best straight line** through the cloud",
        "of points:",
        "",
        "- **Intercept**: predicted weight when length is 0 (often just a",
        "  mathematical anchor, not meaningful by itself).",
        "- **Slope**: extra weight for each extra centimetre of cat.",
        "- **R²**: share of the variation in weight explained by length",
        "  (0 = nothing, 1 = everything).",
        "",
        "Regression turns “the points look related” into numbers you can",
        "report and compare.",
        sep = "\n"
      ))
    )
  ),
  card(
    card_header("WHO example: GDP per capita vs UHC index"),
    layout_columns(
      col_widths = c(7, 5),
      plotlyOutput("st_p_uhc_gdp", height = "360px"),
      div(
        h6("Model: UHC index ~ log10(GDP per capita)"),
        uiOutput("st_gdp_table"),
        uiOutput("st_gdp_text")
      )
    )
  ),
  layout_columns(
    col_widths = c(6, 6),
    card(
      card_header("⚠️ Correlation is not causation"),
      markdown(paste(
        "Richer countries tend to have higher UHC — but GDP is also linked",
        "with health-system capacity, demographics, and reporting quality",
        "(**confounding**).",
        "",
        "Safer wording:",
        "",
        "- “is **associated** with”",
        "- “countries with higher X also **tend to** have higher Y”",
        "",
        "Avoid unless the study design supports it:",
        "",
        "- “causes”, “leads to”, “because of”, “impact of”",
        sep = "\n"
      ))
    ),
    card(
      card_header("Putting it all together"),
      markdown(paste(
        "A complete small analysis usually walks the same path:",
        "",
        "1. **Descriptive statistics** — know your data first.",
        "2. **Distribution** — is it symmetric or skewed? Which summary fits?",
        "3. **t-test** — is the difference between groups beyond chance?",
        "4. **Regression** — how strong is the relationship, and what would",
        "   you predict?",
        "",
        "Then communicate the result honestly, including its uncertainty.",
        sep = "\n"
      ))
    )
  )
)
