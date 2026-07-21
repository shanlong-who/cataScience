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
