# Changelog

## cataScience 2.2.0

CRAN release: 2026-11-05

- Added a shared two-cat navbar icon and favicon based on the
  maintainer’s cats, with a larger circular mark for both app launchers.
  The website uses the same cat favicon and retains its original hex
  logo.
- Added
  [`run_catas()`](https://shanlong-who.github.io/cataScience/reference/run_catas.md)
  for an extended workshop;
  [`run_cata()`](https://shanlong-who.github.io/cataScience/reference/run_cata.md)
  remains the original entry point. The workflow connects review,
  audited joins, explicit denominators, charts and communication, with
  input snapshots and undo.
- Added reusable import, profile, missingness, key-check, outlier-flag,
  join, proportion and status-summary functions, plus documented
  examples.
- Added
  [`cata_plot()`](https://shanlong-who.github.io/cataScience/reference/cata_plot.md)
  with 11 chart types and
  [`theme_cata()`](https://shanlong-who.github.io/cataScience/reference/theme_cata.md),
  and offline HTML report/dashboard exports. Project exports include
  reproducible R, Quarto and Shiny sources, input snapshots and
  preparation records.
- Added Why data matters, John Snow’s map, a care-cascade lesson and the
  synthetic Lao workshop B/C analysis. Kept AI chart comparison as an
  external classroom exercise.
- Kept the mice cat Easter egg and added multiple imputation, diagnostic
  chains and pooled model estimates using synthetic cats.
- Removed rio. Made VIM optional for kNN; replaced its missingness chart
  with mice. Kept naniar/skimr and the optional DSIR theme.
- Fixed classic outlier removal so source columns beginning with
  `shadow_` are preserved. Added explicit UTF-8 loading for nested app
  scripts.
- Revised quiz explanations to distinguish review flags from errors and
  missingness assumptions from conclusions established by observed data.

## cataScience 2.1.4

CRAN release: 2026-10-06

- Added three vignettes covering installation and launch, a reproducible
  data-quality workflow, and guidance for running a training session.
- Added a pkgdown documentation website, linked from the package
  metadata and README, with a function reference and searchable
  articles.
- Added a package hex logo based on the maintainer’s two cats, displayed
  in the README, website and vignettes.

## cataScience 2.1.3

CRAN release: 2026-08-28

- The markdown lesson pages are now rendered from text instead of from
  the file path.
  [`markdown::mark()`](https://rdrr.io/pkg/markdown/man/mark.html) (\>=
  2.0) rewrites an input *file* in place when it runs under
  `R CMD check`, which made the test suite fail on CRAN’s Debian
  machines where the installed package library is mounted read-only (and
  violated the CRAN policy against writing outside the session temp
  directory). Rendering from text writes nothing; the generated HTML is
  unchanged.

## cataScience 2.1.2

CRAN release: 2026-07-30

- Added a `testthat` test suite covering the app code that `R CMD check`
  cannot reach through the examples: the data-cleaning helpers (outlier
  detection, winsorizing, imputation, file import), the quiz and
  cleaning module servers via
  [`shiny::testServer()`](https://rdrr.io/pkg/shiny/man/testServer.html),
  the question bank, and a smoke test that builds the whole app UI.
- The example of
  [`run_cata()`](https://shanlong-who.github.io/cataScience/reference/run_cata.md)
  now also runs outside an interactive session.
- The outlier boxplot no longer warns about missing values while a
  dataset still has them.

## cataScience 2.1.1

- Images inside the markdown lesson pages now scale to the card width
  instead of being clipped (affected the Background tabs of the
  Visualize, Cleaning, and Import pages).
- The app stylesheet link carries a cache-busting version query so
  browsers pick up styling changes after an update.
- Resized one oversized bundled figure (9000 px wide) to 1800 px.

## cataScience 2.1.0

- First release:
  [`run_cata()`](https://shanlong-who.github.io/cataScience/reference/run_cata.md)
  launches the bundled “A Journey of Data Science” training app.
