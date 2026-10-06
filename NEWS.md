# cataScience 2.1.4

* Added three vignettes covering installation and launch, a reproducible
  data-quality workflow, and guidance for running a training session.
* Added a pkgdown documentation website, linked from the package metadata
  and README, with a function reference and searchable articles.
* Added a package hex logo based on the maintainer's two cats, displayed in
  the README, website and vignettes.

# cataScience 2.1.3

* The markdown lesson pages are now rendered from text instead of from the
  file path. `markdown::mark()` (>= 2.0) rewrites an input *file* in place
  when it runs under `R CMD check`, which made the test suite fail on CRAN's
  Debian machines where the installed package library is mounted read-only
  (and violated the CRAN policy against writing outside the session temp
  directory). Rendering from text writes nothing; the generated HTML is
  unchanged.

# cataScience 2.1.2

* Added a `testthat` test suite covering the app code that `R CMD check`
  cannot reach through the examples: the data-cleaning helpers (outlier
  detection, winsorizing, imputation, file import), the quiz and cleaning
  module servers via `shiny::testServer()`, the question bank, and a smoke
  test that builds the whole app UI.
* The example of `run_cata()` now also runs outside an interactive session.
* The outlier boxplot no longer warns about missing values while a dataset
  still has them.

# cataScience 2.1.1

* Images inside the markdown lesson pages now scale to the card width
  instead of being clipped (affected the Background tabs of the Visualize,
  Cleaning, and Import pages).
* The app stylesheet link carries a cache-busting version query so browsers
  pick up styling changes after an update.
* Resized one oversized bundled figure (9000 px wide) to 1800 px.

# cataScience 2.1.0

* First release: `run_cata()` launches the bundled "A Journey of Data
  Science" training app.
