# Count missing values and patterns

Count missing values and patterns

## Usage

``` r
cata_missing(data, by = c("variable", "record", "pattern"))
```

## Arguments

- data:

  A data frame.

- by:

  Summary level: variables, records, or missingness patterns.

## Value

A tibble. Patterns use `1` for missing and `0` for observed, in input
column order; the `variables` attribute records that order.

## Examples

``` r
cata_missing(data.frame(a = c(1, NA), b = c(NA, NA)))
#> # A tibble: 2 × 4
#>   variable missing observed missing_pct
#>   <chr>      <dbl>    <dbl>       <dbl>
#> 1 a              1        1          50
#> 2 b              2        0         100
```
