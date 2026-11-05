This updates cataScience from 2.1.4 to 2.2.0.

The update adds an extended workshop launcher, run_catas(), and reusable
functions for data-quality review, joins, proportions, charts and report
exports. The original run_cata() entry point is retained. New teaching
examples cover public health, multiple imputation and a connected analysis
workflow. Workshop datasets are explicitly documented as synthetic.

The rio dependency was removed. VIM is now optional for kNN imputation,
and DSIR remains optional for its plot theme. The maintainer, email address
and MIT + file LICENSE licence are unchanged.

On 5 November 2026, R CMD check --as-cran was run on the exact source
tarball to be submitted:
- R 4.6.2, Ubuntu 26.04.1: 0 errors, 0 warnings, 0 notes.
- R-devel, Ubuntu 26.04.1: 0 errors, 0 warnings, 0 notes.

Both checks include CRAN incoming checks, tests, examples (including
--run-donttest), rebuilding all three vignettes, and PDF and HTML reference
manuals. The same source commit also passes the repository's Windows,
macOS, Linux release, R-devel and old-release checks.

Source commit: fb06eb99c30c786427929edf52d46183340f1d7c.
Source archive: 6,570,896 bytes. Small app and vignette icons use resized
copies; full-resolution artwork remains in the source repository.

The examples and vignettes use bundled data without network access or
starting an interactive Shiny session. No reverse dependencies, including
reverse Suggests, were found in the current CRAN package index on
5 November 2026. The current CRAN checks for version 2.1.4 are all OK.
