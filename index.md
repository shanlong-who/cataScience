# cataScience

**A Journey of Data Science** — an interactive training app for people
who are new to data: import → clean → visualize → understand, with AI as
your assistant and you as the judge.

Developed for WHO data trainings (Global Health Learning Center and
country-office sessions), but the content is general: anyone learning
data science or starting to use AI assistants at work can use it for
self-study.

Documentation: <https://shanlong-who.github.io/cataScience/>

Try it online: **[Workshop app](https://shanlong-who.github.io/cata/)**
· [Classic app](https://shanlong-who.github.io/cata/classic/)

The online apps run R in your browser with Shinylive. No R installation
is needed; allow time for the runtime and packages to download on the
first visit. kNN imputation requires the local R app and the optional
VIM package.

## Guides

| Guide | What you will learn |
|----|----|
| [Getting started](https://shanlong-who.github.io/cataScience/articles/cataScience.html) | Launch the app, follow the module map and use the example data |
| [Data-quality workflow](https://shanlong-who.github.io/cataScience/articles/data-quality-workflow.html) | Compare cleaning choices, inspect text and joins, and explain a chart |
| [Training guide](https://shanlong-who.github.io/cataScience/articles/training-guide.html) | Plan a three-hour data science session or a two-hour AI session |

Use the online apps above for interactive lessons, or launch either
edition from R using the commands below.

## Installation

``` r

install.packages("cataScience")
```

or

``` r

# install.packages("remotes")
remotes::install_github("shanlong-who/cataScience")
```

## Usage

``` r

library(cataScience)
run_cata()
```

Version 2.2 adds an extended workshop app while keeping the original
entry point above:

``` r

run_catas()
```

Both online apps and the GitHub package support English and Simplified
Chinese. Select **中文** or **English** in the navigation bar to switch
during a lesson. To open directly in Chinese, use
`run_cata(language = "zh")` or `run_catas(language = "zh")`. The default
uses a saved browser preference, then the browser language. The language
catalogue works offline.

The extended app starts with **Why data matters** and adds one connected
**Workflow**: understand the data, review problems, join and summarise,
visualise, then communicate. Actions preserve an input snapshot and a
preparation log, with undo and reset. Dataset A (a fictional care
cascade) and B/C (synthetic ART records and facilities) support the Lao
workshop. They are training examples, not country estimates; A is
independent of B/C.

New lessons include John Snow’s map, explicit numerators and
denominators, multiple imputation with synthetic cats, and the
workshop’s chi-square and logistic-regression examples. AI chart
comparisons remain a separate classroom exercise using the same exported
synthetic data.

**Workflow \> Visualise** offers 11 chart types: bar, sorted dot,
histogram, density, line, scatter, boxplot, heatmap, dumbbell, forest
and cascade. Plots include editable titles, units, grouping, facets,
missing-row counts, and PNG/PDF exports with explicit dimensions.

**Workflow \> Communicate** creates a self-contained HTML report or
dashboard that opens offline. Supply the question, finding, denominator
and limitations; the app does not invent conclusions. The project ZIP
includes input and selected data, reviewed preparation code, chart
settings, HTML, Quarto sources, an RStudio project and a local Shiny
dashboard. Open the project in RStudio and run `source("analysis.R")` to
reproduce it. Quarto is needed only to render the editable `.qmd` files.
The ZIP contains the input data as well as selected records; review it
before sharing.

## Reusable functions

The package can also be used without launching Shiny:

``` r

library(cataScience)

patients <- cata_example("art")
facilities <- cata_example("facilities")
cata_profile(patients)
cata_missing(patients)
cata_check_keys(patients, "patient_id")

joined <- cata_join(patients, facilities, by = "facility_id")
joined$audit

lesson <- cata_lao_analysis()
lesson$flow
summary <- lesson$summary
figure <- cata_plot(summary, "dot", "group", "percent",
  percent = TRUE, sort = TRUE,
  title = "Reported viral-load testing by facility type",
  ylab = "Tested among records with known status (%)")
figure

# Choose a new output file; existing files are protected.
cata_report(lesson$selected, "training-report.html", plot = figure,
  tables = list("Reported testing" = summary),
  source = "Synthetic Lao workshop B/C example",
  unit = "Selected annual ART record",
  denominator = "Records with known reported VL testing status in each group",
  limitations = "Synthetic data; unresolved source and selection issues remain.")
```

Other helpers include
[`cata_read()`](https://shanlong-who.github.io/cataScience/reference/cata_read.md),
[`cata_flag_outliers()`](https://shanlong-who.github.io/cataScience/reference/cata_flag_outliers.md),
[`cata_proportion()`](https://shanlong-who.github.io/cataScience/reference/cata_proportion.md),
[`cata_count_status()`](https://shanlong-who.github.io/cataScience/reference/cata_count_status.md),
[`cata_mice_demo()`](https://shanlong-who.github.io/cataScience/reference/cata_mice_demo.md),
[`theme_cata()`](https://shanlong-who.github.io/cataScience/reference/theme_cata.md)
and
[`cata_export()`](https://shanlong-who.github.io/cataScience/reference/cata_export.md).
Use `?function_name` for arguments and worked examples. Flagging a value
does not delete or replace it.

## Dependencies

- **mice** remains required: the complete-data cat Easter egg is
  preserved, and the extended lesson demonstrates predictive mean
  matching, completed datasets, chain diagnostics and pooled model
  estimates.
- **VIM** is optional and used only for its existing kNN imputation.
  Install it with `install.packages("VIM")` to enable that choice.
  Missingness patterns use
  [`mice::md.pattern()`](https://amices.org/mice/reference/md.pattern.html).
- **rio** is removed. Excel uses readxl; CSV uses readr.
- **naniar** and **skimr** remain required for missingness
  demonstrations and compact data summaries in the original app.
- **DSIR** is optional. Install it to choose `style = "dsi"` or the DSIR
  theme in the chart builder. The app also has a built-in theme.

The app opens in your browser. Everything runs locally — no internet
connection is needed after installation.

Start with **Import → Or use the example data**, then follow **Cleaning
→ Missing data**, **Cleaning → Outliers**, **Visualize** and **Quiz**.
Use **Reset to original data** to compare cleaning choices.

Use RStudio’s Stop button or Escape in the console to stop the app. Live
demonstrations with an external AI assistant need internet access.

## What is inside

| Module | Content |
|----|----|
| Import | Upload Excel/CSV files, or use the bundled example data |
| Cleaning | Missing data (MCAR/MAR/MNAR, imputation), outliers, text, merging |
| Visualize | 7 chart types with grouping, faceting, and flipping |
| Statistics | Describing data, normal distribution, t-test, regression |
| AI | Prompting levels, prompt gallery, AI-assisted analysis, “When AI gets it wrong” case study, AI safety |
| Quiz | 27 questions with per-session topic filters |
| Training | Instructor playbook, lab script, critique checklist |

## For trainers

The **Training → Training guide** page inside the app contains a full
playbook: a module menu with suggested timings, ready-made agendas (a
3-hour data-science session, a 2-hour AI session, and a full day), and a
pre-course checklist for participants.

Participants who do not have R installed can use the portable Windows
edition instead — contact the maintainer.

## Development

Reusable functions live under `R/`; Shiny modules and teaching materials
live under `inst/app/`. From this source checkout, use
[`pkgload::load_all()`](https://pkgload.r-lib.org/reference/load_all.html)
and then
[`run_catas()`](https://shanlong-who.github.io/cataScience/reference/run_catas.md)
to try changes. Run `devtools::test()` and `devtools::check()` before a
release. The existing installed package is unchanged until you install
the new version.

## Contact

Shanlong Ding — <dings@who.int>
