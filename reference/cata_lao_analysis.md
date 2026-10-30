# Reproduce the synthetic Lao workshop analysis

Uses the bundled B/C reference files and the declared course selection
policy. This is a worked teaching example, not a national estimate or a
general clinical analysis function. Reported testing is distinct from
result availability and viral suppression.

## Usage

``` r
cata_lao_analysis()
```

## Value

A list of joined and selected records, join audit, status summary,
analysis flow, chi-square test, logistic models and an odds-ratio table.
Ordinary model intervals ignore within-facility correlation.

## Examples

``` r
lesson <- cata_lao_analysis()
lesson$flow
#> # A tibble: 6 × 2
#>   stage                     records
#>   <chr>                       <int>
#> 1 Imported B records            604
#> 2 After many-to-one join        604
#> 3 After review policy           587
#> 4 Known Female/Male             582
#> 5 Known Yes/No                  577
#> 6 Complete model predictors     575
```
