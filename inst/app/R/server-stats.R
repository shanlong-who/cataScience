# Server logic for the Statistics pages (sourced inside server()).
# Uses the fixed teaching data prepared in R/data-stats.R.

# ---- Describing data ----------------------------------------------------------

st_weights <- reactive({
  c(stats_cat_weights, input$st_newcomer)
})

output$st_p_mean_median <- renderPlotly({
  weights <- st_weights()
  df_plot <- tibble(
    cat = c(stats_cat_names, "Newcomer"),
    weight = weights,
    who = c(rep("Office cat", length(stats_cat_weights)), "Newcomer")
  )
  m <- mean(weights)
  md <- median(weights)
  p <- ggplot(df_plot, aes(weight, 0, color = who, text = cat)) +
    geom_jitter(size = 3, height = .12, width = 0, alpha = .85) +
    geom_vline(xintercept = m, color = "#D55E00", linetype = "dashed", linewidth = 1) +
    geom_vline(xintercept = md, color = "black", linewidth = 1) +
    scale_color_manual(values = c("Office cat" = "#0072B2", "Newcomer" = "#E69F00")) +
    scale_y_continuous(limits = c(-.5, .5), breaks = NULL) +
    labs(
      x = "Weight (kg)", y = "", color = "",
      title = "Dashed line = mean, solid line = median"
    )
  cata_plotly(p, tooltip = c("text", "x"))
})

output$st_mean_median_text <- renderUI({
  weights <- st_weights()
  tagList(
    p(
      strong("Mean: "), sprintf("%.2f kg", mean(weights)), br(),
      strong("Median: "), sprintf("%.2f kg", median(weights))
    )
  )
})

output$st_means_answer <- renderUI({
  req(input$st_show_means > 0)
  x <- stats_uhc5$`UHC Index`
  w <- stats_uhc5$`Population (M)`
  arith <- mean(x)
  geo <- exp(mean(log(x)))
  weighted <- sum(x * w) / sum(w)
  div(
    class = "mt-3",
    tags$ul(
      tags$li(sprintf("Arithmetic mean = (80 + 80 + 60 + 50 + 90) / 5 = %.1f", arith)),
      tags$li(sprintf("Geometric mean = (80 × 80 × 60 × 50 × 90)^(1/5) = %.1f", geo)),
      tags$li(sprintf(
        "Weighted mean = Σ(value × population) / Σ(population) = %.1f", weighted
      ))
    ),
    markdown(paste(
      "- The arithmetic mean is always ≥ the geometric mean; the more the",
      "values vary, the bigger the gap.",
      "- For the weighted mean, the country with the biggest population",
      "(A, UHC = 80) pulls the average towards itself.",
      sep = "\n"
    ))
  )
})

output$st_p_skew <- renderPlot({
  set.seed(1234)
  df_skew <- tibble(
    id = 1:1050,
    `left-skewed` = c(rep(1, 50), rnorm(1000, 80, 20)),
    `right-skewed` = c(rep(150, 50), rnorm(1000, 80, 20))
  ) %>%
    pivot_longer(-id, names_to = "group", values_to = "value")

  ggplot(df_skew, aes(value)) +
    geom_histogram(color = "white", fill = "steelblue", bins = 15) +
    facet_wrap(~group)
})

# ---- Normal distribution -------------------------------------------------------

output$st_p_rule <- renderPlot({
  k <- as.numeric(input$st_sd_k)
  df_normal <- tibble(x = seq(-4, 4, .01), y = dnorm(x))
  ggplot(df_normal, aes(x, y)) +
    geom_area(
      data = filter(df_normal, x >= -k, x <= k),
      fill = "#0072B2", alpha = .35
    ) +
    geom_line(linewidth = 1.1) +
    labs(x = "Standard deviations from the mean", y = "Density")
})

output$st_rule_text <- renderUI({
  k <- as.numeric(input$st_sd_k)
  share <- (pnorm(k) - pnorm(-k)) * 100
  p(
    class = "lead text-center",
    sprintf("About %.1f%% of values fall within %d SD of the mean.", share, k)
  )
})

output$st_p_uhc_density <- renderPlot({
  x <- stats_df_uhc_pop %>%
    pull(sdg381) %>%
    as.numeric() %>%
    na.omit()
  m <- mean(x)
  md <- median(x)
  q <- quantile(x, c(.25, .75), names = FALSE)

  d <- density(x, from = 0, to = 100)
  dens <- tibble(x = d$x, y = d$y)
  dens_iqr <- dens %>% filter(x >= q[1], x <= q[2])

  ggplot(dens, aes(x, y)) +
    geom_area(fill = "steelblue", alpha = .25, color = "steelblue", linewidth = .8) +
    geom_area(data = dens_iqr, fill = "steelblue", alpha = .45) +
    geom_rug(
      data = tibble(x = x), aes(x = x, y = 0), sides = "b",
      inherit.aes = FALSE, alpha = .25
    ) +
    geom_vline(xintercept = md, color = "black", linewidth = .9) +
    geom_vline(xintercept = m, color = "red", linetype = "dashed", linewidth = .9) +
    annotate(
      "label",
      x = md, y = max(dens$y) * .95,
      label = paste0("Median = ", round(md, 1)),
      fill = "white", color = "black", hjust = 1.05
    ) +
    annotate(
      "label",
      x = m, y = max(dens$y) * .85,
      label = paste0("Mean = ", round(m, 1)),
      fill = "white", color = "red", hjust = -0.05
    ) +
    scale_x_continuous(limits = c(0, 100), breaks = seq(0, 100, 10)) +
    scale_y_continuous(expand = expansion(mult = c(0, .05))) +
    labs(
      subtitle = paste0(
        "n = ", length(x), "  |  IQR shaded (",
        round(q[1], 1), "–", round(q[2], 1), ")"
      ),
      x = "UHC Index (0–100)", y = "Density"
    )
})

output$st_p_clt <- renderPlot({
  n <- input$st_clt_n
  x <- stats_df_uhc_pop %>%
    pull(sdg381) %>%
    as.numeric() %>%
    na.omit()
  set.seed(1234)
  sample_means <- replicate(2000, mean(sample(x, n, replace = TRUE)))

  ggplot(tibble(mean = sample_means), aes(mean)) +
    geom_histogram(color = "white", fill = "#0072B2", bins = 30) +
    geom_vline(xintercept = mean(x), color = "#D55E00", linetype = "dashed", linewidth = 1) +
    scale_x_continuous(limits = c(30, 100)) +
    labs(
      x = "Mean of one sample", y = "Count",
      subtitle = sprintf("Sampling distribution of the mean (n = %d per sample)", n)
    )
})

# ---- t-test ---------------------------------------------------------------------

st_ttest_data <- reactive({
  n <- input$st_t_n
  diff <- input$st_t_diff
  # Deterministic per input combination, so the demo is reproducible.
  set.seed(42 + n * 100 + diff * 10)
  tibble(
    group = rep(c("Petted", "Not petted"), each = n),
    minutes = c(rnorm(n, 20 + diff, 8), rnorm(n, 20, 8))
  ) %>%
    mutate(minutes = pmax(round(minutes, 1), 0))
})

st_ttest_result <- reactive({
  broom::tidy(t.test(minutes ~ group, data = st_ttest_data()))
})

output$st_p_ttest <- renderPlotly({
  p <- ggplot(st_ttest_data(), aes(group, minutes, fill = group)) +
    geom_boxplot(alpha = .6, outlier.shape = NA) +
    geom_jitter(width = .15, alpha = .5, size = 1.5) +
    palette_cat() +
    labs(x = "", y = "Purring minutes per day") +
    theme(legend.position = "none")
  cata_plotly(p)
})

output$st_t_table <- renderUI({
  res <- st_ttest_result()
  teach_table(tibble(
    Quantity = c(
      "Mean (not petted)", "Mean (petted)", "Difference",
      "95% CI", "p-value"
    ),
    Value = c(
      sprintf("%.1f", res$estimate1),
      sprintf("%.1f", res$estimate2),
      sprintf("%.1f", res$estimate1 - res$estimate2),
      sprintf("%.1f to %.1f", res$conf.low, res$conf.high),
      format.pval(res$p.value, digits = 2, eps = .001)
    )
  ))
})

output$st_t_text <- renderUI({
  res <- st_ttest_result()
  significant <- res$p.value < 0.05
  div(
    class = if (significant) "alert alert-success py-2" else "alert alert-warning py-2",
    if (significant) {
      "p < 0.05: a difference this large would rarely happen by chance alone."
    } else {
      "p ≥ 0.05: this difference could easily arise by chance — we cannot
       conclude the groups differ."
    }
  )
})

st_methods_result <- reactive({
  broom::tidy(t.test(stats_df_two_methods$new, stats_df_two_methods$old, paired = TRUE))
})

output$st_p_methods <- renderPlotly({
  p <- ggplot(stats_df_two_methods, aes(old, new, text = paste0("id: ", id))) +
    geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "gray50") +
    geom_point(color = "#0072B2", size = 2.5, alpha = .8) +
    coord_equal() +
    labs(
      x = "UHC index — old method", y = "UHC index — new method",
      title = "Points above the dashed line: new method estimates higher"
    )
  cata_plotly(p, tooltip = c("text", "x", "y"))
})

output$st_methods_table <- renderUI({
  res <- st_methods_result()
  teach_table(tibble(
    Quantity = c("Mean difference (new − old)", "95% CI", "p-value"),
    Value = c(
      sprintf("%.1f", res$estimate),
      sprintf("%.1f to %.1f", res$conf.low, res$conf.high),
      format.pval(res$p.value, digits = 2, eps = .001)
    )
  ))
})

output$st_methods_text <- renderUI({
  res <- st_methods_result()
  significant <- res$p.value < 0.05
  div(
    class = if (significant) "alert alert-info py-2" else "alert alert-warning py-2",
    if (significant) {
      "The two methods give systematically different values — switching
       methods changes the indicator, so a time series must not mix them."
    } else {
      "No systematic difference between methods is detectable in these data."
    }
  )
})

# ---- Regression ------------------------------------------------------------------

st_cat_reg_data <- reactive({
  set.seed(2024)
  tibble(
    length_cm = runif(40, 35, 75)
  ) %>%
    mutate(weight_kg = round(0.12 * length_cm - 1.5 + rnorm(40, 0, 0.9), 1))
})

output$st_p_cat_reg <- renderPlotly({
  df_cat <- st_cat_reg_data()
  fit <- lm(weight_kg ~ length_cm, data = df_cat)
  r2 <- summary(fit)$r.squared
  p <- ggplot(df_cat, aes(length_cm, weight_kg)) +
    geom_point(color = "#0072B2", size = 2, alpha = .8) +
    geom_smooth(method = "lm", se = FALSE, color = "#D55E00") +
    labs(
      x = "Cat length (cm)", y = "Cat weight (kg)",
      title = sprintf(
        "weight = %.2f + %.3f × length   (R² = %.2f)",
        coef(fit)[1], coef(fit)[2], r2
      )
    )
  cata_plotly(p)
})

st_gdp_fit <- reactive({
  df_fit <- stats_df_uhc_gdp %>%
    mutate(log_gdp = log10(gdp_per_capita))
  lm(sdg381 ~ log_gdp, data = df_fit)
})

output$st_p_uhc_gdp <- renderPlotly({
  p <- ggplot(stats_df_uhc_gdp, aes(gdp_per_capita, sdg381, text = paste0("id: ", id))) +
    geom_point(color = "#0072B2", size = 2.5, alpha = .8) +
    geom_smooth(
      aes(group = 1),
      method = "lm", se = FALSE, color = "#D55E00"
    ) +
    scale_x_log10(labels = scales::label_comma()) +
    labs(
      x = "GDP per capita (US$, log scale)",
      y = "UHC service coverage index (SDG 3.8.1)"
    )
  cata_plotly(p, tooltip = c("text", "x", "y"))
})

output$st_gdp_table <- renderUI({
  res <- broom::tidy(st_gdp_fit())
  teach_table(
    res %>%
      transmute(
        Term = c("Intercept", "Slope (per 10× GDP)"),
        Estimate = sprintf("%.1f", estimate),
        `p-value` = format.pval(p.value, digits = 2, eps = .001)
      )
  )
})

output$st_gdp_text <- renderUI({
  r2 <- summary(st_gdp_fit())$r.squared
  markdown(sprintf(
    paste(
      "R² = **%.2f**: about %.0f%% of the variation in UHC index is",
      "explained by (log) GDP per capita. A strong **association** — but not",
      "proof that GDP growth *causes* better coverage."
    ),
    r2, r2 * 100
  ))
})
