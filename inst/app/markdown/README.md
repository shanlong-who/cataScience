# Lesson content

The Shiny app reads its content pages directly from the `.md` files in this
folder through `includeMarkdown()` (see `md_page()` in `R/app-function.R`).

- `background-*.md` — the Background / methodology tabs on the Import,
  Cleaning, and Visualize pages.
- `ai-safety.md` — the AI → AI safety page.
- `training-playbook.md`, `lab-script-data-quality.md`,
  `ai-analysis-critique-checklist.md`, `training-dataset-recommendation.md`
  — the Training → Training guide panels.
- `image-credits.md` — the Training → Credits page.
- `images/` — figures referenced by the `.md` pages, served via
  `addResourcePath()` in `R/app-load.R`.

Edit the `.md` files directly to update lesson content.
