# Data and small fixed examples for the Statistics pages, rebuilt from
# slides/slides-cats-teach-stats.Rmd. Loaded once at app startup.

# Real WHO example datasets shipped with the app ------------------------------

stats_df_uhc_pop <- as_tibble(rio::import("data/2025-09-18-sdg381-pop-2021.xlsx"))
stats_df_two_methods <- as_tibble(rio::import("data/2025-09-18-sdg-two-methods.xlsx"))
stats_df_uhc_gdp <- as_tibble(rio::import("data/2025-09-18-uhc-gdp.xlsx"))

# Teaching examples ------------------------------------------------------------

# Office cats: base weights used by the mean-vs-median demo and variance table.
stats_cat_weights <- c(4.2, 4.4, 4.5, 4.6, 4.9, 4.5, 4.6, 4.4, 4.4)
stats_cat_names <- c(
  "Oreo", "Zorro", "Simba", "Nala", "Moli", "Linda", "Socks", "Alon", "Go-Go"
)

# Mode example: counts of a small vector.
stats_mode_table <- tibble(figure = c(2, 2, 3, 4, 4, 4, 5, 5)) %>%
  count(figure, sort = TRUE, name = "count")

# Weighted mean story: vaccination coverage across three litters.
stats_weight_table <- tibble(
  name = c("Luna", "Nala", "Kiji"),
  kittens = c(4, 5, 10),
  `coverage (%)` = c(50, 60, 90),
  `vaccinated kittens` = c(2, 3, 9)
)

# Variance walk-through table for the nine office cats.
stats_var_table <- tibble(
  name = stats_cat_names,
  value = stats_cat_weights
) %>%
  mutate(
    deviation = round(value - mean(value), 1),
    square = round(deviation^2, 4)
  )

stats_var_summary <- stats_var_table %>%
  summarize(across(c(value, deviation, square), ~ round(mean(.x), 4))) %>%
  mutate(name = "MEAN") %>%
  relocate(name)

# Five-country worked example for the three kinds of mean.
stats_uhc5 <- tibble(
  Country = c("A", "B", "C", "D", "E"),
  `UHC Index` = c(80, 80, 60, 50, 90),
  `Population (M)` = c(120, 10, 30, 20, 20)
)
