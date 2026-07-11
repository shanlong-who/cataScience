# cataScience 🐱

**A Journey of Data Science** — an interactive training app for people who
are new to data: import → clean → visualize → understand, with AI as your
assistant and you as the judge.

Developed for WHO data trainings (Global Health Learning Center and
country-office sessions), but the content is general: anyone learning data
science or starting to use AI assistants at work can use it for self-study.

## Installation

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
