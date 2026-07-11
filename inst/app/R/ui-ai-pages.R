# AI learning pages, rebuilt from the 2025-11-18 lecture
# ("AI-Empowered Data Analysis: From Code to System Thinking") and the
# 2026-04-22 PHL-WCO Claude Cowork session. Three pages:
#   ui_ai_prompting - the light / middle / strong prompting framework
#   ui_ai_gallery   - copy-and-adapt prompt cards for everyday WHO tasks
#   ui_ai_case      - case study: AI applies an outdated WHO methodology

# ---- Page 1: Prompting levels -------------------------------------------------

ui_ai_prompting <- div(
  card(
    card_header("Prompting is thinking, not typing"),
    markdown(paste(
      "When we write a prompt, we are not \"instructing\" the AI — we are",
      "**clarifying our own thinking**. There is no single universal template.",
      "The structure of a good prompt depends on the task:",
      "",
      "- **Exploration and inspiration** → a free, open-ended prompt.",
      "- **Analysis with a clear goal** → a guided, semi-structured prompt.",
      "- **Reproducible, policy-relevant work** → a fully defined workflow.",
      "",
      "Structured prompting is not a fixed format. It is a **strategy for",
      "shaping the direction of the analysis**.",
      sep = "\n"
    )),
    div(
      class = "flow-map",
      span(class = "flow-step", "Light — explore"),
      span(class = "flow-arrow", "→"),
      span(class = "flow-step", "Middle — guide"),
      span(class = "flow-arrow", "→"),
      span(class = "flow-step", "Strong — control")
    )
  ),
  card(
    card_header("Five prompt superpowers 💪"),
    markdown(paste(
      "Whatever the level, these five habits improve almost every prompt:",
      "",
      "1. **Be specific** — \"Summarize in 3 bullet points for a non-technical",
      "   manager\", not \"summarize this\".",
      "2. **Give context** — \"I am a WHO programme officer writing to a",
      "   government counterpart.\"",
      "3. **Show examples** — \"Format it like this: [paste an example of what",
      "   you want].\"",
      "4. **Iterate** — \"Make it more formal.\" / \"Add a table.\" /",
      "   \"Shorter, please.\"",
      "5. **Upload files** — \"Here is my data — create a chart showing trends",
      "   by quarter.\"",
      sep = "\n"
    ))
  ),
  card(
    card_header("Choose the level to match the task"),
    teach_table(tribble(
      ~Level, ~Purpose, ~`Best for`, ~`You get`,
      "Light", "Explore — let AI think with you",
      "early EDA, pattern discovery, idea generation",
      "broad insight, hypotheses, directions",
      "Middle", "Guide — you know the task, AI keeps some freedom",
      "visualization, missing data handling, standard models",
      "guided analysis plus interpretation",
      "Strong", "Control — every step is defined",
      "policy analysis, reports to supervisors, publications",
      "transparent, reproducible, checkable output"
    ))
  ),
  navset_card_tab(
    nav_panel(
      "Light — explore",
      layout_columns(
        col_widths = c(5, 7),
        markdown(paste(
          "**Philosophy**: let AI think with you.",
          "",
          "**When to use**:",
          "",
          "- You don't know the structure of the data yet.",
          "- You want inspiration or unexpected patterns.",
          "- You want alternative views before committing to an analysis.",
          "",
          "Minimal limits, maximal flexibility. Treat every answer as a",
          "**hypothesis to check**, not a conclusion.",
          sep = "\n"
        )),
        div(
          copy_button("pl_light_prompt"),
          div(
            id = "pl_light_prompt", class = "prompt-block",
            paste(
              "Here is a dataset with [briefly name the variables].",
              "Please explore it freely and tell me 5 interesting observations.",
              "Suggest two quick plots that help describe the dataset.",
              sep = "\n"
            )
          )
        )
      ),
      accordion(
        open = FALSE,
        accordion_panel(
          "Worked example: a small cat dataset",
          markdown(paste(
            "We gave AI a dataset of cats' body weights and heart weights and",
            "asked for five interesting observations and two quick plots.",
            "AI answered in seconds:",
            "",
            "- a strong positive relationship between body and heart weight;",
            "- male cats are generally larger than female cats;",
            "- the sex difference remains after accounting for body weight;",
            "- possible outliers among very heavy heart weights.",
            "",
            "Each observation came with ready-to-run R code for a scatterplot",
            "and a boxplot. **Total cost: one sentence.** The catch: none of",
            "these are conclusions yet — they are directions to investigate.",
            sep = "\n"
          ))
        )
      )
    ),
    nav_panel(
      "Middle — guide",
      layout_columns(
        col_widths = c(5, 7),
        markdown(paste(
          "**Philosophy**: guide AI without restricting it too much.",
          "",
          "**When to use**:",
          "",
          "- Basic statistical tasks and standard models.",
          "- Visualization with a clear goal.",
          "- Missing data handling.",
          "",
          "You already have something in mind, but you stay open to what AI",
          "suggests along the way.",
          sep = "\n"
        )),
        div(
          copy_button("pl_middle_prompt"),
          div(
            id = "pl_middle_prompt", class = "prompt-block",
            paste(
              "Please analyze the relationship between [x] and [y].",
              "1. Fit a simple model.",
              "2. Report the model equation.",
              "3. Plot the data with the fitted line.",
              "4. Comment briefly on whether the model seems appropriate.",
              sep = "\n"
            )
          )
        )
      ),
      accordion(
        open = FALSE,
        accordion_panel(
          "Worked example: height and weight",
          markdown(paste(
            "With the built-in R dataset `women` (heights and weights of 15",
            "women), the four-step prompt above returned:",
            "",
            "- the fitted equation **weight ≈ −87.5 + 3.45 × height** with",
            "  R² ≈ 0.99;",
            "- a plot with the fitted line;",
            "- a short, honest comment: the relationship is strongly linear,",
            "  with no major deviations in the residuals.",
            "",
            "The structure told AI **what** to deliver; AI chose **how**.",
            "That balance is what the middle level is for.",
            sep = "\n"
          ))
        )
      )
    ),
    nav_panel(
      "Strong — control",
      layout_columns(
        col_widths = c(5, 7),
        markdown(paste(
          "**Philosophy**: eliminate ambiguity; every step is defined.",
          "",
          "**When to use**:",
          "",
          "- Reporting to supervisors or member states.",
          "- Policy analysis and research outputs.",
          "- Any high-stakes or regulatory work.",
          "",
          "A fully defined workflow — AI cannot guess or improvise. This is",
          "what makes the output **transparent, reproducible, and checkable**.",
          sep = "\n"
        )),
        div(
          copy_button("pl_strong_prompt"),
          div(
            id = "pl_strong_prompt", class = "prompt-block",
            paste(
              "Please perform a full diagnostic of the model [formula] using",
              "[dataset]. Follow these exact steps and report each section clearly:",
              "1. Fit the model.",
              "2. Report coefficients, R-squared, and residual SD.",
              "3. Plot the fitted line.",
              "4. Plot residuals vs fitted values.",
              "5. Plot a Q-Q plot of the residuals.",
              "6. Test nonlinearity by adding a quadratic term.",
              "7. Compare both models.",
              "8. Give a final recommendation on model suitability.",
              sep = "\n"
            )
          )
        )
      ),
      accordion(
        open = FALSE,
        accordion_panel(
          "Worked example: the full diagnostic",
          markdown(paste(
            "Running the eight-step prompt on the same `women` dataset, AI",
            "reported every section in order:",
            "",
            "- coefficients, R² = 0.991, residual SD = 1.53;",
            "- residuals vs fitted showed **slight curvature** — mild",
            "  nonlinearity the simple summary had hidden;",
            "- the quadratic term was statistically significant and removed",
            "  the curvature (R² 0.991 → 0.999);",
            "- but with only 15 observations, AI flagged the **risk of",
            "  overfitting** and recommended the linear model as the simpler,",
            "  acceptable summary.",
            "",
            "Every claim can be checked, rerun, and audited. That is why",
            "strong structure is the default for anything that feeds a",
            "decision.",
            sep = "\n"
          ))
        )
      )
    )
  ),
  layout_columns(
    col_widths = c(6, 6),
    card(
      card_header("Do ✅"),
      markdown(paste(
        "- Tell AI your level — \"assume I know basic regression\".",
        "- State the purpose — exploratory vs policy vs publication.",
        "- Ask for assumptions and limitations, not just results.",
        "- Provide definitions, metadata, and the method to use.",
        sep = "\n"
      ))
    ),
    card(
      card_header("Don't ❌"),
      markdown(paste(
        "- Just say \"analyze this dataset and give me insights\".",
        "- Ask for \"the best model\" with no context.",
        "- Copy-paste AI output into policy slides without checking.",
        "- Assume AI knows your organization's current methodology.",
        sep = "\n"
      ))
    )
  ),
  card(
    card_header("Human + AI: a collaboration, not a replacement"),
    layout_columns(
      col_widths = c(6, 6),
      markdown(paste(
        "**AI is strong at:**",
        "",
        "- speed and repetition;",
        "- pattern detection;",
        "- coding and visualization;",
        "- model diagnostics.",
        sep = "\n"
      )),
      markdown(paste(
        "**Humans are strong at:**",
        "",
        "- judgment and context;",
        "- interpretation and causality;",
        "- ethics and accountability;",
        "- communication with decision-makers.",
        sep = "\n"
      ))
    ),
    card_footer(
      "Together: better analysis, faster, and safer. AI needs humans to check",
      " rules, metadata, and definitions — see the \"When AI gets it wrong\" page."
    )
  )
)

# ---- Page 2: Prompt gallery ---------------------------------------------------

# Small helper for one gallery card: a category badge, a copyable prompt, and
# an optional footer tip.
gallery_card <- function(id, category, title, need, prompt, tip = NULL) {
  card(
    card_header(
      div(
        span(class = "badge bg-info quiz-topic-badge me-2", category),
        span(title)
      )
    ),
    markdown(paste0("**You need:** ", need)),
    copy_button(id),
    div(id = id, class = "prompt-block", prompt),
    if (!is.null(tip)) card_footer(tip)
  )
}

ui_ai_gallery <- div(
  card(
    card_header("Copy, paste, adapt 🧰"),
    markdown(paste(
      "Eight ready-made prompts for everyday WHO tasks, tested in live",
      "training demos. To use one:",
      "",
      "1. Open your AI assistant — for example **Claude (claude.ai)**.",
      "2. Copy a prompt below and replace everything in **[brackets]** with",
      "   your own files, names, and context.",
      "3. Iterate: \"shorter\", \"more formal\", \"as a table\", \"in",
      "   Tagalog\" — the first answer is a draft, not the deliverable.",
      "",
      "Most cards need you to **upload a file** together with the prompt.",
      sep = "\n"
    ))
  ),
  layout_columns(
    col_widths = c(6, 6),
    gallery_card(
      "pg_pdf",
      "Data extraction", "PDF → Excel tables",
      "a PDF report that contains tables (e.g. an indicator metadata annex).",
      paste(
        "Extract all tables from this PDF into a clean Excel file.",
        "Each row should be one record and each column one field.",
        "Keep all fields: names, definitions, numerators, denominators,",
        "data sources, and everything else.",
        "Tell me clearly if there is anything you could not extract.",
        sep = "\n"
      ),
      "From a locked PDF to live data — no manual retyping."
    ),
    gallery_card(
      "pg_docqa",
      "Knowledge", "Talk to your 200-page report",
      "a long guideline, strategy, or country cooperation document.",
      paste(
        "Give me a structured summary of this document: the main strategic",
        "priorities, and for each one list 2-3 key actions.",
        "",
        "Then I will ask follow-up questions, for example:",
        "- What does it say about [a topic]? Which sections mention it?",
        "- What is the specific commitment?",
        "- How does it align with the SDGs?",
        sep = "\n"
      ),
      "Not a keyword search — a real conversation with the document."
    ),
    gallery_card(
      "pg_photos",
      "Reporting", "Photos → structured report",
      "3-5 photos from a field visit, an office, or a facility.",
      paste(
        "I visited [a site]. Instead of a standard visit report, analyze",
        "these photos as evidence of how the site works in practice.",
        "For each photo, identify:",
        "- what value or priority it demonstrates;",
        "- how it connects to [your strategy or programme];",
        "- what message it sends to staff and visitors.",
        "Then produce a one-page structured report.",
        sep = "\n"
      ),
      "The same places you walk past every day — AI finds meaning in the details."
    ),
    gallery_card(
      "pg_slides",
      "Productivity", "Data → slide deck",
      "an Excel or CSV file with the data behind your briefing.",
      paste(
        "I have data on [topic, e.g. leading causes of death, by age group].",
        "Create a 6-slide presentation for a briefing:",
        "1. Title slide.",
        "2. Overview of the key numbers, with a chart.",
        "3. The main story in the data.",
        "4. A hidden or surprising finding.",
        "5. Implications for [your strategy or audience].",
        "6. Key messages for leadership.",
        "Keep the style professional and highlight surprising findings.",
        sep = "\n"
      ),
      "From raw Excel to a ready-to-present deck, without opening PowerPoint."
    ),
    gallery_card(
      "pg_audiences",
      "Communication", "One message, 7 audiences",
      "one core paragraph you need to communicate widely.",
      paste(
        "Adapt the message below for 7 different audiences. Preserve the",
        "core meaning, but rework tone, vocabulary, length, and structure",
        "for each. Don't translate - adapt.",
        "1. A formal speech (about 60 words, diplomatic register).",
        "2. A community health worker briefing in [local language]",
        "   (warm, conversational, simple words).",
        "3. A social media post (max 280 characters, one emoji).",
        "4. A press release quote (1-2 sentences, quotable).",
        "5. A children's version for a primary school health class",
        "   (use an analogy a child understands).",
        "6. A one-minute ministerial briefing (4-5 bullets).",
        "7. A campaign slogan (max 10 words, rhythmic, memorable).",
        "",
        "[Paste your message here]",
        sep = "\n"
      ),
      "Translation tools change words. A good prompt changes voice."
    ),
    gallery_card(
      "pg_dashboard",
      "Visualization", "Excel → interactive dashboard",
      "a raw data export (e.g. GHO or SDG indicator data).",
      paste(
        "Here is indicator data for [indicator(s)] across countries and",
        "years. Build an interactive dashboard focused on [country/region].",
        "Include:",
        "- summary metrics at the top;",
        "- a trend chart comparing [country] with the regional average and",
        "  key peers;",
        "- a ranking chart of all countries, with [country] highlighted;",
        "- a scatter plot of [indicator A] vs [indicator B].",
        "Keep the design clean and professional. Use one highlight colour",
        "so [country] stands out.",
        sep = "\n"
      ),
      "Raw export → dashboard in under a minute. No BI software needed."
    ),
    gallery_card(
      "pg_quiz",
      "Engagement", "Team quiz game",
      "nothing — it is generated live from one prompt.",
      paste(
        "Create an interactive quiz game with 10 questions about [topic].",
        "- Mix easy and medium difficulty.",
        "- Categories: [3-4 categories relevant to your team].",
        "- Add a score tracker and a timer.",
        "- Add a \"reveal answer\" button after each question.",
        "- Finish with a celebratory screen showing the final score.",
        sep = "\n"
      ),
      "From one prompt to a custom training tool — great as an ice-breaker."
    ),
    gallery_card(
      "pg_browser",
      "Automation", "Browser agent: fill a form",
      "an AI tool that can control a browser (e.g. Claude in Chrome).",
      paste(
        "Open this form: [link].",
        "Fill it in on my behalf with these details:",
        "[your details, one per line]",
        "Fill every field.",
        "IMPORTANT: Do NOT click submit. Stop at the review stage so I can",
        "check everything and submit it myself.",
        sep = "\n"
      ),
      "Agents can click and type for you — but the human stays on the submit button."
    )
  ),
  card(
    card_header("From the gallery to your real work"),
    markdown(paste(
      "These prompts are **light-to-middle structure**: perfect for drafts,",
      "exploration, and time-saving. When the output will feed a report, a",
      "policy message, or a decision, upgrade to **strong structure**: define",
      "the method, provide the metadata, and ask AI to state its assumptions.",
      "See **AI → Prompting levels** for how, and **AI → AI safety** for the",
      "rules that always apply.",
      sep = "\n"
    ))
  )
)

# ---- Page 3: When AI gets it wrong --------------------------------------------

ui_ai_case <- div(
  card(
    card_header("A true story about a WHO indicator"),
    markdown(paste(
      "**SDG 3.8.1** is the Universal Health Coverage (UHC) **service",
      "coverage index**: one 1–100 score built from **14 tracer indicators**",
      "in four domains (RMNCH, infectious diseases, NCDs, and service",
      "capacity and access).",
      "",
      "How the tracers are combined **changed**:",
      "",
      "- **Old method** — within each domain, a simple geometric mean of the",
      "  tracers; then a geometric mean of the four sub-indices.",
      "- **New method (2025 revision)** — within each domain, a **weighted**",
      "  geometric mean, where each tracer's weight reflects the population",
      "  it represents; then a geometric mean of the four sub-indices.",
      sep = "\n"
    ))
  ),
  card(
    card_header("What we asked AI"),
    copy_button("case_naive_prompt"),
    div(
      id = "case_naive_prompt", class = "prompt-block",
      "Please calculate the SDG 3.8.1 score for this country, and tell me the process."
    ),
    markdown(paste(
      "We uploaded the 14 tracer values for one country and asked the",
      "question above. AI answered instantly: clean R code, clear steps, a",
      "professional explanation.",
      "",
      "**It used the old method.** It did not warn us. It could not — the",
      "2025 revision was not part of what it had learned.",
      sep = "\n"
    ))
  ),
  card(
    card_header("Same data, two very different answers"),
    teach_table(tribble(
      ~Domain, ~`Old method`, ~`New method (2025)`,
      "RMNCH", "80.0", "77.1",
      "Infectious diseases", "58.4", "86.7",
      "NCD", "28.6", "41.9",
      "Service capacity and access", "71.0", "71.0",
      "Overall index", "55.5", "66.7"
    )),
    markdown(paste(
      "An **11-point gap** on a 100-point index — enough to change a",
      "country's ranking, its trend story, and the policy message built on",
      "top of it. (Illustrative example: one country's 2023 tracer values.)",
      "",
      "Both answers *look* equally professional. Only one is right.",
      sep = "\n"
    ))
  ),
  layout_columns(
    col_widths = c(6, 6),
    card(
      card_header("Why this happens"),
      markdown(paste(
        "- AI's knowledge has a **cutoff date** — recent methodology",
        "  revisions may not be in it.",
        "- **Institution-specific rules** (weights, revisions, footnotes)",
        "  are exactly what generic training data lacks.",
        "- AI cannot tell that it is using an outdated method — the code",
        "  runs, the numbers appear, everything looks done.",
        "- Polished output **hides** mistakes. Unless a human checks, the",
        "  error travels straight into slides and briefings.",
        sep = "\n"
      ))
    ),
    card(
      card_header("How to protect yourself"),
      markdown(paste(
        "- **Name the method** in the prompt — never let AI choose the",
        "  methodology for an official indicator.",
        "- **Provide the metadata**: definitions, weights, revision notes,",
        "  or the methodology document itself.",
        "- Ask AI to **state the method and assumptions it used** at every",
        "  step.",
        "- **Check against a known result** (one country, one year) before",
        "  trusting the rest.",
        sep = "\n"
      ))
    )
  ),
  card(
    card_header("The fix: a strong-structure prompt"),
    copy_button("case_strong_prompt"),
    div(
      id = "case_strong_prompt", class = "prompt-block",
      paste(
        "Please calculate the UHC sub-indices and the overall index using the",
        "2025 revised method:",
        "1. For each domain, calculate the WEIGHTED geometric mean of its",
        "   tracer values, using the weights provided in the file.",
        "2. Calculate the geometric mean of the four sub-indices to get the",
        "   overall index (no weights at this step).",
        "3. Report the method you used at each step, and show the",
        "   intermediate sub-index values so I can check them.",
        sep = "\n"
      )
    ),
    markdown(paste(
      "With the method spelled out and the weights supplied, AI reproduced",
      "the revised results exactly. **AI can calculate very fast. Only",
      "humans know which calculation is the right one.**",
      sep = "\n"
    ))
  ),
  card(
    card_header("Try it yourself 🐾"),
    markdown(paste(
      "The datasets download on the **Home** page includes",
      "`2025-09-18-sdg-two-methods.xlsx`: old-method and new-method UHC",
      "index values for the same countries.",
      "",
      "1. **In this app** — upload it on the Import page and use",
      "   **Visualize** to compare the two columns (scatterplot with a",
      "   diagonal reference in mind; or reshape and use a box plot).",
      "2. **With AI** — upload the same file and ask for a paired",
      "   comparison: How different are the two methods? Which countries",
      "   move the most? Is the difference statistically significant",
      "   (paired t-test)?",
      "3. **Interpret** — if a country's score rises 10 points because the",
      "   *method* changed, what must you say in the policy brief so the",
      "   trend is not misread as real progress?",
      sep = "\n"
    )),
    card_footer(
      "This is the whole lesson of this page in one exercise: the numbers",
      " changed, the health system did not."
    )
  )
)
