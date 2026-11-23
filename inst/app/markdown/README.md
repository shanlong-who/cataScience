# Lesson content

The Shiny app reads its content pages directly from the `.md` files in this
folder through `includeMarkdown()` (see `md_page()` in `R/app-function.R`).

- `background-*.md` — the Background / methodology tabs on the Import,
  Cleaning, and Visualize pages.
- `ai-safety.md` — the AI → AI safety page.
- `ai-analysis-critique-checklist.md` — the checklist in AI-assisted analysis.
- `image-credits.md` — sources for the app assets.
- `images/` — figures referenced by the `.md` pages, served via
  `addResourcePath()` in `R/app-load.R`.

Edit the `.md` files directly to update lesson content.
