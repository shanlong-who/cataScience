This is a documentation update from cataScience 2.1.3 to 2.1.4.

The update adds three executable vignettes, a pkgdown documentation website linked from DESCRIPTION and README, and a package hex logo based on the maintainer's two cats. The exported API and bundled Shiny application code are unchanged. The maintainer and MIT + file LICENSE license are unchanged.

R CMD check --as-cran was run on the exact source tarball with:
- R 4.6.1 on Ubuntu 24.04.5: 0 errors, 0 warnings, 0 notes.
- R-devel (2026-10-03 r90638) on Ubuntu 24.04.5: 0 errors, 0 warnings, 0 notes.

Both checks include CRAN incoming checks, tests, examples, rebuilding all three vignettes, and the PDF and HTML reference manuals. Additional Windows, macOS and old-release checks are provided by the repository's R-CMD-check workflow.

The vignette examples use bundled data and do not require network access or start an interactive Shiny session. The installed vignette documentation is approximately 2.0 MB. A single shared logo resource in inst/doc/assets avoids embedding the same image in three HTML documents.

There are no reverse dependencies listed on the current CRAN package page.
