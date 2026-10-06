# cataScience <a href="https://shanlong-who.github.io/cataScience/"><img src="man/figures/logo.png" align="right" height="140" alt="cataScience hex logo featuring the maintainer's two cats" /></a>

<!-- badges: start -->
[![R-CMD-check](https://github.com/shanlong-who/cataScience/actions/workflows/R-CMD-check.yaml/badge.svg?branch=main)](https://github.com/shanlong-who/cataScience/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

**A Journey of Data Science** — an interactive training app for people who
are new to data: import → clean → visualize → understand, with AI as your
assistant and you as the judge.

Developed for WHO data trainings (Global Health Learning Center and
country-office sessions), but the content is general: anyone learning data
science or starting to use AI assistants at work can use it for self-study.

Documentation: <https://shanlong-who.github.io/cataScience/>

## Guides

| Guide | What you will learn |
|---|---|
| [Getting started](https://shanlong-who.github.io/cataScience/articles/cataScience.html) | Launch the app, follow the module map and use the example data |
| [Data-quality workflow](https://shanlong-who.github.io/cataScience/articles/data-quality-workflow.html) | Compare cleaning choices, inspect text and joins, and explain a chart |
| [Training guide](https://shanlong-who.github.io/cataScience/articles/training-guide.html) | Plan a three-hour data science session or a two-hour AI session |

The website contains documentation. Launch the Shiny app from R for the
interactive lessons and exercises.

## Installation

```r
install.packages("cataScience")
```

or

```r
# install.packages("remotes")
remotes::install_github("shanlong-who/cataScience")
```

## Usage

```r
library(cataScience)
run_cata()
```

The app opens in your browser. Everything runs locally — no internet
connection is needed after installation.

Start with **Import → Or use the example data**, then follow **Cleaning →
Missing data**, **Cleaning → Outliers**, **Visualize** and **Quiz**.
Use **Reset to original data** to compare cleaning choices.

Use RStudio's Stop button or Escape in the console to stop the app.
Live demonstrations with an external AI assistant need internet access.

## What is inside

| Module | Content |
|---|---|
| Import | Upload Excel/CSV files, or use the bundled example data |
| Cleaning | Missing data (MCAR/MAR/MNAR, imputation), outliers, text, merging |
| Visualize | 7 chart types with grouping, faceting, and flipping |
| Statistics | Describing data, normal distribution, t-test, regression |
| AI | Prompting levels, prompt gallery, AI-assisted analysis, "When AI gets it wrong" case study, AI safety |
| Quiz | 27 questions with per-session topic filters |
| Training | Instructor playbook, lab script, critique checklist |

## For trainers

The **Training → Training guide** page inside the app contains a full
playbook: a module menu with suggested timings, ready-made agendas (a 3-hour
data-science session, a 2-hour AI session, and a full day), and a pre-course
checklist for participants.

Participants who do not have R installed can use the portable Windows
edition instead — contact the maintainer.

## Development

The app source under `inst/app/` mirrors the internal training project;
edit content there and re-install to test with `run_cata()`.

## Contact

Shanlong Ding — dings@who.int
