# Launch the extended cataScience workshop

Adds a guided workflow, public health examples, audited data
preparation, additional charts, multiple-imputation teaching, and
report/dashboard export to the original training app. Core activities
work offline.

## Usage

``` r
run_catas(..., language = c("auto", "en", "zh"))
```

## Arguments

- ...:

  Arguments passed to
  [`shiny::runApp()`](https://rdrr.io/pkg/shiny/man/runApp.html).

- language:

  Interface language: `"zh"` (Simplified Chinese), `"en"` (English), or
  `"auto"` (saved browser preference, then browser language).
  Participants can switch languages in the navigation bar during a
  session.

## Value

Called for its side effect; blocks while the app is running.

## See also

[`run_cata()`](https://shanlong-who.github.io/cataScience/reference/run_cata.md)

## Examples

``` r
if (interactive()) run_catas()
```
