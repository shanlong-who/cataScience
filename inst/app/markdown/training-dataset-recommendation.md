# Training Dataset Recommendation

Use one primary dataset for the dashboard lab and keep the SDG datasets as
short extension exercises. This keeps the hands-on section focused and avoids
spending too much time on file selection.

## Primary dashboard lab dataset

Use `data/cat-dirty-data.xlsx` for the main 20-30 minute lab.

Why this file works well:

- It is small enough for participants to inspect manually.
- It has a mix of text, numeric, logical, and identifier variables.
- It includes missing values.
- It has numeric variables suitable for outlier detection.
- It is low-stakes and friendly, which helps participants focus on the method
  rather than debating the epidemiology too early.

Recommended tasks:

1. Upload `cat-dirty-data.xlsx` as file 1.
2. Inspect variable names, data types, and missing values.
3. In **Missing data**, compare row removal with median imputation.
4. In **Outliers**, compare removing outliers with winsorizing.
5. In **Text**, standardize one categorical variable if needed.
6. In **Data visualization**, create one chart before and after cleaning.

Expected discussion points:

- Missing values should not be filled automatically without context.
- Median imputation is more robust than mean imputation when outliers are
  present.
- Outlier detection should trigger investigation, not automatic deletion.
- A chart can change after cleaning, so cleaning decisions belong in the
  analytical record.

## Optional merge exercise

Use `data/cat-dirty-data.xlsx` as file 1 and `data/cat-dirty-data2.xlsx` as
file 2.

Recommended tasks:

1. Merge by `id`.
2. Compare row counts before and after merging.
3. Check whether any records are unmatched or duplicated.
4. Ask participants what would happen if the key variable were misspelled,
   duplicated, or not unique.

## SDG extension datasets

Use these only after the main dashboard lab, or when moving from data quality
to interpretation and AI-assisted analysis.

| Dataset | Best use | Suggested question |
|---|---|---|
| `data/2025-09-18-sdg381-pop-2021.xlsx` | Weighted and unweighted descriptive statistics | How does population weighting change the summary of SDG 3.8.1? |
| `data/2025-09-18-uhc-gdp.xlsx` | Correlation and regression caution | Do richer countries appear to have higher UHC, and what should we not claim? |
| `data/2025-09-18-sdg-two-methods.xlsx` | Paired comparison / method revision | Are values from the old and new method meaningfully different? |
| `data/SDG-381-WPRO-filtered.xlsx` | Fixed-data dashboard or Quarto example | How has SDG 3.8.1 changed over time across WPRO? |

## Recommended training choice

For a short course, use this sequence:

1. `cat-dirty-data.xlsx` for the dashboard lab.
2. `cat-dirty-data2.xlsx` only if there is time for merging.
3. One SDG dataset for AI-assisted R coding and interpretation.

This gives participants both experiences: a controlled data quality lab and a
realistic health-indicator analysis task.

