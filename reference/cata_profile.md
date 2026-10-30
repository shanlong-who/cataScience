# Summarise the structure and quality of a table

Summarise the structure and quality of a table

## Usage

``` r
cata_profile(data)
```

## Arguments

- data:

  A data frame.

## Value

One row per variable, with storage type, record count, observed unique
values, missingness, and numeric summaries. No values are changed.

## Examples

``` r
cata_profile(data.frame(id = c("001", "002"), value = c(3, NA)))
#> # A tibble: 2 × 11
#>   variable type  records observed missing missing_pct distinct nonfinite minimum
#>   <chr>    <chr>   <int>    <int>   <int>       <dbl>    <int>     <int>   <dbl>
#> 1 id       char…       2        2       0           0        2         0      NA
#> 2 value    nume…       2        1       1          50        1         0       3
#> # ℹ 2 more variables: median <dbl>, maximum <dbl>
```
