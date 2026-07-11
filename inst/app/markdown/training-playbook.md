# Training playbook: build a session from this app

This app is the **single teaching surface** for data science and AI
trainings — no separate slide decks. Each navbar page is a self-contained
module. Pick the modules that fit your audience and your time, walk through
them live on the projector, and let participants follow on their own copy.

## The module menu

| Module | What it teaches | Typical time |
|---|---|---|
| Home | The data science workflow; everything is data | 10 min |
| Import | Loading files; first inspection of a dataset | 15–20 min |
| Cleaning → Missing data | MCAR / MAR / MNAR; comparing imputation choices | 20–30 min |
| Cleaning → Outliers | Detection; error vs rare vs important; winsorizing | 20–30 min |
| Cleaning → Text | Inconsistent encodings; standardization | 10–15 min |
| Cleaning → Merge | Join types, keys, and denominators | 15–20 min |
| Visualize | Chart choice; same data, different messages | 25–40 min |
| Statistics (4 pages) | Describing data, normal distribution, t-test, regression | 15–25 min per page |
| AI → Prompting levels | The light / middle / strong framework | 20–30 min |
| AI → Prompt gallery | Live demos: copy, paste, adapt | 30–45 min |
| AI → AI-assisted analysis | Human judgment around AI-written analysis | 25–40 min |
| AI → When AI gets it wrong | The SDG 3.8.1 methodology case study | 15–20 min |
| AI → AI safety | The four rules and daily habits | 10–15 min |
| Quiz | Knowledge check — filter the topics to match your session | 15–25 min |

## Ready-made agendas

### A. Data science and interpretation — 3 hours

| Time | Module | Format |
|---|---|---|
| 0:00 | Home: workflow framing | Talk-through |
| 0:15 | Import: upload `cat-dirty-data.xlsx`, inspect it | Hands-on |
| 0:40 | Missing data: compare two imputation choices | Hands-on + discussion |
| 1:05 | Outliers: wrong, rare, or important? | Hands-on + discussion |
| 1:30 | Break | |
| 1:40 | Visualize: one chart before and after cleaning | Hands-on |
| 2:10 | AI-assisted analysis + critique checklist | Talk-through + group work |
| 2:40 | Quiz (topics: Tidy data, Missing data, Outliers, Visualization) | Interactive |
| 2:55 | Wrap-up and take-home messages | Talk-through |

### B. Using AI in daily work — 2 hours

| Time | Module | Format |
|---|---|---|
| 0:00 | Home + why AI, why now | Talk-through |
| 0:10 | Prompting levels | Talk-through + try one prompt per level |
| 0:35 | Prompt gallery: 3–4 live demos, participants follow | Live demo + hands-on |
| 1:15 | When AI gets it wrong | Talk-through + discussion |
| 1:30 | AI safety | Talk-through |
| 1:40 | Quiz (topics: Prompting, AI & methods) + Q&A | Interactive |

### C. Full day — data science + AI

Run agenda A in the morning and agenda B in the afternoon. Use one or two
Statistics pages after lunch as a bridge, and end with the full Quiz (all
topics) as the closing activity. The **When AI gets it wrong** page works
best late in the day, after participants have seen both the data quality
labs and the AI demos.

## Delivery tips

- The **Quiz topic filter** is the module selector: tick only the topics
  your session covered.
- The **example data buttons** on the Import page load the cat datasets
  without any file juggling; the **Download datasets** button on the Home
  page gives participants all exercise files.
- Everything in this app runs **offline**. Only the live AI demos (Prompt
  gallery) need internet and an AI account — if the venue has no
  connectivity, demo from your own machine or skip to the worked examples
  on the Prompting levels page.
- Alternate formats every 20–30 minutes: talk-through → hands-on →
  discussion. The instructor prompts in the lab script (next section)
  carry the discussion parts.

## Pre-course checklist (send to participants)

1. Receive the portable app zip from the instructor.
2. **Extract the whole zip** before running anything — do not open the app
   from inside the zip file.
3. Extract to a **short local path** such as `C:\cata-science` — avoid
   OneDrive folders and deep directory trees.
4. Double-click the launcher and confirm the app opens in the browser.
5. **No R or RStudio installation is needed.**
6. For AI modules only: an account with an AI assistant (for example
   claude.ai) — or simply watch the instructor's live demos.
