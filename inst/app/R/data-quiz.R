# Quiz question bank, rebuilt from slides/slides.Rmd (2025-10-07 training deck)
# plus the prompting / statistics / AI questions from the 2025-11-18 lecture
# ("AI-Empowered Data Analysis").
# Each question: topic, question, optional image (under www/picture), choices,
# the correct answer, an explanation, and an optional plot function whose
# result is shown next to the answer.

# Small datasets used by the answer plots ------------------------------------

quiz_df_age_group <- tribble(
  ~`Age Group`, ~Sex, ~`Hypertension Prevalence (%)`,
  "0-14", "Male", 2,
  "0-14", "Female", 1.5,
  "15-49", "Male", 18,
  "15-49", "Female", 14,
  "50+", "Male", 45,
  "50+", "Female", 50
)

quiz_df_pie <- tribble(
  ~`Cause of Death`, ~Count,
  "Heart disease", 480,
  "Cancer", 390,
  "Stroke", 220,
  "Diabetes", 130,
  "Others", 80
)

quiz_df_3d <- tibble(
  Country = LETTERS[1:5],
  Expenditure = c(68, 69, 66, 62, 57)
)

quiz_df_scatter <- suppressMessages(read_csv("data/test-scatter.csv"))
quiz_df_box <- suppressMessages(read_csv("data/test-boxplot.csv"))

# Question bank ---------------------------------------------------------------

quiz_questions <- list(
  list(
    topic = "Tidy data",
    question = "Is this data table tidy data?",
    image = "3-tidy.png",
    choices = c("Yes", "No"),
    answer = "No",
    explanation = paste(
      "- It uses a multi-row header, which violates tidy data principles.",
      "- Each column should have a single, unique variable name.",
      "- Column names should not span multiple rows or encode hierarchical structure.",
      sep = "\n"
    )
  ),
  list(
    topic = "Tidy data",
    question = "Is this tidy data?",
    image = "4-tidy.png",
    choices = c("Yes", "No"),
    answer = "No",
    explanation = paste(
      "- It uses merged cells.",
      "- In tidy data, no values should be implied by the structure of the table.",
      "- All values must be explicitly filled in.",
      sep = "\n"
    )
  ),
  list(
    topic = "Tidy data",
    question = "Is this tidy data?",
    image = "5-tidy.png",
    choices = c("Yes", "No"),
    answer = "Yes",
    explanation = paste(
      "- Each variable forms a column.",
      "- Each observation forms a row.",
      "- Each type of observational unit forms a table.",
      sep = "\n"
    )
  ),
  list(
    topic = "Missing data",
    question = paste(
      "While collecting data for SDG 3.8.1 (Universal Health Coverage), the",
      "sub-indicator **proportion of people with diabetes receiving medication**",
      "is entirely missing for a specific country. Investigation reveals the",
      "country **has no diabetes registry** and **places low priority on",
      "noncommunicable diseases (NCDs)**. Other variables such as incident TB",
      "cases and malaria were reported normally. Which type of missingness does",
      "this most likely represent?"
    ),
    choices = c(
      "Missing Completely At Random (MCAR)",
      "Missing At Random (MAR)",
      "Missing Not At Random (MNAR)"
    ),
    answer = "Missing Not At Random (MNAR)",
    explanation = paste(
      "- MNAR applies when missingness is related to the **unobserved value itself**.",
      "- Here the lack of data is **structural and policy-driven** — the country's",
      "neglect of diabetes care makes it more likely that no data is collected or reported.",
      sep = "\n"
    )
  ),
  list(
    topic = "Missing data",
    question = paste(
      "You are analyzing SDG 3.4.1 (NCD mortality rate). Your dataset contains a",
      "numerical variable (mortality rate per 100,000), but some values are",
      "missing and the data include **outliers**. Which imputation method is the",
      "most appropriate?"
    ),
    choices = c(
      "Drop missing values",
      "Replace missing with 0",
      "Impute with mean",
      "Impute with median",
      "K-nearest neighbors imputation (kNN)"
    ),
    answer = "Impute with median",
    explanation = paste(
      "- The median is a robust statistic: it is not sensitive to extreme values.",
      "- The mean is influenced by outliers.",
      "- Filling with 0 introduces artificial bias and may mislead downstream analysis.",
      "- Dropping missing values may lose valuable information.",
      "- kNN is powerful but often unnecessary for simple missingness patterns.",
      sep = "\n"
    )
  ),
  list(
    topic = "Outliers",
    question = paste(
      "You visualized a numerical SDG 3 indicator with a boxplot and observed",
      "several extreme outliers above the upper whisker. Which is the most",
      "appropriate way to reduce their influence while preserving the overall",
      "data structure?"
    ),
    choices = c(
      "Remove all outliers",
      "Winsorize the outliers by capping them at the IQR bounds",
      "Replace outliers with the mean value",
      "Do nothing and keep all outliers"
    ),
    answer = "Winsorize the outliers by capping them at the IQR bounds",
    explanation = paste(
      "- Removing may lose information, especially with many outliers.",
      "- **Winsorization** reduces the influence of extreme values while preserving",
      "the data size — often preferred for robust analysis.",
      "- Replacing with the mean may introduce bias, particularly with skewed distributions.",
      "- Doing nothing can mislead results when outliers heavily affect the mean or SD.",
      sep = "\n"
    )
  ),
  list(
    topic = "Text cleaning",
    question = "Why is text cleaning an important step before doing any smart analysis?",
    choices = c(
      "Because people often misspell words",
      "Because text data usually contains lots of missing values",
      "Because inconsistent spelling and casing confuse grouping, filtering, and models",
      "Because machines cannot handle text data at all"
    ),
    answer = "Because inconsistent spelling and casing confuse grouping, filtering, and models",
    explanation = paste(
      "- Misspelling can matter but is not the core reason shown here.",
      "- Missing values are a different kind of data cleaning issue.",
      "- Machines do handle text — but inconsistently formatted text leads to poor results.",
      sep = "\n"
    )
  ),
  list(
    topic = "Merging",
    question = "Please tell me what type of join this diagram shows:",
    image = "6-join.png",
    choices = c("Left join", "Right join", "Inner join", "Full join"),
    answer = "Left join",
    explanation = paste(
      "In a **left join**, all rows from the left table are kept, and matching rows",
      "from the right table are added where possible; unmatched rows get NA.",
      "In this diagram the left table contributes all 3 rows, and key = 3 has no",
      "match on the right, so its `val_y` is NA.",
      sep = "\n"
    )
  ),
  list(
    topic = "Merging",
    question = "Please tell me what type of join this diagram shows:",
    image = "7-join.png",
    choices = c("Left join", "Right join", "Inner join", "Full join"),
    answer = "Inner join",
    explanation = paste(
      "An **inner join** keeps only the rows whose key is present in both tables.",
      "Keys 1 and 2 exist in both tables, so they are kept; key 3 (left) and key 4",
      "(right) are dropped because they have no match in the other table.",
      sep = "\n"
    )
  ),
  list(
    topic = "Visualization",
    question = paste(
      "A national health survey includes **Age Group** (0–14, 15–49, 50+),",
      "**Gender** (Male/Female), and **Prevalence of Hypertension (%)** in each",
      "group. You want to compare prevalence across age groups, separately for",
      "males and females. Which chart type is most appropriate?"
    ),
    choices = c("Line chart", "Pie chart", "Grouped bar chart", "Scatter plot"),
    answer = "Grouped bar chart",
    explanation = paste(
      "- A **grouped bar chart** compares prevalence across age groups while also",
      "splitting by gender — exactly the need here.",
      "- A line chart suits continuous trends (e.g., over time).",
      "- A pie chart is poor for comparisons across multiple groups.",
      "- A scatter plot shows relationships between two continuous variables.",
      sep = "\n"
    ),
    plot = function() {
      p <- ggplot(
        quiz_df_age_group,
        aes(`Age Group`, `Hypertension Prevalence (%)`, fill = Sex)
      ) +
        geom_col(color = "white", position = "dodge") +
        palette_cat()
      ggplotly(p)
    }
  ),
  list(
    topic = "Visualization",
    question = paste(
      "You are analyzing a dataset of 3,000 adults with recorded **BMI** and",
      "**Systolic Blood Pressure**. You want to explore whether there is a",
      "relationship or trend between these two continuous variables. Which chart",
      "type should you use?"
    ),
    choices = c("Grouped bar chart", "Pie chart", "Scatter plot", "Boxplot"),
    answer = "Scatter plot",
    explanation = paste(
      "A **scatter plot** is best for showing the relationship between two",
      "continuous variables — here BMI against systolic blood pressure.",
      sep = "\n"
    ),
    plot = function() {
      p <- ggplot(quiz_df_scatter, aes(BMI, Systolic_BP)) +
        geom_point(alpha = .2, size = 1)
      ggplotly(p)
    }
  ),
  list(
    topic = "Visualization",
    question = paste(
      "You are preparing visual materials for a public health seminar on NCDs.",
      "Which dataset is most appropriate to present with a **pie chart**?"
    ),
    choices = c(
      "Hypertension prevalence trends by age group from 2010 to 2020",
      "Mean BMI for males and females in 2023",
      "Causes of registered deaths in City X (2023): Heart disease, Cancer, Stroke, Diabetes, Others",
      "Fasting glucose levels of 3,000 diabetic patients"
    ),
    answer = "Causes of registered deaths in City X (2023): Heart disease, Cancer, Stroke, Diabetes, Others",
    explanation = paste(
      "- Pie charts illustrate the **composition of a whole** with a small number",
      "of mutually exclusive categories.",
      "- Trends over time → line chart; group comparison with variability → bar",
      "chart with error bars; continuous distribution → histogram or density plot.",
      sep = "\n"
    ),
    plot = function() {
      plot_ly(
        quiz_df_pie,
        labels = ~`Cause of Death`,
        values = ~Count,
        type = "pie"
      )
    }
  ),
  list(
    topic = "Visualization",
    question = paste(
      "A public health officer wants to compare the **distribution** of PM2.5 air",
      "pollution levels across three cities — which city has the worst air",
      "quality, and whether any city has extreme pollution events. Which chart",
      "type is most appropriate?"
    ),
    choices = c("Line chart", "Histogram", "Boxplot", "Bar chart"),
    answer = "Boxplot",
    explanation = paste(
      "- A **boxplot** compares the distribution of a continuous variable across",
      "categories — here PM2.5 across three cities — and makes outliers visible.",
      "- Bar charts compare counts/proportions, not distributions; line charts",
      "show trends over time.",
      sep = "\n"
    ),
    plot = function() {
      p <- ggplot(quiz_df_box, aes(City, PM2.5)) +
        geom_boxplot()
      ggplotly(p)
    }
  ),
  list(
    topic = "Visualization",
    question = "Look carefully at this 3D chart. Which design principles does it violate?",
    image = "8-3d.jpg",
    choices = c(
      "The y-axis does not start at zero",
      "The 3D effect distorts perception",
      "Too much decoration and unclear labels",
      "All of the above"
    ),
    answer = "All of the above",
    explanation = paste(
      "This chart breaks several rules at once: a truncated y-axis exaggerates",
      "differences, the 3D effect distorts perception, and the decoration hides",
      "the message. Below is a redesigned version — flat, zero-based, and labelled.",
      sep = "\n"
    ),
    plot = function() {
      p <- ggplot(quiz_df_3d, aes(Country, Expenditure)) +
        geom_col(fill = "steelblue") +
        labs(
          x = "Country", y = "Health Expenditure (Millions)",
          title = "Comparison of Health Expenditures"
        )
      ggplotly(p)
    }
  ),
  list(
    topic = "Data quality",
    question = paste(
      "A colleague sends you this extract from the cat café dataset. Is it",
      "ready for analysis?",
      "",
      "| gender | weight_kg | length_cm |",
      "|---|---|---|",
      "| Male | 3.1 | 42.1 |",
      "| female | 4.2 | 5.0 |",
      "| F | 56.0 | 48.7 |",
      "| m | 4.9 | 50.3 |",
      sep = "\n"
    ),
    choices = c(
      "Yes — it loads without errors, so it is clean",
      "No — it has encoding problems and impossible values"
    ),
    answer = "No — it has encoding problems and impossible values",
    explanation = paste(
      "- `gender` uses four encodings (Male, female, F, m) for two categories,",
      "which would split every grouped analysis into false subgroups.",
      "- Some values are impossible: a 56 kg cat is almost certainly 5.6 kg",
      "with a misplaced decimal, and a 5 cm body length is likely 50 cm.",
      "- **Loadable is not the same as clean.** Clean means semantically",
      "correct, not just readable by software.",
      sep = "\n"
    )
  ),
  list(
    topic = "Missing data",
    question = "What is the most important step **before** imputing missing values?",
    choices = c(
      "Try random imputation and compare the results",
      "Inspect the missingness patterns and mechanisms",
      "Run the most advanced imputation package available"
    ),
    answer = "Inspect the missingness patterns and mechanisms",
    explanation = paste(
      "- Understanding **why** values are missing (MCAR, MAR, MNAR, or other",
      "patterns) determines which methods are valid at all.",
      "- Tools come second: a sophisticated method applied to a misunderstood",
      "missingness mechanism produces confident but biased results.",
      sep = "\n"
    )
  ),
  list(
    topic = "Missing data",
    question = paste(
      "A dataset has two variables with missing values. **Variable A** has few",
      "missing values and a stable distribution. **Variable B** has many",
      "missing values and is clearly related to several other variables in the",
      "data. Which imputation plan is better?"
    ),
    choices = c(
      "Impute both variables with the mean",
      "A → median imputation; B → kNN imputation using the related variables",
      "A → mean imputation; B → random values"
    ),
    answer = "A → median imputation; B → kNN imputation using the related variables",
    explanation = paste(
      "- A stable variable with little missingness is well served by the",
      "**median**: robust, simple, and easy to explain.",
      "- A variable that depends on others benefits from **kNN**: the imputed",
      "values reflect patterns in the related variables and preserve",
      "variability better than a single constant.",
      "- The mean is vulnerable to outliers, and random values add pure noise.",
      sep = "\n"
    )
  ),
  list(
    topic = "Statistics",
    question = paste(
      "You built a 5 × 6 contingency table (adoption source × personality)",
      "from about 30 cats. Many cells hold counts of 0 or 1. Which test should",
      "you use?"
    ),
    choices = c("Chi-square test", "Fisher's exact test"),
    answer = "Fisher's exact test",
    explanation = paste(
      "- The chi-square test becomes unreliable when expected cell counts fall",
      "below 5 — common in small or sparse tables.",
      "- **Fisher's exact test** works for r × c tables with small counts,",
      "which makes it the safer choice here.",
      sep = "\n"
    )
  ),
  list(
    topic = "Statistics",
    question = paste(
      "You want to compare **weight** across **personality groups**. The",
      "groups are small and unbalanced, and the data show outliers and skewed",
      "distributions. Which test is the safer choice?"
    ),
    choices = c("One-way ANOVA", "Kruskal-Wallis test"),
    answer = "Kruskal-Wallis test",
    explanation = paste(
      "- ANOVA assumes normality and equal variances — doubtful with small,",
      "unbalanced groups, outliers, and skewness.",
      "- The **Kruskal-Wallis test** is the non-parametric alternative: robust",
      "to outliers and unbalanced groups, at the cost of a little power when",
      "ANOVA's assumptions actually hold.",
      sep = "\n"
    )
  ),
  list(
    topic = "Statistics",
    question = "Your test returns **p = 0.20**. How should you interpret it?",
    choices = c(
      "A strong association",
      "A weak but statistically significant association",
      "No statistically significant evidence of an association"
    ),
    answer = "No statistically significant evidence of an association",
    explanation = paste(
      "- We cannot reject the null hypothesis at conventional levels (e.g.",
      "0.05); the result is **inconclusive**.",
      "- Patterns visible in the plots could easily arise by chance — treat",
      "them as exploratory, not as evidence.",
      "- Note the wording: this is *no evidence of an association*, which is",
      "not the same as *evidence of no association*.",
      sep = "\n"
    )
  ),
  list(
    topic = "Prompting",
    question = "Which prompt is most likely to produce a reliable analysis?",
    choices = c(
      "\"Analyze this dataset for me.\"",
      "\"Here are the variables and my goals. Please follow these steps…\"",
      "\"Tell me a story based on the numbers.\""
    ),
    answer = "\"Here are the variables and my goals. Please follow these steps…\"",
    explanation = paste(
      "- The first prompt is too vague — AI does not know your goal or your",
      "constraints.",
      "- The second provides structure, and **clear structure leads to more",
      "reliable output**.",
      "- The third invites storytelling, not analysis.",
      sep = "\n"
    )
  ),
  list(
    topic = "Prompting",
    question = "Why do policy-relevant tasks need **strong-structure** prompting?",
    choices = c(
      "Because AI lacks creativity",
      "Because policy work needs transparency and reproducibility",
      "Because it makes the plots prettier"
    ),
    answer = "Because policy work needs transparency and reproducibility",
    explanation = paste(
      "- When an analysis feeds a decision, every step must be explicit,",
      "reproducible, and checkable.",
      "- A fully defined workflow means AI cannot guess or improvise — and a",
      "reviewer can audit exactly what was done.",
      sep = "\n"
    )
  ),
  list(
    topic = "Prompting",
    question = paste(
      "You have just received an unfamiliar dataset and want first",
      "impressions. Which prompting level fits best?"
    ),
    choices = c("Light — explore", "Middle — guide", "Strong — control"),
    answer = "Light — explore",
    explanation = paste(
      "- **Light structure** lets AI surface patterns and ideas you have not",
      "thought of yet — ideal for early exploration.",
      "- Move to **middle** once you know the task, and to **strong** when the",
      "output must be reproducible and policy-ready.",
      sep = "\n"
    )
  ),
  list(
    topic = "AI & methods",
    question = "Which task is AI most likely to get wrong **without human supervision**?",
    choices = c(
      "Creating a scatter plot",
      "Fitting a linear model",
      "Applying the current WHO methodology for SDG 3.8.1"
    ),
    answer = "Applying the current WHO methodology for SDG 3.8.1",
    explanation = paste(
      "- AI excels at generic tasks such as plotting and standard models.",
      "- It often misapplies **institution-specific rules** — weights,",
      "revisions, definitions — because they are not in its training data.",
      "- See **AI → When AI gets it wrong** for a worked example.",
      sep = "\n"
    )
  ),
  list(
    topic = "AI & methods",
    question = paste(
      "Which aggregation is correct for the UHC service coverage index",
      "(SDG 3.8.1) after the 2025 revision?"
    ),
    choices = c(
      "A simple geometric mean of all 14 tracers",
      "A weighted geometric mean within each domain, then a geometric mean of the four sub-indices"
    ),
    answer = "A weighted geometric mean within each domain, then a geometric mean of the four sub-indices",
    explanation = paste(
      "- The 2025 revision weights each tracer by the **population it",
      "represents** when building the four domain sub-indices.",
      "- The overall index is then the geometric mean of the four sub-indices,",
      "with no additional weights at that step.",
      sep = "\n"
    )
  ),
  list(
    topic = "AI & methods",
    question = "If AI silently applies the **old** SCI aggregation method, what happens?",
    choices = c(
      "Nothing important — the two methods give almost identical results",
      "Systematic bias in the results — and AI will not warn you"
    ),
    answer = "Systematic bias in the results — and AI will not warn you",
    explanation = paste(
      "- In the worked example on the **When AI gets it wrong** page, the",
      "old and new methods differ by **11 points** on a 100-point index.",
      "- Wrong method → wrong rankings → wrong policy message. And because the",
      "code runs cleanly, nothing looks wrong until a human checks.",
      sep = "\n"
    )
  ),
  list(
    topic = "AI & methods",
    question = "Which analysis step is AI **least** able to automate?",
    choices = c(
      "Cleaning the data",
      "Running the models",
      "Choosing conceptually appropriate methods"
    ),
    answer = "Choosing conceptually appropriate methods",
    explanation = paste(
      "- Cleaning and model-fitting are mechanical once defined — AI does",
      "them quickly and well.",
      "- **Method choice** is conceptual and contextual: it depends on the",
      "question, the data-generating process, and the decision at stake.",
      "That judgment remains human work.",
      sep = "\n"
    )
  )
)
